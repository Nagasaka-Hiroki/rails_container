# 試運転
開発用に作ったDockerfile_dev_baseを使ってRailsを動かせるか試す。  
また、便利に開発するためにライブリロードも導入する。

その作業記録をここに記す。

## メモ
```
mkdir -v dev_base
cd dev_base
railse new . -B
```
Gemfileを編集
```
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data" #, platforms: %i[ mingw mswin x64_mingw jruby ]
```
コマンドの続き
一応ディレクトリに入れておく。
> - [https://hacknote.jp/archives/58619/](https://hacknote.jp/archives/58619/)
これを参考に実行
```
curl https://raw.githubusercontent.com/Nagasaka-Hiroki/rails_container/main/Dockerfile_dev_base > Dockerfile_dev_base
```
以下のコマンドでコンテナ作成
```
docker run --name dev_container -v $(path_to_dev_base):/home/rails_dir -it rails_container:dev_base
```
IPアドレス確認
```
cat /etc/hosts
...
172.17.0.2      25fd70ef123d
```

インストール作業
```
# bundle install
```

## ちょっとやり直し。
