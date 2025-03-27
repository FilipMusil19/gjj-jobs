import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controler;
  final String hintText;
  final bool obscureText;

  const MyTextfield({
    super.key,
    required this.controler,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controler,
        obscureText: obscureText,
        autocorrect: true, // ✅ Podpora diakritiky
        enableSuggestions: true, // ✅ Povolení predikce textu
        keyboardType: TextInputType.text, // ✅ Podpora všech znaků
        textCapitalization: TextCapitalization.sentences, // ✅ Zachování české diakritiky
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2), // ✅ ČERNÝ OKRAJ
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2), // ✅ ČERNÝ OKRAJ PO KLIKNUTÍ
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.5), // ✅ ČERNÝ OKRAJ PŘED KLIKNUTÍM
          ),
        ),
      ),
    );
  }
}




