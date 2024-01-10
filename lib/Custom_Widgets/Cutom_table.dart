// ignore_for_file: file_names

import '../constants/light_constants.dart';
import 'package:flutter/material.dart';

class MyTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const MyTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return TableWidget(columns: columns, rows: rows);
  }
}

class TableWidget extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const TableWidget({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: periwinkleColor,
        width: 2.0,
      ),
      children: [
        TableRow(
          children: columns.map((columnName) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  columnName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: periwinkleColor,
                    fontSize: 20,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        for (var rowData in rows)
          TableRow(
            children: rowData.map((cellData) {
              return TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cellData,
                    style: const TextStyle(
                      color: periwinkleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
