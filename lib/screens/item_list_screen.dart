import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inventory_offline_app/providers/upload_provider.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatelessWidget {
  static String routeName = 'item_list';

  @override
  Widget build(BuildContext context) {
    final uploadProvider = Provider.of<UploadProvider>(context);
    List<List<dynamic>> excelDataList = uploadProvider.excelDataList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verificar Datos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              const snackBar = SnackBar(
                content: Text('Todo OK!!!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Message(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: _buildColumns(excelDataList),
                  rows: _buildRows(excelDataList),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(excelDataList) {
    if (excelDataList.isNotEmpty) {
      // Suponiendo que la primera fila contiene los títulos
      return excelDataList[0]
          .map<DataColumn>(
              (cellValue) => DataColumn(label: Text(cellValue.toString())))
          .toList();
    }
    return [];
  }

  List<DataRow> _buildRows(excelDataList) {
    if (excelDataList.isNotEmpty) {
      return excelDataList.skip(1).map<DataRow>((row) {
        return DataRow(
          cells: row.map<DataCell>((cellValue) {
            return DataCell(Text(cellValue.toString()));
          }).toList(),
        );
      }).toList();
    }
    return [];
  }
}

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadProvider = Provider.of<UploadProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.blue[400]),
      child: RichText(
        text: TextSpan(
          text:
              'Verifica la lista de artículos cargados. Si la lista es correcta puedes presionar ☑ o puedes ',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Cancelar',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration
                    .underline, // Para darle un subrayado similar a un link
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // uploadProvider.excelDataList = [];
                  uploadProvider.isLoading = false;
                  Navigator.pop(context);
                },
            ),
            const TextSpan(
              text: ' y volver a la pantalla anterior.',
            ),
          ],
        ),
      ),
    );
  }
}
