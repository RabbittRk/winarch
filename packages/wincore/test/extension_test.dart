// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wincore/extension/extension.dart';

void main() {
  group('ContextExtension', () {
    testWidgets('mediaQuery returns MediaQueryData', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.mediaQuery, isA<MediaQueryData>());
    });

    testWidgets('theme returns ThemeData', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.theme, isA<ThemeData>());
    });

    testWidgets('textTheme and colors are available from theme',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.textTheme, isA<TextTheme>());
      expect(context.colors, isA<ColorScheme>());
    });

    testWidgets('isDarkMode reflects theme brightness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          home: const Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.isDarkMode, isFalse);
    });

    testWidgets('randomColor returns a Color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.randomColor, isA<Color>());
    });

    testWidgets('durationLow and durationNormal return correct durations',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));
      expect(context.durationLow, const Duration(milliseconds: 500));
      expect(context.durationNormal, const Duration(seconds: 1));
    });
  });

  group('DateTimeExtension', () {
    test('toFormattedString returns formatted date string', () {
      final dt = DateTime(2025, 3, 7, 14, 30);
      final result = dt.toFormattedString();
      expect(result, contains('Fri'));
      expect(result, contains('07'));
      expect(result, contains('Mar'));
      expect(result, contains('25'));
      expect(result, contains('PM'));
      expect(result, contains('30'));
    });

    test('toMMMddyyyy returns MMM, dd yyyy format', () {
      final dt = DateTime(2025, 3, 7);
      final result = dt.toMMMddyyyy();
      expect(result, 'Mar, 07 2025');
    });

    test('readable returns dd MMM, yyyy hh:mm a format', () {
      final dt = DateTime(2025, 3, 7, 9, 15);
      final result = dt.readable();
      expect(result, contains('07'));
      expect(result, contains('Mar'));
      expect(result, contains('2025'));
      expect(result, contains('09:15'));
    });

    test('timeOnly returns hh:mm', () {
      final dt = DateTime(2025, 1, 1, 14, 30);
      final result = dt.timeOnly();
      expect(result, contains('30'));
      expect(result, anyOf(contains('2:30'), contains('02:30')));
    });

    test('timeAgo returns "Just now" for very recent time', () {
      final dt = DateTime.now().subtract(const Duration(seconds: 1));
      final result = dt.timeAgo();
      expect(result, anyOf('Just now', '1 second ago', '1 seconds ago'));
    });

    test('timeAgo returns "X minutes ago" for past minutes', () {
      final dt = DateTime.now().subtract(const Duration(minutes: 5));
      expect(dt.timeAgo(), '5 minutes ago');
    });

    test('timeAgo returns "1 minute ago" with numericDates', () {
      final dt = DateTime.now().subtract(const Duration(minutes: 1));
      expect(dt.timeAgo(numericDates: true), '1 minute ago');
    });

    test('timeAgo returns "X days ago" for past days', () {
      final dt = DateTime.now().subtract(const Duration(days: 3));
      expect(dt.timeAgo(), '3 days ago');
    });

    test('timeAgo returns "1 day ago" for yesterday', () {
      final dt = DateTime.now().subtract(const Duration(days: 1));
      expect(dt.timeAgo(numericDates: true), '1 day ago');
    });
  });

  group('Ex (double)', () {
    test('toPrecision rounds to n decimal places', () {
      expect(3.14159.toPrecision(2), 3.14);
      expect(3.14159.toPrecision(0), 3.0);
      expect(10.996.toPrecision(2), 11.0);
    });
  });

  group('Json', () {
    test('toJson pretty-prints Map', () {
      final map = {'a': 1, 'b': 2};
      final result = map.toJson;
      expect(result, contains('"a"'));
      expect(result, contains('"b"'));
      expect(result, contains('1'));
      expect(result, contains('2'));
    });

    test('toJson pretty-prints List', () {
      final list = [1, 2, 3];
      final result = list.toJson;
      expect(result, contains('1'));
      expect(result, contains('2'));
      expect(result, contains('3'));
    });
  });

  group('IndianCurrencyFormat', () {
    test('toAmount formats positive with commas and decimals', () {
      // double.toString() includes decimal part, so output has .00 for whole numbers
      expect(1000.0.toAmount, '₹1,000.00');
      expect(1000000.0.toAmount, '₹1,000,000.00');
    });

    test('toAmount formats with decimals', () {
      expect(12.25.toAmount, '₹12.25');
      expect(100.0.toAmount, '₹100.00');
    });

    test('toAmount handles negative amounts', () {
      expect((-500.0).toAmount, '-₹500.00');
    });
  });

  group('StringExtension', () {
    test('capitalize uppercases first character', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('toPercentage appends %', () {
      expect('50'.toPercentage, '50%');
    });

    test('toAmount prepends rupee symbol', () {
      expect('100'.toAmount, '₹100');
    });

    test('equals compares strings', () {
      expect('abc'.equals('abc'), isTrue);
      expect('abc'.equals('ab'), isFalse);
    });

    test('toInitials single word returns first letter', () {
      expect('John'.toInitials, 'J');
    });

    test('toInitials two words returns both initials', () {
      expect('John Doe'.toInitials, 'JD');
    });

    test('toInitials three or more words returns first and last initial', () {
      expect('John Michael Doe'.toInitials, 'JD');
    });

    test('toCapitalize uppercases first character', () {
      expect('hello'.toCapitalize(), 'Hello');
    });
  });

  group('ColourExtension', () {
    test('toColor parses 6-char hex', () {
      final color = 'FF0000'.toColor;
      expect(color, isA<Color>());
      expect(color.red, 255);
      expect(color.green, 0);
      expect(color.blue, 0);
    });

    test('toColor parses hex with # prefix', () {
      final color = '#00FF00'.toColor;
      expect(color.green, 255);
    });

    test('toColor parses 8-char hex (with alpha)', () {
      final color = '80FFFFFF'.toColor;
      expect(color, isA<Color>());
    });

    test('toColor returns white for invalid hex', () {
      final color = 'invalid'.toColor;
      expect(color, const Color(0xFFFFFFFF));
    });
  });

  group('WidgetExtension', () {
    test('toSliver returns SliverToBoxAdapter', () {
      const w = SizedBox();
      final sliver = w.toSliver;
      expect(sliver, isA<SliverToBoxAdapter>());
      expect((sliver as SliverToBoxAdapter).child, same(w));
    });

    test('pt wraps in Padding with top', () {
      const w = SizedBox();
      final padded = w.pt(8);
      expect(padded, isA<Padding>());
      expect((padded as Padding).padding, const EdgeInsets.only(top: 8));
    });

    test('pb, pl, pr apply correct padding', () {
      const w = SizedBox();
      expect((w.pb(4) as Padding).padding, const EdgeInsets.only(bottom: 4));
      expect((w.pl(6) as Padding).padding, const EdgeInsets.only(left: 6));
      expect((w.pr(10) as Padding).padding, const EdgeInsets.only(right: 10));
    });

    test('px, py apply symmetric padding', () {
      const w = SizedBox();
      expect((w.px(12) as Padding).padding,
          const EdgeInsets.symmetric(horizontal: 12));
      expect((w.py(16) as Padding).padding,
          const EdgeInsets.symmetric(vertical: 16));
    });

    test('p applies all padding', () {
      const w = SizedBox();
      expect((w.p(5) as Padding).padding, const EdgeInsets.all(5));
    });

    test('pltrb applies fromLTRB padding', () {
      const w = SizedBox();
      final padded = w.pltrb(1, 2, 3, 4);
      expect(
          (padded as Padding).padding, const EdgeInsets.fromLTRB(1, 2, 3, 4));
    });
  });

  group('ListDivideExt', () {
    test('enumerate returns map entries with index', () {
      final list = [const SizedBox(), const SizedBox()];
      final entries = list.enumerate;
      expect(entries.length, 2);
      expect(entries.first.key, 0);
      expect(entries.last.key, 1);
    });

    test('divide inserts divider between widgets', () {
      final list = [
        const SizedBox(key: ValueKey('a')),
        const SizedBox(key: ValueKey('b')),
      ];
      const divider = Divider();
      final result = list.divide(divider);
      expect(result.length, 3); // a, divider, b
      expect(result[0], list[0]);
      expect(result[1], divider);
      expect(result[2], list[1]);
    });

    test('divide returns empty for empty list', () {
      final list = <Widget>[];
      expect(list.divide(const Divider()), isEmpty);
    });

    test('around adds widget at start and end', () {
      final list = [const SizedBox()];
      const wrap = Divider();
      final result = list.around(wrap);
      expect(result.length, 3);
      expect(result[0], wrap);
      expect(result[1], list[0]);
      expect(result[2], wrap);
    });

    test('addToStart inserts at beginning', () {
      final list = [const SizedBox()];
      const first = Divider();
      final result = list.addToStart(first);
      expect(result.length, 2);
      expect(result[0], first);
      expect(result[1], list[0]);
    });

    test('addToEnd appends at end', () {
      final list = [const SizedBox()];
      const last = Divider();
      final result = list.addToEnd(last);
      expect(result.length, 2);
      expect(result[0], list[0]);
      expect(result[1], last);
    });

    test('paddingTopEach wraps each in Padding with top', () {
      final list = [
        const SizedBox(),
        const SizedBox(),
      ];
      final result = list.paddingTopEach(10);
      expect(result.length, 2);
      expect(result[0], isA<Padding>());
      expect((result[0]).padding, const EdgeInsets.only(top: 10));
      expect(result[1], isA<Padding>());
    });
  });
}
