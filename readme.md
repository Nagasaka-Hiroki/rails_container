# Rails container
## バージョンについて
railsの実行環境を用意するためのDockerfile。構成は以下の通り。作成時の最新安定版を使用することにする。

|項目|バージョン|
|-|-|
|base image|Ubuntu 22.04|
|Ruby|3.1.2|
|Rails|7.0.4|

## 概要
### Dockerfile
Ubuntu(コンテナ)にRubyとRailsをインストールした状態までセットアップする。  
いきなりこのファイルを作ることは難しいので以下のDockerfileを経て構築することにする。

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
Dockerfile_dev2でインストールしたRubyを使ってRailsをインストールしていく。

## 注意
現状のファイルは1つ。今後追加していく予定。

## その他
Dockerfileのリファレンス
> - [Dockerfile リファレンス](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/)