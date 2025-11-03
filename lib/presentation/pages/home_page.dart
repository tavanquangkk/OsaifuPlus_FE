import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_basic_01/presentation/pages/auth/login_page.dart';
import 'package:flutter_basic_01/core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _secureStorage = FlutterSecureStorage();
  String _userName = '';
  double _totalBalance = 250000;
  double _monthlyIncome = 350000;
  double _monthlyExpense = 180000;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
              padding: EdgeInsets.all(20),
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

            // 残高カード
            Card(
              elevation: 6,
              shadowColor: AppColors.primary.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.orange[50]!, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '総残高',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '¥${_totalBalance.toStringAsFixed(0)}',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 今月の収支
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
                            '今月の収入',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '¥${_monthlyIncome.toStringAsFixed(0)}',
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
                            '今月の支出',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '¥${_monthlyExpense.toStringAsFixed(0)}',
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

            Card(
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildTransactionItem(
                    '給与',
                    '¥350,000',
                    Icons.work,
                    Colors.green,
                    '2024/11/01',
                  ),
                  Divider(height: 1),
                  _buildTransactionItem(
                    '食費',
                    '-¥8,500',
                    Icons.restaurant,
                    Colors.red,
                    '2024/11/02',
                  ),
                  Divider(height: 1),
                  _buildTransactionItem(
                    '交通費',
                    '-¥2,300',
                    Icons.train,
                    Colors.red,
                    '2024/11/02',
                  ),
                  Divider(height: 1),
                  _buildTransactionItem(
                    '電気代',
                    '-¥12,800',
                    Icons.bolt,
                    Colors.red,
                    '2024/11/01',
                  ),
                ],
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('収入追加機能は準備中です'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('支出追加機能は準備中です'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('レポート機能は準備中です'),
                          backgroundColor: AppColors.primary,
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
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('設定機能は準備中です'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    icon: Icon(Icons.settings),
                    label: Text('設定'),
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
