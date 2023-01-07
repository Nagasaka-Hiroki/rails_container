# Rails container
## バージョンについて
Ruby on Rails(以下 Rails または rails)の実行環境を用意するためのDockerfile。構成は以下の通り。作成時（2022/11）の最新安定版を使用することにする。作成及び動作確認はLinux(Ubuntu22.04)で実行する。

|項目|バージョン|
|-|-|
|base image|Ubuntu 22.04|
|Ruby|3.1.2|
|Rails|7.0.4|
|docker|20.10.22|
|docker compose|v2.14.1|

## 概要
### ファイルの概要
Dockerfileを使ってRuby&Railsをインストールしたコンテナイメージを作成する。コマンドの例は以下の通り。(使用するファイルがDockerfile_baseの場合)
```
$ docker build -f Dockerfile_base -t rails_container:base .
```

　本リポジトリの各ファイルの概要について以下に記す。

|ファイル名|概要|ユーザ|
|:---|:---|:---|
|Dockerfile_base|基本のDockerfile。|root|
|Dockerfile_dev_base|Ubuntuベースイメージに、<br>ruby、rails、node.js、yarnをインストールする。|root|
|Dockerfile_remake_gu|Railsが開発できる環境にユーザを追加。|general_user|

### ディレクトリの概要
　本リポジトリのディレクトリは以下の通り。

|ディレクトリ|概要|
|-|-|
|try_and_error|Dockerfileを作る途中のメモを記している。|
|dev|docker-composeでコンテナを作成する。|

## Dockerfileの書式
Dockerfileのリファレンスは以下の通り。
> - [Dockerfile リファレンス](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/)

## railsに関する注意点
　master.keyは機密情報のためリポジトリに含めないように注意する。  
サンプルを削除する過程でミスを一度した。再発しないように注意する。
