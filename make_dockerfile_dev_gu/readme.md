# Dockerfile_dev_gu
調べているとセキュリティ的にはdockerでrootユーザを使うことはやめたほうがいいらしい。なので一般ユーザを追加して使えるようにしたい。  
また、gemのインストールの途中でgemのインストールでrootユーザは避けるべきという主旨の警告が出るのでこれも同時に解決したい。  
と言っても根本の要因としてはdocker内で作成したファイルをホスト側から編集できないのが困っているのに起因しているため、まずはそこを解消して行きたい。

流れとしては、通常のUbuntuイメージに一般ユーザを追加する。Dockerfile_ubuntu_guを作成し、その内容をDockerfile_dev_baseに結合する流れで作成しようと考えている。

## 作業メモ
### Dockerfile_dev_gu1
- 参考
> - [https://qiita.com/Spritaro/items/602118d946a4383bd2bb](https://qiita.com/Spritaro/items/602118d946a4383bd2bb)  

参考のコードがほとんどそのままやりたいことに近いのでまずはそれを実行する。  
uidもguiも同一（これは当然？）だったのでそれを使用する。基本的な骨組みは以前のものから流用しユーザの追加部分を指定する。  
→　上手く行った。ファイルの編集も保存もできた。

確認としてrootにも切り替えられるように設定する。以下で切り替えできた。
```
USER root
```
とりあえずユーザを追加できたので以前のやつに結合。

### Dockerfile_dev_gu2
Dockerfile_dev_baseをコピーしてDockerfile_dev_gu2にする。その上でrootユーザで実行すべきものとそうでないものに注意して書き換えと結合をする。

```bash
$ docker build -f Dockerfile_dev_gu2 -t rails_container:gu2 .
```
yarnが上手くインストールされていなかった。コードを修正する。(Dockerfile_dev_baseも問題があったということなのでその分も修正する。)
> - [https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)
> - [https://qiita.com/chisso_/items/199bbdce3ad9c7428c89](https://qiita.com/chisso_/items/199bbdce3ad9c7428c89)

これを実行する。

以下を追加する。
```docker
# yarnをインストール
RUN mkdir ~/.npm-global \
 && npm config set prefix '~/.npm-global' \
 && export PATH=~/.npm-global/bin:$PATH \
 && source ~/.profile \
 && npm install --global yarn \
 && exec $SHELL -l
```
手動でやったときは上手く行ったがDockerfileだと失敗、npmを最新にしろというエラーがでた。

### Dockerfile_dev_gu3
nodeのインストールを見直す。nvmにしてみる。

以下参考
> - [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)
> - [https://qiita.com/llr114/items/e7beb02d0bf461b3f8b8](https://qiita.com/llr114/items/e7beb02d0bf461b3f8b8)

macの対応になるが、Linuxでも使えるかもしれないので以下を実行する。
```
$ source ~/.nvm/nvm.sh
```

> - [https://zenn.dev/uttk/articles/a7b085c7774ae9](https://zenn.dev/uttk/articles/a7b085c7774ae9)  
Ubuntuのイメージでやっている人を見つけた。上記のコマンドを実行しているはずだが書き方の問題だろうか？
直してみる。

→　上手く走った。どうやら`~/`の意味合いが少し違うみたい。絶対パスで打ち込むのがいいようだ。  
→　と思っていたが、元に戻すと何故か上手く行った。`~/`の解釈はあっているはず。単純にファイルの書き方がまずかっただけのよう。

nodeとnpmとyarnのインストールができた。

これで、
1. ユーザの追加
1. node.js, npm, yarnのインストール
ができた。これを完成としてリポジトリに配置する。また、yarnのインストール部分を移植しておく（過去のものに）