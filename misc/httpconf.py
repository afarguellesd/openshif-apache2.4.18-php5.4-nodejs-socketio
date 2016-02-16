import os, re, shutil

internalIp = os.environ['OPENSHIFT_DIY_IP']
runtimeDir = os.environ['OPENSHIFT_HOMEDIR'] + "/app-root/runtime"
repoDir = os.environ['OPENSHIFT_HOMEDIR'] + "/app-root/runtime/repo"

f = open(repoDir + '/misc/templates/httpd.conf.tpl', 'r')
conf = f.read().replace('{{OPENSHIFT_DIY_IP}}', internalIp).replace('{{OPENSHIFT_REPO_DIR}}', repoDir).replace('{{OPENSHIFT_RUNTIME_DIR}}', runtimeDir)
f.close()

f = open(runtimeDir + '/srv/httpd/conf/httpd.conf', 'w')
f.write(conf)
f.close()
