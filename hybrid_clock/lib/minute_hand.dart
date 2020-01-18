import 'dart:math';

import 'package:flare_dart/actor_bone.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

class MinuteHand extends StatefulWidget {
  const MinuteHand({Key key, @required this.time, this.color})
      : super(key: key);
  final DateTime time;
  final Color color;

  @override
  _MinuteHandState createState() => _MinuteHandState();
}

class _MinuteHandState extends State<MinuteHand> {
  _MinuteController minuteController = _MinuteController();

  @override
  Widget build(BuildContext context) {
    minuteController.time = widget.time;
    return FlareActor(
      'assets/animations/MinuteHand.flr',
      color: widget.color,
      controller: minuteController,
    );
  }
}

const radians = pi / 180;

class _MinuteController extends FlareControls {
  ActorBone baseAngleBone;

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    baseAngleBone = artboard.getNode('BaseAngle') as ActorBone;
  }

  set time(DateTime time) {
    if (baseAngleBone != null) {
      baseAngleBone.rotation =
          (time.minute * 6 + time.second * 0.1 - 90) * radians;
      isActive.value = true;
    }
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    // De-activate the controller, and stop advancing.
    isActive.value = false;
    return false;
  }
}
