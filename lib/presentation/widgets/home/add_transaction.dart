import 'dart:ffi';

import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  final String transactionType; // "支出" or "収入"

  const AddTransaction({super.key, required this.transactionType});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "【${widget.transactionType}】を追加",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Text("カテゴリ"),
              TextFormField(
                controller: _categoryController,
                validator: (v) =>
                    v == null || v.isEmpty ? "カテゴリを入力してください" : null,
              ),

              const SizedBox(height: 12),

              Text("詳細"),
              TextFormField(controller: _noteController),

              const SizedBox(height: 12),

              Text("金額"),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "金額を入力してください";
                  if (double.tryParse(v) == null) return "数字を入力してください";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: Text("追加"),
                  onPressed: () {
                    if (_formKey.currentState?.validate() != true) return;

                    Navigator.pop(context, {
                      "type": widget.transactionType,
                      "category": _categoryController.text,
                      "note": _noteController.text,
                      "amount": int.parse(_amountController.text),
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
