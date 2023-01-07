# 開発用コンテナ
## 概要
　Dockerfileでイメージを作成し、そのイメージからdockeer-compose.ymlでコンテナを作成する。

　コマンドは以下を実行する。

```bash
docker build -t rails_container:rails_on_jammy .
docker compose up -d
```

## 備考
このファイルは、以下のRailsプログラムを開発する過程で作成した。  
- [GitHub - Nagasaka-Hiroki/rails_work_1](https://github.com/Nagasaka-Hiroki/rails_work_1)

バインドマウントをdocker-compose.ymlに記述している。Railsプログラムに含めた状態でコンテナを作成すると、コンテナとホスト間でファイルを共有できる。