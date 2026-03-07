import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget get toSliver {
    return SliverToBoxAdapter(child: this);
  }

  Widget pt(double t) => Padding(padding: EdgeInsets.only(top: t), child: this);

  Widget pb(double b) =>
      Padding(padding: EdgeInsets.only(bottom: b), child: this);

  Widget pl(double l) =>
      Padding(padding: EdgeInsets.only(left: l), child: this);

  Widget pr(double r) =>
      Padding(padding: EdgeInsets.only(right: r), child: this);

  Widget px(double x) => Padding(
        padding: EdgeInsets.symmetric(horizontal: x),
        child: this,
      );

  Widget py(double y) => Padding(
        padding: EdgeInsets.symmetric(vertical: y),
        child: this,
      );

  Widget p(double a) => Padding(padding: EdgeInsets.all(a), child: this);

  Widget pltrb(double l, double t, double r, double b) =>
      Padding(padding: EdgeInsets.fromLTRB(l, t, r, b), child: this);
}

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, t]).expand((i) => i).toList()
        ..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) =>
      enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) =>
      enumerate.map((e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(double val) => map(
        (w) => Padding(padding: EdgeInsets.only(top: val), child: w),
      ).toList();
}
