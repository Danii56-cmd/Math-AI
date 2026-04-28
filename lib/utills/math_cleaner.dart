class MathCleaner {
  static const _knownFunctions = [
    'sqrt',
    'sin',
    'cos',
    'tan',
    'log',
    'ln',
    'exp',
    'abs',
    'integral',
    'delta',
    'sum',
    'product',
    'arcsin',
    'arccos',
    'arctan',
    'sinh',
    'cosh',
    'tanh',
  ];

  static String normalize(String input) {
    String text = input.trim();

    // =========================
    // STEP 0: Normalize line endings
    // =========================
    text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // =========================
    // STEP 1: OCR Fraction Detection
    // MUST happen before removing spaces/newlines
    // =========================

    // Case 1: "3\n───\n4" — fraction with visible bar line
    text = text.replaceAllMapped(
      RegExp(r'([^\n]+)\n[-─—═=_]+\n([^\n]+)'),
      (m) => '(${m[1]!.trim()})/(${m[2]!.trim()})',
    );

    // Case 2: "3\n4" — two-line fraction (OCR skipped bar)
    text = text.replaceAllMapped(RegExp(r'^([^\n]+)\n([^\n]+)$'), (m) {
      final top = m[1]!.trim();
      final bot = m[2]!.trim();
      if (RegExp(r'^[\d\w\+\-\*\(\)\.]+$').hasMatch(top) &&
          RegExp(r'^[\d\w\+\-\*\(\)\.]+$').hasMatch(bot)) {
        return '($top)/($bot)';
      }
      return m[0]!;
    });

    // =========================
    // STEP 2: Unicode operators
    // =========================
    text = text.replaceAll('−', '-');
    text = text.replaceAll('–', '-');
    text = text.replaceAll('—', '-');
    text = text.replaceAll('⁄', '/'); // Unicode fraction slash
    text = text.replaceAll('∕', '/'); // Division slash
    text = text.replaceAll('÷', '/'); // Standard division sign
    text = text.replaceAll('×', '*'); // Multiplication sign

    // =========================
    // STEP 3: Remove noise
    // =========================
    text = text.replaceAll('\n', '');
    text = text.replaceAll(',', '');
    text = text.replaceAll(' ', '');

    // =========================
    // STEP 4: OCR digit-only 'x' replacement
    // Only replace 'x' between digits, not algebra variables
    // =========================
    text = text.replaceAllMapped(
      RegExp(r'(\d)[xX](\d)'),
      (m) => '${m[1]}*${m[2]}',
    );
    text = text.replaceAllMapped(RegExp(r'(\d)[xX](\()'), (m) => '${m[1]}*(');

    // =========================
    // STEP 5: Superscripts & powers
    // =========================
    text = text.replaceAll('⁰', '^0');
    text = text.replaceAll('¹', '^1');
    text = text.replaceAll('²', '^2');
    text = text.replaceAll('³', '^3');
    text = text.replaceAll('⁴', '^4');
    text = text.replaceAll('⁵', '^5');
    text = text.replaceAll('⁶', '^6');
    text = text.replaceAll('⁷', '^7');
    text = text.replaceAll('⁸', '^8');
    text = text.replaceAll('⁹', '^9');

    // =========================
    // STEP 6: Square roots
    // =========================
    text = text.replaceAllMapped(RegExp(r'√(\d+)'), (m) => 'sqrt(${m[1]})');
    text = text.replaceAllMapped(RegExp(r'√\('), (_) => 'sqrt(');
    text = text.replaceAll('√', 'sqrt');

    // =========================
    // STEP 7: Constants
    // =========================
    text = text.replaceAll('π', 'pi');
    text = text.replaceAll('∞', 'infinity');
    // ⚠️ Do NOT replace 'e' — it's both a variable and Euler's number

    // =========================
    // STEP 8: Absolute value bars
    // =========================
    text = text.replaceAllMapped(RegExp(r'\|([^|]+)\|'), (m) => 'abs(${m[1]})');

    // =========================
    // STEP 9: Calculus tokens
    // =========================
    text = text.replaceAll('∫', 'integral');
    text = text.replaceAll('∂', 'd/d');
    text = text.replaceAll('Δ', 'delta');
    text = text.replaceAll('Σ', 'sum');
    text = text.replaceAll('∏', 'product');

    // =========================
    // STEP 10: Implicit multiplication
    // Protect function names first so they don't get mangled
    // =========================
    final placeholders = <String, String>{};
    for (int i = 0; i < _knownFunctions.length; i++) {
      final fn = _knownFunctions[i];
      final placeholder = '__FN${i}__';
      if (text.contains(fn)) {
        placeholders[placeholder] = fn;
        text = text.replaceAll(fn, placeholder);
      }
    }

    // digit before '('
    text = text.replaceAllMapped(RegExp(r'(\d)\('), (m) => '${m[1]}*(');

    // ')' before digit
    text = text.replaceAllMapped(RegExp(r'\)(\d)'), (m) => ')*${m[1]}');

    // ')(' → ')*('
    text = text.replaceAll(')(', ')*(');

    // digit followed by letter (skip x — handled above)
    text = text.replaceAllMapped(
      RegExp(r'(\d)([a-wyzA-WYZ])'),
      (m) => '${m[1]}*${m[2]}',
    );

    // single letter followed by digit → treat as power (x2 → x^2)
    text = text.replaceAllMapped(
      RegExp(r'(?<![_A-Z])([a-wyzA-WYZ])(\d)'),
      (m) => '${m[1]}^${m[2]}',
    );

    // Restore function names
    placeholders.forEach((placeholder, fn) {
      text = text.replaceAll(placeholder, fn);
    });

    // =========================
    // STEP 11: Operator cleanup
    // =========================
    text = text.replaceAll('--', '+');
    text = text.replaceAll('+-', '-');
    text = text.replaceAll('-+', '-');
    text = text.replaceAll('**', '*');

    // Remove leading operators that make no sense
    text = text.replaceAll(RegExp(r'^[*/]'), '');

    return text;
  }
}
