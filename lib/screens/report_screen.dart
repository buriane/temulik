import 'package:flutter/material.dart';
import '../widgets/report_form.dart';
import '../utils/logger.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ReportForm(
          onSubmit: (title, description, location) {
            // Handle form submission here
            logger.i('Submitted: $title, $description, $location');
            // You would typically save this data or send it to a server
          },
        ),
      ),
    );
  }
}