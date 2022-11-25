# Dockerfile_devの作成
Dockerfile_devを作成する手順についてメモする。

前提として、`Dockerfile_base`を使ってrailsコンテナイメージを作っていることを前提として作る。<br>すなわち、作り始める前に以下のコマンドを実行する。
```
$ docker build -f Dockerfile_base -t rails_container:base .
```
このコマンドを実行してイメージファイル、`rails_container:base`をベースとして作成を行う。

また、cssなどのアセットを便利に開発するためにnode.jsとyarnをインストールする。

## 作業記録
FROM句の追加とWORKDIR句の追加をする。

### CMDについて
コンテナを起動した段階で実行するコマンドの指定はCMDで上手く行った。  
`CMD ["pwd"]`としたとき、コンテナを実行したときカレントディレクトリを表示して終了した。  
ファイル名は`Dockerfile_dev1`として記録。

### バックグラウンドで実行　Dockerfile_dev2
バックグラウンドで再生？またはデーモン化して使えれば便利に使えると考えたので試してみる。  

まず、バックグラウンドで再生するコマンドを作る。これを`timer.sh`として保存する。
```
num=0
t=1
while [ "true" ]
do
    echo $num
    num=$(($num+$t))
    sleep $t
done
```
権限を変更する。
```
$ chmod 755 timer.sh
```
ファイルをコピーするコマンドと実行するコマンドを書いてビルド。
```
$ docker build -f Dockerfile_dev2 -t rails_container:dev2 .
$ docker run --name dev2 -it rails_container:dev2 
```
でOK。実行したらいかが表示。
```
$ docker run --name dev2 -it rails_container:dev2 
0
1
2
3
4
5
6
7
```
これをバックグラウンドで実行したい。確か`-d`オプションでデタッチドモードで実行できたはずだがこれはどうだろうか？
> - [https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/commandline/exec/](https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/commandline/exec/)

```
$ docker exec -itd dev2 ./timer.sh
```
動作が見えない。一度試しでrailsサーバを起動してみる。

### railsサーバ化 Dockerfile_dev3
```
$ rails new -B sample
```
`.git`を削除して`Gemfile`を編集する。
```
gem "tzinfo-data" #, platforms: %i[ mingw mswin x64_mingw jruby ]
```
そしてコピーコマンドを以下のように記述。
```
# railsプロジェクトをコピー
COPY sample ./
```
これでビルドして実行した結果いかのディレクトリ構造になった。
```
$ docker build -f Dockerfile_dev3 -t rails_container:dev3 .
$ docker run --name dev3 -it rails_container:dev3 
/home/raisl_dir# pwd
/home/raisl_dir
/home/raisl_dir# ls
Gemfile  README.md  Rakefile  app  bin  config  config.ru  db  lib  log  public  storage  test  tmp  vendor
```
なのでsampleディレクトリをrails_dirにコピー（中身をコピー）の結果になった。

ファイルは用意できた。あとは`bundle install`で`rails s`を実行できるようにする。

試してみると`bundle`がインストールされてない？
```
# gem which bundle
ERROR:  Can't find Ruby library file or shared library bundle
# gem which bundler
/root/.rbenv/versions/3.1.2/lib/ruby/site_ruby/3.1.0/bundler.rb
```
ホスト環境でやってみてもgem whichではbundleが出てこなかった。なので大丈夫。

とりあえず以前のgemと同様に同じパスを与えて実行→上手く行った
しかしインストール途中で以下のエラーが出た。
```
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root will break this application for all non-root users on this machine.
```
とりあえず現状ではrootユーザ以外で使用する予定がないためこのままにしておく。

とりあえず  
1. ファイルのコピー
2. bundle install （あとでやり方を変えた）
ができた。次は開発用に`./bin/rails s`を実行する。IPアドレスは以前調べたとき、`cat /etc/hosts`を実行して`172.17.0.2`だということがわかっているので今はこの値を直接打ち込む。

まず手動で起動してみる

上手く行かない。`./bin/rails s`が通らない。rubyがないと言われる。考えられる原因はgemと同じ。なのでこれを解決しないと始まらない。

以下に参考。
> - [https://fujiya228.com/ruby-rbenv-installation/](https://fujiya228.com/ruby-rbenv-installation/)  
環境変数の設定が２つある。これを参考に設定してみる。
```
ENV PATH="~/.rbenv/bin:$PATH"
```
は設定済みなのでもう一つ。
```
~/.rbenv/shims:$PATH
```
のほうを設定する（私が手動で入力しているのもこれなので非常に怪しい）
→まずgemが通った。なので`Dockerfile_base`の方も更新しておく。

サーバも手動だが起動した。しかし`CMD`で起動しない。

### railsサーバ化 Dockerfile_dev4
Dockerfile_baseの修正を受けて変更を加える。

また、作業の途中で方向性が間違えていることに気づいたので修正する。

今作っているのは開発で使用するコンテナを作るDockerfileなので、要求されるのはコンテナ実行と同時にサーバを起動することではなく。  
ホスト環境とファイルを同期、サーバーを起動して開発結果を確認する、可能であればライブリロード機能をつけて効率的に開発をできるようにする。  
といったところだと思う。故に開発用コンテナはでは以下の設定に固定するとする。

1. ファイルのコピーはしない。`docker run`時にマウントするため不要である。
1. `CMD`コマンドは`bin/bash`にする。コンテナに入るときはおおよそサーバを起動するとき、またはコンテ内の設定ファイルなどをみるときなのでサーバの起動に設定しない。
1. `bundle install`しない。ファイルがないので当然だが、コンテナ作成後コンテナに入って手動で実行する。
（＋ライブリロードがほしいと感じる）

反対に本番環境コンテナは以下の想定である。

1. `RUN git clone`または`COPY`コマンドなどの手段でコンテナ内にファイルを取り込む。
1. コンテナ実行時にrailsサーバを起動してリクエストを受け付ける状態にする。
1. `bundle install`する。当然だがサーバを起動するために実行する。(Gemfile.lockがある場合はbundle updateになるか？明確に違いが現状説明できないので後日調べる)

いま簡単に列挙できるものは以上である。上記の設定の違いにすれば、dockerのメリットである開発環境の違いの吸収が有効である（環境のインストールまでは同一なので）と考えている。  
故に上記の前提で以降開発用コンテナを作成していく。

上記の内容を考えると開発用コンテナはそこまで記述する内容はない。書き直したところ以下のようになる。
```Dockerfile
# Ruby&Railsをインストールしたイメージをベースに始める。
FROM rails_container:base

# 作業ディレクトリを定義する
WORKDIR /home/raisl_dir

# コンテナ起動時に/bin/bashを起動するように設定する。
CMD ["/bin/bash"]
```
しかし問題なのは、起動のコマンドが変わるという点。考えられるのは3つ。

1. runでイメージを実行してコンテナ作成。
1. コンテナ作成後、コンテナに入ってシェルを使って操作する。
1. コンテナをコマンド付きで実行する（単純にサーバを起動したいとき）

である。詳細な内容については実行時に考えるが、前提があるという点だけ注意したい。  
また、開発用であるためubuntu:22.04から作成しない。本番用は`Dockerfile_base`なしで作成できるようにする。  
(Dockerfile_dev4をDockerfile_devとしてトップにコピーする。)

### node.jsのインストール Dockerfile_dev5
インストール意外の項目について作業したので、インストール作業を行っていく。
node.jsのインストール。nvmでインストールする。
> - [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)  

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
```

> - [https://nodejs.org/ja/](https://nodejs.org/ja/)
最新安定版は18.12.1だそうだ。

yarnのインストール
> - [https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable](https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable)

nvmがシェルだからか上手く行かない。コンテナに直接入って実行はできるがDockerfileとしては難しい。なので別の方法を考える。

### node.jsのインストールその2 Dockerfile_dev6
nvmだと上手く行かないみたい？いろいろ試したが`nvm`コマンドが実行できない。そのためapt-getで入れる。その方法は以下を参考にする。
> - [https://qiita.com/nanbuwks/items/ed8adb2d4324c939a349](https://qiita.com/nanbuwks/items/ed8adb2d4324c939a349)

ひとまず上手く行ったはず。完成したものと、Dockerfile_baseと結合して一つにしリポジトリのルートに配置する。