import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';

class TabActivity extends StatefulWidget {
  final String tab1;
  final String tab2;
  final Widget page1;
  final Widget page2;

  const TabActivity({
    super.key,
    required this.tab1,
    required this.tab2,
    required this.page1,
    required this.page2,
  });

  @override
  State<TabActivity> createState() => _TabActivityState();
}

class _TabActivityState extends State<TabActivity> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: AppColors.green,
            indicatorWeight: 3,
            labelColor: AppColors.green,
            unselectedLabelColor: Colors.black,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: widget.tab1),
              Tab(text: widget.tab2),
            ],
          ),
          title: const Center(child: Text('Aktivitas')),
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            widget.page1,
            widget.page2,
          ],
        ),
      ),
    );
  }
}
