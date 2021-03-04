import 'package:flutter_test/flutter_test.dart';

import 'package:number_ticker/number_ticker.dart';

void main() {
  test('test number_ticker', () {
    final controller = NumberTickerController();
    expect(() => NumberTicker(controller: null, initialNumber: 123),
        throwsAssertionError);
    expect(() => NumberTicker(controller: controller, initialNumber: null),
        throwsAssertionError);
  });
}
