import 'package:flutter/material.dart';

class SongListTab extends StatefulWidget {
  SongListTab({Key key}) : super(key: key);

  @override
  _SongListTabState createState() => _SongListTabState();
}

class _SongListTabState extends State<SongListTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  indicatorWeight: 0,
                  indicator: ShapeDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  tabs: <Widget>[Tab(text: '创建歌单'), Tab(text: '收藏歌单')],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 500,
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Wrap(
                        children: <Widget>[
                          item(),
                          item(),
                          item(),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget item() {
    return Container(
        width: MediaQuery.of(context).size.width / 2 - 10,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Image.network(
                    'http://y.gtimg.cn/music/photo_new/T002R180x180M000002lJJi244utqN_1.jpg',
                    fit: BoxFit.cover),
              )),
          title: Text('歌单名'),
          subtitle: Text('300首'),
        ));
  }
}
