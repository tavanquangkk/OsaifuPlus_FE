import 'package:flutter/material.dart';
import 'package:flutter_basic_01/data/api/auth_service.dart';
import 'package:flutter_basic_01/presentation/pages/auth/login_page.dart';
import 'package:flutter_basic_01/presentation/widgets/auth/auth_redirect_link.dart';
import 'package:flutter_basic_01/presentation/widgets/others/wave_clipper.dart';
import 'package:flutter_basic_01/presentation/widgets/shared/primary_gradient_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text;
      final username = _nameController.text;
      final password = _passwordController.text;

      await register(email, username, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登録が完了しました'), backgroundColor: Colors.green),
        );

        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登録に失敗しました: $e'), backgroundColor: Colors.red),
        );
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("新規登録", style: textTheme.displayLarge),
                        SizedBox(height: 20),

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

                        Text("名前", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(hintText: "おさいふ 太郎"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '名前を入力してください';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        Text("パスワード", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(hintText: "パスワード"),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                            if (value.length < 6) {
                              return '6文字以上で入力してください';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        Text("パスワード確認", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordConfirmController,
                          decoration: InputDecoration(hintText: "パスワード（確認用）"),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワード（確認用）を入力してください';
                            }
                            if (_passwordController.text != value) {
                              return 'パスワードが一致しません';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        PrimaryGradientButton(
                          text: "新規登録",
                          onPressed: _isLoading ? null : _register,
                        ),

                        AuthRedirectLink(
                          promptText: "すでにアカウントをお持ちの方？",
                          linkText: "ログイン",
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
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
