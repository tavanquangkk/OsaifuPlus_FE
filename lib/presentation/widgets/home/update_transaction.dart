import 'package:flutter/material.dart';

class UpdateTransaction extends StatefulWidget {
  final String transactionType; // "支出" or "収入"
  String category;
  String note;
  int amount;

  UpdateTransaction({
    super.key,
    required this.transactionType,
    required this.category,
    required this.note,
    required this.amount,
  });

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🔥 ここで初期値をセット！
    _categoryController.text = widget.category;
    _noteController.text = widget.note;
    _amountController.text = widget.amount.toString();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
                "【${widget.transactionType}】を編集",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // カテゴリ
              Text("カテゴリ"),
              TextFormField(
                controller: _categoryController,
                validator: (v) =>
                    v == null || v.isEmpty ? "カテゴリを入力してください" : null,
              ),

              const SizedBox(height: 12),

              // 詳細
              Text("詳細"),
              TextFormField(controller: _noteController),

              const SizedBox(height: 12),

              // 金額
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
                  child: Text("更新"),
                  onPressed: () {
                    if (_formKey.currentState?.validate() != true) return;

                    // 更新結果を返す
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
