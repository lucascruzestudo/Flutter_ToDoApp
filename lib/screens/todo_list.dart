import 'package:flutter/material.dart';
import 'package:todolist/screens/add_todo.dart';
import 'package:todolist/services/project_api.dart';
import 'package:todolist/widget/todo_card.dart';

import '../core/constants/show_feedback.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  TodoApi api = TodoApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddPage();
          },
          label: const Text('Criar task'),
          icon: const Icon(Icons.add)),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text(
                'Não há tasks',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: ((context, index) {
                  final item = items[index];
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deleteById: deleteById);
                })),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    fetchData();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    fetchData();
  }

  Future<void> deleteById(String id) async {
    final bool response = await api.deleteTodo(id);
    if (response) {
      final filteredItems =
          items.where((element) => element['_id'] != id).toList();
      showFeedback(context, "Task removida com sucesso!", true);
      setState(() {
        items = filteredItems;
      });
    } else {
      showFeedback(context, "Ocorreu um erro...", false);
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await api.getTodos('?page=1&limit=10');
      setState(() {
        items = response;
      });
    } catch (error) {
      debugPrint('fail');
      debugPrint(error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }
}
