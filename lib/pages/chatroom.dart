import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whproject/service/database.dart';

class ChatRoom extends StatefulWidget {
  String groupId="";
  String groupName="";
  String userName="";
  ChatRoom({Key? key, required this.groupId, required this.groupName,required this.userName }) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}
class _ChatRoomState extends State<ChatRoom> {
  Stream? chatRoomStream;
  String chatMessage = "";
  String user= "";

  @override
  void initState() {
    super.initState();
    getChat();
  }

  getChat() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getChatData(widget.groupId).then((snapshot) {
      setState(() {
        chatRoomStream = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0XFFF18800),
        title: const Text("Chat Room", style: TextStyle(color: Colors.white30)),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 80),
            child: StreamBuilder(
              stream: chatRoomStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            message: snapshot.data!.docs[index].data()["message"],
                            user: snapshot.data!.docs[index].data()["username"],
                            sendByMe: FirebaseAuth.instance.currentUser!.uid == snapshot.data!.docs[index]['uid'],
                          );
                        })
                    : const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0XFFF18800),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        chatMessage = value;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      controller: TextEditingController(text: chatMessage),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (chatMessage.isNotEmpty) {
                        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addChatMessage(
                            widget.groupId,
                            chatMessage,
                            widget.userName,
                            FirebaseAuth.instance.currentUser!.uid);
                        setState(() {
                          chatMessage = "";
                          TextEditingController(text: chatMessage).clear();
                        });
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  MessageTile({required String message,required String user, required bool sendByMe}) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: sendByMe ? const EdgeInsets.only(top: 15, bottom: 15, left: 17, right: 17):
        const EdgeInsets.only(top: 2, bottom: 15, left: 17, right: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: sendByMe ? const Color(0xffFFBE49) : const Color(0xffB25500),
        ),
        child: sendByMe ? Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
            const SizedBox(height: 3,),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
      ),
    ),
  );

  }
}