import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = ChangeNotifierProvider((ref) => Counter());

class Counter extends ChangeNotifier {
  int count = 0;

  //以下は状態を操作するメソッド

  // `notifyListners()` で状態（count）の変化を通知し、
  // `count`を使用しているWidgetの再構築が行われる

  void increase() {
    count++;
    notifyListeners();
  }
  void decrease() {
    count--;
    notifyListeners();
  }
  void reset() {
    count = 0;
    notifyListeners();
  }

}