bool validateMpesaNumber(String phone) {
  final validPrefixes = [
    "070",
    "071",
    "072",
    "0740",
    "0743",
    "0745",
    "0746",
    "0748",
    "0757",
    "0759",
    "0768",
    "0769",
    "079",
    "0110",
    "0111",
    "0112",
    "0113",
    "0114",
    "0115"
  ];

  return validPrefixes.any((prefix) => phone.startsWith(prefix));
}
