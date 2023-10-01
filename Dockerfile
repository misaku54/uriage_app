FROM ruby:3.2.1
# 本番環境用の環境変数
ENV RAILS_ENV=production
# 本番環境でもasset内の静的ファイルを配信する設定。
ENV RAILS_SERVE_STATIC_FILES=true
# 本番環境のログ出力を標準出力に変更する設定。
ENV RAILS_LOG_TO_STDOUT=true
ENV TZ=Asia/Tokyo
# インストール済みのパッケージ更新をおこない、新しいバージョンにアップグレードする
RUN apt-get update -qq && apt-get install -y nodejs yarnpkg
RUN apt-get install -y cron 
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
# 定期バッチのため、コンテナ内のタイムゾーンをJSTに変更
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
# 勤怠app内のファイルフォルダを全てコンテナないのappフォルダにもってく。
COPY . /app

COPY entrypoint.sh /usr/bin/
# chmodはファイル or ディレクトリに対する権限を設定するコマンド。
# entrypoint.shaファイルに、実行権限を与えるという意味。
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# -bバインドするIPアドレスを指定
CMD bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 80"