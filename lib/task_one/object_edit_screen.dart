// object_edit_screen.dart

import 'package:flutter/material.dart';
import 'object_model.dart';

class ObjectEditScreen extends StatefulWidget {
  final ObjectModel? initialObject;

  const ObjectEditScreen({Key? key, this.initialObject}) : super(key: key);

  @override
  _ObjectEditScreenState createState() => _ObjectEditScreenState();
}

class _ObjectEditScreenState extends State<ObjectEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialObject?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialObject?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialObject == null ? 'Add Object' : 'Edit Object'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveObject();
              },
              child: Text(widget.initialObject == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveObject() async {
    // Get data from controllers and save or update the object
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    final ObjectModel updatedObject = widget.initialObject != null
        ? widget.initialObject!.copyWith(name: name, description: description)
        : ObjectModel(name: name, description: description);

    // Close the current screen and return the updatedObject to the previous screen
    Navigator.pop(context, updatedObject);
  }

}
