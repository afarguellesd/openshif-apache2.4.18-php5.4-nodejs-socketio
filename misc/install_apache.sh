#!/bin/sh

#OPENSHIFT_RUNTIME_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime
#OPENSHIFT_REPO_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime/repo
OPENSHIFT_RUNTIME_DIR=/opt/app-root/runtime
OPENSHIFT_REPO_DIR=/opt/app-root/runtime/repo


# INSTALL APACHE
cd $OPENSHIFT_RUNTIME_DIR
mkdir srv
mkdir srv/pcre
mkdir srv/httpd
mkdir srv/php
mkdir tmp
cd tmp/
# Descarga de fuentes de Apache 
#wget http://ftp.halifax.rwth-aachen.de/apache/httpd/httpd-2.4.12.tar.gz
wget http://www.us.apache.org/dist/httpd/httpd-2.4.18.tar.gz
tar -zxf httpd-2.4.18.tar.gz
# Descarga de fuentes APR
#wget http://artfiles.org/apache.org/apr/apr-1.5.2.tar.gz
wget http://www.us.apache.org/dist/apr/apr-1.5.2.tar.gz
tar -zxf apr-1.5.2.tar.gz
# Se mueven fuentes APR a srclib Apache para compilacion
mv apr-1.5.2 httpd-2.4.18/srclib/apr
# Descarga de fuentes APR Utils
#wget http://artfiles.org/apache.org/apr/apr-util-1.5.2.tar.gz
wget http://www.us.apache.org/dist/apr/apr-util-1.5.4.tar.gz
tar -zxf apr-util-1.5.4.tar.gz
# Se mueven fuentes APR Utils a srclib Apache para compilacion
mv apr-util-1.5.4 httpd-2.4.18/srclib/apr-util
# Descarga de fuentes PCRE
#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.gz
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
tar -zxf pcre-8.38.tar.gz
# Compilacion PCRE
cd pcre-8.38
./configure \
--prefix=$OPENSHIFT_RUNTIME_DIR/srv/pcre
make && make install
# Compilacion Apache
cd ../httpd-2.4.18
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
# Limpieza de ejecutables
cd ..
rm -r $OPENSHIFT_RUNTIME_DIR/tmp/*.tar.gz

# COPY TEMPLATES
cp $OPENSHIFT_REPO_DIR/misc/templates/bash_profile.tpl $OPENSHIFT_HOMEDIR/app-root/data/.bash_profile
python $OPENSHIFT_REPO_DIR/misc/httpconf.py

# START APACHE
$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apachectl start
