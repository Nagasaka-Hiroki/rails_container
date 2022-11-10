# Ubuntu 22.04をベースに作成する
FROM ubuntu:22.04

# 使用するシェルをbashに変更する
SHELL ["/bin/bash","-c"]

# Ruby&Railsに必要なツールをインストールおよび設定をする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install git autoconf bison patch build-essential rustc libssl-dev libyaml-dev \
    libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev \
    libdb-dev uuid-dev curl sqlite3 libsqlite3-dev -y \
 && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
 && echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc \
 && source ~/.bashrc

# 環境変数を登録しrbenvを呼び出せるようにする
ENV PATH="~/.rbenv/bin:$PATH"

# Ruby&Railsをインストール
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build \
 && rbenv install 3.1.2 \
 && rbenv global 3.1.2 \
 && rbenv rehash \
 && /root/.rbenv/shims/gem update --system \
 && /root/.rbenv/shims/gem install rails -v 7.0.4 \
 && rbenv rehash \
 && mkdir -p /home/rails_dir