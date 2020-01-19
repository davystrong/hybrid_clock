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
    //a split. Initially used a ShaderMask but it seems
    //to be broken on stable. Works on beta
    return FractionallySizedBox(
      widthFactor: 0.4,
      //Padding to avoid text overflow
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            //Only update once every minute, rather than every second
            return Selector<DateTime, DateTime>(
              selector: (_, dateTime) => DateTime(dateTime.year, dateTime.month,
                  dateTime.day, dateTime.hour, dateTime.minute),
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
                //Workaround for the ShaderMask. Split the widget
                //and colour both halves differently.
                //This may hit performance
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        child: _BaseClock(
                          color: ClockTheme.of(context).digitalDark,
                          constraints: constraints,
                          minute: minute,
                          hour: hour,
                        ),
                      ),
                    ),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.5,
                        child: _BaseClock(
                          color: ClockTheme.of(context).digitalLight,
                          constraints: constraints,
                          minute: minute,
                          hour: hour,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _BaseClock extends StatelessWidget {
  const _BaseClock(
      {Key key,
      @required this.color,
      @required this.constraints,
      @required this.minute,
      @required this.hour})
      : super(key: key);
  final Color color;
  final BoxConstraints constraints;
  final int minute;
  final int hour;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${hour.toString().padLeft(2, '0')}   ${minute.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontFamily: 'NotoSerif',
        fontSize: constraints.maxWidth * 0.5,
        color: color,
        letterSpacing: -constraints.maxWidth * 0.08,
      ),
      textAlign: TextAlign.center,
    );
  }
}
