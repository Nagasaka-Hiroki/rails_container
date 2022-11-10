FROM ubuntu:22.04
RUN apt-get update && apt-get upgrade -y
RUN apt-get install git autoconf bison patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev curl sqlite3 libsqlite3-dev -y
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
RUN rbenv install 3.1.2
RUN rbenv global 3.1.2
RUN gem update --system
RUN bundle update --bundler
RUN gem install rails -v 7.0.4
RUN mkdir -p /home/rails_dir
