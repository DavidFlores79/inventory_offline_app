import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inventory_offline_app/providers/upload_provider.dart';
import 'package:inventory_offline_app/screens/home_screen.dart';
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
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: excelDataList.length,
        itemBuilder: (context, index) {
          final row = excelDataList[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Código:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${row[1]}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${row[0]}'),
                    Text(
                      '${row[3]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text('${row[2]}'),
              ],
            ),
          );
        },
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
      decoration: BoxDecoration(color: Colors.purple[400]),
      child: RichText(
        text: TextSpan(
          text:
              'Verifica la lista de ${uploadProvider.excelDataList.length} artículos cargados. Si la lista es correcta puedes presionar ☑ o puedes ',
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
