FROM centos:6.8

ENV PHP=php-5.6.16
ENV NGINX=nginx-1.8.0
ENV ZLIB=zlib-1.2.8
ENV LIBMCRYPT=libmcrypt-2.5.8

ENV SRC_PATH=sources/
ENV DST_PATH=/usr/local/src/

COPY ${SRC_PATH}${NGINX}.tar.gz $DST_PATH
COPY ${SRC_PATH}${PHP}.tar.gz $DST_PATH
COPY ${SRC_PATH}${ZLIB}.tar.gz $DST_PATH
COPY ${SRC_PATH}${LIBMCRYPT}.tar.gz $DST_PATH

RUN yum install wget -y && yum install tar -y && yum install gcc -y && yum install gcc-c++ -y && yum install pcre-devel -y
RUN cd ${DST_PATH} && tar xzfv ${ZLIB}.tar.gz && cd ${ZLIB} && ./configure && make && make install && make clean
RUN yum install curl-devel -y && yum install openssl-devel -y && yum install -y libxml2 libxml2-devel -y
RUN cd ${DST_PATH} && tar xzfv ${LIBMCRYPT}.tar.gz && cd ${LIBMCRYPT} && ./configure && make && make install && make clean
RUN cd ${DST_PATH} && tar xzfv ${PHP}.tar.gz && cd ${PHP} && ./configure --enable-mbregex --with-iconv --enable-mbstring --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-ftp --with-zlib --with-curl --with-mcrypt --with-openssl --enable-fpm
RUN cd ${DST_PATH}${PHP} && make && make install && make clean
RUN cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
COPY ${SRC_PATH}php-fpm /etc/init.d/
RUN chmod 755 /etc/init.d/php-fpm && chkconfig --add php-fpm

RUN groupadd -g 500 nginx && useradd -g nginx -u 500 -s /sbin/nologin nginx
RUN cd ${DST_PATH} && tar xzfv ${NGINX}.tar.gz && cd ${NGINX} && ./configure --prefix=/usr/local/nginx && make && make install && make clean
COPY ${SRC_PATH}nginx /etc/init.d/
RUN chmod 755 /etc/init.d/nginx && chkconfig --add nginx && chkconfig --level 35 nginx on
RUN mkdir /var/log/nginx && mkdir /var/www

COPY ${SRC_PATH}php.ini /usr/local/lib/
COPY ${SRC_PATH}nginx.conf /usr/local/nginx/conf/

EXPOSE 80 81
ENTRYPOINT ["/sbin/init"]

