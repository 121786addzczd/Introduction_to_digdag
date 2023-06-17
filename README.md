## 環境構築

以下の通りdocker-composeを実行して、Digdagコンテナ・Digdagサーバー・PostgreSQLコンテナを起動します。

```
$ docker-compose build --no-cache

$ docker-compose up -d
```

digdagコンテナ・Digdagサーバー・PostgreSQLコンテナを起動後、http://localhost:65432/ アクセスすることで画面からワークフローの設定ができます。



公式:https://docs.digdag.io/getting_started.html


## コンテナ周りの操作

### digdagコンテナにログイン
```shell
$ docker exec -it digdag bash
```

### digdagコンテナからpostgreにログイン
```shell
$ psql -d digdag -U postgres_user -h db
```

### digdagコンテナからpostgreログインをまとめて実行
```shell
$ docker exec -it digdag psql -d digdag -U postgres_user -h db
```


### postgresコンテナにログイン
```shell
$ docker exec -it postgres bash
```

### コンテナからpostgresへアクセス
```shell
psql -d digdag -U postgres_user -h localhost
```

### コンテナからpostgreログインをまとめて実行
```shell
$ docker exec -it postgres psql -d digdag -U postgres_user -h localhost
```



## エラーメモ

### PostgreSQLへの接続時に "sorry, too many clients already" エラーが発生する
以下のコマンドを実行するとエラーが発生します。
```shell
psql -d digdag -U postgres_user -h localhost
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  sorry, too many clients already
```

### 原因
このエラーは、PostgreSQLの同時接続数制限を超えてしまっているために発生します。Digdagがポート5432でPostgreSQLに接続しているため、その後にターミナルからPostgreSQLに接続できなくなってしまいます。


### 対策方法
PostgreSQLの同時接続数制限を増やすことで対応できます。具体的な手順を以下に示します。

1. postgresコンテナに入る
```shell
$ docker exec -it postgres bash
```

2. PostgreSQL設定ファイルを編集する
以下のコマンドを実行して、/var/lib/postgresql/data/postgresql.confファイルを編集します。

```shell
$ sed -i 's/max_connections = 100/max_connections = 300/g' /var/lib/postgresql/data/postgresql.conf
```


3. PostgreSQLコンテナからログアウトして再起動する
```shell
$ exit
$ docker restart postgres
```

4. 変更が反映されたか確認する
以下のコマンドを実行して、変更が正しく反映されたか確認します。

```shell
$ docker exec -it postgres psql -d digdag -U postgres_user -h localhost
```

上記のコマンドを実行すると、以下のような出力が表示されれば成功です。
```
$ docker exec -it postgres psql -d digdag -U postgres_user -h localhost
psql (15.3 (Debian 15.3-1.pgdg120+1))
Type "help" for help.

digdag=#
```



### postgresログインのパスワード入力を省略する方法

```shell
$ docker exec -it digdag bash
$ export PGPASSWORD="postgres12345"
```
注意点としてコンテナ外からのログインパスワードは省略されない
