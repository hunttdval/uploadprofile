import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDelete extends StatefulWidget {
  @override
  _ProfileDeleteState createState() => _ProfileDeleteState();
}

class _ProfileDeleteState extends State<ProfileDelete> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete shoe profile")),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.docs.map((doc) {
                      return GestureDetector(
                        child: ListTile(
                          leading: CircleAvatar(
                            child:ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: doc.data()["url"],
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        colorFilter:
                                        ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                                  ),
                                ),
                                //placeholder: (context, url) => CircularProgressIndicator(),
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          title: Text('Shoe: ' + doc.data()["name"]),
                          subtitle: Text('Cost: ' + doc.data()["price"].toString()),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await db
                                    .collection('items')
                                    .doc(doc.id)
                                    .delete();
                              }
                          ),
                          dense: true,
                          //selected: true,
                        ),
                        onTap: () {
                          Tooltip(message: 'Tap on Icon to Delete!');
                        },
                      );

                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}