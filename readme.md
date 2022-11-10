# Rails container
## バージョンについて
Ruby on Rails(以下 Rails または rails)の実行環境を用意するためのDockerfile。構成は以下の通り。作成時（2022/11）の最新安定版を使用することにする。作成及び動作確認はLinux(Ubuntu22.04)で実行する。

|項目|バージョン|
|-|-|
|base image|Ubuntu 22.04|
|Ruby|3.1.2|
|Rails|7.0.4|

## 概要
Dockerfileを使ってRuby&Railsをインストールしたコンテナイメージを作成する。コマンドの例は以下の通り。(使用するファイルがDockerfile_baseの場合)
```
$ docker build -f Dockerfile_base -t rails_container:base .
```

以下のファイルを作成する。（予定）

|ファイル名|内容|
|:---:|:---|
|Dockerfile_base|RubyとRailsをインストールしたコンテナイメージを作成する。<br>コンテナにログインしてrails new、またはボリュームをマウントしてrailsプロジェクトを実行する。<br>主に作業で使用する。基本のDockerfile。|
|Dockerfile_dev|作成予定。<br>コンテナを作成した段階でrails newをしてプロジェクトを生成する。←これは要検討。したくない場合もある（オプションが決まっているときなど）<br>コンテナを起動した段階でサーバを起動するように設定する。|

## Dockerfileの書式
Dockerfileのリファレンス
> - [Dockerfile リファレンス](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/)