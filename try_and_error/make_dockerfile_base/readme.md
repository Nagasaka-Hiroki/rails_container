# Dockerfile_base作成
Dockerfile_baseの作成メモをかんたんに記録する。  
本ディレクトリ内では`Dockerfile`と`Dockerfile_base`は同義である。  
(基本のDockerfile_baseをDockerfileとして作成していた過程の記録である)

## 作業記録
### Dockerfile
Ubuntu(コンテナ)にRubyとRailsをインストールした状態までセットアップする。  
いきなりこのファイルを作ることは難しいので以下のDockerfileを経て構築することにする。(./make_dockerfile_baseにDockerfile_dev1~4を移動する。)

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