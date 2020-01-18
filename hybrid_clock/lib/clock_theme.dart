import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<MaterialColor> _colors = [
  // Colors.amber, //Too bright
  Colors.orange,
  Colors.deepOrange,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.blueGrey,
  Colors.brown,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  // Colors.lime, //Too bright
];

/// The values of all the colours used in the clock
class ClockTheme extends ChangeNotifier {
  //This was designed to be easily changeable
  int _colorIndex = _colors.indexOf(Colors.blueGrey);
  MaterialColor get baseColor => _colors[_colorIndex % _colors.length];

  set colorIndex(int newIndex) {
    _colorIndex = newIndex;
    notifyListeners();
  }

  int get colorIndex => _colorIndex;

  Color get secondHand => baseColor[700];
  Color get minuteHand =>
      Color.alphaBlend(Colors.grey[600].withAlpha(200), baseColor);
  Color get hourHand =>
      Color.alphaBlend(Colors.grey[800].withAlpha(220), baseColor);

  Color get centralDot => Colors.grey[800];
  Color get quartersLight => Colors.grey[500];
  Color get quartersMid => Color.lerp(quartersLight, quartersDark, 0.5);
  Color get quartersDark => Colors.grey[600];

  Color get markerLight => Colors.grey[100];
  Color get markerDark =>
      Color.alphaBlend(backgroundLight.withAlpha(20), baseColor[400]);

  Color get backgroundLight => Colors.grey[100];
  Color get backgroundDark =>
      Color.alphaBlend(backgroundLight.withAlpha(20), baseColor[300]);

  Color get digitalLight =>
      Color.alphaBlend(Colors.grey[200].withAlpha(190), backgroundDark);
  Color get digitalDark =>
      Color.alphaBlend(baseColor[300].withAlpha(150), backgroundLight);

  Color get ampmHighlight => digitalLight;
  Color get ampmText => digitalLight;
  Color get ampmHighlightText => baseColor;

  Color get extrasText => backgroundDark;

  /// Helper function for Provider.of(context)
  static ClockTheme of(BuildContext context) =>
      Provider.of<ClockTheme>(context);
}
