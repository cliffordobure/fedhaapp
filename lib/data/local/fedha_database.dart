import 'dart:convert';

import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' hide Transaction;

/// Local source of truth for Fedha (offline-first).
class FedhaDatabase {
  FedhaDatabase._();
  static final FedhaDatabase instance = FedhaDatabase._();

  static const _dbName = 'fedha_local.db';
  /// v3: recover devices stuck on "transaction_links already exists".
  static const _dbVersion = 3;

  Database? _db;
  bool _recovering = false;

  Future<Database> get database async {
    if (_db != null) return _db!;
    try {
      _db = await _open();
      return _db!;
    } catch (e) {
      // Failed open must not leave a poisoned handle — allow retry.
      _db = null;
      // Half-migrated DBs throw during onCreate/onUpgrade/onOpen and then
      // block Sync / Home forever. Wipe once and recreate.
      if (!_recovering) {
        _recovering = true;
        try {
          await _deleteDatabaseFile();
          _db = await _open();
          return _db!;
        } catch (_) {
          _db = null;
          rethrow;
        } finally {
          _recovering = false;
        }
      }
      rethrow;
    }
  }

  Future<String> _dbFilePath() async {
    final dbPath = await getDatabasesPath();
    return p.join(dbPath, _dbName);
  }

  Future<void> _deleteDatabaseFile() async {
    final path = await _dbFilePath();
    await deleteDatabase(path);
  }

  Future<Database> _open() async {
    final path = await _dbFilePath();
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createV1Tables(db);
        await _ensureTransactionLinksTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Idempotent — safe even if the table already exists.
        if (oldVersion < 3) {
          await _ensureTransactionLinksTable(db);
        }
      },
      onOpen: (db) async {
        // Heal devices that already have the table but hit a bad upgrade.
        await _ensureTransactionLinksTable(db);
      },
    );
  }

  Future<void> _createV1Tables(Database db) async {
    await db.execute('''
      CREATE TABLE transactions (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        transaction_code TEXT NOT NULL UNIQUE,
        user_id INTEGER,
        category_id INTEGER,
        subcategory_id INTEGER,
        wallet_id INTEGER,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        narration TEXT NOT NULL DEFAULT '',
        charges REAL,
        date TEXT,
        balance REAL,
        currency TEXT DEFAULT 'KES',
        created_at TEXT,
        updated_at TEXT,
        sync_status TEXT NOT NULL DEFAULT 'synced',
        payload_json TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_tx_wallet ON transactions(wallet_id)',
    );
    await db.execute(
      'CREATE INDEX idx_tx_date ON transactions(date)',
    );
    await db.execute(
      'CREATE INDEX idx_tx_sync ON transactions(sync_status)',
    );

    await db.execute('''
      CREATE TABLE wallets (
        id INTEGER PRIMARY KEY,
        account_id TEXT,
        institution_name TEXT,
        account_name TEXT,
        account_number TEXT,
        account_type TEXT,
        balance TEXT,
        currency TEXT,
        bank_id INTEGER NOT NULL,
        img TEXT,
        name TEXT NOT NULL,
        shortname TEXT NOT NULL,
        json_blob TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE kv_store (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_outbox (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_key TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      )
    ''');
    await db.execute(
      'CREATE UNIQUE INDEX idx_outbox_key ON sync_outbox(entity_type, entity_key)',
    );
  }

  /// Always idempotent. Never let a duplicate CREATE abort DB open / Sync.
  Future<void> _ensureTransactionLinksTable(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS transaction_links (
        transaction_code TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        entity_name TEXT NOT NULL,
        linked_amount REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    } catch (e) {
      final msg = '$e'.toLowerCase();
      if (!msg.contains('already exists')) rethrow;
    }
    try {
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_links_entity ON transaction_links(entity_type, entity_id)',
      );
    } catch (e) {
      final msg = '$e'.toLowerCase();
      if (!msg.contains('already exists')) rethrow;
    }
  }

  // --- KV ---

  Future<void> putKv(String key, Map<String, dynamic> value) async {
    final db = await database;
    await db.insert(
      'kv_store',
      {
        'key': key,
        'value': jsonEncode(value),
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getKv(String key) async {
    final db = await database;
    final rows = await db.query(
      'kv_store',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['value'] as String?;
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }

  /// Wipe all local user data (logout / account switch).
  Future<void> clearAllUserData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('wallets');
      await txn.delete('sync_outbox');
      await txn.delete('transaction_links');
      await txn.delete('kv_store');
    });
  }

  /// Clear transactions + related sync rows only (keep wallets / planning).
  Future<void> clearAllTransactions() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('transaction_links');
      await txn.delete(
        'sync_outbox',
        where: "entity_type = ?",
        whereArgs: const ['transaction'],
      );
      await txn.delete('kv_store', where: 'key = ?', whereArgs: ['transactions_meta']);
      await txn.delete('kv_store', where: 'key = ?', whereArgs: ['home_data']);
      await txn.delete('kv_store', where: 'key = ?', whereArgs: ['graphs_weekly']);
      await txn.delete(
        'kv_store',
        where: 'key = ?',
        whereArgs: ['dismissed_allocation_matches'],
      );
      await txn.delete(
        'kv_store',
        where: 'key = ?',
        whereArgs: ['deleted_transaction_codes'],
      );
    });
  }

  // --- Transactions ---

  Future<void> upsertTransactions(
    List<Transaction> transactions, {
    String syncStatus = 'synced',
    Map<String, String?> payloadByCode = const {},
  }) async {
    if (transactions.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (final t in transactions) {
      final code = t.transactionId.trim();
      if (code.isEmpty) continue;
      batch.insert(
        'transactions',
        _txToRow(
          t,
          syncStatus: syncStatus,
          payloadJson: payloadByCode[code],
        ),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> replaceAllTransactions(List<Transaction> transactions) async {
    final db = await database;
    await db.transaction((txn) async {
      // Snapshot locals before wipe so we can preserve upload races.
      final existing = await txn.query('transactions');
      final pendingByCode = <String, Map<String, Object?>>{};
      final localOnlyByCode = <String, Map<String, Object?>>{};
      for (final row in existing) {
        final code = (row['transaction_code'] as String?)?.trim() ?? '';
        if (code.isEmpty) continue;
        final status = (row['sync_status'] as String?) ?? 'synced';
        if (status == 'pending' || status == 'failed') {
          pendingByCode[code] = row;
        } else if (row['server_id'] == null) {
          // Uploaded (or optimistic) but cloud pull has not returned a
          // server id yet — keep so Latest Transactions does not blink away.
          localOnlyByCode[code] = row;
        }
      }

      await txn.delete('transactions');
      final inserted = <String>{};
      for (final t in transactions) {
        final code = t.transactionId.trim();
        if (code.isEmpty) continue;
        final pendingRow = pendingByCode[code];
        final status = pendingRow != null
            ? (pendingRow['sync_status'] as String? ?? 'pending')
            : 'synced';
        await txn.insert(
          'transactions',
          _txToRow(
            t,
            syncStatus: status,
            payloadJson: pendingRow?['payload_json'] as String?,
          ),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        inserted.add(code);
      }

      // Re-insert locals the cloud page(s) did not include yet.
      for (final entry in {...pendingByCode, ...localOnlyByCode}.entries) {
        if (inserted.contains(entry.key)) continue;
        await txn.insert('transactions', entry.value);
      }
    });
  }

  Future<List<Transaction>> loadAllTransactions() async {
    final db = await database;
    final rows = await db.query(
      'transactions',
      orderBy: 'COALESCE(date, created_at) DESC',
    );
    return rows.map(_rowToTx).toList();
  }

  /// Which of [codes] are already stored locally (by transaction_code).
  Future<Set<String>> existingTransactionCodes(Iterable<String> codes) async {
    final unique = codes
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    if (unique.isEmpty) return {};
    final db = await database;
    final found = <String>{};
    // Chunk to stay under SQLite variable limits.
    const chunkSize = 400;
    for (var i = 0; i < unique.length; i += chunkSize) {
      final chunk = unique.sublist(
        i,
        i + chunkSize > unique.length ? unique.length : i + chunkSize,
      );
      final placeholders = List.filled(chunk.length, '?').join(',');
      final rows = await db.query(
        'transactions',
        columns: ['transaction_code'],
        where: 'transaction_code IN ($placeholders)',
        whereArgs: chunk,
      );
      for (final row in rows) {
        final code = (row['transaction_code'] as String?)?.trim();
        if (code != null && code.isNotEmpty) found.add(code);
      }
    }
    return found;
  }

  Future<List<Transaction>> loadPendingTransactions() async {
    final db = await database;
    final rows = await db.query(
      'transactions',
      where: "sync_status IN ('pending', 'failed')",
      orderBy: 'created_at ASC',
    );
    return rows.map(_rowToTx).toList();
  }

  /// Counts local rows waiting to upload, plus outbox entries.
  Future<({int pending, int failed, int outbox})> countSyncBacklog() async {
    final db = await database;
    final pendingRows = await db.rawQuery(
      "SELECT COUNT(*) AS c FROM transactions WHERE sync_status = 'pending'",
    );
    final failedRows = await db.rawQuery(
      "SELECT COUNT(*) AS c FROM transactions WHERE sync_status = 'failed'",
    );
    final outboxRows = await db.rawQuery(
      "SELECT COUNT(*) AS c FROM sync_outbox WHERE entity_type = 'transaction'",
    );
    int asInt(List<Map<String, Object?>> rows) {
      if (rows.isEmpty) return 0;
      final v = rows.first['c'];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse('$v') ?? 0;
    }

    return (
      pending: asInt(pendingRows),
      failed: asInt(failedRows),
      outbox: asInt(outboxRows),
    );
  }

  Future<void> markTransactionsSynced(List<String> codes) async {
    if (codes.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (final code in codes) {
      batch.update(
        'transactions',
        {
          'sync_status': 'synced',
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'transaction_code = ?',
        whereArgs: [code],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteTransactionByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'transactions',
        where: 'transaction_code = ?',
        whereArgs: [trimmed],
      );
      await txn.delete(
        'sync_outbox',
        where: 'entity_type = ? AND entity_key = ?',
        whereArgs: ['transaction', trimmed],
      );
      await txn.delete(
        'transaction_links',
        where: 'transaction_code = ?',
        whereArgs: [trimmed],
      );
    });
  }

  Future<void> deleteTransactionByServerId(int serverId) async {
    if (serverId <= 0) return;
    final db = await database;
    await db.delete(
      'transactions',
      where: 'server_id = ?',
      whereArgs: [serverId],
    );
  }

  Future<void> deleteOutboxByEntityKey({
    required String entityType,
    required String entityKey,
  }) async {
    final key = entityKey.trim();
    if (key.isEmpty) return;
    final db = await database;
    await db.delete(
      'sync_outbox',
      where: 'entity_type = ? AND entity_key = ?',
      whereArgs: [entityType, key],
    );
  }

  // --- Wallets ---

  Future<void> saveWallets(List<Wallet> wallets) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('wallets');
      for (final w in wallets) {
        await txn.insert(
          'wallets',
          {
            'id': w.id,
            'account_id': w.accountId,
            'institution_name': w.institutionName,
            'account_name': w.accountName,
            'account_number': w.accountNumber,
            'account_type': w.accountType,
            'balance': w.balance,
            'currency': w.currency,
            'bank_id': w.bankId,
            'img': w.img,
            'name': w.name,
            'shortname': w.shortname,
            'json_blob': jsonEncode(w.toJson()),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Wallet>> loadWallets() async {
    final db = await database;
    final rows = await db.query('wallets', orderBy: 'id ASC');
    return rows.map((row) {
      final blob = row['json_blob'] as String?;
      if (blob != null && blob.isNotEmpty) {
        try {
          return Wallet.fromJson(jsonDecode(blob));
        } catch (_) {}
      }
      return Wallet(
        id: row['id'] as int,
        accountId: row['account_id'] as String?,
        institutionName: row['institution_name'] as String?,
        accountName: row['account_name'] as String?,
        accountNumber: row['account_number'] as String?,
        accountType: row['account_type'] as String?,
        balance: row['balance'] as String?,
        currency: row['currency'] as String?,
        bankId: row['bank_id'] as int,
        img: row['img'] as String? ?? '',
        name: row['name'] as String? ?? '',
        shortname: row['shortname'] as String? ?? '',
      );
    }).toList();
  }

  // --- Outbox ---

  Future<void> enqueueOutbox({
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    await db.insert(
      'sync_outbox',
      {
        'entity_type': entityType,
        'entity_key': entityKey,
        'payload_json': jsonEncode(payload),
        'created_at': DateTime.now().toIso8601String(),
        'attempts': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> loadOutbox({int limit = 50}) async {
    final db = await database;
    return db.query(
      'sync_outbox',
      orderBy: 'id ASC',
      limit: limit,
    );
  }

  Future<void> removeOutbox(int id) async {
    final db = await database;
    await db.delete('sync_outbox', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> bumpOutboxAttempt(int id, String error) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE sync_outbox SET attempts = attempts + 1, last_error = ? WHERE id = ?',
      [error, id],
    );
  }

  Map<String, Object?> _txToRow(
    Transaction t, {
    required String syncStatus,
    String? payloadJson,
  }) {
    return {
      'server_id': t.id > 0 ? t.id : null,
      'transaction_code': t.transactionId,
      'user_id': t.userId,
      'category_id': t.categoryId,
      'subcategory_id': t.subcategoryId,
      'wallet_id': t.walletId,
      'type': t.type == TransactionType.credit ? 'credit' : 'debit',
      'amount': t.amount,
      'narration': t.narration,
      'charges': t.charges,
      'date': t.date?.toIso8601String(),
      'balance': t.balance,
      'currency': t.currency ?? 'KES',
      'created_at': t.createdAt?.toIso8601String(),
      'updated_at': t.updatedAt?.toIso8601String(),
      'sync_status': syncStatus,
      'payload_json': payloadJson,
    };
  }

  Transaction _rowToTx(Map<String, Object?> row) {
    final typeRaw = (row['type'] as String? ?? 'debit').toLowerCase();
    final serverId = row['server_id'] as int?;
    final localId = row['local_id'] as int? ?? 0;
    return Transaction(
      id: serverId ?? -localId,
      userId: row['user_id'] as int?,
      categoryId: row['category_id'] as int?,
      subcategoryId: row['subcategory_id'] as int?,
      walletId: row['wallet_id'] as int?,
      transactionId: row['transaction_code'] as String? ?? '',
      type: typeRaw.contains('credit')
          ? TransactionType.credit
          : TransactionType.debit,
      amount: (row['amount'] as num?)?.toDouble() ?? 0,
      narration: row['narration'] as String? ?? '',
      charges: (row['charges'] as num?)?.toDouble(),
      date: _parseDt(row['date'] as String?),
      balance: (row['balance'] as num?)?.toDouble(),
      currency: row['currency'] as String? ?? 'KES',
      createdAt: _parseDt(row['created_at'] as String?),
      updatedAt: _parseDt(row['updated_at'] as String?),
    );
  }

  DateTime? _parseDt(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  // --- Transaction allocation links (local-only) ---

  Future<void> upsertTransactionLink(TransactionAllocationLink link) async {
    final db = await database;
    await db.insert(
      'transaction_links',
      link.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<TransactionAllocationLink?> getTransactionLink(String code) async {
    final db = await database;
    final rows = await db.query(
      'transaction_links',
      where: 'transaction_code = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TransactionAllocationLink.fromRow(rows.first);
  }

  Future<Map<String, TransactionAllocationLink>> loadAllTransactionLinks() async {
    final db = await database;
    final rows = await db.query('transaction_links');
    final map = <String, TransactionAllocationLink>{};
    for (final row in rows) {
      final link = TransactionAllocationLink.fromRow(row);
      if (link.transactionCode.isNotEmpty) {
        map[link.transactionCode] = link;
      }
    }
    return map;
  }

  Future<void> deleteTransactionLink(String code) async {
    final db = await database;
    await db.delete(
      'transaction_links',
      where: 'transaction_code = ?',
      whereArgs: [code],
    );
  }
}
