import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class musicCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String cover;
  final Color color;
  final primaryColor;
  const musicCard(
      {Key key,
      this.icon,
      this.title,
      this.cover,
      this.color = Colors.white,
      this.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: this.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: cover != ''
                ? Image.network(cover, fit: BoxFit.cover)
                : Center(
                    child: icon,
                  ),
          ),
          Visibility(
            visible: cover != '',
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.black.withOpacity(0.7),
                Colors.transparent
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 40,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: this.color),
                  ),
                )),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Material(
              color: Colors.transparent,
              child: RawMaterialButton(
                padding: EdgeInsets.all(0),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
