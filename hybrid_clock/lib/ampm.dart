import 'package:hybrid_clock/clock_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

/// AM/PM indicator. Only appears if not in 24h mode
class AmPm extends StatelessWidget {
  const AmPm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ClockModel>(context).is24HourFormat) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    DateTime now = Provider.of<DateTime>(context);
    bool am = now.hour < 12;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SelectedText(
          'AM',
          selected: am,
        ),
        _SelectedText(
          'PM',
          selected: !am,
        ),
      ],
    );
  }
}

/// Text box that highlights in a stadium border when [selected] is true
class _SelectedText extends StatelessWidget {
  const _SelectedText(this.text, {Key key, this.selected}) : super(key: key);
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    ClockTheme theme = ClockTheme.of(context);
    return Container(
      decoration: !selected
          ? null
          : ShapeDecoration(
              color: theme.ampmHighlight,
              shape: StadiumBorder(),
            ),
      child: Center(
        heightFactor: 1.2,
        widthFactor: 1.5,
        child: Text(
          text,
          style: TextStyle(
            fontSize: Provider.of<Size>(context).height / 12,
            fontWeight: FontWeight.w200,
            color: selected ? theme.ampmHighlightText : theme.ampmText,
          ),
        ),
      ),
    );
  }
}
