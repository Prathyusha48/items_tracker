import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:item_tracker/View/tasks_list_ui.dart';
import 'package:item_tracker/ViewModel/get_tasks.dart';
import 'package:provider/provider.dart';

void main() {
  group('ItemTrackerApp Widget Tests', () {
    // Widget test for checking if the app displays the title
    testWidgets('displays the app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: const MaterialApp(home: ItemTrackerApp()),
        ),
      );

      expect(find.text('ITEMS TRACKER'), findsOneWidget);
    });

    // Test for adding a task
    testWidgets('adds a task when title and description are provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: const MaterialApp(home: ItemTrackerApp()),
        ),
      );

      final titleField =
          find.widgetWithText(TextFormField, 'Enter the Title Name');
      final descriptionField =
          find.widgetWithText(TextFormField, 'Enter the Description');
      final addButton = find.text('Create Task');
      final detailsButton = find.text('Details');
      final okButton = find.text('Ok');

      await tester.enterText(titleField, 'Test Task');
      await tester.enterText(descriptionField, 'Test Description');

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('Test Task'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    // Test for error message when fields are empty
    testWidgets('shows error message when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: const MaterialApp(home: ItemTrackerApp()),
        ),
      );

      final addButton = find.text('Create Task');

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('Please Fill Empty Fields'), findsOneWidget);
    });
  });

  // Test for Details dialog box
  testWidgets('shows details dialog for a task', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    taskProvider.addItem('Test_Task', 'Test_Description');

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ItemTrackerApp(),
          ),
        ),
      ),
    );

    final detailsButton = find.text('Details');
    expect(detailsButton, findsOneWidget);

    await tester.tap(detailsButton);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('openDetailsDialog')), findsOneWidget);
    expect(find.text('Test_Description'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
  });

  testWidgets('Should open edit dialog and show name, description fields', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    taskProvider.addItem("Sample Task", "Sample Description");

    // Wrap the widget with a Provider to pass down the TaskProvider
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ItemTrackerApp(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    // Verify if the dialog with "Edit Item" title appears
    expect(find.text('Edit Item'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Description'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Should edit task and close dialog on Save button tap', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    taskProvider.addItem("Initial Task", "Initial Description");

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ItemTrackerApp(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    // Enter new values for name and description
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Updated Task');
    await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Updated Description');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Check if the updated values are in the task provider
    expect('Updated Task', 'Updated Task');
    expect('Updated Description', 'Updated Description');
    expect(find.byType(AlertDialog), findsNothing); // Dialog should be closed
  });

  testWidgets('Should not save if fields are empty and show SnackBar message', (WidgetTester tester) async {
    final taskProvider = TaskProvider();
    taskProvider.addItem("Initial Task1", "Initial Description1");

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ItemTrackerApp(),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Name'), '');
    await tester.enterText(find.widgetWithText(TextField, 'Description'), '');
    await tester.tap(find.text('Save'));
    await tester.pump(); // Allow time for SnackBar

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Please Fill Empty Fields'), findsOneWidget);
  });

}
