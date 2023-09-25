FROM ruby:3.2.1
# インストール済みのパッケージ更新をおこない、新しいバージョンにアップグレードする
RUN apt-get update -qq && apt-get install -y nodejs yarnpkg
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
RUN apt-get install -y cron 
# コンテナないにappフォルダをつくる。
RUN mkdir /app
# 作業ディレクトリを指定
# こうしておくと、コンテナ上でコマンド実行しようとする時の階層がapp上になる。
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
EXPOSE 3000
# -bバインドするIPアドレスを指定
CMD ["rails", "server", "-b", "0.0.0.0"]