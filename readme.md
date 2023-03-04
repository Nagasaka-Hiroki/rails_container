# Rails container
## バージョンについて
Ruby on Rails(以下 Rails または rails)の実行環境を用意するためのDockerfile。構成は以下の通り。作成及び動作確認はLinux(Ubuntu22.04)で実行する。

|項目|バージョン|
|-|-|
|base image|Ubuntu 22.04|
|Ruby|3.1.3|
|Rails|7.0.4.2|

---

追記:(2023/03/03)  
OSを再インストールして環境をセットアップし直す過程で2022/11/24に3.1.3にアップデートされていることに気づいた。(rbenvでは当時表示されていなかったと思うのでその点は後で調査する。)

- [Ruby 3.1.3 リリース](https://www.ruby-lang.org/ja/news/2022/11/24/ruby-3-1-3-released/)

そのため、`3.1.2`から`3.1.3`にアップデートする。  
→アップデート完了。コンテナの作成も問題なくできた。

rbenvについてかんたんに調べると以下がヒットした。
- [rbenvで最新のrubyバージョンが見つからなかったときは](https://zenn.dev/yukito0616/articles/80031da7310707)
- [　rbenv install -l で最新バージョンが出ない時の対処 - Qiita](https://qiita.com/yahsan2/items/afbabacfd414d13a1504)

内容はおおよそrbenvとその関連のバージョンにあるそうだ。そのため最新がほしい場合はrbenv周りのアップデートをする必要がある。そのためにもRubyのアップデート情報も気にしたほうがいいかもしれない。

---

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
