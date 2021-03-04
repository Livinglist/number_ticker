library number_ticker;

import 'package:flutter/material.dart';

class _DigitTickerController extends ValueNotifier {
  int _number;

  _DigitTickerController({int num = 0}) : super(num) {
    assert(num <= 9 && num >= 0);
    this._number = num;
  }

  int get number => _number;

  dispose() {
    super.dispose();
  }

  set number(int num) {
    this._number = num;
    super.value = num;
  }
}

class _DigitTicker extends StatelessWidget {
  final Color color;
  final TextStyle textStyle;
  final int initialNumber;
  final Duration duration;
  final _DigitTickerController controller;
  final ScrollController scrollController;

  _DigitTicker(
      {this.color = Colors.black,
        this.controller,
        this.textStyle,
        this.initialNumber,
        this.duration})
      : scrollController =
  ScrollController(initialScrollOffset: textStyle.fontSize* (4/3) * initialNumber),
        assert(controller != null),
        assert(initialNumber != null),
        assert(initialNumber <= 9),
        assert(initialNumber >= 0),
        super(key: Key(controller.toString())) {
    controller.addListener(onValueChanged);
  }

  void onValueChanged() {
    if (this.scrollController.positions.isNotEmpty) {
      scrollController.animateTo(controller.number * textStyle.fontSize*(4/3),
          duration: duration, curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: textStyle.fontSize*(4/3),
        width: textStyle.fontSize*(7/10),
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i in List.generate(10, (index) => index))
                  Container(
                    height: textStyle.fontSize*(4/3),
                    child: Center(
                      child: Text("$i", style: textStyle),
                    ),
                  )
              ],
            ),
          ],
        ));
  }
}

class NumberTickerController extends ValueNotifier {
  double _number;

  NumberTickerController() : super(0) {
    this._number = 0;
  }

  double get number => _number;

  set number(double num) {
    this._number = num;
    super.value = num;
  }
}

class NumberTicker extends StatefulWidget {
  final Color color;
  final TextStyle textStyle;
  final double initialNumber;
  final NumberTickerController controller;
  final Duration duration;
  final int fractionDigits;

  NumberTicker(
      {this.color = Colors.black,
        this.controller,
        this.textStyle = const TextStyle(color: Colors.black, fontSize: 12),
        this.initialNumber,
        this.duration = const Duration(milliseconds: 500),
        this.fractionDigits = 0})
      : assert(controller != null),
        assert(initialNumber != null),
        assert(duration != null) {
    this.controller.number = initialNumber;
  }

  @override
  _NumberTickerState createState() => _NumberTickerState();
}

class _NumberTickerState extends State<NumberTicker> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  double currentNum;
  String currentNumString;
  int numLength;
  int decimalIndex;
  bool shorter = false, longer = false;
  List<_DigitTickerController> digitControllers = [];

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    var num = widget.initialNumber;
    currentNum = num;
    var numString = num.toStringAsFixed(widget.fractionDigits);
    this.numLength = numString.length;
    currentNumString = numString;

    for (int i = 0; i < numString.length; i++) {
      var digit = numString.codeUnitAt(i) - 48;

      if (digit >= 0) {
        digitControllers.insert(i, _DigitTickerController(num: digit));
      } else {
        decimalIndex = i;
        digitControllers.insert(i, null);
      }
    }

    widget.controller.addListener(onNumberChanged);

    animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState(() {
          //digitControllers.last.dispose();

          if(shorter) digitControllers.removeLast();

          this.longer = false;
          this.shorter = false;
        });
        animationController.value = 0;
      }
    });

    super.initState();
  }

  onNumberChanged() {
    if(animationController.isAnimating){
      animationController.notifyStatusListeners(AnimationStatus.completed);
    }
    var num = widget.controller.number;
    var numString = num.toStringAsFixed(widget.fractionDigits);

    bool shorter = false;
    bool longer = false;

    if (numString.length < currentNumString.length) {
      shorter = true;
    }else if(numString.length > currentNumString.length){

      digitControllers.insert(0, _DigitTickerController(num: 1));

      longer = true;
    }

    int startIndex = 0;

    if(longer){
      startIndex = 1;
    }


    for (int i = startIndex; i < numString.length; i++) {

      var digit = numString.codeUnitAt(i) - 48;
      var oldDigit = longer ? currentNumString.codeUnitAt(i-1) - 48 : currentNumString.codeUnitAt(i) - 48;

      if (digit >= 0 && digit != oldDigit) {
        digitControllers[i].number = digit;
      } else {}
    }

    currentNumString = numString;
    currentNum = num;

    if (shorter || longer) {
      animationController.forward();
    }
    this.shorter = shorter;
    this.longer = longer;
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.textStyle.fontSize*(7/10);
    return AnimatedBuilder(animation: animationController, builder: (_, __){
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: longer ? (animationController.value) * width : width,
              child: digitControllers.first == null
                  ? Text(' ')
                  : _DigitTicker(
                  controller: digitControllers.first,
                  duration: widget.duration,
                  textStyle: widget.textStyle,
                  initialNumber: currentNumString.codeUnitAt(0) - 48),
            ),
            for (int i = 1; i < digitControllers.length-1; i++)
              digitControllers[i] == null
                  ? Text(' ')
                  : _DigitTicker(
                  controller: digitControllers[i],
                  duration: widget.duration,
                  textStyle: widget.textStyle,
                  initialNumber: i == currentNumString.length? 0 : (currentNumString.codeUnitAt(i) - 48)),
            if (digitControllers.length > 1)
              Container(
                width: shorter ? (1-animationController.value) * width : width,
                child: digitControllers.last == null
                    ? Text(' ')
                    : _DigitTicker(
                    controller: digitControllers.last,
                    duration: widget.duration,
                    textStyle: widget.textStyle,
                    initialNumber: currentNumString.codeUnitAt(currentNumString.length-1) - 48),
              )
          ],
        ),
      );
    });
  }
}

