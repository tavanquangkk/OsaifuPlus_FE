# flutter_basic_01

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```

フォルダー構成等
lib/
 ├── main.dart
 │
 ├── config/
 │   ├── router.dart        # 画面遷移 (GoRouterなど)
 │   └── di.dart            # 依存注入 (API Client, Repositoryなど)
 │
 ├── core/
 │   ├── constants/         # 色、スタイル、APIエンドポイントなどの定数
 │   ├── theme/             # アプリのテーマ
 │   └── utils/             # 共通関数（フォーマッターなど）
 │
 ├── data/
 │   ├── api/               # 👈 gRPCの代わりにAPI Serviceを配置
 │   │   ├── api_client.dart    # (dio, httpなどのラッパー)
 │   │   └── api_service.dart   # (GET /home, POST /expense など)
 │   │
 │   ├── models/            # 👈 ProtobufではなくJSONレスポンス用モデル
 │   │   ├── home_response_model.dart # (json_serializableなど)
 │   │   └── transaction_model.dart
 │   │
 │   └── repositories/      # 👈 Domain層への橋渡し
 │       └── home_repository_impl.dart # (API Serviceを呼び出す)
 │
 ├── domain/
 │   ├── entities/          # 👈 UIが本当に使う「純粋な」データ
 │   │   ├── asset.dart
 │   │   └── transaction.dart
 │   │
 │   ├── repositories/      # 👈 抽象インターフェース (UI層はこれを参照)
 │   │   └── home_repository.dart
 │   │
 │   └── usecases/          # 👈 ビジネスロジック
 │       └── get_home_data_usecase.dart
 │
 ├── presentation/
 │   ├── pages/             # ✅ ここから作る
 │   │   └── home_page.dart   # (Scaffold, AppBar, Bodyを持つ)
 │   │
 │   ├── widgets/           # 👈 分割したウィジェット置き場
 │   │   ├── home/            # (HomePage専用のウィジェット)
 │   │   │   ├── header_summary_widget.dart
 │   │   │   ├── expense_donut_chart_widget.dart
 │   │   │   ├── category_grid_widget.dart
 │   │   │   ├── asset_summary_card_widget.dart
 │   │   │   └── recent_history_widget.dart
 │   │   └── shared/          # (アプリ全体で再利用するウィジェット)
 │   │       └── transaction_row_widget.dart
 │   │
 │   └── state/             # 状態管理 (Riverpod, Blocなど)
 │       ├── home_provider.dart  # (Usecaseを呼び出し、状態をUIに渡す)
 │       └── state_notifier.dart
 │
 └── generated/             # 👈 json_serializableの .g.dart ファイルなど


```

1️⃣ ユーザー関連

ログイン／サインアップ画面
→ メール・パスワードで認証

プロフィール編集画面
→ 名前やメールアドレスの変更

2️⃣ カテゴリ管理

カテゴリ一覧画面
→ 食費、交通費などの一覧

カテゴリ追加／編集／削除画面

3️⃣ 取引管理

取引一覧画面
→ 月ごと・カテゴリごとに絞り込み

取引追加／編集／削除画面
→ 日付、金額、カテゴリ、メモなどを入力

残高表示
→ 総残高やカテゴリごとの残高

4️⃣ 予算管理

月予算一覧画面
→ カテゴリ別の月予算表示

予算追加／編集／削除画面

5️⃣ レポート・分析（簡易版）

月次収支グラフ
→ 円グラフで支出割合、折れ線グラフで収支推移

カテゴリ別支出比率
