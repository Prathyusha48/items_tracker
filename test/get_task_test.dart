import 'package:flutter_test/flutter_test.dart';
import 'package:item_tracker/ViewModel/get_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('TaskProvider adds a new task', () async {
    SharedPreferences.setMockInitialValues({});

    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    final taskProvider = TaskProvider();
    taskProvider.addItem('Task 1', 'Description 1');
    expect(taskProvider.items.length, 1);
    expect(taskProvider.items[0].name, 'Task 1');
  });

  test('TaskProvider deletes a task', () {
    final taskProvider = TaskProvider();
    taskProvider.addItem('Task 1', 'Description 1');
    taskProvider.deleteItem(0);
    expect(taskProvider.items.length, 0);
  });

  test('editItem should update the name and description of a task', () async {
    final taskProvider = TaskProvider();
    taskProvider.addItem('Original Name', 'Original Description');
    int index = 0;
    String newName = 'Updated Name';
    String newDescription = 'Updated Description';

    taskProvider.editItem(index, newName, newDescription);

    expect(taskProvider.items[index].name, newName);
    expect(taskProvider.items[index].description, newDescription);
  });

  test('deleteItem should remove the item at a specific index', () async {
    final taskProvider = TaskProvider();
    taskProvider.addItem('Task 1', 'Description 1');
    taskProvider.addItem('Task 2', 'Description 2');
    int initialLength = taskProvider.items.length;

    taskProvider.deleteItem(0); // Delete the first item

    expect(taskProvider.items.length, initialLength - 1);
  });

  test('editItem should do nothing if the index is out of bounds', () async {
    final taskProvider = TaskProvider();
    taskProvider.addItem('Task 1', 'Description 1');
    int index = 5;

    taskProvider.editItem(index, 'New Name', 'New Description');


    expect(taskProvider.items[0].name, 'Task 1');
    expect(taskProvider.items[0].description, 'Description 1');
  });


}
