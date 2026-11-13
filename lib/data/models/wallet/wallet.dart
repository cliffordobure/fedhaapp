// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    @Default("") @JsonKey(name: "account_id") String? accountId,
    @JsonKey(name: "institution_name") String? institutionName,
    @JsonKey(name: "account_name") String? accountName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: "account_type") String? accountType,
    @JsonKey(name: 'balance') String? balance,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "bank_id") required int bankId,
    @JsonKey(name: "img_url") @Default("") String img,
    required String name,
    required String shortname,
  }) = _Wallet;

  factory Wallet.fromJson(json) => _$WalletFromJson(json);
}

@freezed
class WalletType with _$WalletType {
  const factory WalletType({
    required int id,
    required String name,
  }) = _WalletType;

  factory WalletType.fromJson(Map<String, dynamic> json) =>
      _$WalletTypeFromJson(json);
}

@freezed
class Currency with _$Currency {
  const factory Currency({
    required int id,
    required String name,
    required String symbol,
  }) = _Currency;

  factory Currency.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    final rawName = (map['name'] ?? '').toString().trim();
    final rawSymbol = (map['symbol'] ?? map['code'] ?? '')
        .toString()
        .trim()
        .toUpperCase();
    final nameUpper = rawName.toUpperCase();

    String symbol;
    if (rawSymbol == 'USD' ||
        rawSymbol == 'US\$' ||
        rawSymbol == '\$' ||
        nameUpper.contains('DOLLAR') ||
        nameUpper == 'USD' ||
        rawSymbol.contains('DOLLAR')) {
      symbol = 'USD';
    } else if (rawSymbol == 'KES' ||
        nameUpper.contains('SHILLING') ||
        nameUpper.contains('KES')) {
      symbol = 'KES';
    } else if (rawSymbol.isNotEmpty &&
        rawSymbol.length <= 3 &&
        !rawSymbol.contains(' ')) {
      symbol = rawSymbol;
    } else {
      symbol = 'KES';
    }

    map['symbol'] = symbol;
    map['name'] = rawName.isNotEmpty
        ? rawName
        : (symbol == 'USD' ? 'US Dollar' : 'Kenyan Shilling');
    final id = map['id'];
    if (id is! num) {
      map['id'] = symbol == 'USD' ? 2 : 1;
    }
    return _$CurrencyFromJson(map);
  }
}
