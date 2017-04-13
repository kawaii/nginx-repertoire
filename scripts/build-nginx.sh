#!/bin/bash

# this is the version of nginx we will download and compile
export NGINX_VERSION=1.12.0

# ensure that we have the required software to compile our own nginx
apt-get -y install curl wget build-essential libgd-dev libgeoip-dev checkinstall git libpcre3 libpcre3-dev

# create working directory for source compilation
mkdir /opt/build/

# clean out any files from previous runs of this script
rm -rf /opt/build/*
cd /opt/build/

# download any custom modules we need
git clone https://github.com/kyprizel/testcookie-nginx-module.git

cd /opt/build/

# download nginx
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz

cd nginx-${NGINX_VERSION}/

# configure and compile nginx with our chosen options
./configure \

	--prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \

	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \

	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \

	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \

	--user=www-data \
	--group=www-data \

	--with-http_ssl_module \
	--with-http_v2_module \
	--with-http_realip_module \
	--with-http_geoip_module \
	--with-http_mp4_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-http_auth_request_module \
	--with-file-aio \
	--with-ipv6 \
	--with-debug \

	--without-mail_pop3_module \
	--without-mail_smtp_module \
	--without-mail_imap_module \

	--add-module=/root/build/testcookie-nginx-module

make
make install

mkdir /var/www/
chown -R www-data:www-data /var/www/

echo "Success!"
