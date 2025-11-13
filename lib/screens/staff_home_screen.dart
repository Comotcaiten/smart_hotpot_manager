import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Smart Hotpot Manager", subtitle: "Staff Page"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text("Staff Page"),
              ),
            ),
          ),
        ),
      ),
    );
  }

}