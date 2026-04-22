import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';

// ─────────────────────────────────────────────
//  MathCalculatorWidget  –  drop this anywhere
// ─────────────────────────────────────────────
class MathCalculatorWidget extends StatefulWidget {
  /// Called whenever the user taps a key.
  /// [value] is the string that should be appended / handled.
  final void Function(String value) onKeyTap;

  /// Called when the backspace key is tapped.
  final VoidCallback onBackspace;

  const MathCalculatorWidget({
    Key? key,
    required this.onKeyTap,
    required this.onBackspace,
  }) : super(key: key);

  @override
  State<MathCalculatorWidget> createState() => _MathCalculatorWidgetState();
}

class _MathCalculatorWidgetState extends State<MathCalculatorWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── button builders ──────────────────────────────────────────────────────

  Widget _numBtn(String label) =>
      _CalcButton(label: label, onTap: () => widget.onKeyTap(label));

  Widget _opBtn(String label, {String? insert}) => _CalcButton(
    label: label,
    isOperator: true,
    onTap: () => widget.onKeyTap(insert ?? label),
  );

  Widget _fnBtn(String label, {String? insert, bool isSpecial = false}) =>
      _CalcButton(
        label: label,
        isFunction: true,
        isSpecial: isSpecial,
        onTap: () => widget.onKeyTap(insert ?? '$label('),
      );

  Widget _backBtn() =>
      _CalcButton(label: '⌫', isBackspace: true, onTap: widget.onBackspace);

  // ── tab content ───────────────────────────────────────────────────────────

  /// Basic: numbers + basic operators + common functions
  Widget _basicGrid(AppColors c) {
    return _KeyGrid(
      children: [
        // row 1
        _numBtn('7'),
        _numBtn('8'),
        _numBtn('9'),
        _opBtn('÷', insert: '/'),
        _fnBtn('x', insert: 'x'),
        // row 2
        _numBtn('4'),
        _numBtn('5'),
        _numBtn('6'),
        _opBtn('×', insert: '*'),
        _fnBtn('y', insert: 'y'),
        // row 3
        _numBtn('1'),
        _numBtn('2'),
        _numBtn('3'),
        _opBtn('−', insert: '-'),
        _fnBtn('f', insert: 'f('),
        // row 4
        _numBtn('0'), _numBtn('.'), _numBtn('('), _opBtn('+'), _numBtn(')'),
        // row 5
        _fnBtn('𝑓𝑥', insert: ''),
        _fnBtn('√', insert: 'sqrt('),
        _fnBtn('x²', insert: '^2'),
        _fnBtn('xⁿ', insert: '^'),
        _fnBtn('log', insert: 'log('),
        // row 6
        _fnBtn('sin', insert: 'sin('),
        _fnBtn('cos', insert: 'cos('),
        _fnBtn('tan', insert: 'tan('),
        _fnBtn('∫', insert: '∫'),
        _backBtn(),
      ],
    );
  }

  /// Calculus tab
  Widget _calculusGrid(AppColors c) {
    return _KeyGrid(
      children: [
        // row 1
        _numBtn('7'),
        _numBtn('8'),
        _numBtn('9'),
        _opBtn('÷', insert: '/'),
        _fnBtn('x', insert: 'x'),
        // row 2
        _numBtn('4'),
        _numBtn('5'),
        _numBtn('6'),
        _opBtn('×', insert: '*'),
        _fnBtn('n', insert: 'n'),
        // row 3
        _numBtn('1'),
        _numBtn('2'),
        _numBtn('3'),
        _opBtn('−', insert: '-'),
        _fnBtn('e', insert: 'e'),
        // row 4
        _numBtn('0'), _numBtn('.'), _numBtn('('), _opBtn('+'), _numBtn(')'),
        // row 5
        _fnBtn('d/dx', insert: 'd/dx('),
        _fnBtn('∫dx', insert: '∫('),
        _fnBtn('∂', insert: '∂/∂x('),
        _fnBtn('lim', insert: 'lim('),
        _fnBtn('∑', insert: '∑('),
        // row 6
        _fnBtn('ln', insert: 'ln('),
        _fnBtn('eˣ', insert: 'e^('),
        _fnBtn('π', insert: 'π'),
        _fnBtn('∞', insert: '∞'),
        _backBtn(),
      ],
    );
  }

  /// Geometry tab
  Widget _geometryGrid(AppColors c) {
    return _KeyGrid(
      children: [
        // row 1
        _numBtn('7'),
        _numBtn('8'),
        _numBtn('9'),
        _opBtn('÷', insert: '/'),
        _fnBtn('r', insert: 'r'),
        // row 2
        _numBtn('4'),
        _numBtn('5'),
        _numBtn('6'),
        _opBtn('×', insert: '*'),
        _fnBtn('h', insert: 'h'),
        // row 3
        _numBtn('1'),
        _numBtn('2'),
        _numBtn('3'),
        _opBtn('−', insert: '-'),
        _fnBtn('a', insert: 'a'),
        // row 4
        _numBtn('0'), _numBtn('.'), _numBtn('('), _opBtn('+'), _numBtn(')'),
        // row 5
        _fnBtn('π', insert: 'π'),
        _fnBtn('πr²', insert: 'π*r^2'),
        _fnBtn('2πr', insert: '2*π*r'),
        _fnBtn('r²', insert: 'r^2'),
        _fnBtn('√', insert: 'sqrt('),
        // row 6
        _fnBtn('sin', insert: 'sin('),
        _fnBtn('cos', insert: 'cos('),
        _fnBtn('tan', insert: 'tan('),
        _fnBtn('°→rad', insert: '*(π/180)'),
        _backBtn(),
      ],
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: c.subtitle.withAlpha(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tab bar ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
            child: Row(
              children: [
                _TabItem(
                  label: 'Basic',
                  selected: _tabController.index == 0,
                  onTap: () => _tabController.animateTo(0),
                  c: c,
                ),
                SizedBox(width: 8.w),
                _TabItem(
                  label: 'Calculus',
                  selected: _tabController.index == 1,
                  onTap: () => _tabController.animateTo(1),
                  c: c,
                ),
                SizedBox(width: 8.w),
                _TabItem(
                  label: 'Geometry',
                  selected: _tabController.index == 2,
                  onTap: () => _tabController.animateTo(2),
                  c: c,
                ),
                const Spacer(),
                Icon(Icons.keyboard_outlined, color: c.subtitle, size: 20),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // ── Tab content ──────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: KeyedSubtree(
              key: ValueKey(_tabController.index),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 12.h),
                child: _tabController.index == 0
                    ? _basicGrid(c)
                    : _tabController.index == 1
                    ? _calculusGrid(c)
                    : _geometryGrid(c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _TabItem
// ─────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppColors c;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? c.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : c.subtitle,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _KeyGrid  –  5-column uniform grid
// ─────────────────────────────────────────────
class _KeyGrid extends StatelessWidget {
  final List<Widget> children;
  const _KeyGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 0.9,
      children: children,
    );
  }
}

// ─────────────────────────────────────────────
//  _CalcButton
// ─────────────────────────────────────────────
class _CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final bool isFunction;
  final bool isSpecial;
  final bool isBackspace;

  const _CalcButton({
    required this.label,
    required this.onTap,
    this.isOperator = false,
    this.isFunction = false,
    this.isSpecial = false,
    this.isBackspace = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    Color bg;
    Color fg;

    if (isBackspace) {
      bg = const Color(0xFFFDE8E8);
      fg = const Color(0xFFE53935);
    } else if (isOperator) {
      bg = c.primary.withOpacity(0.15);
      fg = c.primary;
    } else if (isFunction || isSpecial) {
      bg = c.iconBgMuted;
      fg = c.subtitle;
    } else {
      // number
      bg = c.card;
      fg = c.title;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30.r),
          // border: Border.all(color: c.border.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: label.length > 3 ? 10 : 14,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
