import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final GetStorage _storage = GetStorage();
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    List<dynamic>? storedTasks = _storage.read<List>('tasks');
    if (storedTasks != null) {
      setState(() {
        _tasks =
            storedTasks.map((task) => Map<String, dynamic>.from(task)).toList();
      });
    }
  }

  void _saveTasks() {
    _storage.write('tasks', _tasks);

  }

  void _addTask(inputData, status ) {
    if (inputData.isNotEmpty) {
      setState(() {
        _tasks.add({'title':inputData, 'completed': status});
        // _controller.clear();
        _saveTasks();
      });
    }
  }
  void _updateTask(int index, String newTitle) {
    if (newTitle.isNotEmpty) {
      setState(() {
        _tasks[index]['title'] = newTitle;
        _saveTasks();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      _saveTasks();
    });
  }

  bool _isCompleted = false;

  void _showAddTaskDialog() {
    _controller.clear();
    _isCompleted = false;
    showDialog(
      context: context,
      builder: (context) {
        bool isChecked = _isCompleted;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration:const  InputDecoration(labelText: 'Task Title'),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: Colors.amber,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                     const  Text('Completed')
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:const Text('Cancel',style: TextStyle(color: Colors.black54),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[200], // Change button color
                    foregroundColor: Colors.black, // Change text color
                  ),
                  onPressed: () {
                    setState(() {
                      _isCompleted = isChecked;
                    });
                    _addTask(_controller.text, _isCompleted);
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding:  EdgeInsets.only(left: 30.0),
          child:  Icon(Icons.widgets_outlined,size:  30,),
        ),
          title: const Text('To-Do List', style: TextStyle(fontWeight: FontWeight.w500),)),
      body: Column(
        children: [
          Expanded(
            child: _tasks.isEmpty
                ?  Center(child: Container(
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.task_outlined, size: 30,),
                      SizedBox(height: 10,),
                      Text('No tasks added yet'),
                    ],
                  ),
                ))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shadowColor: Colors.grey,
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          title: Row(
                            children: [
                              Checkbox(
                                // checkColor: Colors.amber[200],
                                activeColor: Colors.amber,
                                value: _tasks[index]['completed'],
                                onChanged: (bool? value) {
                                  _toggleTask(index);
                                },
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text("${_tasks[index]['title']}", style: TextStyle(fontWeight: FontWeight.w500),),
                                  subtitle: Text(
                                    _tasks[index]['completed']
                                        ? "Completed"
                                        : "Not Completed",
                                    style: TextStyle(
                                        color: _tasks[index]['completed']
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    TextEditingController editController = TextEditingController(text: _tasks[index]['title']);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Task'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: const InputDecoration(labelText: 'Task Title'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel', style: TextStyle(color: Colors.black54),),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber[200], // Change button color
                                                foregroundColor: Colors.black, // Change text color
                                              ),
                                              onPressed: () {
                                                _updateTask(index, editController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Update'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  label: const Text('Edit', style: TextStyle(color:Colors.blue),),
                                  icon: const Icon(Icons.edit, color: Colors.blue,),
                                ),
                                TextButton.icon(
                                  onPressed: () => _deleteTask(index),
                                  label: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                  icon: const Icon(Icons.delete, color: Colors.red,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Task",
        backgroundColor: Colors.amber[200],
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
