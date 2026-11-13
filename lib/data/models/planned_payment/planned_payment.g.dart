// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannedPaymentImpl _$$PlannedPaymentImplFromJson(Map<String, dynamic> json) =>
    _$PlannedPaymentImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      categoryId: (json['category_id'] as num?)?.toInt(),
      subcategoryId: (json['subcategory_id'] as num?)?.toInt(),
      paymentDate: json['payment_date'] as String,
      amount: json['amount'] as String,
      frequency: json['frequency'] as String,
      status: json['status'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      subcategory: json['subcategory'] == null
          ? null
          : Subcategory.fromJson(json['subcategory'] as Map<String, dynamic>),
      paymentHistory: (json['payment_histories'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : PaymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlannedPaymentImplToJson(
        _$PlannedPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'category_id': instance.categoryId,
      'subcategory_id': instance.subcategoryId,
      'payment_date': instance.paymentDate,
      'amount': instance.amount,
      'frequency': instance.frequency,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'payment_histories': instance.paymentHistory,
    };

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: (json['type'] as num).toInt(),
      image: json['image'] as String?,
      status: (json['status'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'image': instance.image,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$SubcategoryImpl _$$SubcategoryImplFromJson(Map<String, dynamic> json) =>
    _$SubcategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      categoryId: (json['category_id'] as num).toInt(),
      image: json['image'],
      status: (json['status'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$SubcategoryImplToJson(_$SubcategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category_id': instance.categoryId,
      'image': instance.image,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$PaymentHistoryImpl _$$PaymentHistoryImplFromJson(Map<String, dynamic> json) =>
    _$PaymentHistoryImpl(
      id: (json['id'] as num?)?.toInt(),
      plannedPaymentsId: json['planned_payments_id'] as num?,
      amount: json['amount'] as String,
      paidAt: json['paid_at'] as String,
      userId: (json['user_id'] as num).toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$PaymentHistoryImplToJson(
        _$PaymentHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planned_payments_id': instance.plannedPaymentsId,
      'amount': instance.amount,
      'paid_at': instance.paidAt,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
