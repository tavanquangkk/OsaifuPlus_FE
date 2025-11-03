import 'package:flutter/material.dart';
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
  //  Formを管理するためのキー
  final _formKey = GlobalKey<FormState>();

  // 各TextFormFieldの入力を保持・操作するためのコントローラー
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  //  ロジック実行中（ローディング中）かを管理する状態
  bool _isLoading = false;

  @override
  void dispose() {
    // 画面が破棄される時にコントローラーも破棄（メモリリーク防止）
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  // 新規登録ボタンが押されたときの処理
  Future<void> _register() async {
    //  バリデーションを実行
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      // バリデーションエラーがあれば何もしない
      return;
    }

    //  ローディング状態を開始
    setState(() {
      _isLoading = true;
    });

    try {
      // --- ここでAPI通信（データ層の呼び出し）を実行 ---
      // final email = _emailController.text;
      // final name = _nameController.text;
      // final password = _passwordController.text;
      // await authRepository.register(email, name, password);

      // (ダミーの待機)
      await Future.delayed(Duration(seconds: 2));

      // 成功したら次の画面へ
      if (mounted) {
        // (非同期処理の後、ウィジェットがまだ存在するか確認)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()), // (例) ログイン画面へ
        );
      }
      // ----------------------------------------------
    } catch (e) {
      // エラーハンドリング (スナックバーなどで表示)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('登録に失敗しました: $e')));
      }
    } finally {
      // 成功・失敗にかかわらずローディング状態を解除
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // テーマからスタイルを取得
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // 👈 [改善] Stackで全体を囲み、ローディング表示を追加
      body: Stack(
        children: [
          Column(
            children: [
              // 波形背景
              ClipPath(
                clipper: WaveClipper(),
                child: Image.asset(
                  "assets/images/bg.png",
                  width: double.infinity,
                ),
              ),

              // キーボード対策でスクロール可能にする
              Expanded(
                child: SingleChildScrollView(
                  // 👈 [改善] LoginPage と余白を合わせる
                  padding: const EdgeInsets.all(24.0),
                  // フォーム全体を Form ウィジェットで囲む
                  child: Form(
                    key: _formKey, // キーをセット
                    // 👈 [改善] リアルタイムバリデーション
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // タイトル (テーマからスタイルを適用)
                        Text("新規登録", style: textTheme.displayLarge),
                        // 👈 [改善] LoginPage と余白を合わせる
                        SizedBox(height: 20),

                        // --- メール ---
                        Text("メール", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController, // コントローラー
                          decoration: InputDecoration(hintText: "メールアドレス"),
                          keyboardType: TextInputType.emailAddress,
                          // バリデーションロジック
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'メールアドレスを入力してください';
                            }
                            if (!value.contains('@')) {
                              return '有効なメールアドレスではありません';
                            }
                            return null; // OK
                          },
                        ),
                        SizedBox(height: 20),

                        // --- 名前 ---
                        Text("名前", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(hintText: "おさいふ 太郎"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '名前を入力してください';
                            }
                            return null; // OK
                          },
                        ),
                        SizedBox(height: 20),

                        // --- パスワード ---
                        Text("パスワード", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(hintText: "パスワード"),
                          obscureText: true, // パスワードを隠す
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                            if (value.length < 6) {
                              return '6文字以上で入力してください';
                            }
                            return null; // OK
                          },
                        ),
                        SizedBox(height: 20),

                        // --- パスワード確認 ---
                        Text("パスワード確認", style: textTheme.bodyMedium),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordConfirmController,
                          decoration: InputDecoration(hintText: "パスワード（確認用）"),
                          obscureText: true, // パスワードを隠す
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワード（確認用）を入力してください';
                            }
                            if (_passwordController.text != value) {
                              return 'パスワードが一致しません';
                            }
                            return null; // OK
                          },
                        ),
                        // 👈 [改善] LoginPage と余白を合わせる
                        SizedBox(height: 20),

                        // 共通ウィジェット（ボタン）
                        PrimaryGradientButton(
                          text: "新規登録",
                          // ローディング中はボタンを押せないようにする (onPressedをnullに)
                          onPressed: _isLoading
                              ? null
                              : _register, // _register メソッドを呼ぶ
                        ),

                        // 共通ウィジェット（リンク）
                        AuthRedirectLink(
                          promptText: "すでにアカウントをお持ちの方？",
                          linkText: "ログイン",
                          onPressed: () {
                            // RegisterPage から LoginPage へは 'push' で良い
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

          // 👈 [改善] ローディングオーバーレイ
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
