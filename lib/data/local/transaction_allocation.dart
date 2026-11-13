import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';

enum AllocationEntityType { bill, plannedPayment, budget, goal }

extension AllocationEntityTypeX on AllocationEntityType {
  String get storageKey {
    switch (this) {
      case AllocationEntityType.bill:
        return 'bill';
      case AllocationEntityType.plannedPayment:
        return 'planned_payment';
      case AllocationEntityType.budget:
        return 'budget';
      case AllocationEntityType.goal:
        return 'goal';
    }
  }

  String get label {
    switch (this) {
      case AllocationEntityType.bill:
        return 'Bill';
      case AllocationEntityType.plannedPayment:
        return 'Planned payment';
      case AllocationEntityType.budget:
        return 'Budget';
      case AllocationEntityType.goal:
        return 'Goal';
    }
  }

  static AllocationEntityType? fromStorage(String? raw) {
    switch (raw) {
      case 'bill':
        return AllocationEntityType.bill;
      case 'planned_payment':
        return AllocationEntityType.plannedPayment;
      case 'budget':
        return AllocationEntityType.budget;
      case 'goal':
        return AllocationEntityType.goal;
      default:
        return null;
    }
  }
}

class TransactionAllocationLink {
  const TransactionAllocationLink({
    required this.transactionCode,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.linkedAmount,
    required this.createdAt,
  });

  final String transactionCode;
  final AllocationEntityType entityType;
  final int entityId;
  final String entityName;
  final double linkedAmount;
  final DateTime createdAt;

  Map<String, Object?> toRow() => {
        'transaction_code': transactionCode,
        'entity_type': entityType.storageKey,
        'entity_id': entityId,
        'entity_name': entityName,
        'linked_amount': linkedAmount,
        'created_at': createdAt.toIso8601String(),
      };

  factory TransactionAllocationLink.fromRow(Map<String, Object?> row) {
    return TransactionAllocationLink(
      transactionCode: row['transaction_code'] as String? ?? '',
      entityType: AllocationEntityTypeX.fromStorage(
            row['entity_type'] as String?,
          ) ??
          AllocationEntityType.bill,
      entityId: (row['entity_id'] as num?)?.toInt() ?? 0,
      entityName: row['entity_name'] as String? ?? '',
      linkedAmount: (row['linked_amount'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class AllocationMatchCandidate {
  const AllocationMatchCandidate({
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.targetAmount,
    required this.score,
  });

  final AllocationEntityType entityType;
  final int entityId;
  final String entityName;
  final double targetAmount;
  final double score;

  String get subtitle =>
      '${entityType.label} · KES ${targetAmount.toStringAsFixed(2)}';
}

class AllocationCatalog {
  const AllocationCatalog({
    this.bills = const [],
    this.plannedPayments = const [],
    this.budgets = const [],
    this.goals = const [],
  });

  final List<Bill> bills;
  final List<PlannedPayment> plannedPayments;
  final List<UserBudget> budgets;
  final List<Goals> goals;
}

/// Local-only matcher: compare transaction amount to bills / PP / budgets / goals.
class TransactionAllocationMatcher {
  /// Absolute KES tolerance for an amount match.
  static const double amountTolerance = 1.0;

  /// Relative tolerance (2%) for larger amounts.
  static const double amountRelativeTolerance = 0.02;

  /// Whether [txAmount] matches [target] closely enough to auto-prompt.
  static bool amountsMatch(double txAmount, double target) {
    if (target <= 0 || txAmount <= 0) return false;
    final diff = (txAmount - target).abs();
    return diff <= amountTolerance || diff / target <= amountRelativeTolerance;
  }

  static List<AllocationMatchCandidate> findMatches(
    Transaction tx,
    AllocationCatalog catalog, {
    int limit = 5,
    /// When true (auto-prompt), only amount matches — never soft name-only hits.
    bool requireAmountMatch = false,
  }) {
    // Linking is for money leaving the wallet (payments / contributions).
    if (tx.type != TransactionType.debit) return const [];

    final amount = tx.amount.abs();
    if (amount <= 0) return const [];

    final narration = tx.narration.toLowerCase();
    final out = <AllocationMatchCandidate>[];

    for (final bill in catalog.bills) {
      final target = bill.amount.toDouble();
      final score = _score(
        amount,
        target,
        narration,
        bill.name,
        requireAmountMatch: requireAmountMatch,
      );
      if (score > 0) {
        out.add(AllocationMatchCandidate(
          entityType: AllocationEntityType.bill,
          entityId: bill.id,
          entityName: bill.name,
          targetAmount: target,
          score: score,
        ));
      }
    }

    for (final pp in catalog.plannedPayments) {
      final id = pp.id;
      if (id == null) continue;
      final target = double.tryParse(pp.amount.replaceAll(',', '')) ?? 0;
      if (target <= 0) continue;
      final score = _score(
        amount,
        target,
        narration,
        pp.name,
        requireAmountMatch: requireAmountMatch,
      );
      if (score > 0) {
        out.add(AllocationMatchCandidate(
          entityType: AllocationEntityType.plannedPayment,
          entityId: id,
          entityName: pp.name,
          targetAmount: target,
          score: score,
        ));
      }
    }

    for (final budget in catalog.budgets) {
      final id = budget.id;
      if (id == null) continue;
      final limitAmt = double.tryParse(
            (budget.budgetLimitAmount ?? '').replaceAll(',', ''),
          ) ??
          0;
      final spent = double.tryParse(budget.amount.replaceAll(',', '')) ?? 0;
      // Match the budget limit / remaining — never "spent so far" (false prompts).
      final remaining = (limitAmt - spent).clamp(0, double.infinity).toDouble();
      final targets = <double>[
        if (limitAmt > 0) limitAmt,
        if (remaining > 0 && (remaining - limitAmt).abs() > amountTolerance)
          remaining,
      ];
      for (final target in targets) {
        final score = _score(
          amount,
          target,
          narration,
          budget.budgetName ?? budget.category ?? 'Budget',
          requireAmountMatch: requireAmountMatch,
        );
        if (score > 0) {
          out.add(AllocationMatchCandidate(
            entityType: AllocationEntityType.budget,
            entityId: id,
            entityName: budget.budgetName ?? budget.category ?? 'Budget',
            targetAmount: target,
            score: score,
          ));
          break;
        }
      }
    }

    for (final goal in catalog.goals) {
      final id = goal.id;
      if (id == null) continue;
      final targetAmt = goal.targetAmount ?? 0;
      final saved = goal.amountSaved ?? 0;
      final remaining = (targetAmt - saved).clamp(0, double.infinity);
      final targets = <double>[
        if (remaining > 0) remaining.toDouble(),
        if (targetAmt > 0) targetAmt,
      ];
      for (final target in targets) {
        final score = _score(
          amount,
          target,
          narration,
          goal.name ?? 'Goal',
          requireAmountMatch: requireAmountMatch,
        );
        if (score > 0) {
          out.add(AllocationMatchCandidate(
            entityType: AllocationEntityType.goal,
            entityId: id,
            entityName: goal.name ?? 'Goal',
            targetAmount: target,
            score: score,
          ));
          break;
        }
      }
    }

    out.sort((a, b) => b.score.compareTo(a.score));
    return out.take(limit).toList();
  }

  static double _score(
    double txAmount,
    double target,
    String narration,
    String name, {
    bool requireAmountMatch = false,
  }) {
    if (target <= 0) return 0;
    final matchedAmount = amountsMatch(txAmount, target);
    if (!matchedAmount) {
      if (requireAmountMatch) return 0;
      // Manual sheet only: soft name match without amount.
      final nameLower = name.toLowerCase().trim();
      if (nameLower.length >= 3 && narration.contains(nameLower)) {
        return 0.55;
      }
      return 0;
    }
    final diff = (txAmount - target).abs();
    var score = 1.0 - (diff / (target + 1));
    final nameLower = name.toLowerCase().trim();
    if (nameLower.length >= 3 && narration.contains(nameLower)) {
      score += 0.25;
    }
    return score.clamp(0.0, 1.5);
  }

  static List<AllocationMatchCandidate> allManualOptions(
    AllocationCatalog catalog,
  ) {
    final out = <AllocationMatchCandidate>[];
    for (final bill in catalog.bills) {
      out.add(AllocationMatchCandidate(
        entityType: AllocationEntityType.bill,
        entityId: bill.id,
        entityName: bill.name,
        targetAmount: bill.amount.toDouble(),
        score: 0,
      ));
    }
    for (final pp in catalog.plannedPayments) {
      final id = pp.id;
      if (id == null) continue;
      out.add(AllocationMatchCandidate(
        entityType: AllocationEntityType.plannedPayment,
        entityId: id,
        entityName: pp.name,
        targetAmount: double.tryParse(pp.amount.replaceAll(',', '')) ?? 0,
        score: 0,
      ));
    }
    for (final budget in catalog.budgets) {
      final id = budget.id;
      if (id == null) continue;
      out.add(AllocationMatchCandidate(
        entityType: AllocationEntityType.budget,
        entityId: id,
        entityName: budget.budgetName ?? budget.category ?? 'Budget',
        targetAmount: double.tryParse(
              (budget.budgetLimitAmount ?? budget.amount).replaceAll(',', ''),
            ) ??
            0,
        score: 0,
      ));
    }
    for (final goal in catalog.goals) {
      final id = goal.id;
      if (id == null) continue;
      final remaining =
          ((goal.targetAmount ?? 0) - (goal.amountSaved ?? 0)).clamp(0, 1e15);
      out.add(AllocationMatchCandidate(
        entityType: AllocationEntityType.goal,
        entityId: id,
        entityName: goal.name ?? 'Goal',
        targetAmount: remaining.toDouble(),
        score: 0,
      ));
    }
    out.sort((a, b) => a.entityName.toLowerCase().compareTo(b.entityName.toLowerCase()));
    return out;
  }
}
