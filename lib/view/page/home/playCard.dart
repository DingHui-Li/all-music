import 'dart:ui';

import 'package:allMusic/view/play/index.dart';
import 'package:allMusic/view/test2.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayCard extends StatefulWidget {
  final sc;
  final primaryColor;
  final textColor;
  PlayCard({Key key, this.sc,this.primaryColor,this.textColor}) : super(key: key);

  @override
  _PlayCardState createState() => _PlayCardState();
}

class _PlayCardState extends State<PlayCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _scrollTop = false; //是否向上滑动
  bool _movePos = false;
  bool _showCardContent = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (widget.sc != null) {
      widget.sc.addListener(() {
        var temp = false; //避免重复更新-
        if (widget.sc.offset < 10) {
          temp = false;
          if (temp != this._scrollTop) {
            this.setState(() {
              this._scrollTop = temp;
              this._movePos = false;
            });
          }
        } else {
          temp = true;
          this._animationController.forward();
          if (temp != this._scrollTop) {
            this.setState(() {
              this._scrollTop = temp;
              this._movePos = false;
              this._showCardContent = false;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _cardHeight = 80;
    double _cardFullWidth = MediaQuery.of(context).size.width - 20;
    double _top = MediaQuery.of(context).size.height / 3 +
        MediaQueryData.fromWindow(window).padding.top-40;
    double _bottom = MediaQuery.of(context).size.height - 120;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      top: (_scrollTop && _movePos) ? _bottom : _top,
      onEnd: () {
        this._animationController.reset();
        if (!this._scrollTop) {
          this.setState(() {
            this._showCardContent = true;
          });
        }
      },
      right: 10,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          width: _scrollTop ? _cardHeight : _cardFullWidth,
          height: _cardHeight,
          onEnd: () {
            //宽度动画完成后再开始位置动画
            if (!this._movePos) {
              this._movePos = true;
              this.setState(() {});
            }
          },
          decoration: BoxDecoration(
            color: widget.primaryColor,
            borderRadius:
                BorderRadius.all(Radius.circular(_scrollTop ? _cardHeight : 10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(_scrollTop ? 0.1 : 0.03),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ],
          ),
          child: OpenContainer(
            closedColor: widget.primaryColor,
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(_scrollTop ? _cardHeight : 10)),
            closedBuilder: (context, action) => Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(_scrollTop ? _cardHeight : 10))),
              child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return cardItem(_cardHeight);
                  }),
            ),
            openBuilder: (context, action) => Test(),
          )),
    );
  }

  Widget cardItem(_cardHeight) {
    return Container(
      decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius:
              BorderRadius.all(Radius.circular(_scrollTop ? _cardHeight : 10))),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: RotationTransition(
                turns: _animationController,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Image.network(
                          'http://y.gtimg.cn/music/photo_new/T002R180x180M000004VfM814VFuNw_1.jpg',
                          fit: BoxFit.cover),
                    ),
                    // Visibility(
                    //     visible: _scrollTop,
                    //     child: Container(
                    //       color: Colors.black.withOpacity(0.2),
                    //       child: ConstrainedBox(
                    //         constraints: BoxConstraints.expand(),
                    //         child: ClipOval(
                    //           child: Material(
                    //             color: Colors.transparent,
                    //             child: IconButton(
                    //               icon: FaIcon(FontAwesomeIcons.play),
                    //               onPressed: () {},
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ))
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: Visibility(
                visible: !_scrollTop,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Uu',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '夏天的风',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color:widget.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )),
          Visibility(
              visible: !_scrollTop,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.play,
                        color: widget.textColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
