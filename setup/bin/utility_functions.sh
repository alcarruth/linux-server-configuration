#!/bin/bash
# utility functions

. ./global_settings

function add_users() {
    adduser --disabled-password $GRADER
    adduser --disabled-password $DB_OWNER
    adduser --no-create-home --disabled-login $DB_USER

    mkdir /home/$STUDENT/.ssh
    mkdir /home/$GRADER/.ssh

    echo $UDACITY_KEY >> /home/$STUDENT/.ssh/authorized_keys
    echo $UDACITY_KEY >> /home/$GRADER/.ssh/authorized_keys

    echo "$GRADER ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$GRADER
    echo "$STUDENT ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$STUDENT
}

function del_users() {
    deluser --quiet $GRADER
    deluser --quiet $DB_OWNER
    deluser --quiet $DB_USER

    rm -R /home/$STUDENT
    rm -R /home/$GRADER

    rm /etc/sudoers.d/$GRADER
    rm /etc/sudoers.d/$STUDENT
}

function set_host_name() {
    public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
    public_host=$(host -t ptr $public_ip | sed 's/.*\ \(.*\)\./\1/')
    echo $public_host > /etc/hostname
    hostname $public_host
}

function ufw_pass1() {
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow $SSH_PORT/tcp
    ufw allow ntp
    ufw allow http
    ufw status
    ufw enable
}

function sshd_config() {
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
    sed -i "s/^Port/Port $SSH_PORT/" /etc/ssh/sshd_config
    sed -i "s/^PermitRootLogins/PermitRootLogins No/" /etc/ssh/sshd_config
    sed -i "s/^AllowUsers.*/AllowUsers $STUDENT $GRADER/" /etc/ssh/sshd_config
}

function ufw_pass2() {
    ufw delete allow ssh
    ufw allow $SSH_PORT/tcp
    ufw status
    ufw enable
}

function install_apps() {
    apt-get update
    apt-get upgrade

    apt-get install apache2
    apt-get install apache2-utils
    apt-get install libapache2-mod-wsgi
    apt-get install git
    apt-get install postgresql
    apt-get install emacs
    apt-get install emacs-goodies-el 
    apt-get install finger
    apt-get install python-pip

    pip install dict2xml
    pip install SQLAlchemy
    pip install Flask
    pip install flask-seasurf
    pip install Werkzeug
    pip install oauth2client
    pip install psycopg2
}

function clone_repositories() {
    mkdir -P /opt/git
    chown $STUDENT:$STUDENT /opt/git
    cd /opt/git
    sudo -u $STUDENT git clone https://github.com/alcarruth/fullstack-p3-item-catalog.git
    mv fullstack-p3-item-catalog tickets
    sudo -u $STUDENT git clone https://github.com/alcarruth/random-names.git
}

function config_postgresql() {
    PG_DIR='/etc/postgresql/9.3/main/'
    sed -i "s/\(^local\ *all\ *all\ *peer\).*/\1 map=$DB_PROJECT/g" $PG_DIR/pg_hba.conf
    printf "%-16s%-24s%s\n" $DB_PROJECT $DB_USER $DB_USER >> $PG_DIR/pg_ident.conf
    printf "%-16s%-24s%s\n" $DB_PROJECT $DB_OWNER $DB_OWNER >> $PG_DIR/pg_ident.conf
}

function config_apache2() {
    echo 'configure apache2'
    #rm /etc/apache2/sites-enabled/000-default.conf
    #mv /etc/apache2/sites-available/000-default /etc/apache2/sites-available/000-default.conf.orig
    
    HOST=$(hostname)
    DOCUMENT_ROOT="/var/www/html"
    cp udacity-project.conf 000-udacity-project.conf
    sed -i "s,__HOST__,${HOST},g" 000-udacity-project.conf
    sed -i "s,__DOCUMENT_ROOT__,${DOCUMENT_ROOT},g" 000-udacity-project.conf

    APP_NAME='tickets-r-us'
    APP_OWNER=${STUDENT}
    APP_GROUP=${STUDENT}
    cp include_app.conf ${APP_NAME}.conf
    sed -i "s,__APP_NAME__,${APP_NAME},g" ${APP_NAME}.conf
    sed -i "s,__APP_OWNER__,${APP_OWNER},g" ${APP_NAME}.conf
    sed -i "s,__DOCUMENT_ROOT__,${DOCUMENT_ROOT},g" ${APP_NAME}.conf

    APP_NAME='random-names'
    APP_OWNER=${STUDENT}
    APP_GROUP=${STUDENT}
    cp include_app.conf ${APP_NAME}.conf
    sed -i "s,__APP_NAME__,${APP_NAME},g" ${APP_NAME}.conf
    sed -i "s,__APP_OWNER__,${APP_OWNER},g" ${APP_NAME}.conf
    sed -i "s,__DOCUMENT_ROOT__,${DOCUMENT_ROOT},g" ${APP_NAME}.conf
}

function install_apps() {
    apt-get update
    apt-get upgrade

    apt-get install apache2
    apt-get install apache2-utils
    apt-get install libapache2-mod-wsgi
    apt-get install git
    apt-get install postgresql
    apt-get install emacs
    apt-get install emacs-goodies-el 
    apt-get install finger
    apt-get install python-pip
    
    pip install dict2xml
    pip install SQLAlchemy
    pip install Flask
    pip install flask-seasurf
    pip install Werkzeug
    pip install oauth2client
    pip install psycopg2
}

export add_user
export del_users
export set_host_name
export ufw_pass1
export sshd_config
export ufw_pass2
export install_apps
export clone_repositories
export config_postgresql
export config_apache2
export install_apps
   

#printf "\n\nNow log out and ssh back in\n\n"

