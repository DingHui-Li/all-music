import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final List data;
  Result({Key key, this.data}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          var music = widget.data[index];
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
                title: Text(
                  music['name'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_singer(music['source'], music['singer']),
                        overflow: TextOverflow.ellipsis),
                    // SizedBox(width: 5),
                    // Text(' - ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                    // SizedBox(width: 5),
                    Text(music['album']['name'],
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
                isThreeLine: true,
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Visibility(
                    visible: music['album']['img'] != '',
                    child: Image.network(
                      music['album']['img'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/logo/${music['source']}.jpg'),
                ),
                onTap: () {}),
          );
        });
  }

  _singer(source, singer) {
    if (source == 'kg') {
      return singer;
    } else {
      if (singer is List) {
        String s = singer.fold('', (curr, next) => curr + '/' + next['name']);
        return s.replaceFirst('/', '');
      }
    }
    return 'unknow';
  }
}
