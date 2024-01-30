import 'package:flutter/material.dart';
import 'object_model.dart';

class ObjectEditScreen extends StatefulWidget {
  final ObjectModel? initialObject;

  const ObjectEditScreen({Key? key, this.initialObject}) : super(key: key);

  @override
  ObjectEditScreenState createState() => ObjectEditScreenState();
}

class ObjectEditScreenState extends State<ObjectEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late FocusNode _nameFocusNode;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialObject?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialObject?.description ?? '');

    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.initialObject == null ? 'Add Object' : 'Edit Object'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Name',
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              decoration: const InputDecoration(
                labelText: 'Description',
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveObject();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150.0, 50.0),
              ),
              child: Text(widget.initialObject == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveObject() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    final ObjectModel updatedObject = widget.initialObject != null
        ? widget.initialObject!.copyWith(
            name: name,
            description: description,
            timestamp: DateTime.now(),
          )
        : ObjectModel(
            name: name,
            description: description,
            timestamp: DateTime.now(),
          );

    Navigator.pop(context, updatedObject);
  }
}
