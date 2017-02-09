#!/bin/bash

. ./global_settings

function section() {
    printf "\n-------------------------------------------------------------------------------------------------\n"
    printf "\n\$ ${1}\n\n"
}

#-------------------------------------------------------------------------------------------------#
# User Management
# ----------------

# Are users prompted for their password at least once when using sudo commands?
function test_sudoers() {
    section 'testing sudoers';
    grep includedir /etc/sudoers
    LC_COLLATE=C
    # hat tip:
    # http://unix.stackexchange.com/questions/227070/why-does-a-z-match-lowercase-letters-in-bash
    cat /etc/sudoers.d/[a-z]*;
}

#-------------------------------------------------------------------------------------------------#
# Is remote login of the root user disabled?
# Is a remote user given access?

function test_root_login() {
    section 'testing root login';
    grep ^PermitRootLogin /etc/ssh/sshd_config;
}

#   Yes. see files in /etc/sudoers.d/ for users carruth and grader.
# - Do users have good/secure passwords?
#   ?
   
#-------------------------------------------------------------------------------------------------#
# Security
# ---------

# Is the firewall configured to only allow for 
# SSH (port 2200), HTTP (port 80) and NTP (port 123)?

function test_ufw_status {
    section 'testing ufw status';
    ufw status;
}

# - Are users required to authenticate using RSA keys?
#   Yes. see 'RSAAuthentication yes' line in /etc/ssh/sshd_config.
#   What about 'PubkeyAuthentication' ?
#   http://www.thegeekstuff.com/2011/05/openssh-options/
#   AllowUsers carruth grader


#-------------------------------------------------------------------------------------------------#
# Are the applications up-to-date?

function test_applications_up_to_date() {
    section 'test: applications_up_to_date()';
    apt-get upgrade;
}

#-------------------------------------------------------------------------------------------------#
# Is SSH hosted on non-default port?

function test_sshd_port() {
    section 'testing sshd port';
    printf "grep Port /etc/ssh/sshd_config\n\n"
    sudo grep Port /etc/ssh/sshd_config;
    printf "\n\n"
}

function test_host_ip() {
    section "testing public ip and hostname"
    cat /etc/hostname
    echo ${HOSTNAME}
    public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)


    get_public_ip ;
    public_host=$(host -t ptr $public_ip | sed 's/.*\ \(.*\)\./\1/')

}

#-------------------------------------------------------------------------------------------------#
# Application Functionality
# --------------------------

# Has the database server been configured to properly serve data?
# Yes. postgresql, user 'catalog', pg_user 'catalog'

function test_postgresql_config() {

    POSTGRESQL_CONF_DIR="/etc/postgresql/9.3/main/"
    PG_HBA_CONF="pg_hba.conf"
    PG_IDENT_CONF="pg_ident.conf"

    section "POSTGRESQL_CONF_DIR: ${POSTGRESQL_CONF_DIR}"
    sudo ls ${POSTGRESQL_CONF_DIR}
    printf "\n\n"

    section "PG_HBA_CONF: ${PG_HBA_CONF}"
    sudo sh -c "cat ${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF} | grep -v '^#' | grep ^[a-z]"
    printf "\n\n"

    section "PG_HBA_CONF: ${PG_IDENT_CONF}"
    sudo sh -c "cat ${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF} | grep -v '^#' | grep ^[a-z]"
    printf "\n\n"

    section "Checking access privileges"
    printf "sudo -u catalog psql tickets -c '\dp'\n\n"
    sudo -u catalog psql tickets -c '\dp'
    printf "\n\n"

    section "Checking db and table access for user 'catalog'"
    printf '$ sudo -u catalog psql tickets -c "select * from conference;";\n\n'
    sudo -u catalog psql tickets -c "select * from conference;";
    printf "\n\n"
}

#-------------------------------------------------------------------------------------------------#
# Can the VM (AWS Server) be remotely logged into?
# Yes, users carruth and grader can log in remotely.

# Has the web-server been configured to serve the Item Catalog application?
# Yes. cat /etc/apache2/sites-enabled/000-default.conf 

# Web-server has been configured to serve the Item Catalog application as a wsgi app.
# Yes. cat /etc/apache2/sites-enabled/000-default.conf
function test_apache2_wsgi() {

    section "APACHE2_CONF_DIR: ${APACHE2_CONF_DIR}"
    ls -l ${APACHE2_CONF_DIR}
    printf "\n\n"

    section "APACHE2_CONF: ${APACHE2_CONF}"
    cat ${APACHE2_CONF}
    printf "\n\n"

    section "RANDOM_NAMES_WSGI_CONF: ${RANDOM_NAMES_WSGI_CONF}"
    cat ${RANDOM_NAMES_WSGI_CONF}
    printf "\n\n"

    section "TICKETS_WSGI_CONF: ${TICKETS_WSGI_CONF}" 
    cat ${TICKETS_WSGI_CONF}
    printf "\n\n"
}

#-------------------------------------------------------------------------------------------------#

function test_all() {
    #test_sudoers;
    #test_root_login;
    #test_ufw_status;
    #test_applications_up_to_date;
    #test_sshd_port;
    test_postgresql_config;
    test_apache2_wsgi;
}

export test_root_login;
export test_ufw_status;
export test_applications_up_to_date;
export test_sshd_port;
export test_postgresql_config;
export test_apache2_tickets_wsgi;
export test_all;

