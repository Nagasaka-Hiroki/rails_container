# Ubuntu 22.04をベースに作成する
FROM ubuntu:22.04

# 使用するシェルをbashに変更する
SHELL ["/bin/bash","-c"]

#インストールするRubyとRailsのバージョンを指定する。
ARG RUBY_VERSION="3.1.3"
ARG RAILS_VERSION="7.0.4.2"
#nodeのバージョンを指定する。
ARG NODE_VERSION="18.14.2"

# ユーザを追加する。
ARG USERNAME=general_user
ARG GROUPNAME=general_user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUPNAME \
 && useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# rootユーザでツールをインストールする。
# Ruby&Railsに必要なツールをインストールおよび設定をする。
RUN apt-get update && apt-get upgrade -y \
 && apt-get install git autoconf bison patch build-essential rustc libssl-dev libyaml-dev \
    libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev \
    libdb-dev uuid-dev curl sqlite3 libsqlite3-dev \
    libvips ffmpeg poppler-utils poppler-data -y

# 一般ユーザで続きを実行する。
USER $USERNAME
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
 && echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc \
 && source ~/.bashrc

# 環境変数を登録しrbenvを呼び出せるようにする
ENV PATH="~/.rbenv/bin:$PATH"
ENV PATH="~/.rbenv/shims:$PATH"

# Ruby&Railsをインストール
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
RUN rbenv install $RUBY_VERSION \
 && rbenv global  $RUBY_VERSION \
 && rbenv rehash \
 && gem update --system \
 && gem install rails -v $RAILS_VERSION \
 && gem install foreman \
 && rbenv rehash

# nvmをダウンロードしてインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash \
 && source ~/.bashrc

# node.jsをインストールする。
# yarnをインストール
RUN source ~/.nvm/nvm.sh \
 && nvm install $NODE_VERSION \ 
 && npm install --global yarn

# 作業ディレクトリを定義する
WORKDIR /home/$USERNAME/rails_dir

# コンテナ起動時に/bin/bashを起動するように設定する。
CMD ["/bin/bash"]