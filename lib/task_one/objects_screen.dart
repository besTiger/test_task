// objects_screen.dart

import 'package:flutter/material.dart';
import 'object_dao.dart';
import 'object_model.dart';
import 'object_edit_screen.dart';

class ObjectsScreen extends StatefulWidget {
  const ObjectsScreen({Key? key}) : super(key: key);

  @override
  _ObjectsScreenState createState() => _ObjectsScreenState();
}

class _ObjectsScreenState extends State<ObjectsScreen> {
  final ObjectDao objectDao = ObjectDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects List'),
      ),
      body: FutureBuilder<List<ObjectModel>>(
        future: objectDao.getAllObjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No objects available'),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updatedObject = await Navigator.push<ObjectModel>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ObjectEditScreen(
                                initialObject: snapshot.data![index],
                              ),
                            ),
                          );

                          if (updatedObject != null) {
                            // Update the object in the database after editing
                            await objectDao.updateObject(updatedObject);
                            setState(() {});
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // Delete the object from the database
                          await objectDao.deleteObject(snapshot.data![index].id!);
                          setState(() {});
                        },
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open a modal window to add a new object
          final newObject = await Navigator.push<ObjectModel>(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectEditScreen(),
            ),
          );

          if (newObject != null) {
            // Add a new object to the database
            await objectDao.insertObject(newObject);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
