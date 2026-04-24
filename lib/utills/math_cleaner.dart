class MathCleaner {
  static String clean(String input) {
    return input
        .replaceAll(' ', '')
        .replaceAll('×', '*')
        .replaceAll('x', '*')
        .replaceAll('X', '*')
        .replaceAll('÷', '/');
  }
}
