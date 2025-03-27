import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String errorMessage = "";

  void addJob() async {
    if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty || priceController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Vyplňte všechna pole!";
      });
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("jobs").add({
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "price": priceController.text.trim(),
      "authorId": user.uid,
      "authorName": user.displayName ?? "Neznámý uživatel",
      "timestamp": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // ✅ Jemné světle šedé pozadí
      appBar: AppBar(
        title: const Text(
          "Přidat brigádu",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800], // ✅ Zachování tmavé lišty
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ✅ Chybová zpráva (pokud existuje)
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 10),

            // ✅ TextFieldy s tmavším pozadím a stíny
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300], // ✅ Tmavší pozadí TextFieldu
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MyTextfield(
                controler: titleController,
                hintText: "Název brigády",
                obscureText: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MyTextfield(
                controler: descriptionController,
                hintText: "Popis",
                obscureText: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MyTextfield(
                controler: priceController,
                hintText: "Cena",
                obscureText: false,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Odeslat tlačítko s jemným stínem
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 3,
                    blurRadius: 12,
                    offset: const Offset(0, 6), // Jemný stín
                  ),
                ],
              ),
              child: MyButton(
                onTap: addJob,
                text: "Odeslat",
              ),
            ),
          ],
        ),
      ),
    );
  }
}






