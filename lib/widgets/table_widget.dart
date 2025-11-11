import 'dart:ffi';

import 'package:flutter/material.dart';

class BaseTable extends StatelessWidget {
  const BaseTable({
    super.key,
    required this.columnWidths,
    required this.buildHeaderRow,
    required this.buildDataRow,
  });

  final TableRow buildHeaderRow;

  final List<TableRow> buildDataRow;

  final Map<int, TableColumnWidth>? columnWidths;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade300),
      ),
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,

      children: <TableRow>[ 
        buildHeaderRow,
        for (int i = 0; i < buildDataRow.length; i++) buildDataRow[i],
      ],
    );
  }
}

class HeaderCellWidget extends StatelessWidget {
  final String? content;
  final TextAlign? align;

  const HeaderCellWidget({super.key, required this.content, this.align});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        content ?? "",
        textAlign: align ?? TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class DataCellWidget extends StatelessWidget {
  const DataCellWidget({super.key, this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(content ?? "", style: const TextStyle(fontSize: 14)),
    );
  }
}

TableRow productDataRow(
  String name,
  String category,
  String price,
  bool inStock, {
  bool highlighted = false,
}) {
  return TableRow(
    decoration: BoxDecoration(
      color: highlighted ? Colors.grey.shade100 : Colors.transparent,
    ),
    children: [
      DataCellWidget(content: name),
      DataCellWidget(content: category),
      DataCellWidget(content: price),
      DataCellWidget(),
      DataCellWidget(),
    ],
  );
}

TableRow categoryDataRow(
  String name,
  String amount,
  bool delete, {
  bool highlighted = false,
}) {
  return TableRow(
    decoration: BoxDecoration(
      color: highlighted ? Colors.grey.shade100 : Colors.transparent,
    ),
    children: [
      DataCellWidget(content: name),
      DataCellWidget(),
    ],
  );
}
