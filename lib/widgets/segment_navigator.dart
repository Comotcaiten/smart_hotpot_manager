import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AdminView { overview, menu, table, account, order }

class SegmentMenu extends StatefulWidget {
  const SegmentMenu({super.key, required this.mapContents});

  final Map<AdminView, Map<SegmentText, Widget>>? mapContents;

  @override
  State<StatefulWidget> createState() => _SegmentMenuState();
}

class _SegmentMenuState extends State<SegmentMenu> {
  AdminView _select = AdminView.overview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoSlidingSegmentedControl<AdminView>(
            groupValue: _select,
            thumbColor: Colors.white,
            backgroundColor: Colors.transparent,
            onValueChanged: (value) {
              setState(() => _select = value!);
            },

            children: const {
              AdminView.overview: SegmentText(content: "Overview"),
              AdminView.menu: SegmentText(content: "Menu"),
              AdminView.table: SegmentText(content: "Table"),
              AdminView.order: SegmentText(content: "Order"),
              AdminView.account: SegmentText(content: "Account"),
            },
          ),
        ),

        child: Center(
          child: Column(
            children: [
              Text(
                'Selected Segment: < ${_select.name} >',
                style: TextStyle(color: CupertinoColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentText extends StatelessWidget {
  final String content;
  const SegmentText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        content,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
