import 'package:flutter/material.dart';
import 'package:flutter_basic_01/data/api/auth_service.dart';
import 'package:flutter_basic_01/presentation/pages/auth/register_page.dart';
import 'package:flutter_basic_01/presentation/pages/home_page.dart';
import 'package:flutter_basic_01/presentation/widgets/auth/auth_redirect_link.dart';
import 'package:flutter_basic_01/presentation/widgets/others/wave_clipper.dart';
import 'package:flutter_basic_01/presentation/widgets/shared/primary_gradient_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secureStorage = FlutterSecureStorage();

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
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await login(email, password);

      if (response['status'] == 'success' && response['data'] != null) {
        final data = response['data'];

        // トークンをセキュアストレージに保存
        await _secureStorage.write(
          key: 'access_token',
          value: data['accessToken'],
        );
        await _secureStorage.write(
          key: 'refresh_token',
          value: data['refreshToken'],
        );
        await _secureStorage.write(key: 'user_email', value: data['email']);
        await _secureStorage.write(key: 'user_name', value: data['username']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ログインに成功しました'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'ログインに失敗しました');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ログインに失敗しました：$e"),
            backgroundColor: Colors.red,
          ),
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
                        SizedBox(height: 30),
                        PrimaryGradientButton(
                          text: "ログイン",
                          onPressed: _isLoading ? null : _login,
                        ),

                        AuthRedirectLink(
                          promptText: "アカウントをお持ちでない方？",
                          linkText: "新規登録",
                          onPressed: () {
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
