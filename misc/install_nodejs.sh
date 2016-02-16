#!/bin/sh

#OPENSHIFT_RUNTIME_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime
#OPENSHIFT_REPO_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime/repo
OPENSHIFT_RUNTIME_DIR=/opt/app-root/runtime
OPENSHIFT_REPO_DIR=/opt/app-root/runtime/repo


cd $OPENSHIFT_RUNTIME_DIR/tmp

# INSTALL NODEJS
#wget https://nodejs.org/dist/v4.3.0/node-v4.3.0.tar.gz
#tar -zxf node-v4.3.0-linux-x64.tar.gz
#cd node-v4.3.0-linux-x64

#./configure \
#--prefix=$OPENSHIFT_RUNTIME_DIR/srv/nodejs/

#make && make install
wget https://nodejs.org/dist/v5.6.0/node-v5.6.0-linux-x64.tar.xz
unxz node-v5.6.0-linux-x64.tar.xz
tar -xf node-v5.6.0-linux-x64.tar

mv node-v5.6.0-linux-x64 $OPENSHIFT_RUNTIME_DIR/srv/
mv $OPENSHIFT_RUNTIME_DIR/srv/node-v5.6.0-linux-x64 $OPENSHIFT_RUNTIME_DIR/srv/node

# CLEANUP
rm -r $OPENSHIFT_RUNTIME_DIR/tmp/*.tar
rm -r $OPENSHIFT_RUNTIME_DIR/tmp/*.xz


# COPY TEMPLATES
cp $OPENSHIFT_REPO_DIR/misc/templates/bash_profile.tpl $OPENSHIFT_HOMEDIR/app-root/data/.bash_profile
cp $OPENSHIFT_REPO_DIR/misc/templates/php.ini.tpl $OPENSHIFT_RUNTIME_DIR/srv/php/etc/apache2/php.ini

# START APACHE
$OPENSHIFT_RUNTIME_DIR/srv/httpd/bin/apachectl start
