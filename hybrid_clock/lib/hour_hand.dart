import 'dart:math';

import 'package:flare_dart/actor_bone.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

class HourHand extends StatefulWidget {
  const HourHand({Key key, this.time, this.color}) : super(key: key);
  final DateTime time;
  final Color color;

  @override
  _HourHandState createState() => _HourHandState();
}

class _HourHandState extends State<HourHand> {
  _HourController hourController = _HourController();
  Color prevColor;

  @override
  Widget build(BuildContext context) {
    //Change the color immediately
    if (prevColor != widget.color) {
      prevColor = widget.color;
      hourController.isActive.value = true;
    }
    hourController.time = widget.time;
    return FlareActor(
      'assets/animations/HourHand.flr',
      color: widget.color,
      controller: hourController,
    );
  }
}

const radians = pi / 180;

class _HourController extends FlareControls {
  ActorBone baseAngleBone;

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    baseAngleBone = artboard.getNode('BaseAngle') as ActorBone;
  }

  set time(DateTime time) {
    if (baseAngleBone != null) {
      baseAngleBone.rotation =
          (time.hour * 30 + time.minute * 0.5 + time.second / 120 - 90) *
              radians;
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
