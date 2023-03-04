# 開発用コンテナ
## 概要
　Dockerfileでイメージを作成し、そのイメージからdocker-compose.ymlでコンテナを作成する。

　コマンドは以下を実行する。

```bash
docker build -t rails_container:rails_on_jammy .
docker compose up -d
```

## 備考
このファイルは、以下のRailsプログラムを開発する過程で作成した。  
- [GitHub - Nagasaka-Hiroki/rails_work_1](https://github.com/Nagasaka-Hiroki/rails_work_1)

バインドマウントをdocker-compose.ymlに記述している。Railsプログラムに含めた状態でコンテナを作成すると、コンテナとホスト間でファイルを共有できる。

## アップデート
### 概要
　Rubyが3.1.3にアップデートされていることに、気づいた（2023/03/03で気づいた）。そのためこちらもアップデートする。またせっかくなのでバージョンの数字をまとめて見やすくする。以下のように記述した。

```docker
#インストールするRubyとRailsのバージョンを指定する。
ARG RUBY_VERSION="3.1.3"
ARG RAILS_VERSION="7.0.4.2"
#nodeのバージョンを指定する。
ARG NODE_VERSION="18.14.2"
```

注意点として`FROM`句よりもあとに記述すること。そうしないとうまく動かない。以下参考。
- [ARG と FROM の関連について｜Dockerfile リファレンス｜Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#understand-how-arg-and-from-interact)

また、Railsも7.0.4.2になっていたのでこちらにも対応する。
同様に、nodejsも18.12.1から18.14.2になっていたので対応する。

### インストールバージョンの整理
　以下にインストール時にバージョンを指定する項目と、アップデート時(2023/3)での値を記述する。

|インストール項目|バージョン|
|-|-|
|Ruby|3.1.3|
|Ruby on Rails|7.0.4.2|
|Node.js|18.14.2|