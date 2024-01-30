import 'package:flutter/material.dart';
import 'object_dao.dart';
import 'object_model.dart';
import 'object_edit_screen.dart';

class ObjectsScreen extends StatefulWidget {
  const ObjectsScreen({Key? key}) : super(key: key);

  @override
  ObjectsScreenState createState() => ObjectsScreenState();
}

class ObjectsScreenState extends State<ObjectsScreen> {
  final ObjectDao objectDao = ObjectDao();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              return const Center(
                child: Text('No objects available'),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                return SizedBox(
                  height: 120.0, // Задайте фіксовану висоту картки
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  snapshot.data![index].description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green[200],
                                ),
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
                                    await objectDao.updateObject(updatedObject);
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[200],
                                ),
                                onPressed: () async {
                                  await objectDao.deleteObject(snapshot.data![index].id!);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
                builder: (context) => const ObjectEditScreen(),
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
      ),
    );
  }
}
