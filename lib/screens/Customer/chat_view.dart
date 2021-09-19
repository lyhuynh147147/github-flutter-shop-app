import 'dart:async';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:phone_verification/helpers/chat_const.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/widgets/message_bubble.dart';

//FirebaseUser loggedInUser;
User loggedInUser;


class ChatScreen extends StatefulWidget {
  ChatScreen({this.isAdmin = false, this.uidCustomer = '', this.type});
  final bool isAdmin;
  final String uidCustomer;
  final String type;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  List<MessageBubble> messageBubbles = [];
  String messageText;
  String uid = '';
  List<Asset> images = [];
  StreamController _controller = new StreamController();

  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      uid = widget.uidCustomer;
      _controller.sink.add(widget.uidCustomer);
    } else {
      StorageUtil.getUid().then((uid) {
        _controller.sink.add(uid);
        this.uid = uid;
      });
    }
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  //TODO: Image product holder
  Widget imageGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(8),
          child: Stack(
            children: <Widget>[
              //TODO: image
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              //TODO: close
              GestureDetector(
                onTap: () {
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: kColorWhite,
                    ),
                    child: Icon(Icons.close,
                        color: kColorBlack,
                        size: 15)),
              )
            ],
          ),
        );
      }),
    );
  }

  //TODO Save Image to Firebase Storage
  Future saveImage(List<Asset> asset) async {
    firebase_storage.UploadTask uploadTask;
    List<String> linkImage = [];
    for (var value in asset) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = FirebaseStorage.instance.ref().child(fileName);
      ByteData byteData = await value.requestOriginal(quality: 70);
      var imageData = byteData.buffer.asUint8List();
      uploadTask = ref.putData(imageData);
      String imageUrl;
      await (await uploadTask).ref.getDownloadURL().then((onValue) {
        imageUrl = onValue;
      });
      linkImage.add(imageUrl);
    }
    return linkImage;
  }

  //TODO: load multi image
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Pick Product Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar:  widget.isAdmin
            ? AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black87,
              //size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/welcome_wall.jpg"),
                maxRadius: 20,
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Khách Hàng",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Active 1 min ago",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
          actions: [
            Icon(Icons.more_vert,color: Colors.grey.shade700,),
            SizedBox(width:10,),
          ],
        )
            : AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black87,
              //size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'welcome_screen');
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/welcome_wall.jpg"),
                maxRadius: 20,
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sale-Man",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Active 1 min ago",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          ),
          actions: [
            Icon(Icons.more_vert,color: Colors.grey.shade700,),
            SizedBox(width:10,),
          ],
        )  ,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10,),
            //TODO: Chat space
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, mainSnapshot) {
                if (mainSnapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Chat')
                        .doc(mainSnapshot.data)
                        .collection(mainSnapshot.data)
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || !mainSnapshot.hasData) {
                        return Container();
                      }
                      /*Map data = snapshot.data();*/
                      final messages = snapshot.data.docs.reversed;
                      messageBubbles = [];
                      for (var message in messages) {
                        Map data = message.data();
                        final messageText = data['text'];
                        final messageSender = data['sender'];
                        final List<dynamic> images = data['image'];
                        final currentUser = loggedInUser.email == null ? loggedInUser.phoneNumber : loggedInUser.email;

                        final messageBubble = MessageBubble(
                          context: context,
                          uid: uid,
                          createAt: data['timestamp'],
                          documentID: message.id,
                          sender: messageSender,
                          text: (messageText != null) ? messageText : '',
                          isAdmin: data['is_admin'],
                          isMe: currentUser == messageSender,
                          onlineImagesList:
                          (images != null || images.length != 0)
                              ? images
                              : [],
                        );

                        messageBubbles.add(messageBubble);
                      }
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          children: messageBubbles,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            //TODO: Image holder
            (images.length != 0) ? imageGridView() : Container(),
            //TODO: bottom chat sent
            //SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black.withOpacity(0.7)),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20 * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF00BF6D).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                loadAssets();
                              },
                              child: Container(

                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color
                                      .withOpacity(0.64),
                                  size: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                loadAssets();
                              },
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color
                                    .withOpacity(0.64),
                              ),
                            ),
                            //TODO: sent message
                            Expanded(
                              child: TextField(
                                controller: messageTextController,
                                onChanged: (value) {
                                  messageText = value;
                                },
                                decoration: kMessageTextFieldDecoration,
                              ),
                            ),
                            //TODO: sent message
                            FlatButton(
                              minWidth: 10,
                              onPressed: () async {
                                print(loggedInUser.uid);
                                if (images.length != 0) {
                                  List<String> listImages = await saveImage(images);
                                  FirebaseFirestore.instance
                                      .collection('Chat')
                                      .doc(uid)
                                      .collection(uid)
                                      .add({
                                    'roomId': uid,
                                    'text': messageText,
                                    'is_admin': widget.isAdmin ? true : false,
                                    'sender': loggedInUser.email == null ? loggedInUser.phoneNumber : loggedInUser.email,
                                    'image': listImages,
                                    'timestamp':
                                    DateTime.now().toUtc().millisecondsSinceEpoch
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Chat')
                                      .doc(uid)
                                      .collection(uid)
                                      .add({
                                    'roomId': uid,
                                    'text': messageText,
                                    'is_admin': widget.isAdmin ? true : false,
                                    'sender': loggedInUser.email == null ? loggedInUser.phoneNumber : loggedInUser.email,
                                    'image': [],
                                    'timestamp':
                                    DateTime.now().toUtc().millisecondsSinceEpoch}
                                  );
                                }
                                messageTextController.clear();
                                setState(() {
                                  images.clear();
                                });
                              },
                              child: Icon(
                                Icons.send_sharp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color
                                    .withOpacity(0.64),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );

  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
