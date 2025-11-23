import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final String id;
  const DeleteTransactionDialog({required this.id, super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("削除確認"),
      content: Text("本当に削除しまか？"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("キャンセル"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("削除"),
        ),
      ],
    );
  }
}
