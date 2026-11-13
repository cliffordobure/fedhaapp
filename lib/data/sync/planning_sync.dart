import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:fedha/data/models/planned_payment/planned_payment_request.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:logging/logging.dart';

final _log = Logger('PlanningSync');

/// Pull + push for bills, planned payments, budgets, and goals.
///
/// Lists live in SQLite (`LocalDataCache`); mutations go through `sync_outbox`
/// and are uploaded here so the UI never has to wait on the network.
class PlanningSync {
  PlanningSync({
    LocalDataCache? cache,
    BillService? billService,
    PlannedPaymentService? plannedPaymentService,
    PlanningService? planningService,
  })  : _cache = cache ?? service<LocalDataCache>(),
        _bills = billService ?? service<BillService>(),
        _planned = plannedPaymentService ?? service<PlannedPaymentService>(),
        _planning = planningService ?? service<PlanningService>();

  final LocalDataCache _cache;
  final BillService _bills;
  final PlannedPaymentService _planned;
  final PlanningService _planning;

  /// Download cloud lists into local cache (best-effort per endpoint).
  Future<void> pullAll() async {
    await Future.wait([
      _pullPlanned(),
      _pullGoals(),
      _pullBudgets(),
      _pullBills(),
    ]);
  }

  Future<void> _pullPlanned() async {
    final res = await _planned.fetchPlannedPayment();
    await res.when(
      onError: (e) async => _log.warning('Planned pull failed: ${e.error}'),
      onSuccess: (data) async {
        await _cache.savePlannedPayments(data);
        _log.info('Pulled ${data.length} planned payments');
      },
    );
  }

  Future<void> _pullGoals() async {
    final res = await _planning.getGoals();
    await res.when(
      onError: (e) async => _log.warning('Goals pull failed: ${e.error}'),
      onSuccess: (data) async {
        await _cache.saveGoals(await _cache.mergeServerGoalsWithPending(data));
        _log.info('Pulled ${data.length} goals');
      },
    );
  }

  Future<void> _pullBudgets() async {
    final res = await _planning.getUserBudgets();
    await res.when(
      onError: (e) async => _log.warning('Budgets pull failed: ${e.error}'),
      onSuccess: (data) async {
        final merged = await _cache.mergeServerBudgetsWithPending(data);
        await _cache.saveUserBudgets(merged);
        _log.info('Pulled ${merged.budgets.length} budgets '
            '(server=${data.budgets.length})');
      },
    );
  }

  Future<void> _pullBills() async {
    final res = await _bills.fetchUserBills();
    await res.when(
      onError: (e) async => _log.warning('Bills pull failed: ${e.error}'),
      onSuccess: (data) async {
        final local = await _cache.loadUserBills();
        await _cache.saveUserBills(BillService.mergePendingBills(data, local));
        _log.info('Pulled user bills snapshot');
      },
    );
  }

  /// Upload queued planning mutations.
  Future<bool> pushPending() async {
    final rows = await _cache.loadPlanningOutbox();
    if (rows.isEmpty) return true;

    var ok = true;
    for (final row in rows) {
      final outboxId = row['id'] as int?;
      if (outboxId == null) continue;
      try {
        final payloadRaw = row['payload_json'];
        final payload = payloadRaw is String
            ? jsonDecode(payloadRaw)
            : payloadRaw;
        if (payload is! Map) {
          await _cache.removeOutboxRow(outboxId);
          continue;
        }
        final map = Map<String, dynamic>.from(payload);
        final entity = '${map['entity_type'] ?? row['entity_type']}';
        final op = '${map['op'] ?? ''}';
        final serverId = map['server_id'] is num
            ? (map['server_id'] as num).toInt()
            : int.tryParse('${map['server_id']}');
        final body = map['body'] is Map
            ? Map<String, dynamic>.from(map['body'] as Map)
            : <String, dynamic>{};

        final success = await _dispatch(
          entity: entity,
          op: op,
          serverId: serverId,
          body: body,
        );
        if (success) {
          await _cache.removeOutboxRow(outboxId);
        } else {
          ok = false;
          _log.warning('Planning push failed for $entity/$op ($outboxId)');
        }
      } catch (e, st) {
        ok = false;
        _log.warning('Planning push error: $e\n$st');
      }
    }
    return ok;
  }

  Future<bool> _dispatch({
    required String entity,
    required String op,
    required int? serverId,
    required Map<String, dynamic> body,
  }) async {
    switch (entity) {
      case 'planned_payment':
        return _pushPlanned(op, serverId, body);
      case 'goal':
        return _pushGoal(op, serverId, body);
      case 'budget':
        return _pushBudget(op, serverId, body);
      case 'bill':
        return _pushBill(op, serverId, body);
      default:
        return true; // drop unknown
    }
  }

  Future<bool> _pushPlanned(
    String op,
    int? serverId,
    Map<String, dynamic> body,
  ) async {
    if (op == 'create') {
      final req = PlannedPaymentRequest.fromJson(body);
      final res = await _planned.addPlannedPayment(request: req);
      return res.when(
        onError: (_) => false,
        onSuccess: (_) => true,
      );
    }
    if (op == 'update' && serverId != null) {
      final req = PlannedPaymentRequest.fromJson(body);
      final res =
          await _planned.updatePlannedPayment(id: serverId, request: req);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'delete' && serverId != null && serverId > 0) {
      final res = await _planned.deletePlannedPayment(id: serverId);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'mark_paid' && serverId != null && serverId > 0) {
      final res = await _planned.createPaymentHistory(id: serverId);
      return res.when(
        onError: (e) {
          // Date-not-reached is not a hard failure — local history already saved.
          final msg = e.error.toLowerCase();
          if (msg.contains('422') ||
              msg.contains('not yet') ||
              msg.contains('date')) {
            return true;
          }
          return false;
        },
        onSuccess: (_) => true,
      );
    }
    // Local-only temp delete — nothing to send.
    if (op == 'delete' && (serverId == null || serverId <= 0)) return true;
    return false;
  }

  Future<bool> _pushGoal(
    String op,
    int? serverId,
    Map<String, dynamic> body,
  ) async {
    if (op == 'create') {
      final res = await _planning.createGoals(body);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'update' && serverId != null) {
      final goal = Goals.fromJson(body);
      final res = await _planning.updateGoals(goal, serverId);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'status' && serverId != null) {
      final status = '${body['status'] ?? ''}';
      final res = await _planning.updateGoalStatus(serverId, status);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'delete' && serverId != null && serverId > 0) {
      final res = await _planning.deleteGoal(serverId);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    // Payments are applied to the cached goal's amount_saved; push that total.
    if (op == 'recharge' && serverId != null && serverId > 0) {
      final goals = await _cache.loadGoals() ?? const <Goals>[];
      final matches = goals.where((g) => g.id == serverId);
      if (matches.isEmpty) return true;
      final total = double.tryParse('${body['new_amount_saved']}');
      final goal = total == null
          ? matches.first
          : matches.first.copyWith(amountSaved: total);
      final res = await _planning.updateGoals(goal, serverId);
      return res.when(
        onError: (e) => e.code == 404,
        onSuccess: (_) => true,
      );
    }
    if (op == 'delete' && (serverId == null || serverId <= 0)) return true;
    return false;
  }

  Future<bool> _pushBudget(
    String op,
    int? serverId,
    Map<String, dynamic> body,
  ) async {
    if (op == 'create') {
      final res = await _planning.createUserBudget(body);
      return res.when(
        onError: (e) {
          _log.warning('Budget create failed: ${e.error} body=$body');
          return false;
        },
        onSuccess: (_) => true,
      );
    }
    if (op == 'update' && serverId != null) {
      final res = await _planning.updateUserBudget(body, serverId);
      return res.when(
        onError: (e) {
          _log.warning('Budget update failed: ${e.error}');
          return false;
        },
        onSuccess: (_) => true,
      );
    }
    // Payments are applied to the cached budget's spent amount; push that total.
    if (op == 'contribute' && serverId != null && serverId > 0) {
      var total = body['new_amount']?.toString();
      if (total == null) {
        final cached = await _cache.loadUserBudgets();
        final matches =
            cached?.budgets.where((b) => b.id == serverId) ?? const [];
        if (matches.isEmpty) return true;
        total = matches.first.amount;
      }
      final res =
          await _planning.updateUserBudget({'amount': total}, serverId);
      return res.when(
        onError: (e) => e.code == 404,
        onSuccess: (_) => true,
      );
    }
    if (op == 'delete' && serverId != null && serverId > 0) {
      final res = await _planning.deleteUserBudget(serverId);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'delete' && (serverId == null || serverId <= 0)) return true;
    return false;
  }

  Future<bool> _pushBill(
    String op,
    int? serverId,
    Map<String, dynamic> body,
  ) async {
    if (op == 'create') {
      var billId = body['bill_id'] is num
          ? (body['bill_id'] as num).toInt()
          : int.tryParse('${body['bill_id']}');
      final name = '${body['name'] ?? ''}'.trim();
      final billType = body['bill_type'];
      final walletId = body['wallet_id'];
      // Ops queued by older builds had no name/type and can never succeed.
      if ((billId == null && name.isEmpty) ||
          billType == null ||
          walletId == null) {
        _log.warning('Dropping invalid bill create: $body');
        return true;
      }
      // Keep the op queued on auth, server or network errors so the bill
      // isn't lost; it stays visible locally until the server accepts it.
      try {
        billId ??= await _bills.resolveBillId(name);
        if (billId == null) {
          _log.warning('Could not resolve bill id for "$name"');
          return false;
        }
        final error = await _bills.createUserBill({
          'bill_id': billId,
          'bill_type': billType,
          'wallet_id': walletId,
          'amount': body['amount'],
        });
        if (error != null) _log.warning('Bill create rejected (422): $error');
        return true;
      } on DioException catch (e) {
        _log.warning('Bill create failed: ${e.response?.statusCode} $e');
        return false;
      }
    }
    if (op == 'update' && serverId != null) {
      if (serverId <= 0) return true;
      final res = await _bills.editBill(body, serverId);
      return res.when(
        onError: (e) => e.code != null && e.code! >= 400 && e.code! < 500,
        onSuccess: (_) => true,
      );
    }
    if (op == 'delete' && serverId != null && serverId > 0) {
      final res = await _bills.deleteBill(serverId);
      return res.when(onError: (_) => false, onSuccess: (_) => true);
    }
    if (op == 'delete' && (serverId == null || serverId <= 0)) return true;
    return false;
  }
}
