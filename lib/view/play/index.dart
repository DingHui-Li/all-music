import 'dart:ui';

import 'body.dart';
import 'package:flutter/material.dart';

class Play extends StatefulWidget {
  Play({Key key}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> with AutomaticKeepAliveClientMixin {
  List musics = [
    {
      'name': 'Lonely Girls',
      'singer': 'TV Girl',
      'duration': 175.0,
      'cover':
          'http://b-ssl.duitang.com/uploads/item/201409/05/20140905123336_3FcHn.jpeg'
    },
    {
      'name': 'Alive',
      'singer': 'Black Eyed Peas',
      'duration': 304.0,
      'cover':
          'http://f.hiphotos.baidu.com/zhidao/pic/item/9358d109b3de9c82fc1cb5336d81800a19d84314.jpg'
    },
    {
      'name': 'Out Of My Head (Original Mix)',
      'singer': 'Satin Jackets',
      'duration': 242.0,
      'cover':
          'http://images.0199.com.cn/data/attachment/forum/201401/23/021747g733piooe4sksq7e.jpg'
    },
  ];
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: PageView.builder(
            controller: _pageController,
            itemCount: musics.length,
            itemBuilder: (context, index) =>
                Image.network(musics[index]['cover'], fit: BoxFit.fill),
          ),
        )),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.grey,
            ),
          ),
        ),
        Body(
            musics: this.musics,
            changeMusic: (v) => this.setState(() {
                  _pageController.animateToPage(v,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastLinearToSlowEaseIn);
                }))
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
