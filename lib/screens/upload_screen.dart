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

class UploadScreen extends StatelessWidget {
  static String routeName = 'upload';
  List<List<dynamic>> _data = [];
  String? filePath;
  static const int MAXCOLUMNUMBER = 12;

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
          onPressed: () async {
            pickFile(context);
          },
          child: const Text('Cargar XLS'),
        ),
      ),
    );
  }

  void pickFile(context) async {
    final uploadProvider = Provider.of<UploadProvider>(context, listen: false);

    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
        withData: true,
      );

      if (pickedFile != null) {
        var bytes = pickedFile.files.single.bytes;
        // print(bytes);
        List<List<dynamic>> excelData = [];

        var excel = Excel.decodeBytes(bytes!);
        for (var table in excel.tables.keys) {
          print(table); //sheet Name
          // print('Max Columns');
          // print(excel.tables[table]!.maxColumns);
          // print('Max Columns');
          // print(excel.tables[table]!.maxRows);

          for (var row in excel.tables[table]?.rows ?? []) {
            List<dynamic> rowData = [];

            for (var cell in row) {
              final value = cell!.value;
              // final numFormat =
              //     cell.cellStyle?.numberFormat ?? NumFormat.standard_0;
              // print(value);
              if (cell.rowIndex >= 1 && cell.columnIndex <= MAXCOLUMNUMBER) {
                // print(
                //     'numFormat $numFormat => $value  cellRowIndex = ${cell.rowIndex}   /   cellColumnIndex = ${cell.columnIndex}');
                rowData.add(value ?? '');
              }
            }
            // print('$row');
            if (rowData.isNotEmpty) excelData.add(rowData);
          }
        }
        // Ahora puedes usar la lista excelData como desees
        print('Datos leídos: $excelData');
        uploadProvider.excelDataList = excelData;
        Navigator.pushNamed(context, ItemListScreen.routeName);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
