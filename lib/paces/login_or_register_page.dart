import 'package:flutter/material.dart';
import 'package:maturitagjjj/paces/login_page.dart';
import 'package:maturitagjjj/paces/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Přepínání mezi přihlášením a registrací
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(
      onTap: () => togglePages(), // ✅ Opraveno, správné volání funkce
    )
        : RegisterPage(
      onTap: () => togglePages(), // ✅ Opraveno, žádný error!
    );
  }
}
