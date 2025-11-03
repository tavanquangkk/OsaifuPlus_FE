import 'package:flutter/material.dart';
import 'package:flutter_basic_01/presentation/pages/auth/register_page.dart'; // 👈 [修正] RegisterPageをインポート
import 'package:flutter_basic_01/presentation/pages/home_page.dart';
import 'package:flutter_basic_01/presentation/widgets/auth/auth_redirect_link.dart';
import 'package:flutter_basic_01/presentation/widgets/others/wave_clipper.dart';
import 'package:flutter_basic_01/presentation/widgets/shared/primary_gradient_button.dart';

class LoginPage extends StatefulWidget {
  // 👈 [修正] StatelessWidgetから変更（元コードではStatefulWidgetになっていたのでOK）
  const LoginPage({super.key}); // 👈 [修正] key を追加

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      // --- ここでAPI通信（データ層の呼び出し）を実行 ---
      // (ダミーの待機)
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        // ログイン成功時はHomePageに置き換える
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ログインに失敗しました：$e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // 👈 [UX改善] Stackで全体を囲み、ローディング表示を追加
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Image.asset(
                  "assets/images/bg.png",
                  width: double.infinity,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    // 👈 [UX改善] リアルタイムバリデーション
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 👈 [修正] 左揃えに
                      children: [
                        // 👈 [修正] テーマからスタイルを適用
                        Text("ログイン", style: textTheme.displayLarge),
                        SizedBox(height: 30),

                        // mail
                        Text("メール", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "メールアドレス"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'メールアドレスを入力してください';
                            }
                            if (!value.contains('@')) {
                              return '有効なメールアドレスではありません';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Password
                        Text("パスワード", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "パスワード",
                          ), // 👈 [修正]
                          obscureText: true, // 👈 [修正] パスワードを隠す
                          // keyboardType: TextInputType.emailAddress, // 👈 [修正] 削除
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワードを入力してください'; // 👈 [修正]
                            }
                            if (value.length < 6) {
                              return '6文字以上で入力してください'; // 👈 [修正] バリデーション強化
                            }
                            return null;
                          },
                        ),
                        // password
                        SizedBox(height: 30),
                        PrimaryGradientButton(
                          text: "ログイン",
                          onPressed: _isLoading ? null : _login,
                        ),

                        // don't have a account , register
                        AuthRedirectLink(
                          promptText: "アカウントをお持ちでない方？",
                          linkText: "新規登録",
                          onPressed: () {
                            // 👈 [修正] RegisterPage に遷移する
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 👈 [UX改善] ローディングオーバーレイ
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
