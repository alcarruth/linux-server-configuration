#!/bin/bash

function section() {
    printf "\n\n-----------------------------------------------------------------------------\n"
    printf "\n\$ ${1}\n\n"
}

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
test_sudoers;

# Is remote login of the root user disabled?
# Is a remote user given access?
function test_root_login() {
    section 'testing root login';
    grep ^PermitRootLogin /etc/ssh/sshd_config;
}
test_root_login;

#   Yes. see files in /etc/sudoers.d/ for users carruth and grader.
# - Do users have good/secure passwords?
#   ?
   
#Security
#---------

# Is the firewall configured to only allow for 
# SSH (port 2200), HTTP (port 80) and NTP (port 123)?
function test_ufw_status {
    section 'testing ufw status';
    ufw status;
}
test_ufw_status;

# - Are users required to authenticate using RSA keys?
#   Yes. see 'RSAAuthentication yes' line in /etc/ssh/sshd_config.
#   What about 'PubkeyAuthentication' ?
#   http://www.thegeekstuff.com/2011/05/openssh-options/
#   AllowUsers carruth grader

# Are the applications up-to-date?
function test_applications_up_to_date() {
    section 'test: applications_up_to_date()';
    apt-get upgrade;
}
test_applications_up_to_date;

# Is SSH hosted on non-default port?
function test_sshd_port() {
    section 'testing sshd port';
    grep Port /etc/ssh/sshd_config;
}
test_sshd_port;

function test_host_ip() {
    section test_host_ip;
    host $HOSTNAME
}
# Application Functionality
# --------------------------

# Has the database server been configured to properly serve data?
# Yes. postgresql, user 'catalog', pg_user 'catalog'
function test_postgresql_config() {
    section 'test: postgresql configuration';
    printf 'sudo -u catalog psql tickets -c "select * from conference;";\n\n'
    sudo -u catalog psql tickets -c "select * from conference;";
}
test_postgresql_config;

# Can the VM (AWS Server) be remotely logged into?
# Yes, users carruth and grader can log in remotely.

# Has the web-server been configured to serve the Item Catalog application?
# Yes. cat /etc/apache2/sites-enabled/000-default.conf 

# Web-server has been configured to serve the Item Catalog application as a wsgi app.
# Yes. cat /etc/apache2/sites-enabled/000-default.conf
function test_apache2_tickets_wsgi() {
    section 'apache2 configured to serve tickets app via wsgi';
    printf 'cat /etc/apache2/sites-enabled/000-default.conf;\n\n'
    cat /etc/apache2/sites-enabled/000-default.conf;
}
test_apache2_tickets_wsgi;

