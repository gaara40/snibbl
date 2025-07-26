import 'package:flutter/material.dart';
import 'package:storygram/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AuthServices().signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Hi, this is the main page')),
    );
  }
}
