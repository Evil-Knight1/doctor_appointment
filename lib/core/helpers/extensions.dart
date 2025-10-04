import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushName(String name, {Object? arguments}) {
    return Navigator.of(this).pushNamed(name, arguments: arguments);
  }

  Future<dynamic> pushNamedReplacement(String name, {Object? arguments}) {
    return Navigator.pushReplacementNamed(this, name, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String name, {
    Object? arguments,
    required RoutePredicate perdicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(name, perdicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}
