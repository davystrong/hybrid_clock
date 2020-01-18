import 'package:hybrid_clock/clock_theme.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// This widget was created to change the colour of the clock
// However, after reviewing the rules, I realised this wouldn't
// be possible
/// Change the colour of the clock on tap
class Pallete extends StatefulWidget {
  const Pallete({Key key}) : super(key: key);

  @override
  _PalleteState createState() => _PalleteState();
}

class _PalleteState extends State<Pallete> {
  bool visible = false;
  RestartableTimer timer;

  void showPalette() {
    setState(() {
      visible = true;
    });

    //Fade palette after delay
    timer ??= RestartableTimer(Duration(seconds: 3), () {
      setState(() {
        visible = false;
      });
    });
    timer.reset();
  }

  void switchColor() {
    showPalette();
    ClockTheme.of(context).colorIndex += 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: showPalette,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: visible ? 1.0 : 0.2,
            child: IconButton(
              onPressed: switchColor,
              icon: Icon(
                FontAwesomeIcons.palette,
                color: ClockTheme.of(context).backgroundLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
