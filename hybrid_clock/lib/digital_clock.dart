import 'package:hybrid_clock/clock_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

/// Digital clock to show in background
class DigitalClock extends StatefulWidget {
  const DigitalClock({Key key}) : super(key: key);

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  Widget build(BuildContext context) {
    //Different colour for top and bottom half, using
    //LinearGradient
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ClockTheme.of(context).digitalDark,
            ClockTheme.of(context).digitalLight,
          ],
          stops: [0.5, 0.5],
        ).createShader(bounds);
      },
      child: FractionallySizedBox(
        widthFactor: 0.4,
        //Padding to avoid text overflow
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              //Only update once every minute, rather than every second
              return Selector<DateTime, DateTime>(
                selector: (_, dateTime) => DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    dateTime.hour,
                    dateTime.minute),
                builder: (_, DateTime now, __) {
                  int hour = now.hour;
                  //Convert to AM/PM if set
                  if (!Provider.of<ClockModel>(context).is24HourFormat) {
                    hour = now.hour % 12;
                    if (hour == 0) {
                      hour = 12;
                    }
                  }
                  final int minute = now.minute;
                  return Text(
                    '${hour.toString().padLeft(2, '0')}   ${minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: constraints.maxWidth * 0.5,
                      color: Colors.black,
                      letterSpacing: -constraints.maxWidth * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
