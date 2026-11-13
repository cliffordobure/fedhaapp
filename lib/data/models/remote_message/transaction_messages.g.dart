// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionMessageImpl _$$TransactionMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionMessageImpl(
      reference: json['reference'] as String?,
      amount: json['amount'],
      datetime: _dateTimeFromJson(json['datetime']),
      type: json['type'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      balance: json['balance'],
      cost: json['cost'],
      fulizaAmount: json['fulizaAmount'],
      interest: json['interest'],
      outstanding: json['outstanding'],
      mShwariBalance: json['mShwariBalance'],
      account: json['account'] as String?,
      currency: json['currency'] as String? ?? 'KES',
    );

Map<String, dynamic> _$$TransactionMessageImplToJson(
        _$TransactionMessageImpl instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'amount': instance.amount,
      'datetime': _dateTimeToJson(instance.datetime),
      'type': instance.type,
      'from': instance.from,
      'to': instance.to,
      'balance': instance.balance,
      'cost': instance.cost,
      'fulizaAmount': instance.fulizaAmount,
      'interest': instance.interest,
      'outstanding': instance.outstanding,
      'mShwariBalance': instance.mShwariBalance,
      'account': instance.account,
      'currency': instance.currency,
    };

_$TransactionsListImpl _$$TransactionsListImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionsListImpl(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => TransactionMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransactionsListImplToJson(
        _$TransactionsListImpl instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
    };
