import 'dart:math';

import 'package:flare_dart/actor_bone.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

class SecondHand extends StatefulWidget {
  const SecondHand({Key key, @required this.time, this.color})
      : super(key: key);
  final DateTime time;
  final Color color;

  @override
  _SecondHandState createState() => _SecondHandState();
}

class _SecondHandState extends State<SecondHand> {
  _SecondController secondController = _SecondController();
  num prevSeconds = 0;
  Color prevColor;

  @override
  Widget build(BuildContext context) {
    //Change the color immediately
    if (prevColor != widget.color) {
      prevColor = widget.color;
      secondController.isActive.value = true;
    }
    if (prevSeconds != widget.time.second) {
      secondController.seconds = widget.time.second;
      prevSeconds = widget.time.second;
    }
    return FlareActor(
      'assets/animations/SecondHand.flr',
      color: widget.color,
      controller: secondController,
    );
  }
}

const radians = pi / 180;

class _SecondController extends FlareControls {
  ActorBone baseAngleBone;

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    baseAngleBone = artboard.getNode('BaseAngle') as ActorBone;
  }

  /// Number of seconds for the second hand
  set seconds(int seconds) {
    if (baseAngleBone != null) {
      baseAngleBone.rotation = (seconds * 6 - 90) * radians;
      play('Wobble2');
    }
  }
}
