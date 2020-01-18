import 'package:hybrid_clock/clock_theme.dart';
import 'package:hybrid_clock/hour_hand.dart';
import 'package:hybrid_clock/minute_hand.dart';
import 'package:hybrid_clock/points.dart';
import 'package:hybrid_clock/second_hand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Analog clock for foreground. Main part of the clock
class AnalogClock extends StatefulWidget {
  const AnalogClock({Key key}) : super(key: key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Points(),
        ClockHands(),
      ],
    );
  }
}

/// Combination of the three clock hands
class ClockHands extends StatelessWidget {
  const ClockHands({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //Should be circular
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            HourHand(
              time: Provider.of<DateTime>(context),
              color: ClockTheme.of(context).hourHand,
            ),
            MinuteHand(
              time: Provider.of<DateTime>(context),
              color: ClockTheme.of(context).minuteHand,
            ),
            SecondHand(
              time: Provider.of<DateTime>(context),
              color: ClockTheme.of(context).secondHand,
            ),
            //Circle for the centre of hands
            Center(
              child: FractionallySizedBox(
                heightFactor: 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: ClockTheme.of(context).centralDot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
