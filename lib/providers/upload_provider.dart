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
          final value = cell.value; // Obtiene el valor de la celda
          rowData.add(value); // Agrega el valor a la lista de la fila
        }

        // Verifica si el código de barras ya existe en la lista
        String? barcode = rowData.length > 1
            ? rowData[1].toString()
            : null; // El código de barras está en la segunda celda (índice 1)
        // print(barcode);
        bool exists = excelData.any((element) =>
            element.length > 1 && element[1].toString() == barcode);

        if (!exists && barcode != null) {
          excelData.add(
              rowData); // Agrega la fila completa a la lista principal si no existe
        }
      }
    }
    isLoading = false;
    excelDataList = excelData;
    // print(excelDataList.length);
  }
}
