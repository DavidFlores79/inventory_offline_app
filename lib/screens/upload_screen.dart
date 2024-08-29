import 'package:flutter/material.dart';
import 'package:inventory_offline_app/screens/home_screen.dart';

class UploadScreen extends StatelessWidget {
  static String routeName = 'upload';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cargar XLS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
          child: const Text('Cargar XLS'),
        ),
      ),
    );
  }
}
