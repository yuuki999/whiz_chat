### バージョン
```
Flutter 3.24.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 4cf269e36d (8 days ago) • 2024-09-03 14:30:00 -0700
Engine • revision a6bd3f1de1
Tools • Dart 3.5.2 • DevTools 2.37.2
```

### 設計思想

Feature-firstアーキテクチャを使用している。
https://codewithandrea.com/articles/flutter-project-structure/#feature-first-layers-inside-features

### ディレクトリ構成

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── bloc/
│   ├── home/
│   │   └── [similar structure to auth]
│   └── profile/
│       └── [similar structure to auth]
├── shared/
│   ├── widgets/
│   └── services/
└── main.dart
```

## ディレクトリの説明と使い方

1. `features/`: アプリの各機能（フィーチャー）を格納します。各フィーチャーは以下の構造を持ちます：
    - `data/`: データ層
        - `datasources/`: APIクライアントやローカルストレージなどのデータソース。APIのリクエストのみを実装する。
          - `user_api.dart`
        - `repositories/`: リポジトリの実装。datasourcesの結果を加工したりする。
          - `user_repository_impl.dart`
    - `domain/`: ドメイン層
        - `entities/`: ビジネスロジックで使用するエンティティ(Freezed使用)
          - `user.dart`
        - `repositories/`: リポジトリのインターフェース。ここに詳細を実装しないことで柔軟性が高くなる。
          -  `user_repository.dart`
    - `presentation/`: `プレゼンテーション層`
        - `pages/`: 画面全体のウィジェット
        - `widgets/`: 再利用可能な小さなウィジェット
        - `providers/`: 状態管理
2. `shared/`: 複数のフィーチャーで共有されるコンポーネント
    - `widgets/`: 共有ウィジェット
3. `main.dart`: アプリケーションのエントリーポイント

#### キャッシュ戦略はどうするか？
メモリキャッシュ: 
Riverpodを使用。

永続化キャッシュ: 
SharedPreferences, Hiveなどを使用。リポジトリレイヤーで実装するのがいいと思う。
アプリが終了してもデータが保持される。

#### 使い方のガイドライン

1. 新しい機能を追加する際は、`features/`ディレクトリ内に新しいフォルダを作成します。
2. 各フィーチャーは独立して機能するように設計し、他のフィーチャーへの依存を最小限に抑えます。
3. 共通のロジックや設定は`core/`ディレクトリに配置し、アプリ全体で再利用します。
4. 複数のフィーチャーで使用されるウィジェットは`shared/`ディレクトリに配置します。
5. 依存性の方向は常に外側（presentation）から内側（domain）に向かうようにします。
6. 各層（data, domain, presentation）は明確に分離し、それぞれの責任を守ります。

### デバイス確認
```
fvm flutter devices
```

### ビルド方法
```
fvm flutter run 
```

デバイスを指定したビルド方法
```
fvm flutter run -d E9A21676-5125-43BB-973D-2F0331CE648C
```

### パッケージインストール

個別にパッケージをインストール
```
fvm flutter pub add <パッケージの名前>
例) flutter pub add flutter_riverpod
```

pubspec.yamlの内容でインストール
```
fvm flutter pub get
```

### Freezedのコード生成

```
fvm flutter pub run build_runner build --delete-conflicting-outputs
```