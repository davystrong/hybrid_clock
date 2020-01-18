import 'dart:async';

import 'package:hybrid_clock/ampm.dart';
import 'package:hybrid_clock/analog_clock.dart';
import 'package:hybrid_clock/clock_theme.dart';
import 'package:hybrid_clock/digital_clock.dart';
import 'package:hybrid_clock/extras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

/// Base clock widget
class Clock extends StatefulWidget {
  const Clock(this.model);

  final ClockModel model;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  ValueNotifier<DateTime> _now = ValueNotifier(DateTime.now());
  Timer _timer;

  @override
  void initState() {
    super.initState();
    //Start the time updater
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    DateTime now = DateTime.now();
    _now.value = now;
    // Update once per second. Make sure to do it at the beginning of each
    // new second, so that the clock is accurate.
    _timer = Timer(
      Duration(seconds: 1) - Duration(milliseconds: now.millisecond),
      _updateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //Providers for the theme, time, ClockModel and base size
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ClockTheme>(create: (_) => ClockTheme()),
            ValueListenableProvider<DateTime>.value(value: _now),
            ChangeNotifierProvider.value(value: widget.model),
            Provider<Size>.value(value: constraints.biggest),
          ],
          child: Background(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DigitalClock(),
              Align(
                alignment: Alignment(0, 0.5),
                child: AmPm(),
              ),
              AnalogClock(),
              Align(
                alignment: Alignment.topLeft,
                child: Date(),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Weather(),
              ),
            ],
          ),
          ),
        );
      },
    );
  }
}

/// Simple two colour background, using LinearGradient
class Background extends StatelessWidget {
  const Background({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ClockTheme.of(context).backgroundLight,
            ClockTheme.of(context).backgroundDark,
          ],
          stops: [0.5, 0.5],
        ),
      ),
      child: child,
    );
  }
}
