#!/bin/sh

#
# Creating supervisor file
###########################
create_supervisor_conf() {
  rm -rf /etc/supervisord.conf
  cat > /etc/supervisord.conf <<EOF
[unix_http_server]
file=/var/run/supervisor.sock   ; 
chmod=0700                       ; 

[supervisord]
logfile=/var/log/supervisord.log ; 
pidfile=/var/run/supervisord.pid ; 
childlogdir=/var/log/           ; 

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; 

[program:nginx]
command=/usr/sbin/nginx
autorestart=true
autostart=true

[program:gunicorn]
command=gunicorn app:app --bind 0.0.0.0:8000 --workers 3
directory=/DATA/www/
autostart=true
autorestart=true
user=nginx

numprocs=1
EOF
}

# WWW & LOGS 
#
# ################

create_www_dir() {
  # Create LOG directoties for NGINX
  echo "Creating www log directory"
  mkdir -p /DATA/logs

}

apply_www_permissions(){
  echo "Applying www permissions"
  chown -R nginx:nginx /DATA/www /DATA/logs

}


# PIP install 
#
##############

pip_install(){
  echo 'Creating temporary file with pip requirements in one line with spaces'
  cat > /DATA/www/temp.txt <<EOF
${PIP_PACKAGES}
EOF
  echo 'Using sed to turn white space into new lines'
  sed 's/\s\+/\n/g' /DATA/www/temp.txt > /DATA/www/requirements.txt && rm /DATA/www/temp.txt
  echo 'Pip install requirements.txt' 
  pip3 install --no-cache-dir -r /DATA/www/requirements.txt 
}


# DJANGO INSTALL  
#
# ################

flask_install(){
  
}


# Running all our scripts
create_www_dir
apply_www_permissions
pip_install
flask_install
create_supervisor_conf




# Start Supervisor 
echo "Starting Supervisor"
/usr/bin/supervisord -n -c /etc/supervisord.conf
