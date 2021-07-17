import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonDateOrTime extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;
  const ButtonDateOrTime({@required this.onTap,@required this.iconData,@required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 2)]
            ),
        child: Row(
          mainAxisSize:MainAxisSize.min ,
          children: [
            Icon(iconData),
            Text(title)
          ],
        ),
      )),
    );
  }
}
