ARG BASE_IMAGE=php:7.0
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_VERSION=18.03.1-ce

# Install common
RUN docker-php-source extract \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
  git \
  gnupg \
  jq \
  libldap2-dev \
  libmcrypt-dev \
  mysql-client \
  openssh-client \
  software-properties-common \
  wget \
  zlib1g-dev \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap zip mysqli pdo pdo_mysql

# Install Docker cli
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
&& mv docker-${DOCKER_VERSION}.tgz docker.tgz \
&& tar xzvf docker.tgz \
&& mv docker/docker /usr/local/bin \
&& rm -r docker docker.tgz

# Install AWS cli
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 \
&& pip install awscli --upgrade

# Install mysql
RUN apt-get install mysql-server -y \
&& sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf \
&& sed -i '/max_connections/a max_connections = 3000' /etc/mysql/my.cnf

# Install xdebug php extention
RUN pecl config-set preferred_state beta \
&& pecl install -o -f xdebug \
&& rm -rf /tmp/pear \
&& pecl config-set preferred_state stable

# Install node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
&& apt-get install nodejs -y

# Install bower
RUN npm install -g bower

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update \
&& apt-get install yarn -y

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
&& mv composer.phar /usr/bin/composer

# Install newman (Postman test runner)
RUN npm install newman --global

# Clean
RUN apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
&& docker-php-source delete
