## サイト概要
小売店向けの売上分析業務アプリケーションです。
毎日の売上を登録でき、一覧で確認できます。
登録しておいた売上データから、選択した期間の売上合計額を集計し
次に仕入れる商品を予測できるアプリを目指しました。
* ホーム画面
![screencapture-lily-sales-2023-10-11-22_55_01](https://github.com/misaku54/uriage_app/assets/123493228/95b0a91e-a9c4-42f6-98c1-30b6878332de)
* 集計画面（年別集計）
![screencapture-localhost-users-1-yearly-search-2023-10-11-23_11_12](https://github.com/misaku54/uriage_app/assets/123493228/75907f33-db1b-41de-a447-276b231e8c33)
## 使用方法
* １.左側のサイドバーの「マスター」からメーカーと商品分類データを登録します。
* 2.左側のサイドバーの「売上登録/売上一覧」から１で登録したメーカーと商品分類のデータをもとに、売上データを登録します。
* ３.左側のサイドバーの「売上分析」から月別、日別、年別の期間で２で登録した売上データを集計し、合計売上額やもっとも売れたメーカーや商品分類をカテゴリ別で表示します。
* ４.ホーム画面では当日の売上データをグラフで表示したり、天気情報をリアルタイムで表示します。
## 制作背景
実家が小売業をしており、少しでも業務を効率化し業績に貢献したいという思いから制作を決意しました。
いただいた要望やヒアリングしたことをベースに開発しました。
* 要望
  * 商品の仕入れをする時、どんなメーカーのどんな商品をいくらぐらいで何個仕入れたら良いか
    事前に予測できるサービスが欲しい。
  * 店員の年齢層的にパソコンをほとんど扱ったことのない
    世代のため、操作が簡単にできて、おおまかに分析できるものがほしい。
* ヒアリングしたこと
  * 現在の仕入れはどのように予測しているのか。
    * その日の売上金額、メーカー、商品分類、天候、人手状況などが記載された記録ノートがあり、
      それをもとに予測している。
  * 売り上げはどのように把握しているのか。
    * 溜まったレシートを税理士に渡すことで、売り上げ合計額のグラフを作成してくれるため、それを見て把握している。
      ただし、その情報は、月の最終日にしかわからないので、日毎の売り上げ情報をノートで管理し、店側で随時確認できるようにしている。
## 使用技術
* バックエンド
  * Ruby 3.2.1
  * Ruby on Rails 7.0.4.2
  * MySql5.7
* フロントエンド
  * Bootstrap5
  * JavaScript
* テスト
  * rspec(model request system)
* インフラ
  * Docker/Docker-compose
  * AWS（ECR ECS Fargate ROUTE53 ACM ELB）
  * Github Actions  

## インフラ構成図
![aws (1)](https://github.com/misaku54/uriage_app/assets/123493228/2347a9c4-cbce-4857-ae78-f149526bfe7c)
## ER図
![ER drawio (1)](https://github.com/misaku54/uriage_app/assets/123493228/3665dedc-7364-4008-a488-739106d6f175)
## 機能一覧
* ログイン機能（クッキー保存、フレンドリーフォワーディング）
* ユーザー管理機能(管理者限定)（CRUD）
* メーカー管理機能（CRUD）
* 商品分類管理機能（CRUD）
* 売上管理機能（CRUD）
  * プラグインslimselectによる検索ができるセレクトボックス
* 集計機能
  売上管理に登録されたデータより、年別、月別、日別で売上合計額の集計する
  * メーカーごとの売上合計額をランキング形式で表示
  * 商品分類ごとの売上合計額をランキング形式で表示
  * メーカー、商品分類の組み合わせごとの売上合計額ランキング形式で表示
  * 前年比や販売個数も合わせて表示
* 定期処理実行機能
  * 3時間ごとに天気APIから当日の天気情報をDBに保存
* その他機能
  * カレンダー機能
  * ページネーション機能(kaminari＋hotwire)
  * 検索機能(ransack)
  * CSV出力機能
  * リアルタイム売上表示機能
* javascriptで実装した機能
  * 当日の天気情報を天気APIより1時間おきに取得して表示
  * リアルタイムバリデーション
  * 時計機能
  * ツールチップ
  * アコーディオンサイドバー
  * ハンバーガーメニュー
  * タブメニュー
    
## 今後追加したい機能
　　* 一括削除機能の実装
   
## 今後取り組みたいこと
* RubyとJavaSciptの基礎を磨き、できることを増やす。
* 書籍を読み、設計とコーディング力をつける。
* React RailsのSPAアプリ作成
* インフラスキルの学習
* 応用情報の取得
