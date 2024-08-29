import 'package:flutter/material.dart';

class UploadProvider extends ChangeNotifier {
  List<List<dynamic>> _excelDataList = [];

  List<List<dynamic>> get excelDataList => _excelDataList;

  set excelDataList(List<List<dynamic>> value) {
    _excelDataList = value;
  }
}
