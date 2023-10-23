import 'package:flutter/material.dart';
import 'package:todolist/services/project_api.dart';

import '../core/constants/show_feedback.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TodoApi api = TodoApi();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar task' : 'Criar task'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Título"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Descrição"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                isEdit ? updateData() : submitData();
              },
              child: Text(isEdit ? 'Editar' : 'Criar'))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    try {
      final bool response = await api.createTodo(title, description);
      showFeedback(context, "Task criada com sucesso!", true);
    } catch (error) {
      showFeedback(context, "Ocorreu um erro...", false);
    }
    Navigator.pop(context);
    titleController.text = '';
    descriptionController.text = '';
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      debugPrint('Error: Can not edit without todo data');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    try {
      final bool response = await api.updateTodo(id, title, description);
      showFeedback(context, "Task editada com sucesso!", true);
    } catch (error) {
      showFeedback(context, "Ocorreu um erro...", false);
    }
    Navigator.pop(context);
    titleController.text = '';
    descriptionController.text = '';
  }
}
