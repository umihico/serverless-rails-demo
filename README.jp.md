# Railsのサーバーレス化を最小手順でやるデモ

Railsのサーバーレスで動かす代表的な方法としてJetsやLambyなどがあります。またSinatraではありますがAWSは[公式サンプル](https://raw.githubusercontent.com/aws-samples/serverless-sinatra-sample)を提供するようになりました。

この記事はそれよりももっと手軽に、最小の改変でLambdaにデプロイするにはどうすればよいか試してみた記事になります。結論としては数ファイルの設置と数カ所の変更だけでRailsのサーバーレス化は可能でした。[こちらが試しに作ったURLです。](https://fxkgpsdpvl.execute-api.ap-northeast-1.amazonaws.com/)

以下は新規プロジェクトの場合の実演です。[レポジトリはこちらです。](https://github.com/umihico/serverless-rails-demo)今回もServerless Frameworkを使います。

1. 以下の４ファイルを置く (1stコミット)

   - [.dockerignore](https://github.com/umihico/serverless-rails-demo/blob/master/.dockerignore)
   - [Dockerfile](https://github.com/umihico/serverless-rails-demo/blob/master/Dockerfile)
   - [init.sh](https://github.com/umihico/serverless-rails-demo/blob/master/init.sh)
   - [serverless.yml](https://github.com/umihico/serverless-rails-demo/blob/master/serverless.yml)

2. init.shを実行する。 (2ndコミット). `rails new .`が中で実行され初期の構成ファイルが生成されます。

3. Sinatraの公式サンプルから[このファイル](https://raw.githubusercontent.com/aws-samples/serverless-sinatra-sample/71c8e849a619a8fea169e328b93a7434054e86fa/lambda.rb)をダウンロードします。(3rdコミット)

4. 以下のファイルを改変します。 (4stコミット)

   - config.ruのパスに合わせ修正
   - サンプルはAPI GatewayのREST API対応なので、HTTP APIに合うように修正
   - `/tmp`以下以外の書き込みが不可なので、またCouldwatchで見れるようロギング設定を標準出力に変える
   - Serverless Frameworkに合わせ.gitignore追加
   - 任意ですが開発中は生リクエスト情報見たいので標準出力に書き出す

5. 後述のわけあってproductionとしてデプロイしてますが、welcomeページ消えるので追加 (5thコミット)

6. 次のコマンドでデプロイ`SECRET_KEY_BASE=$(cat tmp/development_secret.txt) sls deploy`（devのキーをこのように使い回すのは良くないですが、デモなので楽します）。実行結果が教えてくる生成されたページに行きます

サーバーレス化に共通ですが、主な工数はAPI Gatewayが送りつけてくる生のeventを、Railsアプリが処理できる引数にする変換処理と、`/tmp`以外への書き出しを封じることになります。

RalisはShopifyが作ったbootsnapがデフォで入りましたが、こちらはコールドスタートでキャッシュの作り直しが都度発生するので、パフォーマンスが悪化するケースがあり相性が悪いです。環境変数DISABLE_BOOTSNAP=trueで無効にさせてもらっています。サーバーレス化にトライする今日まで存在さえ知らなかったので勉強になりました。

## 参考

- https://nihemak.hatenablog.com/entry/2019/01/15/015802
- https://qiita.com/tsutorm/items/d08119b3174c4ff7645d
