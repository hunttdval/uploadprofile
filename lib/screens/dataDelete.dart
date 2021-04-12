import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
class ProfileDelete extends StatefulWidget {
  @override
  _ProfileDeleteState createState() => _ProfileDeleteState();
}

class _ProfileDeleteState extends State<ProfileDelete> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseFirestore dbcol = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Meal profile")),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('inst').doc('mustOne').collection('items').snapshots(),
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
                          title: Text('Meal: ' + doc.data()["name"]),
                          subtitle: Text('Cost: ' + doc.data()["price"].toString()),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                if(doc.id != null){
                                  String imageUrl = doc.data()['url'];
                                  StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
                                  print('The Ref is: ' + storageReference.path);
                                  storageReference.delete();
                                  print('image deleted');
                                  setState(() {
                                    print("Image Deleted Done");
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text(
                                          'Deletion Successful',
                                          textAlign: TextAlign.center,
                                        ),
                                        ));
                                  });
                                }
                                await db
                                    .collection('inst')
                                    .doc('mustOne')
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