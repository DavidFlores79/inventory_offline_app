import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventory_offline_app/providers/upload_provider.dart';
import 'package:inventory_offline_app/screens/home_screen.dart';
import 'package:inventory_offline_app/screens/item_list_screen.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  static String routeName = 'upload';
  static const int MAXCOLUMNUMBER = 12;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? filePath;

  @override
  void initState() {
    // final uploadProvider = context.read<UploadProvider>();
    // uploadProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uploadProvider = Provider.of<UploadProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cargar XLS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: (uploadProvider.isLoading)
            ? CircularProgressIndicator()
            : TextButton(
                onPressed: () async {
                  uploadProvider.isLoading = true;
                  pickFile(uploadProvider);
                },
                child: const Text('Cargar XLS'),
              ),
      ),
    );
  }

  void pickFile(UploadProvider uploadProvider) async {
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
        withData: true,
      );

      if (pickedFile != null) {
        await uploadProvider.processXLSFile(pickedFile);
        Navigator.pushNamed(context, ItemListScreen.routeName);
      } else {
        uploadProvider.isLoading = false;
      }
    } catch (e) {
      print('Error: $e');
      final snackBar = SnackBar(
        content: Text('$e'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
