import 'dart:math';

import 'package:hybrid_clock/clock_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Display the points all around the clock. Circles for
/// quarters, lines for 5 minute marks
class Points extends StatelessWidget {
  const Points({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //Keep it circular for now
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Markers(),
            Align(
              alignment: Alignment.topCenter,
              child: Circle(
                color: ClockTheme.of(context).quartersLight,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Circle(
                color: ClockTheme.of(context).quartersMid,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Circle(
                color: ClockTheme.of(context).quartersDark,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Circle(
                color: ClockTheme.of(context).quartersMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The circles for the quarters marks
class Circle extends StatelessWidget {
  const Circle({Key key, @required this.color}) : super(key: key);
  final double dotSizeFactor = 0.08;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Color color = ClockTheme.of(context).quartersLight;
    double diameter = Provider.of<Size>(context).height * this.dotSizeFactor;
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Markers for 5 minutes, except quarters
class Markers extends StatefulWidget {
  const Markers({Key key}) : super(key: key);

  @override
  _MarkersState createState() => _MarkersState();
}

class _MarkersState extends State<Markers> {
  MarkersPainter painter;

  @override
  Widget build(BuildContext context) {
    //Have a different colour top and bottom
    //Initially used ShaderMask, however this seems
    //to be broken on the stable channel (it works
    //as expected on the beta channel)
    painter ??= MarkersPainter(
      ClockTheme.of(context).markerDark,
      ClockTheme.of(context).markerLight,
    );
    return CustomPaint(
      painter: painter,
    );
  }
}

/// Custom painter for the 5 minute markers
class MarkersPainter extends CustomPainter {
  Size prevSize;
  Paint paintData = Paint();
  List<Offset> p1s;
  List<Offset> p2s;
  final Color firstColor;
  final Color lastColor;

  MarkersPainter(this.firstColor, this.lastColor);

  void calculatePoints(Size size) {
    p1s = [];
    p2s = [];
    paintData.strokeWidth = size.height / 150;
    int count = 12;
    double length = size.height / 12;
    for (int i = 0; i < count; i++) {
      if (i % 3 == 0) {
        continue;
      }
      double angle = (i / count) * 2 * pi;
      double dx = (size.width / 2) * cos(angle);
      double dy = (size.height / 2) * sin(angle);
      Offset p1 = Offset(dx, dy);
      Offset p2 = p1.translate(
          length * cos(p1.direction + pi), length * sin(p1.direction + pi));
      p1s.add(p1);
      p2s.add(p2);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //Only calculate offsets when size changes
    if (prevSize != size) {
      prevSize = size;
      calculatePoints(size);
    }
    canvas.translate(size.width * 0.5, size.height * 0.5);

    for (int i = 0; i < 4; i++) {
      paintData.color = lastColor;
      canvas.drawLine(p1s[i], p2s[i], paintData);
    }
    for (int i = 4; i < 8; i++) {
      paintData.color = firstColor;
      canvas.drawLine(p1s[i], p2s[i], paintData);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
