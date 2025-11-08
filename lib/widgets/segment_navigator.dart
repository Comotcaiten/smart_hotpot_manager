import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AdminView { overview, menu, table, account, order }

class SegmentMenu extends StatefulWidget {
  const SegmentMenu({super.key, this.child});

  final Widget? child;

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
              AdminView.overview: _SegmentText("Overview"),
              AdminView.menu: _SegmentText("Menu"),
              AdminView.table: _SegmentText("Table"),
              AdminView.order: _SegmentText("Order"),
              AdminView.account: _SegmentText("Account"),
            },
          ),
        ),

        child: Center(
          child:
              widget.child ??
              Text(
                'Selected Segment: ${_select.name}',
                style: TextStyle(color: CupertinoColors.black),
              ),
        ),
      ),
    );
  }
}

class _SegmentText extends StatelessWidget {
  final String text;
  const _SegmentText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
