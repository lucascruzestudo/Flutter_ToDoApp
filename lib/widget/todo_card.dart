import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;

  const TodoCard(
      {Key? key,
      required this.index,
      required this.item,
      required this.navigateEdit,
      required this.deleteById})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = item['_id'];
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text("${index + 1}")),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateEdit(item);
            } else if (value == 'delete') {
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                child: Text('Editar'),
                value: 'edit',
              ),
              const PopupMenuItem(
                child: Text('Remover'),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );
  }
}
