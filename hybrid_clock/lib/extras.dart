import 'package:hybrid_clock/clock_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Show the date in three lines. Eg: Saturday, November 7th
class Date extends StatelessWidget {
  const Date({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: ClockTheme.of(context).extrasText,
        ),
        //Using the selector to only rebuild when date changes
        child: Selector<DateTime, DateTime>(
          selector: (_, dateTime) =>
              DateTime(dateTime.year, dateTime.month, dateTime.day),
          builder: (_, DateTime date, __) {
            String dayOfWeek = DateFormat('EEEE').format(date);
            String month = DateFormat('MMMM').format(date);
            String dayOfMonth = _ordinal(date.day);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$dayOfWeek,'.toUpperCase(),
                  style: TextStyle(
                    fontSize: Provider.of<Size>(context).height / 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    fontSize: Provider.of<Size>(context).height / 13,
                  ),
                ),
                Text(
                  dayOfMonth,
                  style: TextStyle(
                    fontSize: Provider.of<Size>(context).height / 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Get the ordinal for a number. Eg: 4 -> 4th
  String _ordinal(int number) {
    String suffix = 'th';
    final int digit = number % 10;
    if ((digit > 0 && digit < 4) && (number < 11 || number > 13)) {
      suffix = <String>['st', 'nd', 'rd'][digit - 1];
    }
    return '$number$suffix';
  }
}

/// Show the current temperature and an icon showing the weather
class Weather extends StatelessWidget {
  const Weather({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClockModel model = Provider.of<ClockModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: Provider.of<Size>(context).height / 12,
          fontWeight: FontWeight.w300,
          color: ClockTheme.of(context).extrasText,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(model.temperatureString),
            SizedBox(
              width: Provider.of<Size>(context).height * 0.04,
            ),
            _WeatherIcon(model.weatherCondition),
          ],
        ),
      ),
    );
  }
}

/// Takes a WeatherCondition and returns an appropriate icon
class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon(this.weather, {Key key}) : super(key: key);
  final WeatherCondition weather;

  IconData _getIcon(WeatherCondition weather) {
    switch (weather) {
      case WeatherCondition.cloudy:
        return FontAwesomeIcons.cloud;
        break;
      case WeatherCondition.foggy:
        return FontAwesomeIcons.smog;
        break;
      case WeatherCondition.rainy:
        return FontAwesomeIcons.cloudRain;
        break;
      case WeatherCondition.snowy:
        return FontAwesomeIcons.snowflake;
        break;
      case WeatherCondition.sunny:
        return FontAwesomeIcons.sun;
        break;
      case WeatherCondition.thunderstorm:
        return FontAwesomeIcons.bolt;
        break;
      case WeatherCondition.windy:
        return FontAwesomeIcons.wind;
        break;
      default:
        return FontAwesomeIcons.sun;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(weather),
      color: ClockTheme.of(context).backgroundDark,
      size: Provider.of<Size>(context).height / 12,
    );
  }
}
