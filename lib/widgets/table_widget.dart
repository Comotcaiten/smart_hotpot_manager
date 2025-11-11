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

class DataCellWidgetBadge extends StatelessWidget {
  const DataCellWidgetBadge({super.key, required this.option_1, required this.option_2, required this.inStock});

  final bool inStock;
  
  final String option_1;
  final String option_2;

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: inStock ? Colors.black : Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          inStock ? option_1 : option_2,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    ),
  );
  }
}