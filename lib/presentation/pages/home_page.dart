import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_01/data/api/home_service.dart';
import 'package:flutter_basic_01/presentation/pages/report_page.dart';
import 'package:flutter_basic_01/presentation/widgets/home/add_transaction.dart';
import 'package:flutter_basic_01/presentation/widgets/home/update_transaction.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_basic_01/presentation/pages/auth/login_page.dart';
import 'package:flutter_basic_01/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat("#,##0", "en_US");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _secureStorage = FlutterSecureStorage();
  String _userName = '';
  String _totalBalance = "";
  int _monthlyIncome = 0;
  int _monthlyExpense = 0;
  String _thisMonth = "";
  List _transactions = [];
  List _monthSummaryIncome = [];
  List _monthSummaryExpense = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchTransactions();
    _getMonthlySumary();
  }

  Future<void> _getMonthlySumary() async {
    final response = await getMonthlySeparatedSummary();
    if (response != null) {
      setState(() {
        _monthlyIncome = response["data"]["income"][0]["amount"] as int;
        _monthlyExpense = response["data"]["expense"][0]["amount"] as int;
        _thisMonth = response["data"]["expense"][0]["month"].toString();
      });
      _monthSummaryIncome = response["data"]["income"];
      _monthSummaryExpense = response["data"]["expense"];

      print("??????");
      print(response["data"]["expense"][0]["amount"]);
    }
  }

  Future<void> _loadUserData() async {
    final userName = await _secureStorage.read(key: 'user_name') ?? 'ユーザー';
    setState(() {
      _userName = userName;
    });
  }

  Future<void> _logout() async {
    await _secureStorage.deleteAll();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future<void> _fetchTransactions() async {
    final res = await getAllTransactions();
    final data = res["data"] ?? [];

    setState(() {
      _transactions = data;
    });
    _getMonthlySumary();
  }

  Future<void> _deleteTransaction(String id) async {
    await deleteTransactions(id);
    _fetchTransactions();
  }

  Future<void> _createTransaction(dynamic params) async {
    final body = {
      "type": params["type"] ?? "test",
      "category": params["category"] ?? "tess",
      "note": params["note"] ?? "tesss",
      "amount": params["amount"] ?? 300,
    };
    final res = await addTransactions(body);
    print("success to add >>>> i am at homepage!!!!");
    _fetchTransactions();
  }

  Future<void> _updateTransaction(String id, dynamic params) async {
    final body = {
      "type": params["type"],
      "category": params["category"],
      "note": params["note"],
      "amount": params["amount"],
    };
    final res = await updateTransactions(id, body);
    print("success to update >>>> i am at homepage!!!!");
    _fetchTransactions();
  }

  IconData _convertIcon(String category) {
    final key = category.trim().toLowerCase();

    const iconMap = {
      // -------------- 食費・生活系 --------------
      "食費": Icons.restaurant,
      "外食": Icons.restaurant,
      "自炊": Icons.restaurant,
      "food": Icons.restaurant,
      "meal": Icons.restaurant,

      "飲み物": Icons.local_cafe,
      "カフェ": Icons.local_cafe,
      "drink": Icons.local_cafe,
      "cafe": Icons.local_cafe,

      "日用品": Icons.shopping_bag,
      "生活用品": Icons.shopping_bag,
      "daily": Icons.shopping_bag,

      "買い物": Icons.shopping_cart,
      "ショッピング": Icons.shopping_cart,
      "shopping": Icons.shopping_cart,

      // -------------- 交通 --------------
      "交通": Icons.train,
      "電車": Icons.train,
      "バス": Icons.train,
      "タクシー": Icons.directions_car,
      "transport": Icons.train,
      "taxi": Icons.directions_car,

      // -------------- 家・住居 --------------
      "家賃": Icons.home,
      "住宅": Icons.home,
      "住居": Icons.home,
      "rent": Icons.home,

      "光熱費": Icons.lightbulb,
      "電気": Icons.lightbulb,
      "ガス": Icons.local_fire_department,
      "水道": Icons.water_drop,

      // -------------- 通信 --------------
      "通信費": Icons.wifi,
      "スマホ": Icons.smartphone,
      "internet": Icons.wifi,
      "wifi": Icons.wifi,

      // -------------- 医療・美容 --------------
      "医療": Icons.health_and_safety,
      "病院": Icons.local_hospital,
      "health": Icons.health_and_safety,

      "美容": Icons.brush,
      "ビューティー": Icons.brush,
      "beauty": Icons.brush,

      // -------------- 娯楽・エンタメ --------------
      "娯楽": Icons.movie,
      "映画": Icons.movie,
      "entertainment": Icons.movie,

      "ゲーム": Icons.sports_esports,
      "game": Icons.sports_esports,

      // -------------- 教育 --------------
      "教育": Icons.school,
      "学習": Icons.school,
      "study": Icons.school,
      "school": Icons.school,

      // -------------- 収入（Income） --------------
      "給料": Icons.work,
      "給与": Icons.work,
      "salary": Icons.work,
      "income": Icons.work,

      "ボーナス": Icons.card_giftcard,
      "bonus": Icons.card_giftcard,

      "副業": Icons.work_history,
      "sidejob": Icons.work_history,

      // -------------- その他 --------------
      "旅行": Icons.flight,
      "travel": Icons.flight,

      "ペット": Icons.pets,
      "pet": Icons.pets,

      "貯金": Icons.savings,
      "saving": Icons.savings,

      "投資": Icons.trending_up,
      "investment": Icons.trending_up,

      "その他": Icons.more_horiz,
      "other": Icons.more_horiz,
    };

    return iconMap[key] ?? Icons.receipt; // 存在しない場合のデフォルト
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('おさいふプラス'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
              if (value == 'reload') {
                _fetchTransactions();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('ログアウト'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reload',
                child: Row(
                  children: [
                    Icon(
                      Icons.read_more,
                      color: const Color.fromARGB(255, 3, 250, 11),
                    ),
                    SizedBox(width: 8),
                    Text('リロード'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ユーザー挨拶
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'こんにちは、$_userNameさん！',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '今日も家計管理を頑張りましょう！',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // 今月の収支 (API開発中)
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.green.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.green[50]!, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              color: Colors.green[600],
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '今月の収入($_thisMonth)',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '¥${oCcy.format(_monthlyIncome)}',
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.red.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.red[50]!, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.trending_down,
                              color: Colors.red[600],
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '今月の支出($_thisMonth)',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '¥${oCcy.format(_monthlyExpense)}',
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.red[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // 最近の取引
            Text(
              '最近の取引',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            Container(
              height: 300, // 高さを固定（必要に応じて調整）
              child: Card(
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _transactions.reversed.map((e) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  "取引詳細",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: SizedBox(
                                  width: double.minPositive,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(
                                        "カテゴリ",
                                        "${e["category"]}",
                                      ),
                                      _buildDetailRow("タイプ", "${e["type"]}"),
                                      _buildDetailRow("メモ", "${e["note"]}"),
                                      const Divider(height: 24),

                                      // 金額
                                      Center(
                                        child: Text(
                                          "${e["type"] == "EXPENSE" ? "-" : "+"}¥${e["amount"]}",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: e["type"] == "EXPENSE"
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  // 編集
                                  TextButton(
                                    onPressed: () async {
                                      final result =
                                          await showDialog<
                                            Map<String, dynamic>
                                          >(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => UpdateTransaction(
                                              transactionType: "EXPENSE",
                                              category: e["category"],
                                              note: e["note"],
                                              amount: e["amount"],
                                            ),
                                          );

                                      if (result != null) {
                                        final id = e["id"];
                                        // APIに送信
                                        await _updateTransaction(id, result);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("編集"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text("削除しますか？"),
                                            content: Text("復元できませんのでご注意ください！"),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text('キャンセル'),
                                                isDestructiveAction: true,
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('削除'),
                                                onPressed: () async {
                                                  //delete logic
                                                  final id = e["id"];
                                                  await _deleteTransaction(id);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("削除"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: _buildTransactionItem(
                          e["category"],
                          "${e["type"] == "EXPENSE" ? "-" : "+"}¥${e["amount"]}",
                          _convertIcon(e["category"]),
                          e["type"] == "EXPENSE" ? Colors.red : Colors.green,
                          e["created_at"].toString().split("T")[0],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // クイックアクション
            Text(
              'クイックアクション',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) =>
                            AddTransaction(transactionType: "INCOME"),
                      );

                      if (result != null) {
                        // APIに送信
                        await _createTransaction(result);

                        // 最新のトランザクションを取得
                        _fetchTransactions();
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('収入追加', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.green.withOpacity(0.3),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) =>
                            AddTransaction(transactionType: "EXPENSE"),
                      );

                      if (result != null) {
                        // APIに送信
                        await _createTransaction(result);

                        // 最新のトランザクションを取得
                        _fetchTransactions();
                      }
                    },
                    icon: Icon(Icons.remove, color: Colors.white),
                    label: Text('支出追加', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.red.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ReportPage(
                              monthSummaryIncome: _monthSummaryIncome,
                              monthSummaryExpense: _monthSummaryExpense,
                            );
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.bar_chart),
                    label: Text('レポート'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // test block
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    IconData icon,
    Color color,
    String date,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        date,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
