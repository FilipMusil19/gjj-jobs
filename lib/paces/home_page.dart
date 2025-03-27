import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_job_page.dart';
import 'job_list_page.dart';
import 'chat_list_page.dart';
import 'login_or_register_page.dart';
import '../components/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true, // ✅ Centrovaný text v AppBaru
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("Načítání...", style: TextStyle(color: Colors.white));
            }
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              userData["name"] ?? "Neznámý uživatel",
              style: TextStyle(
                fontWeight: FontWeight.bold, // ✅ Tučné písmo
                fontSize: 20, // ✅ Ponechaná rozumná velikost
                color: Colors.white, // ✅ Bílé písmo
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5), // ✅ Jemný stín za textem
                    offset: const Offset(1, 1), // Posun stínu
                    blurRadius: 3, // Jemný rozmazaný stín
                  ),
                ],
              ),
            );
          },
        ),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // ✅ LOGO s decentním stínem
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5), // Posun stínu dolů
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "images/logo.png",
                  height: 180,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Vítejte text
            const Text(
              "Vítejte v GJJ Jobs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 50),

            // ✅ Přidat brigádu tlačítko se stínem
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4), // Stín pod tlačítkem
                  ),
                ],
              ),
              child: MyButton(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddJobPage())),
                text: "Přidat brigádu",
              ),
            ),

            // ✅ Najít brigádu tlačítko se stínem
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MyButton(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JobListPage())),
                text: "Najít brigádu",
              ),
            ),

            // ✅ Chat tlačítko se stínem
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MyButton(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListPage())),
                text: "Chat",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

