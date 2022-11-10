# Rails container
## バージョンについて
Ruby on Rails(以下 Rails または rails)の実行環境を用意するためのDockerfile。構成は以下の通り。作成時（2022/11）の最新安定版を使用することにする。作成及び動作確認はLinux(Ubuntu22.04)で実行する。

|項目|バージョン|
|-|-|
|base image|Ubuntu 22.04|
|Ruby|3.1.2|
|Rails|7.0.4|

## 概要
Dockerfileを使ってRuby&Railsをインストールしたコンテナイメージを作成する。コマンドの例は以下の通り。
```
$ docker build -t rails_container:dev_rails .
```

開発過程のファイルを除いて以下のファイルが存在する。

|ファイル名|完成or未完成|内容|
|-|-|-|
|Dockerfile|完成|RubyとRailsをインストールしたコンテナイメージを作成する<br>コンテナにログインしてrails new、またはボリュームをマウントしてrailsプロジェクトを実行する。<br>主に作業で使用する。|

## Dockerfileの書式
Dockerfileのリファレンス
> - [Dockerfile リファレンス](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/)

## 作業記録
### Dockerfile
Ubuntu(コンテナ)にRubyとRailsをインストールした状態までセットアップする。  
いきなりこのファイルを作ることは難しいので以下のDockerfileを経て構築することにする。

Dockerfile_dev1~4でわかったことを結合する。完成したDockerfileを元に以下のコマンドでイメージをビルドする。
```
$ docker build -t rails_container:dev_rails .
```
このコマンドで、`Dockerfile`を用いてRubyとRuby on Railsをインストールが完了したイメージが完成する。

### Dockerfile_dev1
Dockerfileを作成するために試行錯誤するためのイメージを作るDockerfile。例えば以下のようにイメージを作成する。
```
$ docker build -f Dockerfile_dev1 -t rails_container:tmp1 .
```
こうすることで`apt-get`でツールをある程度インストールした状態からスタートできる。`apt-get`の時間が長いのでそれを短縮することが目的である。

### Dockerfile_dev2
Dockerfile_tempで作ったイメージから再開するDockerfile。  
Rubyのインストールまでを行う。`apt-get`以上にRubyのインストールに時間がかかるため、Rubyインストール以降のDockerfileスクリプトを効率よく書くために使用する。前述と同様にbuildコマンドの例は以下の通りとしてやっていく。
```
$ docker build -f Dockerfile_dev2 -t rails_contailer:tmp2 .
```

### Dockerfile_dev3
Dockerfile_dev1とDockerfile_dev2を結合して上手くいくか確認する。以下のコマンドでビルドしてみる。
```
$ docker build -f Dockerfile_dev3 -t rails_container:tmp3 .
```
→ OK。コンテナの作成に成功したので、以降このDockerfileで作ったイメージをベースにDockerfileを作っていく。

### Dockerfile_dev4
Railsをインストールする。現状の問題は`gem`コマンドが見つからないエラーが出ることこれを修正する。以下のコマンドでイメージをビルドする。
```
$ docker build -f Dockerfile_dev4 -t rails_container:tmp4 .
```

#### コマンドメモ
以下のコマンドでコンテナの生成と実行して確認してみる。
```
$ docker run --name dev_tmp3 -it rails_container:tmp3
```
gemが使えるか確認する。
```
# gem environment home
/root/.rbenv/versions/3.1.2/lib/ruby/gems/3.1.0
```
使えるようだ。`gem update --system`ができるかやってみる  
→ 実行はできた。コマンドラインからの実行はできる。DockerfileのRUNコマンドからはできない？  

いい解決方法がわからないので、パスを直接打ち込んで実行するようにした。  
→ 上手く行った。とりあえずrails newも上手く行った。

Dockerfileにまとめる。(Railsをインストール直後にrbenv rehashが抜けていたので追加する)