import 'package:flutter/material.dart';

class ReportForm extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  const ReportForm({super.key, required this.onSubmit});

  @override
  ReportFormState createState() => ReportFormState();
}

class ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _location = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_title, _description, _location);
      
      // Show a snackbar to confirm submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      
      // Clear the form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) => _title = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onSaved: (value) => _description = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Location'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
            onSaved: (value) => _location = value!,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }
}