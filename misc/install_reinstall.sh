#!/bin/sh

#OPENSHIFT_RUNTIME_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime
#OPENSHIFT_REPO_DIR=$OPENSHIFT_HOMEDIR/app-root/runtime/repo
OPENSHIFT_RUNTIME_DIR=/opt/app-root/runtime
OPENSHIFT_REPO_DIR=/opt/app-root/runtime/repo

cd $OPENSHIFT_RUNTIME_DIR

# Se eliminna todos los directorios creados por el script
rm -rf srv/pcre
rm -rf srv/httpd
rm -rf srv/php
rm -rf srv
rm -rf tmp

# TODO: Agregar directorios de node.js y socket.io

