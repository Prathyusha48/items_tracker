import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/get_tasks.dart';


class ItemTrackerApp extends StatefulWidget {
  const ItemTrackerApp({super.key});

  @override
  ItemTrackerAppState createState() => ItemTrackerAppState();
}

class ItemTrackerAppState extends State<ItemTrackerApp> {
  TextEditingController titleController =  TextEditingController();
  TextEditingController descriptionController =  TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.loadItems(); // Load items when the app starts
    });
  }

  @override
  Widget build(BuildContext context) {

    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ITEMS TRACKER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 40.0,
            foreground: Paint()..shader = const LinearGradient(colors: [Colors.blue,Colors.purple],
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10.0),
                child: Text("Title Name :",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  foreground: Paint()..shader = const LinearGradient(colors: [Colors.blue,Colors.purple],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),),),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Enter the Title Name",
                  hintStyle: TextStyle(color: Colors.blueGrey)
                ),
              ),),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10.0),
                child: Text("Description :",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  foreground: Paint()..shader = const LinearGradient(colors: [Colors.blue,Colors.purple],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter the Description",
                      hintStyle: TextStyle(color: Colors.blueGrey)
                  ),
                ),),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8,),),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(5.0), // Match ElevatedButton border radius
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                      taskProvider.addItem(
                          titleController.text, descriptionController.text);
                      titleController.clear();
                      descriptionController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('Please Fill Empty Fields')),
                          duration: Duration(seconds: 2),
                          elevation: 0.2,
                          backgroundColor: Colors.blueGrey,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make button background transparent
                    shadowColor: Colors.transparent, // Remove shadow to avoid blending issues
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // Match container radius
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(color: Colors.white,fontSize: 30),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8),),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.6),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(0.7),
              3: FlexColumnWidth(0.7),
            },
            border: const TableBorder(),
            children: [
              TableRow(children: [
                Container(
                  width:
                  MediaQuery.of(context).size.height * 0.42,
                  alignment: Alignment.center,
                  child: Text("Title Name",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    foreground: Paint()..shader = const LinearGradient(colors: [Colors.blue,Colors.purple],
                    ).createShader(const Rect.fromLTWH(-50.0, 0.0, 200.0, 70.0)),),),
                ),
                Container(
                  width:
                  MediaQuery.of(context).size.height * 0.42,
                  alignment: Alignment.center,
                  child: Text("Description",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    foreground: Paint()..shader = const LinearGradient(colors: [Colors.blue,Colors.purple],
                    ).createShader(const Rect.fromLTWH(100.0, 0.0, 200.0, 70.0)),
                  ),),
                ),
                Container(),
                Container(),
              ]),
            ],
          ),
              const Divider(
                height: 2,
                thickness: 2,
                color: Colors.grey,
              ),
              Expanded(
                child: _loadTaskListView(taskProvider),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _loadTaskListView(taskList) {
    return Container(
        child: (taskList.items.length > 0)
            ? ListView.builder(
                 scrollDirection: Axis.vertical,
                itemCount: taskList.items.length,
                itemBuilder: (BuildContext context, int index) =>
                    _loadTaskListData(taskList.items[index], index,taskList))
            : Container(
            alignment: Alignment.center, child: const Text("No Tasks Found",
          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
        ),
        )
    );
  }

  Widget _loadTaskListData(tasks, int index,taskList) {
    return Container(
      color: index % 2 != 0 ? Colors.grey.withOpacity(0.3) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.6),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(0.7),
              3: FlexColumnWidth(0.7),
            },
            border: const TableBorder(
                verticalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid)),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,top:10),
                  child: Text(
                    tasks.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(5.0), // Match ElevatedButton border radius
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                       _showDetailsDialog(context,tasks);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Make button background transparent
                        shadowColor: Colors.transparent, // Remove shadow to avoid blending issues
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Match container radius
                        ),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                  child: Container(
                    width:
                    MediaQuery.of(context).size.height * 0.42,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: (){
                        _showEditDialog(context, taskList, index, tasks);
                      },
                      icon: const Icon(Icons.edit),
                      color: Color.alphaBlend(Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.5)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                  child: Container(
                    width:
                    MediaQuery.of(context).size.height * 0.42,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: (){
                        taskList.deleteItem(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Center(child: Text('${tasks.name} Deleted',)),
                          backgroundColor: Colors.blueGrey,
                            elevation: 0.2,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: Color.alphaBlend(Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.5)),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(
      BuildContext context, item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${item.name}",
            key: Key("openDetailsDialog"),
          ),
          content: SizedBox(
            width: 250,
            height: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description)
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }


  void _showEditDialog(
      BuildContext context, itemProvider, int index, item) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Item"),
          content: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if(nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  itemProvider.editItem(
                    index,
                    nameController.text,
                    descriptionController.text,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(child: Text('Please Fill Empty Fields')),
                      duration: Duration(seconds: 2),
                      elevation: 0.2,
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }


}

