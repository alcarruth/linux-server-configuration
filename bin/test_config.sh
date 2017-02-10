#!/bin/bash

. ./global_settings



#-------------------------------------------------------------------------------------------------#
# Utility Functions
#-------------------


function todo() {
    printf "\n\n ******* TODO: ${1} *******\n\n"
}


function section() {
    printf "\n\n\n#--------------------------------------------------------------------------------------"
    printf "\n# ${1}\n\n"
}


function indent() {
    sed "s/\(^.\)/${1}\1/"
}


function print_config() {
    sudo sh -c "${1} ${2}" | grep -v '^#' | grep --color=never [a-z] | indent "${3}"
    printf "\n\n"
}


function heading() {
    printf "\n\n\n# ${1}\n\n"
}


function psql_command() {
    sudo -u ${1} psql tickets -c "${2}"  | indent "${3}"
}

#-------------------------------------------------------------------------------------------------#
# User Management
# ----------------

# Are users prompted for their password at least once when using sudo commands?
function test_sudoers() {

    section 'Super User Access';
    heading "/etc/sudoers:"
    sudo grep includedir /etc/sudoers | indent '   '
    # hat tip:
    # http://unix.stackexchange.com/questions/227070/why-does-a-z-match-lowercase-letters-in-bash
    LC_COLLATE=C;
    heading "/etc/sudoers.d:"
    print_config 'cat' "/etc/sudoers.d/[a-z]*" '   '
}

#-------------------------------------------------------------------------------------------------#
# Secure Shell
#--------------

function test_sshd() {

    section "Secure Shell";
    heading '/etc/ssh/sshd_config:'
    sudo grep --color=never '^Port' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^PermitRootLogin' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^RSAAuthentication' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^AllowUsers' /etc/ssh/sshd_config | indent '   ';

    # Do users have good/secure passwords?
    todo "Do users have good/secure passwords?"
}


#-------------------------------------------------------------------------------------------------#
# Security
# ---------

# Is the firewall configured to only allow for 
# SSH (port 2200), HTTP (port 80) and NTP (port 123)?

function test_ufw_status() {

    section 'Firewall'
    heading 'ufw status:'
    print_config ufw status '   ';
}

#-------------------------------------------------------------------------------------------------#
# Applications up-to-date?
#--------------------------

function test_applications_up_to_date() {
    section 'Applications up-to-date?'
    heading 'apt-get upgrade'
    sudo apt-get update > /dev/null;
    print_config apt-get upgrade '   ';
}

#-------------------------------------------------------------------------------------------------#
# Is the hostname properly configured?
#--------------------------------------

function get_apache2_host() {
    cat ${APACHE2_CONF} | grep --color=never ServerName | sed s/.*ServerName\ *//
}

function test_hostname() {

    section "testing public ip and hostname"

    printf "/etc/hostname: \n$(cat /etc/hostname)\n\n" | indent '   ';
    printf "HOSTNAME: \n${HOSTNAME}\n\n" | indent '   ';
    printf "get_public_host(): \n$(./get_public_host)\n\n" | indent '   ';
    printf "apache2 ServerName: \n$(get_apache2_host)\n\n" | indent '   ';
}

#-------------------------------------------------------------------------------------------------#
# PostgreSQL Functionality
# --------------------------

function test_postgresql_config() {

    section "PostgreSQL Configuration"

    heading "${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF}:"
    #sudo sh -c "cat ${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF}" | grep -v '^#' | grep --color=never [a-z]
    print_config cat "${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF}" '   '

    heading "${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF}:"
    #sudo sh -c "cat ${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF}" | grep -v '^#' | grep --color=never [a-z]
    print_config cat "${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF}" '   '

    heading "sudo -u catalog psql tickets -c '\dp'"
    psql_command catalog '\dp' '   ';

    heading 'sudo -u catalog psql tickets -c "select * from conference;"'
    psql_command catalog 'select * from conference;' '   ';
    printf "\n\n"
}


#-------------------------------------------------------------------------------------------------#
# Apache2 
# --------

# Has the web-server been configured to serve the Item Catalog
# application?

function test_apache2_wsgi() {

    section "Apache2 Configuration"

    heading "symlinks in ${APACHE2_CONF_DIR}"
    ls -l ${APACHE2_CONF_DIR} | cut -d ' ' --fields='10 11 12' | indent '   '
    printf "\n"

    heading "${APACHE2_CONF}\n"
    print_config cat ${APACHE2_CONF} '   '

    heading "${RANDOM_NAMES_WSGI_CONF}\n"
    print_config cat ${RANDOM_NAMES_WSGI_CONF} '  '

    heading "${TICKETS_WSGI_CONF}\n" 
    print_config cat ${TICKETS_WSGI_CONF} '   '
}

#-------------------------------------------------------------------------------------------------#

function test_all() {
    test_sudoers;
    test_sshd;
    test_ufw_status;
    #test_applications_up_to_date;
    test_hostname;
    test_postgresql_config;
    test_apache2_wsgi;
}

export test_sudoers;
export test_root_login;
export test_ufw_status;
export test_applications_up_to_date;
export test_sshd_port;
export test_hostname;
export test_postgresql_config;
export test_apache2_tickets_wsgi;

export test_all;

test_all;
#test_apache2_wsgi;
