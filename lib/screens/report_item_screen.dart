import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/items_provider.dart';
import '../utils/logger.dart';

class ReportItemScreen extends StatefulWidget {
  final bool isLostItem;

  const ReportItemScreen({super.key, required this.isLostItem});

  @override
  ReportItemScreenState createState() => ReportItemScreenState();
}

class ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _location;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newItem = Item(
        id: DateTime.now().toString(), // This should be generated by the backend in a real app
        title: _title,
        description: _description,
        location: _location,
        date: _date,
      );

      try {
        await Provider.of<ItemsProvider>(context, listen: false).addItem(newItem);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.isLostItem ? "Lost" : "Found"} item reported successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        logger.e('Error reporting item: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to report item. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report ${widget.isLostItem ? "Lost" : "Found"} Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                onSaved: (value) => _location = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Report ${widget.isLostItem ? "Lost" : "Found"} Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}