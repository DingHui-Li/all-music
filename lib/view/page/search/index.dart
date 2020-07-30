import 'package:allMusic/api/controller.dart';
import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/page/search/result/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Color _bgColor = Colors.white; //default value
  Color _primaryColor = Colors.white;
  Color _textColor = Colors.black;
  FocusNode _focusNode = FocusNode();
  bool _focus = false; //搜索框是否焦点
  bool _topbarElevation = true; //topbar是否显示阴影

  List musics=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      this.setState(() {
        this._focus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    _bgColor = getThemeColor(isDark)['_bgColor'];
    _primaryColor = getThemeColor(isDark)['_primaryColor'];
    _textColor = getThemeColor(isDark)['_textColor'];
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
              backgroundColor: _primaryColor,
              elevation: _topbarElevation ? 2 : 0,
              title: searchBar()),
          body: Stack(
            children: <Widget>[
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       IconButton(
              //         iconSize: 50,
              //         icon: FaIcon(FontAwesomeIcons.search),
              //         onPressed: (){},
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Text(
              //         '搜索',
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //       )
              //     ],
              //   ),
              // ),
              Result(data:this.musics),
              Visibility(
                visible: _focus,
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.2)),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                onEnd: () {
                  this.setState(() {
                    this._topbarElevation = !this._topbarElevation;
                  });
                },
                top: _focus ? 0 : -MediaQuery.of(context).size.height / 2,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height / 2),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                        historyItem(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: BoxDecoration(
          color: this._textColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(border: InputBorder.none),
        onChanged: (v){
          search(v).then((res){
            this.setState(() {this.musics=res;});
          });
        },
      ),
    );
  }

  Widget historyItem() {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.all(0),
        color: this._primaryColor,
        child: ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.fromLTRB(16, 3, 0, 3),
            dense: true,
            leading: FaIcon(
              FontAwesomeIcons.solidClock,
              size: 18,
            ),
            title: Text(
              "关键字",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.grey),
            ),
            trailing: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.arrowUp,
                size: 16,
              ),
              onPressed: () {},
            )));
  }
}
