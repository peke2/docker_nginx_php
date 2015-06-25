FROM centos:6.6

ENV PHP php-5.6.10

RUN yum install wget -y && yum install tar -y && yum install gcc -y && yum install gcc-c++ -y && yum install pcre-devel -y && \
 yum install curl-devel -y && yum install openssl-devel -y && yum install -y libxml2 libxml2-devel -y && \
 cd /usr/local/src && wget http://jaist.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz && tar xzfv libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8 && ./configure && make && make install && make clean && \
 cd /usr/local/src && wget http://jp2.php.net/distributions/$PHP.tar.gz && tar xzfv $PHP.tar.gz && cd $PHP && ./configure --enable-mbregex --with-iconv --enable-mbstring --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-ftp --with-zlib --with-curl --with-mcrypt --with-openssl --enable-fpm && \
 make && make install && make clean && cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf && echo '/usr/local/sbin/php-fpm' >> /etc/rc.local

RUN cd /usr/local/src && wget http://www.zlib.net/zlib-1.2.8.tar.gz && tar xzfv zlib-1.2.8.tar.gz && cd zlib-1.2.8 && ./configure && make && make install && make clean && \
 cd /usr/local/src && wget http://nginx.org/download/nginx-1.8.0.tar.gz && tar xzfv nginx-1.8.0.tar.gz && cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx && make && make install && make clean && \
 echo '/usr/local/nginx/sbin/nginx -g "daemon off;"' >> /etc/rc.local

ADD ./php.ini /usr/local/lib/php.ini
ADD ./nginx.conf /usr/local/nginx/conf/nginx.conf

VOLUME /var/www:/var/www

EXPOSE 80
ENTRYPOINT ["/sbin/init"]

