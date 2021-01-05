import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlutterExample(),
    );
  }
}

class FlutterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: new List.generate(5, (i)=>new ListTileItem(
          title: "Item#$i",
        )),
      ),
    );
  }
}
class ListTileItem extends StatefulWidget {
  String title;
  ListTileItem({this.title});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int _itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.title),
      subtitle: new Row(
        children: <Widget>[
          _itemCount!=0? new  IconButton(icon: new Icon(Icons.remove),onPressed: ()=>setState(()=>_itemCount--),):new Container(),
          new Text(_itemCount.toString()),
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: (){
                print(_itemCount);
                return setState(()=>_itemCount++);
              }
          ),
          new IconButton(
              icon: new Icon(Icons.send),
              onPressed: (){
                print(_itemCount);
              }
          )
        ],
      ),
    );
  }
}