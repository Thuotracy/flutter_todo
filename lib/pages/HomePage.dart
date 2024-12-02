import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/Service/Auth_Service.dart';
import 'package:todolist/pages/SignUpPage.dart';
import 'package:todolist/pages/TodoCard.dart';
import 'package:todolist/pages/view_data.dart';
import 'AddTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Your Tasks",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22),
              child: Text(
                "Today",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }

          final data = snapshot.data!;

          // Initialize the 'selected' list when snapshot changes
          selected = List.generate(
            data.docs.length,
                (index) => Select(
              id: data.docs[index].id,
              checkValue: false,
            ),
          );

          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              var doc = data.docs[index];

              return InkWell(
                onTap: () {
                  // Pass the 'doc' parameter to ViewData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewData(
                        doc: doc.data() as Map<String, dynamic>,
                        id: doc.id,
                      ),
                    ),
                  );
                },
                child: TodoCard(
                  id: doc.id,
                  title: doc.get('title') ?? 'No Title',
                  check: selected[index].checkValue,
                  dueDate: doc.get('dueDate') ?? 'No Due Date',
                  index: index,
                  OnChange: onChange,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        backgroundColor: const Color(0xfffd746c),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  void onChange(bool? value, int index) {
    setState(() {
      selected[index].checkValue = value ?? false; // Ensure null safety
    });
  }

}

class Select {
  String id;
  bool checkValue;
  Select({required this.id, required this.checkValue});
}
