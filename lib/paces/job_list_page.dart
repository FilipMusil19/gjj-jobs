import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[200], // ✅ Jemné světle šedé pozadí
      appBar: AppBar(
        title: const Text(
          "Najít brigádu",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800], // ✅ Zachování šedé lišty
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("jobs").orderBy("timestamp", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Žádné brigády."));
          }

          var jobs = snapshot.data!.docs;

          // ✅ Rozdělení brigád na uživatelovy a ostatní
          var myJobs = jobs.where((job) => job["authorId"] == user?.uid).toList();
          var otherJobs = jobs.where((job) => job["authorId"] != user?.uid).toList();

          return ListView(
            children: [
              ...myJobs.map((job) => _buildJobCard(context, job, isMyJob: true)),
              ...otherJobs.map((job) => _buildJobCard(context, job, isMyJob: false)),
            ],
          );
        },
      ),
    );
  }

  // ✅ Vytváří kartu pro brigádu se stíny a moderním designem
  Widget _buildJobCard(BuildContext context, QueryDocumentSnapshot jobDoc, {required bool isMyJob}) {
    User? user = FirebaseAuth.instance.currentUser;
    var job = jobDoc.data() as Map<String, dynamic>;

    String jobId = jobDoc.id;
    String jobTitle = job["title"];
    String jobDescription = job["description"];
    String jobPrice = job["price"].toString(); // ✅ Převod ceny na String
    String authorId = job["authorId"];
    String authorName = job["authorName"] ?? "Neznámý uživatel";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          jobTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobDescription,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                "Cena: $jobPrice Kč",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
              ),
              Text(
                "Tvůrce: $authorName",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        trailing: isMyJob
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteJob(context, jobId),
        )
            : IconButton(
          icon: const Icon(Icons.favorite, color: Colors.pink), // ✅ Srdíčko pro ostatní brigády
          onPressed: () => _startChat(context, authorId, authorName),
        ),
      ),
    );
  }

  // ✅ Funkce pro smazání brigády
  void _deleteJob(BuildContext context, String jobId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Smazat brigádu"),
        content: const Text("Opravdu chcete smazat tuto brigádu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Zrušit", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Smazat", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance.collection("jobs").doc(jobId).delete();
    }
  }

  // ✅ Funkce pro zahájení chatu
  void _startChat(BuildContext context, String recipientId, String recipientName) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // ✅ Najdi existující chat mezi uživateli nebo vytvoř nový
    QuerySnapshot chatQuery = await FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: user.uid)
        .get();

    String? chatId;

    for (var chatDoc in chatQuery.docs) {
      var chatData = chatDoc.data() as Map<String, dynamic>;
      List participants = chatData["participants"];
      if (participants.contains(recipientId)) {
        chatId = chatDoc.id;
        break;
      }
    }

    if (chatId == null) {
      // ✅ Pokud chat neexistuje, vytvoř nový
      DocumentReference newChatRef = await FirebaseFirestore.instance.collection("chats").add({
        "participants": [user.uid, recipientId],
        "lastMessage": "",
        "lastMessageTime": FieldValue.serverTimestamp(),
        "senderId": user.uid,
        "senderName": user.displayName ?? "Neznámý uživatel",
      });

      chatId = newChatRef.id;
    }

    // ✅ Přesměruj uživatele do chatu
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          chatId: chatId!,
          recipientId: recipientId,
          recipientName: recipientName,
          senderName: user.displayName ?? "Neznámý uživatel",
        ),
      ),
    );
  }
}
