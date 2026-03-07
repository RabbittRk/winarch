import 'dart:convert';

import 'package:flutter/material.dart';

const _rupeeSymbol = '₹';

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension Json on dynamic {
  String get toJson {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(this);
    return prettyprint;
  }
}

extension IndianCurrencyFormat on double {
  String get toAmount {
    // Handle negative numbers
    bool isNegative = this < 0;
    String amount = this.abs().toString();

    // Split into rupees and paise
    List<String> parts = amount.split('.');
    String rupees = parts[0];
    String paise =
        parts.length > 1 ? '.${parts[1].padRight(2, '0').substring(0, 2)}' : '';

    // Add commas in Indian style (from right)
    String formattedRupees = '';
    int count = 0;

    for (int i = rupees.length - 1; i >= 0; i--) {
      formattedRupees = rupees[i] + formattedRupees;
      count++;
      if (count == 3 && i > 0) {
        formattedRupees = ',$formattedRupees';
        count = 0;
      }
    }

    // Combine everything
    return '${isNegative ? '-' : ''}$_rupeeSymbol$formattedRupees$paise';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get toPercentage => "$this%";

  String get toAmount => "$_rupeeSymbol$this";

  bool equals(String nn) {
    return (nn == this);
  }

  String get toInitials {
    List<String> words = this.split(' ');

    if (words.length == 1) {
      // If there's only one word, return its initial
      return words[0][0].toUpperCase();
    } else if (words.length == 2) {
      // If there are two words, return the initials of both
      return words.map((word) => word[0].toUpperCase()).join();
    } else if (words.length >= 3) {
      // If there are three or more words, return the initials of the first and last words
      return words[0][0].toUpperCase() +
          words[words.length - 1][0].toUpperCase();
    } else {
      return 'XX'; // Handle cases with no name or invalid input
    }
  }

  String toCapitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

extension ColourExtension on String {
  Color get toColor {
    var hexColor = this;
    hexColor = hexColor.replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
      return Color(int.parse("0x$hexColor"));
    }

    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return const Color(0xFFFFFFFF);
  }
}
