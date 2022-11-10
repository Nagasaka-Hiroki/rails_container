# Dockerfile_devの作成
Dockerfile_devを作成する手順についてメモする。

前提として、`Dockerfile_base`を使ってrailsコンテナイメージを作っていることを前提として作る。<br>すなわち、作り始める前に以下のコマンドを実行する。
```
$ docker build -f Dockerfile_base -t rails_container:base .
```
このコマンドを実行してイメージファイル、`rails_container:base`をベースとして作成を行う。

## 作業記録
FROM句の追加とWORKDIR句の追加をする。
