import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat("#,##0.00", "en_US");

class ReportPage extends StatefulWidget {
  final List monthSummaryIncome;
  final List monthSummaryExpense;

  ReportPage({
    required this.monthSummaryExpense,
    required this.monthSummaryIncome,
    super.key,
  });
  @override
  State<StatefulWidget> createState() {
    return _ReportPageState();
  }
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left),
        ),
        title: Text("レポート"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: widget.monthSummaryIncome.map((el) {
                return Column(
                  children: [
                    Text("収入"),
                    Text("${el["month"]} : ¥${oCcy.format(el["amount"])}"),
                  ],
                );
              }).toList(),
            ),
            Column(
              children: widget.monthSummaryExpense.map((el) {
                return Column(
                  children: [
                    Text("支出"),
                    Text("${el["month"]} : ¥${oCcy.format(el["amount"])}"),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
