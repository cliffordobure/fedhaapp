import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

/// Bundled bank/wallet logos — never load wallet icons from the network.
const String kDefaultBankLogoAsset = 'assets/bank_logos/bank.png';

const Map<String, String> _bankLogoAssets = {
  'm-pesa': 'assets/bank_logos/80df53106497285.Y3JvcCw4NjIsNjc1LDE2OCww.png',
  'mpesa': 'assets/bank_logos/80df53106497285.Y3JvcCw4NjIsNjc1LDE2OCww.png',
  'national bank': 'assets/bank_logos/Group -1.png',
  'nbk': 'assets/bank_logos/Group -1.png',
  'kcb': 'assets/bank_logos/Group -2.png',
  'kenya commercial': 'assets/bank_logos/Group -2.png',
  'i&m': 'assets/bank_logos/Group -3.png',
  'i & m': 'assets/bank_logos/Group -3.png',
  'imbank': 'assets/bank_logos/Group -3.png',
  'equity': 'assets/bank_logos/Group -4.png',
  'co-operative': 'assets/bank_logos/Group -5.png',
  'cooperative': 'assets/bank_logos/Group -5.png',
  'coop': 'assets/bank_logos/Group -5.png',
  'citi': 'assets/bank_logos/Group -6.png',
  'barclays': 'assets/bank_logos/Group -7.png',
  'absa': 'assets/bank_logos/Group 191.png',
  'ncba': 'assets/bank_logos/Group 192.png',
  'dtb': 'assets/bank_logos/Group 369.png',
  'diamond trust': 'assets/bank_logos/Group 369.png',
  // Prefer longer keys first via sorted match below.
  'standard chartered': 'assets/bank_logos/stanchart.png',
  'stanchart': 'assets/bank_logos/stanchart.png',
  'scb': 'assets/bank_logos/stanchart.png',
  'stanbic': 'assets/bank_logos/stanbic.png',
};

/// Resolves a local asset path for a bank/wallet by name or shortname.
String bankLogoAsset({String? name, String? shortname}) {
  final keys = <String>[
    if (shortname != null && shortname.trim().isNotEmpty) shortname,
    if (name != null && name.trim().isNotEmpty) name,
  ];

  for (final raw in keys) {
    final lower = raw.toLowerCase().trim();
    final direct = _bankLogoAssets[lower];
    if (direct != null) return direct;

    // Prefer the longest matching key so "standard chartered" beats "stanbic"
    // substrings / short aliases, and avoid matching tiny keys against shortnames.
    String? bestAsset;
    var bestLen = 0;
    for (final entry in _bankLogoAssets.entries) {
      final key = entry.key;
      if (key.length < 3) continue;
      if (lower.contains(key) && key.length > bestLen) {
        bestLen = key.length;
        bestAsset = entry.value;
      }
    }
    if (bestAsset != null) return bestAsset;
  }
  return kDefaultBankLogoAsset;
}

ImageProvider bankLogoProvider({String? name, String? shortname}) {
  return AssetImage(bankLogoAsset(name: name, shortname: shortname));
}

/// Circular / clipped bank logo from local assets only.
class BankLogoImage extends StatelessWidget {
  const BankLogoImage({
    super.key,
    this.name,
    this.shortname,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackIconSize,
  });

  final String? name;
  final String? shortname;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? fallbackIconSize;

  @override
  Widget build(BuildContext context) {
    final asset = bankLogoAsset(name: name, shortname: shortname);
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Icon(
        Icons.account_balance,
        size: fallbackIconSize ?? ((width ?? height ?? 24) * 0.55),
        color: AppColors.darkBlueColor,
      ),
    );
  }
}
