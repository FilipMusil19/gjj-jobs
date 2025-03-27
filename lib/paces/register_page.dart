import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  String errorMessage = "";

  void registrace() async {
    try {
      if (passwordController.text.trim() == confirmpasswordController.text.trim()) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String userName = nameController.text.trim();

        await userCredential.user!.updateDisplayName(userName);

        // ✅ Uložit uživatele do Firestore
        await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
          "name": userName,
          "email": emailController.text.trim(),
        });

        await Future.delayed(const Duration(seconds: 1)); // ✅ Počkáme na synchronizaci

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          errorMessage = 'Hesla se neshodují';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Chyba při registraci: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // ✅ Jemné světle šedé pozadí
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // ✅ Logo se stínem
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
                      height: 200,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // ✅ Text Registrace
                const Text(
                  "Vítej Gjj Jobs",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Chybová zpráva (pokud existuje)
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 10),

                // ✅ TextFieldy s tmavším pozadím
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Stejné tmavé pozadí jako okolí
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
                    controler: nameController,
                    hintText: 'Jméno',
                    obscureText: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    controler: emailController,
                    hintText: 'E-mail',
                    obscureText: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    controler: passwordController,
                    hintText: 'Heslo',
                    obscureText: true,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    controler: confirmpasswordController,
                    hintText: 'Heslo znovu',
                    obscureText: true,
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Registrovat tlačítko s jemným stínem
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    onTap: registrace,
                    text: 'Registrovat',
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Text pro přepnutí na přihlášení
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Už máš účet? ',
                      style: TextStyle(
                        color: Colors.black, // ✅ Černý obyčejný text
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap, // ✅ Klikací pouze na "Přihlaste se"
                      child: const Text(
                        'Přihlaš se',
                        style: TextStyle(
                          color: Colors.blue, // ✅ Modrý text
                          fontWeight: FontWeight.bold, // ✅ Zvýrazněný text
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


