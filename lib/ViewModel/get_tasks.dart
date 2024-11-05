import 'dart:convert';

import 'package:flutter/material.dart';
import '../Model/tasks_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _items = [];

  // Getter to access the items list
  List<Task> get items => _items;

  // Method to add a new item
  void addItem(String name, String description) {
    _items.insert(0,Task(name: name, description: description));
    saveItems(_items);
    notifyListeners();// Notifies listeners to rebuild UI when list changes
  }

  void editItem(int index, String newName, String newDescription) {
    if (index >= 0 && index < _items.length) {
      _items[index].name = newName;
      _items[index].description = newDescription;
      saveItems(_items);
      notifyListeners();
    }
  }

  void deleteItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      saveItems(_items);
      notifyListeners();
    }
  }

  Future<void> saveItems(List<Task> items) async {
    List<String> itemStrings = items.map((item) => item.toMap().toString()).toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('items', itemStrings);
  }

  Future<List<Task>> loadItems() async {
    _items.clear();
    List<String>? itemStrings;
      // Load from mobile SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      itemStrings = prefs.getStringList('items');
    if (itemStrings != null) {
      _items.clear(); // Clear the current list to avoid duplicates
      for (String itemString in itemStrings) {
        Map<String, dynamic> itemMap = _parseMap(itemString);
        _items.add(Task.fromMap(itemMap)); // Add the loaded task to the list
      }
    }
    notifyListeners();
    return _items;
  }

  Map<String, dynamic> _parseMap(String itemString) {
    String trimmedString = itemString.substring(1, itemString.length - 1); // Remove the curly braces
    List<String> keyValuePairs = trimmedString.split(', ');

    Map<String, dynamic> map = {};
    for (String pair in keyValuePairs) {
      List<String> keyValue = pair.split(': ');
      map[keyValue[0].trim()] = keyValue[1].trim();
    }
    return map;
  }

}
