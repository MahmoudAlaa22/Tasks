import 'dart:developer';

import 'package:flutter/material.dart';

class WidgetOfScaleTransition extends StatefulWidget {
  Widget child;
  WidgetOfScaleTransition({@required this.child});

  @override
  _WidgetOfScaleTransitionState createState() => _WidgetOfScaleTransitionState();
}

class _WidgetOfScaleTransitionState extends State<WidgetOfScaleTransition> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> scaleAnimation;
  final form=GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale:scaleAnimation,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
