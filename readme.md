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
|Dockerfile_base|RubyとRailsをインストールしたコンテナイメージを作成する。<br>コンテナにログインしてrails new、またはボリュームをマウントしてrailsプロジェクトを実行する。<br>主に作業で使用する。基本のDockerfile。<br>※修正を加えた。正常にイメージがビルドされたことも確認。|
|Dockerfile_dev|開発用のrailsコンテナ。<br>ベースイメージを`Dockerfile_base`によって作成したイメージ`rails_container:base`として用いることを前提に作成している。<br>開発ではバインドマウントを使用してホスト側とファイルを共有することを想定しているため、実行コマンドもそれに合わせて設定する。`CMD`コマンドにbashを指定している。また、node.jsとyarnを追加でインストールしている。|
|Dockerfile_dev_base|単一のDockerfileでUbuntuベースイメージから、ruby、rails、node.js、yarnをインストールする。<br>node.jsとyarnをインストールしているためcssフレームワークをrailsで使用できる。しかしコンテナないから直接rails newするとGemfileの設定の関係でエラーが出るので、ホスト環境で実行後バインドマウントでファイルを共有するのがいいと考えれる。|
|Dockerfile|作成予定。本番環境のDockerfile。<br>ベースイメージを`ubuntu:22.04`として作成し、rubyおよびruby on railsのインストール、作成したファイルの取得及びgemのインストールを行い。コンテナを起動した段階で`production`環境設定でrailsサーバを起動する。|

## Dockerfileの書式
Dockerfileのリファレンス
> - [Dockerfile リファレンス](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/)

## railsに関する反省
本リポジトリでサンプルとして作成したrailsプロジェクトについて途中から管理から外すために削除したが、削除の仕方がしっかりしていなくてmaster.keyがpushされていた（メールで知らされてびっくりした）。とりあえず鍵の値が個人特有の値ではなくプロジェクトごとに違ったため一安心であったが今後こういったことはないように注意する。今回はサンプルだったので大きな問題にはならないはず。そのためリポジトリから履歴ごと削除して対応する。以下を参考に削除した。

> - [https://qiita.com/go_astrayer/items/6e39d3ab16ae8094496c](https://qiita.com/go_astrayer/items/6e39d3ab16ae8094496c)

