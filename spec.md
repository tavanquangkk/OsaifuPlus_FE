# おさいふプラス - バックエンドAPI仕様書

## 概要

家計管理アプリ「おさいふプラス」のバックエンドAPI仕様書です。
RESTful APIアーキテクチャに基づいて設計されています。

## 基本情報

- **ベースURL**: `http://localhost:8080/api/v1`
- **認証方式**: JWT Bearer Token
- **Content-Type**: `application/json`
- **文字エンコーディング**: UTF-8
- **日付形式**: ISO 8601 (UTC)

## エラーレスポンス

全てのAPIエラーは以下の形式で返却されます：

```json
{
  "status": "error",
  "message": "エラーメッセージ",
  "code": "ERROR_CODE",
  "timestamp": "2024-11-01T12:00:00Z"
}
```

## 1. 認証関連API

### 1.1 ユーザー登録

**エンドポイント**: `POST /api/v1/auth/register`

**リクエスト**:
```json
{
  "email": "user@example.com",
  "username": "ユーザー名",
  "password": "password123"
}
```

**成功レスポンス (201)**:
```json
{
  "status": "success",
  "message": "ユーザー登録が完了しました",
  "data": {
    "userId": "36a37f81-0f7d-412a-9572-9ce212c95083",
    "email": "user@example.com",
    "username": "ユーザー名"
  }
}
```

**バリデーション**:
- `email`: 必須、有効なメールアドレス形式
- `username`: 必須、3文字以上50文字以下
- `password`: 必須、6文字以上

### 1.2 ログイン

**エンドポイント**: `POST /api/v1/auth/login`

**リクエスト**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "message": "ログインに成功しました",
  "data": {
    "accessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "email": "user@example.com",
    "username": "ユーザー名"
  }
}
```

### 1.3 トークン更新

**エンドポイント**: `POST /api/v1/auth/refresh`

**リクエスト**:
```json
{
  "refreshToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
}
```

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "accessToken": "new_jwt_access_token",
    "refreshToken": "new_jwt_refresh_token"
  }
}
```

### 1.4 ログアウト

**エンドポイント**: `POST /api/v1/auth/logout`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "message": "ログアウトしました"
}
```

## 2. ユーザー管理API

### 2.1 ユーザー情報取得

**エンドポイント**: `GET /api/v1/users/profile`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "userId": "36a37f81-0f7d-412a-9572-9ce212c95083",
    "email": "user@example.com",
    "username": "ユーザー名",
    "createdAt": "2024-11-01T00:00:00Z",
    "totalBalance": 250000
  }
}
```

### 2.2 ユーザー情報更新

**エンドポイント**: `PUT /api/v1/users/profile`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**リクエスト**:
```json
{
  "username": "新しいユーザー名",
  "email": "new@example.com"
}
```

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "message": "ユーザー情報を更新しました",
  "data": {
    "userId": "36a37f81-0f7d-412a-9572-9ce212c95083",
    "email": "new@example.com",
    "username": "新しいユーザー名"
  }
}
```

## 3. 残高・資産管理API

### 3.1 総残高取得

**エンドポイント**: `GET /api/v1/balance/total`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "totalBalance": 250000,
    "lastUpdated": "2024-11-01T12:00:00Z"
  }
}
```

### 3.2 月別収支サマリー取得

**エンドポイント**: `GET /api/v1/balance/monthly?year=2024&month=11`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**パラメータ**:
- `year`: 年 (必須)
- `month`: 月 (必須、1-12)

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "year": 2024,
    "month": 11,
    "totalIncome": 350000,
    "totalExpense": 180000,
    "netIncome": 170000,
    "transactionCount": 25
  }
}
```

## 4. 取引管理API

### 4.1 取引一覧取得

**エンドポイント**: `GET /api/v1/transactions?page=1&limit=10&type=all&category=all`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**パラメータ**:
- `page`: ページ番号 (デフォルト: 1)
- `limit`: 1ページあたりの件数 (デフォルト: 10、最大: 100)
- `type`: 取引タイプ (`all`, `income`, `expense`)
- `category`: カテゴリID (`all` または具体的なカテゴリID)
- `startDate`: 開始日 (ISO 8601形式)
- `endDate`: 終了日 (ISO 8601形式)

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "transactions": [
      {
        "transactionId": "uuid",
        "type": "income",
        "amount": 350000,
        "category": "給与",
        "categoryIcon": "work",
        "description": "月給",
        "date": "2024-11-01T00:00:00Z",
        "createdAt": "2024-11-01T12:00:00Z",
        "updatedAt": "2024-11-01T12:00:00Z"
      },
      {
        "transactionId": "uuid",
        "type": "expense",
        "amount": 8500,
        "category": "食費",
        "categoryIcon": "restaurant",
        "description": "ランチ",
        "date": "2024-11-02T00:00:00Z",
        "createdAt": "2024-11-02T12:00:00Z",
        "updatedAt": "2024-11-02T12:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 100,
      "totalPages": 10
    }
  }
}
```

### 4.2 取引追加

**エンドポイント**: `POST /api/v1/transactions`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**リクエスト**:
```json
{
  "type": "expense",
  "amount": 5000,
  "category": "食費",
  "description": "ランチ",
  "date": "2024-11-01T12:00:00Z"
}
```

**バリデーション**:
- `type`: 必須、`income` または `expense`
- `amount`: 必須、正の数値
- `category`: 必須、存在するカテゴリ名
- `description`: 任意、500文字以下
- `date`: 任意、ISO 8601形式（省略時は現在日時）

**成功レスポンス (201)**:
```json
{
  "status": "success",
  "message": "取引を追加しました",
  "data": {
    "transactionId": "uuid",
    "type": "expense",
    "amount": 5000,
    "category": "食費",
    "categoryIcon": "restaurant",
    "description": "ランチ",
    "date": "2024-11-01T12:00:00Z",
    "createdAt": "2024-11-01T12:00:00Z"
  }
}
```

### 4.3 取引更新

**エンドポイント**: `PUT /api/v1/transactions/{transactionId}`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**パラメータ**:
- `transactionId`: 取引ID (UUID)

**リクエスト**:
```json
{
  "type": "expense",
  "amount": 6000,
  "category": "食費",
  "description": "ディナー",
  "date": "2024-11-01T18:00:00Z"
}
```

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "message": "取引を更新しました",
  "data": {
    "transactionId": "uuid",
    "type": "expense",
    "amount": 6000,
    "category": "食費",
    "categoryIcon": "restaurant",
    "description": "ディナー",
    "date": "2024-11-01T18:00:00Z",
    "updatedAt": "2024-11-01T18:30:00Z"
  }
}
```

### 4.4 取引削除

**エンドポイント**: `DELETE /api/v1/transactions/{transactionId}`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "message": "取引を削除しました"
}
```

### 4.5 最近の取引取得

**エンドポイント**: `GET /api/v1/transactions/recent?limit=5`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**パラメータ**:
- `limit`: 取得件数 (デフォルト: 5、最大: 20)

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "transactions": [
      {
        "transactionId": "uuid",
        "type": "income",
        "amount": 350000,
        "category": "給与",
        "categoryIcon": "work",
        "description": "月給",
        "date": "2024-11-01T00:00:00Z"
      }
    ]
  }
}
```

## 5. カテゴリ管理API

### 5.1 カテゴリ一覧取得

**エンドポイント**: `GET /api/v1/categories?type=all`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**パラメータ**:
- `type`: カテゴリタイプ (`all`, `income`, `expense`)

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "categories": [
      {
        "categoryId": "uuid",
        "name": "給与",
        "icon": "work",
        "color": "#4CAF50",
        "type": "income",
        "isDefault": true
      },
      {
        "categoryId": "uuid",
        "name": "食費",
        "icon": "restaurant",
        "color": "#FF5722",
        "type": "expense",
        "isDefault": true
      },
      {
        "categoryId": "uuid",
        "name": "交通費",
        "icon": "train",
        "color": "#2196F3",
        "type": "expense",
        "isDefault": true
      },
      {
        "categoryId": "uuid",
        "name": "光熱費",
        "icon": "bolt",
        "color": "#FF9800",
        "type": "expense",
        "isDefault": true
      }
    ]
  }
}
```

### 5.2 カテゴリ追加

**エンドポイント**: `POST /api/v1/categories`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**リクエスト**:
```json
{
  "name": "投資",
  "icon": "trending_up",
  "color": "#9C27B0",
  "type": "income"
}
```

**成功レスポンス (201)**:
```json
{
  "status": "success",
  "message": "カテゴリを追加しました",
  "data": {
    "categoryId": "uuid",
    "name": "投資",
    "icon": "trending_up",
    "color": "#9C27B0",
    "type": "income",
    "isDefault": false
  }
}
```

### 5.3 カテゴリ更新

**エンドポイント**: `PUT /api/v1/categories/{categoryId}`

### 5.4 カテゴリ削除

**エンドポイント**: `DELETE /api/v1/categories/{categoryId}`

## 6. レポート・統計API

### 6.1 月別レポート

**エンドポイント**: `GET /api/v1/reports/monthly?year=2024&month=11`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "year": 2024,
    "month": 11,
    "summary": {
      "totalIncome": 350000,
      "totalExpense": 180000,
      "netIncome": 170000,
      "transactionCount": 25
    },
    "categoryBreakdown": [
      {
        "category": "食費",
        "amount": 50000,
        "percentage": 27.8,
        "transactionCount": 15
      }
    ],
    "dailyTrend": [
      {
        "date": "2024-11-01",
        "income": 350000,
        "expense": 8500
      }
    ]
  }
}
```

### 6.2 カテゴリ別統計

**エンドポイント**: `GET /api/v1/reports/category?period=month&year=2024&month=11`

**パラメータ**:
- `period`: 期間 (`month`, `quarter`, `year`)
- `year`: 年
- `month`: 月 (period=monthの場合)
- `quarter`: 四半期 (period=quarterの場合、1-4)

### 6.3 年間サマリー

**エンドポイント**: `GET /api/v1/reports/yearly?year=2024`

## 7. 予算管理API

### 7.1 予算設定

**エンドポイント**: `POST /api/v1/budgets`

**ヘッダー**: `Authorization: Bearer {accessToken}`

**リクエスト**:
```json
{
  "categoryId": "uuid",
  "amount": 50000,
  "period": "monthly",
  "year": 2024,
  "month": 11
}
```

### 7.2 予算進捗取得

**エンドポイント**: `GET /api/v1/budgets/progress?year=2024&month=11`

**成功レスポンス (200)**:
```json
{
  "status": "success",
  "data": {
    "budgets": [
      {
        "budgetId": "uuid",
        "category": "食費",
        "budgetAmount": 50000,
        "spentAmount": 32000,
        "remainingAmount": 18000,
        "percentage": 64.0,
        "status": "on_track"
      }
    ]
  }
}
```

## 実装優先順位

### Phase 1 (最優先)
1. ✅ 認証API (register, login, refresh, logout)
2. 🔄 ユーザー管理API (profile取得・更新)
3. 🔄 残高管理API (総残高、月別サマリー)
4. 🔄 取引管理API (一覧、追加、更新、削除、最近の取引)
5. 🔄 基本カテゴリAPI (一覧取得)

### Phase 2 (次期実装)
6. カテゴリ管理API (追加、更新、削除)
7. レポート・統計API (月別、カテゴリ別)
8. 予算管理API (設定、進捗)

### Phase 3 (将来拡張)
9. 通知機能API
10. データエクスポートAPI
11. 複数通貨対応API
12. 家族共有機能API

## セキュリティ要件

### JWT Token
- **Access Token**: 15分間有効
- **Refresh Token**: 30日間有効
- **アルゴリズム**: RS256 (RSA署名)

### データ検証
- 全てのユーザー入力をサニタイズ
- SQLインジェクション対策
- XSS対策
- CSRF対策

### レート制限
- 認証API: 5回/分
- その他API: 100回/分
- レポートAPI: 10回/分

## データベース設計参考

### テーブル構成
1. **users** - ユーザー情報
2. **transactions** - 取引記録
3. **categories** - カテゴリマスタ
4. **budgets** - 予算設定
5. **user_sessions** - セッション管理

この仕様書に基づいてバックエンドAPIを実装してください。