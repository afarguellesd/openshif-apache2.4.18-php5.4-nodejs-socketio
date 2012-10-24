#!/bin/sh

# INSTALL
cd $OPENSHIFT_RUNTIME_DIR
mkdir srv
mkdir srv/pcre
mkdir srv/httpd
mkdir srv/php
mkdir tmp
cd tmp/
wget http://ftp.halifax.rwth-aachen.de/apache/httpd/httpd-2.4.3.tar.gz
tar -zxvf httpd-2.4.3.tar.gz
wget http://artfiles.org/apache.org/apr/apr-1.4.6.tar.gz
tar -zxvf apr-1.4.6.tar.gz
mv apr-1.4.6 httpd-2.4.3/srclib/apr
wget http://artfiles.org/apache.org/apr/apr-util-1.5.1.tar.gz
tar -zxvf apr-util-1.5.1.tar.gz
mv apr-util-1.5.1 httpd-2.4.3/srclib/apr-util
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.gz
tar -zxvf pcre-8.31.tar.gz
cd pcre-8.31
./configure \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/pcre
make && make install
cd ../httpd-2.4.3
./configure \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/httpd \
--with-included-apr \
--with-pcre=$OPENSHIFT_RUNTIME_DIR/srv/pcre \
--enable-so \
--enable-auth-digest \
--enable-rewrite \
--enable-setenvif \
--enable-mime \
--enable-deflate \
--enable-headers
make && make install
cd ..
wget http://de2.php.net/get/php-5.4.7.tar.gz/from/this/mirror
tar -zxvf php-5.4.7.tar.gz
cd php-5.4.7
./configure \
--with-libdir=lib64 \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/php/ \
--with-config-file-path=$OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2 \
--with-layout=PHP \
--with-apxs2=$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apxs
make && make install
mkdir $OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2

# CLEANUP
rm -r $OPENSHIFT_RUNTIME_DIR/tmp/*.tar.gz

# COPY CONFIG
cp $OPENSHIFT_RUNTIME_DIR/tmp/php-5.4.7/php.ini-development $OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2/php.ini
python $OPENSHIFT_REPO_DIR/misc/httpconf.py

# START APACHE
$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apachectl start