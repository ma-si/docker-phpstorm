FROM ubuntu:vivid
MAINTAINER Iain Mckay "me@iainmckay.co.uk"

# block from https://github.com/fgrehm/docker-netbeans
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common wget git php5-cli php5-mcrypt php5-mysql php5-xdebug php5-curl php5-memcached php5-memcache php-pear curl && \
    add-apt-repository ppa:webupd8team/java -y && \
    curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN useradd -m -s /bin/bash developer \
    && mkdir /home/developer/.WebIde100 \
    && touch /home/developer/.WebIde100/.keep \
    && chown -R developer.developer /home/developer \
    && mkdir /opt/phpstorm \
    && wget -O - https://download.jetbrains.com/webide/PhpStorm-10.0.3.tar.gz | tar xzf - --strip-components=1 -C "/opt/phpstorm"

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin
RUN php5enmod mcrypt curl
RUN wget -c http://static.phpmd.org/php/latest/phpmd.phar -O /usr/bin/phpmd.phar
#RUN pear install PHP_CodeSniffer
RUN npm install -g bower

USER developer
VOLUME /home/developer/.WebIde100
CMD /opt/phpstorm/bin/phpstorm.sh
