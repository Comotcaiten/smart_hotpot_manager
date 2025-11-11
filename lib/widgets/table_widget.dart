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

class HeaderCellWidgetText extends StatelessWidget {
  final String? content;
  final TextAlign? align;

  const HeaderCellWidgetText({super.key, required this.content, this.align});

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

class DataCellWidgetText extends StatelessWidget {
  const DataCellWidgetText({super.key, this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(content ?? "", style: const TextStyle(fontSize: 14)),
    );
  }
}

class DataCellWidgetAction extends StatelessWidget {
  const DataCellWidgetAction({super.key, required this.editAction, required this.deleteAction});

  // final Widget child;
  final VoidCallback editAction;
  final VoidCallback deleteAction;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(onPressed: editAction, icon: Icon(Icons.edit_outlined, color: Colors.black)),
        IconButton(onPressed: deleteAction, icon: Icon(Icons.delete_outline, color: Colors.red)),
      ],),
    );
  }
}

// TableRow productDataRow(
//   String name,
//   String category,
//   String price,
//   bool inStock, {
//   bool highlighted = false,
// }) {
//   return TableRow(
//     decoration: BoxDecoration(
//       color: highlighted ? Colors.grey.shade100 : Colors.transparent,
//     ),
//     children: [
//       DataCellWidget(content: name),
//       DataCellWidget(content: category),
//       DataCellWidget(content: price),
//       DataCellWidget(),
//       DataCellWidget(),
//     ],
//   );
// }
