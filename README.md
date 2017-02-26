# Lodge for SUP

SUP (Skill Up Project) での情報共有ツール。[Lodge](https://github.com/lodge/lodge)に対して機能追加・ユーザビリティー改善を行っている。

# Deploy方法（開発者向け）

## ローカル環境にDeployする方法

### 新規Deploy

1. ソースコードの取得
  - `git clone https://github.com/fzawa/sup-lodge.git`
2. 依存ソフトウェアのインストール
  - Mac
    - `brew install rbenv icu4c cmake`
    - `rbenv install 2.3.3`
      - 2.3系最新安定版を推奨
    - `cd /path/to/sup-lodge`
    - `rbenv local 2.3.3`
    - `gem install bundler`
  - 共通
    - [Java Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/)
3. Lodgeのインストール
  - `config/database.yml`の作成
    - オリジナルLodgeの[インストール手順](https://github.com/lodge/lodge/blob/release/README.md)を参照
  - `bundle install`
  - `.env`の作成
    - `.env.example`をコピーし、内容をアップデートする
  - `bundle exec rake db:create`
  - `bundle exec rake db:migrate`
  - [任意] `bundle exec gemoji extract public/images/emoji`
    - ブラウザ・OSがサポートしていない絵文字データのダウンロード
    - Macの場合、Sierra以上のみで実行可能
  - `./setup/sunspot-solr/setup-sunspot-solor-development.sh`
4. Lodgeの起動
  - `bin/rake sunspot:solr:start`
    - 全文検索エンジンが起動する
    - 再起動の場合は `bin/rake sunspot:solr:restart`
  - `bundle exec rails server`
5. [任意] サンプルデータの投入
  - `bundle exec rake db:seed`
    - サンプルユーザー・記事をDBに登録する
    - Lodge起動中のみ実行可能
6. ブラウザからアクセス
  - http://localhost:3000/
7. Lodgeの終了
  - サーバー実行画面で ctrl + c
  - `bin/rake sunspot:solr:stop`

### アップデート

1. ソースコードのアップデート
  - `cd /path/to/sup-lodge`
  - `git pull`
2. Lodgeのアップデート
  - `bundle update`
  - `bin/rake sunspot:solr:start`
  - `bundle exec rake db:migrate`
  - `bin/rake sunspot:reindex`
  - `bin/rake sunspot:solr:stop`

## Cloud9にDeployする方法

### Cloud9のアカウント作成
cloud9のサイトでアカウントを作成し、Sign inする。
[http://c9.io/](http://c9.io/)

### Workspaceの作成
1. 「Create a new workspace」をクリックする。
2. 諸々情報を入力
  - Workspace name: sup-lodge（なんでも良い）
  - Description: 適当に
  - Private/Public の選択。Privateにしておこう。
  - Clone from Git or Mercurial URL: https://github.com/fzawa/sup-lodge.git
  - Choose a template: Rubyを選択。
3. Create workspace ボタンを押すと、workspaceが完成。
4. ホームディレクトリ直下に workspaceというディレクトリがあり、その配下に git cloneしてきたコードが置かれている。

### Lodgeが起動するまで
* まだ書いている途中です。*

# 開発者向けTips

## Ruby on Railsの日本語と英語の切り替え
config/application.rbのconfig.i18n.default_localeを変更する。
日本語の場合は :ja 英語の場合は :en
```
module Lodge
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.time_zone = "Tokyo"
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
```
