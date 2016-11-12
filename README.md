# Cloud9での開発環境構築方法

## Cloud9のアカウント作成
cloud9のサイトでアカウントを作成し、Sign inする。
[http://c9.io/](http://c9.io/)

## Workspaceの作成
1. 「Create a new workspace」をクリックする。
2. 諸々情報を入力
  - Workspace name: sup-lodge（なんでも良い）
  - Description: 適当に
  - Private/Public の選択。Privateにしておこう。
  - Clone from Git or Mercurial URL: https://github.com/fzawa/sup-lodge.git
  - Choose a template: Rubyを選択。
3. Create workspace ボタンを押すと、workspaceが完成。
4. ホームディレクトリ直下に workspaceというディレクトリがあり、その配下に git cloneしてきたコードが置かれている。

## Lodgeが起動するまで
* まだ書いている途中です。*

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
