import 'dart:math';

String generateRandomString([int length = 8]) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  final chars = List<String>.generate(
      length, (index) => characters[random.nextInt(characters.length)]);
  return chars.join();
}
