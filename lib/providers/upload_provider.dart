import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:inventory_offline_app/screens/upload_screen.dart';

class UploadProvider extends ChangeNotifier {
  List<List<dynamic>> _excelDataList = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<List<dynamic>> get excelDataList => _excelDataList;

  set excelDataList(List<List<dynamic>> value) {
    _excelDataList = value;
  }

  processXLSFile(pickedFile) {
    var bytes = pickedFile.files.single.bytes;
    // print(bytes);
    List<List<dynamic>> excelData = [];

    var excel = Excel.decodeBytes(bytes!);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]?.rows ?? []) {
        List<dynamic> rowData = [];
        for (var cell in row) {
          final value = cell!.value;
          if (cell.rowIndex >= 1 &&
              cell.columnIndex <= UploadScreen.MAXCOLUMNUMBER) {
            rowData.add(value ?? '');
          }
        }
        if (rowData.isNotEmpty) excelData.add(rowData);
      }
    }
    isLoading = false;
    excelDataList = excelData;
  }
}
