#!/bin/bash

. ./global_settings



#-------------------------------------------------------------------------------------------------#
# Utility Functions
#-------------------


function todo() {
    printf " ******* TODO: ${1} *******\n\n"
}


function section() {
    printf "\n\n### ${1}\n\n"
}


function heading() {
    printf "\n\n#### ${1}\n\n"
}


function indent() {
    sed "s/\(^.\)/${1}\1/"
}


function print_config() {
    printf '```\n'
    sudo sh -c "${1} ${2}" | grep -v '^#' | grep --color=never [a-z] | indent "${3}"
    printf '```\n'
    printf "\n\n"
}


function psql_command() {
    printf '```\n'
    sudo -u ${1} psql tickets -c "${2}"  | indent "${3}"
    printf '```\n'
}

#-------------------------------------------------------------------------------------------------#
# Users
#----------

function test_user_accounts() {
    section User Accounts
    printf '```\n'
    grep 'grader\|carruth\|catalog' /etc/passwd | indent '   '
    printf '```\n'
}

#-------------------------------------------------------------------------------------------------#
# Security
#----------

# Is the firewall configured to only allow for 
# SSH (port 2200), HTTP (port 80) and NTP (port 123)?

# Are users prompted for their password at least once when using sudo commands?
function test_sudoers() {
    heading "/etc/sudoers:"
    printf '```\n'
    sudo grep includedir /etc/sudoers | indent '   '
    printf '```\n'
    # hat tip:
    # http://unix.stackexchange.com/questions/227070/why-does-a-z-match-lowercase-letters-in-bash
    LC_COLLATE=C;
    heading "/etc/sudoers.d:"
    print_config 'cat' "/etc/sudoers.d/90-udacity-project-users" '   '
}

function test_sshd_config() {
    heading '/etc/ssh/sshd_config:'
    printf '```\n'
    sudo grep --color=never '^Port' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^PermitRootLogin' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^RSAAuthentication' /etc/ssh/sshd_config | indent '   ';
    sudo grep --color=never '^AllowUsers' /etc/ssh/sshd_config | indent '   ';
    printf '```\n'
}

function test_ufw_status() {
    heading 'ufw status:'
    print_config ufw status '   ';
}

function test_passwords() {
    # Do users have good/secure passwords?
    heading "TODO: Do users have good/secure passwords?"
}

function test_security() {
    section "Security"
    test_sudoers
    test_sshd_config
    test_ufw_status
    #test_passwords
}

#-------------------------------------------------------------------------------------------------#
# Applications up-to-date?
#--------------------------

function test_applications_up_to_date() {
    section 'Application Update Status'
    printf '```\n'
    printf '# apt update && apt list --upgradable\n'
    printf '```\n'
    print_config 'apt update 2>/dev/null && apt list --upgradable 2>/dev/null ' '   ';
}

#-------------------------------------------------------------------------------------------------#
# Is the hostname properly configured?
#--------------------------------------

function get_apache2_host() {
    cat ${APACHE2_CONF} | grep --color=never ServerName | sed s/.*ServerName\ *//
}

function test_hostname() {

    section "Public IP and Hostname"
    printf '```\n'
    printf "/etc/hostname: \n$(cat /etc/hostname)\n\n" | indent '   ';
    printf "HOSTNAME: \n${HOSTNAME}\n\n" | indent '   ';
    printf "get_public_host(): \n$(./get_public_host)\n\n" | indent '   ';
    printf "apache2 ServerName: \n$(get_apache2_host)\n\n" | indent '   ';
    printf '```\n'
}

#-------------------------------------------------------------------------------------------------#
# PostgreSQL Functionality
# --------------------------

function test_postgresql_config() {

    section "PostgreSQL Configuration"

    heading "${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF}:"
    print_config cat "${POSTGRESQL_CONF_DIR}/${PG_HBA_CONF}" '   ';

    heading "${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF}:"
    print_config cat "${POSTGRESQL_CONF_DIR}/${PG_IDENT_CONF}" '   ';

    heading "sudo -u catalog psql tickets -c '\dp'"
    psql_command catalog '\dp' '   ';

    heading 'sudo -u catalog psql tickets -c "select * from conference;"'
    psql_command catalog 'select * from conference;' '   ';
}


#-------------------------------------------------------------------------------------------------#
# Apache2 
# --------

# Has the web-server been configured to serve the Item Catalog
# application?

function test_apache2_wsgi() {

    section "Apache2 Configuration"

    heading "symlinks in ${APACHE2_CONF_DIR}"
    printf '```\n'
    ls -l ${APACHE2_CONF_DIR} | cut -d ' ' --fields='10 11 12' | indent '   '
    printf '```\n'

    heading "${APACHE2_CONF}\n"
    print_config cat ${APACHE2_CONF} '   '

    heading "${RANDOM_NAMES_WSGI_CONF}\n"
    print_config cat ${RANDOM_NAMES_WSGI_CONF} '  '

    heading "${TICKETS_WSGI_CONF}\n" 
    print_config cat ${TICKETS_WSGI_CONF} '   '
}

#-------------------------------------------------------------------------------------------------#

function test_all() {
    test_user_accounts;
    test_security;
    test_applications_up_to_date;
    test_hostname;
    test_postgresql_config;
    test_apache2_wsgi;
}

export test_user_accounts
export test_security
export test_sudoers
export test_sshd_config
export test_ufw_status
export test_passwords
export test_applications_up_to_date
export test_hostname
export test_postgresql_config
export test_apache2_tickets_wsgi

export test_all

test_all
