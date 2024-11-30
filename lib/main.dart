import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist/Service/Auth_Service.dart';
import 'package:todolist/pages/AddTodo.dart';
import 'package:todolist/pages/HomePage.dart';
import 'package:todolist/pages/SignInPage.dart';
import 'package:todolist/pages/SignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignUpPage(); // Corrected variable name
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    // Initialize any state-related logic here if needed
  }

  void checkLogin() async {
    String? token = await authClass.getToken(); // token is nullable
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    } else {
      // If token is null, navigate to the SignInPage or handle accordingly
      setState(() {
        currentPage = SignInPage();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Use the currentPage variable
    );
  }
}
