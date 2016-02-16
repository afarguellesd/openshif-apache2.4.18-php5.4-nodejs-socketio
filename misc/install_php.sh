#!/bin/sh

#OPENSHIFT_RUNTIME_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime
#OPENSHIFT_REPO_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime/repo
OPENSHIFT_RUNTIME_DIR=/opt/app-root/runtime
OPENSHIFT_REPO_DIR=/opt/app-root/runtime/repo


cd $OPENSHIFT_RUNTIME_DIR/tmp

# INSTALL PHP
wget http://download.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz
tar -zxf icu4c-55_1-src.tgz
cd icu/source/
chmod +x runConfigureICU configure install-sh
./configure \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/icu/
make && make install
cd ../..
wget http://zlib.net/zlib-1.2.8.tar.gz
tar -zxf zlib-1.2.8.tar.gz
cd zlib-1.2.8
chmod +x configure
./configure \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/zlib/
make && make install
cd ../..
wget http://de2.php.net/get/php-7.0.3.tar.gz/from/this/mirror
mv mirror php-7.0.3.tar.gz
tar -zxf php-7.0.3.tar.gz
#cd php-5.4.40
cd php-7.0.3
./configure \
--with-libdir=lib64 \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/php/ \
--with-config-file-path=$OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2 \
--with-layout=PHP \
--with-zlib=$OPENSHIFT_RUNTIME_DIR/srv/zlib \
--with-gd \
--enable-zip \
--with-apxs2=$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apxs \
--enable-mbstring \
--enable-intl \
--with-icu-dir=$OPENSHIFT_RUNTIME_DIR/srv/icu
make && make install
mkdir $OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2
cd ..
wget http://pecl.php.net/get/APC-3.1.13.tgz
tar -zxf APC-3.1.13.tgz
cd APC-3.1.13
pwd
$OPENSHIFT_RUNTIME_DIR/srv/php/bin/phpize
./configure \
--with-php-config=$OPENSHIFT_RUNTIME_DIR/srv/php/bin/php-config \
--enable-apc \
--enable-apc-debug=no
make && make install

# CLEANUP
rm -r $OPENSHIFT_RUNTIME_DIR/tmp/*.tar.gz



# COPY TEMPLATES
cp $OPENSHIFT_REPO_DIR/misc/templates/bash_profile.tpl $OPENSHIFT_HOMEDIR/app-root/data/.bash_profile
cp $OPENSHIFT_REPO_DIR/misc/templates/php.ini.tpl $OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2/php.ini

# START APACHE
$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apachectl start
