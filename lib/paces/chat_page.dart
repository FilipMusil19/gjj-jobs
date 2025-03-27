import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String recipientId;
  final String recipientName;
  final String senderName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.recipientId,
    required this.recipientName,
    required this.senderName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String messageText = messageController.text.trim();
    messageController.clear();

    // Uloží zprávu do Firestore s kontrolou diakritiky
    await FirebaseFirestore.instance.collection("chats").doc(widget.chatId).collection("messages").add({
      "senderId": user?.uid,
      "senderName": user?.displayName ?? "Neznámý uživatel",
      "text": messageText,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // Aktualizuje poslední zprávu v chatu
    await FirebaseFirestore.instance.collection("chats").doc(widget.chatId).set({
      "lastMessage": messageText,
      "lastMessageTime": FieldValue.serverTimestamp(),
      "lastSenderId": user?.uid,
      "lastSenderName": user?.displayName ?? "Neznámý uživatel",
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Správné pozadí
      appBar: AppBar(
        title: Text(
          widget.recipientName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ), // Zobrazuje správné jméno příjemce
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Žádné zprávy."));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message["senderId"] == user?.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe ? "Ty" : (message["senderName"] ?? "Neznámý uživatel"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message["text"] ?? "",
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Napište zprávu...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



