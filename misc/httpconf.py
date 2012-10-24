import os, re, shutil

internalIp = os.environ['OPENSHIFT_INTERNAL_IP']
runtimeDir = os.environ['OPENSHIFT_RUNTIME_DIR']
repoDir = os.environ['OPENSHIFT_REPO_DIR']

f = open(repoDir + 'misc/templates/httpd.conf.tpl', 'r')
conf = f.read().replace('{{OPENSHIFT_INTERNAL_IP}}', internalIp).replace('{{OPENSHIFT_REPO_DIR}}', repoDir)
f.close()

f = open(runtimeDir + '/srv/httpd/conf/httpd.conf', 'w')
f.write(conf)
f.close()