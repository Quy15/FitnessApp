import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/chat_bubble.dart';
import 'package:dev/services/chat_services.dart';
import 'package:dev/tablayout/tab_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.receiveUserName, required this.receiveUID});

  final String receiveUserName;
  final String receiveUID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMess() async {
    //Chỉ gửi khi có nhập tin nhắn
    if(_messageController.text.isNotEmpty)
    {
      await _chatServices.sendMessage(widget.receiveUID, _messageController.text);
      _messageController.clear();
    }
  }

  String name = " ";
  String id = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
          this.name = '${doc['email']}';
          print(id);
          print(name);
        });
      });
    });
  }

  Future getPT(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
          this.name = '${doc['email']}';
          print(id);
          print(name);
        });
      });
    });
  }

  @override
  void initState(){
    getUserByEmail(_firebaseAuth.currentUser?.email);
    getPT(_firebaseAuth.currentUser?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserName),
        centerTitle: true,  
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CallView(callID: "1", username: id)));
            },
            icon: Icon(Icons.video_call))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            //danh sach tin nhắn
            child: _buildMessageList(),
          ),
            
          //Người dùng nhập tin nhắn
          _builtUserInput()
        ],
      ),
    );
  }

  //message list
  Widget _buildMessageList(){
    return StreamBuilder(stream: _chatServices.getMessages(widget.receiveUID, _firebaseAuth.currentUser!.uid), 
    builder: (context, snapshot) {
      if(snapshot.hasError){
        return Text('Error: ' + snapshot.error.toString()); 
      }

      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading ....");
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItems(document)).toList(),
      );
    },);
  }


  //messgae items
  Widget _buildMessageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    var align = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 10,),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }


  //user input
  Widget _builtUserInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                color: Colors.deepPurpleAccent),
                borderRadius: BorderRadius.circular(10)),
                hintText: 'Nhập tin nhắn ....',
                fillColor: Colors.grey[200],
                filled: true,
             ),
            ),
          ),
          IconButton(onPressed: sendMess, icon: Icon(Icons.arrow_upward, size: 40,))
        ],
      ),
    );
  }
}