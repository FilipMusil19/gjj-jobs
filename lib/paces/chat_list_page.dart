import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Přihlaste se pro zobrazení zpráv.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Zprávy", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("participants", arrayContains: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Žádné zprávy."));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index].data() as Map<String, dynamic>;

              // Načtení údajů z Firestore
              String? recipientId = chat["senderId"] == user.uid
                  ? chat["recipientId"]
                  : chat["senderId"];
              String lastMessage = chat["lastMessage"] ?? "Žádná zpráva";

              // Kontrola, zda recipientId existuje
              if (recipientId == null || recipientId.isEmpty) {
                return const ListTile(
                  title: Text(
                    "Neznámý uživatel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Žádná zpráva"),
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection("users").doc(recipientId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Načítání..."),
                    );
                  }

                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    return const ListTile(
                      title: Text(
                        "Neznámý uživatel",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Žádná zpráva"),
                    );
                  }

                  // Načítání jména
                  String recipientName = userSnapshot.data?.get("name") ?? "Neznámý uživatel";

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        recipientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              chatId: chats[index].id,
                              recipientId: recipientId,
                              recipientName: recipientName,
                              senderName: user.displayName ?? "Neznámý uživatel",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}










