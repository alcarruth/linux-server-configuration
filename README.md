# Udacity FSND Project 5 LinuxServer Configuration

## Secure Shell Access for `grader`

You'll be able to login to the server as follows:

`$ ssh -p 2200 -i grader-key.pem grader@34.200.104.130`

where `grader-key.pem` is the key file provided during project submission.
Also, in order to sudo you'll need a password and I'll provide this as well.

 - host: ec2-34-200-104-130.compute-1.amazonaws.com
 - ip_addr: 34.200.104.130
 - ssh port: 2200

## Accessing the Web Application(s)

This project includes two WSGI apps and an index.html "landing page" which
contains links to each of the WSGI apps.

 - [Tickets-R-Us](https://github.com/alcarruth/fullstack-p3-item-catalog)
   is the FSND item catalog app.
 - [Random Name Generator](https://github.com/alcarruth/random-names)
   is a toy program to demonstrate second WSGI capability.

The landing page can be accessed via either of these two urls:

 - [http://ec2-34-200-104-130.compute-1.amazonaws.com](
   http://ec2-34-200-104-130.compute-1.amazonaws.com)
 - [http://34.200.104.130](http://34.200.104.130)

There is a redirect in the apache2 configuration that redirects a
request using the IP address to the FQDN because the oauth servers are
configured to serve requests from pages at the FQDN and will fail
otherwise. Plus it just looks better in the browser's location bar.


## Installed Packages

A number of packages were installed to support this project. In the
`bin/` directory there is a bash script called
[`utility_functions.sh`](https://github.com/alcarruth/fullstack-p5-linux-server-configuration/blob/submit/bin/utility_functions.sh)
which contains a function called `install_apps()` which automates this
(so the next time I lock myself out by changing the sshd port and have
to start over it'll be easier :-)

The following packages were installed using `apt-get install`:
 - `Apache 2.4.7 (Ubuntu)`
 - `apache2-utils`
 - `libapache2-mod-wsgi`
 - `git version 1.9.1`
 - `PostgreSQL 9.3.15`
 - `GNU Emacs 24.3.1`
 - `emacs-goodies-el`
 - `finger`
 - `python-requests`
 - `python-psycopg2`
 - `python-pip 1.5.4`

The following packages were installed using `pip install`:
 - `dict2xml (1.4)`
 - `Flask (0.12)`
 - `Flask-SeaSurf (0.2.2)`
 - `oauth2client (4.0.0)`
 - `prettytable (0.7.2)`
 - `psycopg2 (2.4.5)`
 - `SQLAlchemy (1.1.5)`
 - `Werkzeug (0.11.15)`


## Configuration Summary

Also in the `bin/` directory there is a bash script called
[`test_config.sh`](https://github.com/alcarruth/fullstack-p5-linux-server-configuration/blob/submit/bin/test_config.sh)
which checks requirements for the project. This script checks a number of configuration settings and outputs a summary in markdown format.  I found the script useful to check my progress. 
You can execute the script yourself from the command line.

View recent copy of the output here: 
[`test_config_out.md`](https://github.com/alcarruth/fullstack-p5-linux-server-configuration/blob/submit/test_config_out.md).


## Users

```
grader:x:1000:1000:udacity grader,,,:/home/grader:/bin/bash
carruth:x:1001:1001:Al Carruth,,,:/home/carruth:/bin/bash
postgres:x:106:112:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash
catalog:x:1002:1002:catalog,,,:/home/catalog:/usr/sbin/nologin
```

## Security

### /etc/sudoers:
```
   #includedir /etc/sudoers.d
```
### /etc/sudoers.d:
```
   carruth ALL=(ALL:ALL) ALL
   grader ALL=(ALL:ALL) ALL
```

### /etc/ssh/sshd_config:
```
   Port 2200
   PermitRootLogin no
   RSAAuthentication yes
   AllowUsers carruth grader
```

### ufw status:
```
   Status: active
   To                         Action      From
   2200/tcp                   ALLOW       Anywhere
   80/tcp                     ALLOW       Anywhere
   123                        ALLOW       Anywhere
   80                         ALLOW       Anywhere
   2200/tcp (v6)              ALLOW       Anywhere (v6)
   80/tcp (v6)                ALLOW       Anywhere (v6)
   123 (v6)                   ALLOW       Anywhere (v6)
   80 (v6)                    ALLOW       Anywhere (v6)
```

### TODO: Do users have good/secure passwords? 


## Public IP Address and Hostname

### get_public_host(): 
```
   ec2-52-33-68-114.us-west-2.compute.amazonaws.com
```

### /etc/hostname: 
```
   ec2-52-33-68-114.us-west-2.compute.amazonaws.com
```

### ${HOSTNAME}: 
```
   ec2-52-33-68-114.us-west-2.compute.amazonaws.com
```

### Apache2 Server Name: 
```
   ec2-52-33-68-114.us-west-2.compute.amazonaws.com
```

## PostgreSQL Configuration

### /etc/postgresql/9.3/main//pg_hba.conf:
```
   local   all             postgres                                peer
   local   all             all                                     peer map=ticket-app
   host    all             all             127.0.0.1/32            md5
   host    all             all             ::1/128                 md5
```

### /etc/postgresql/9.3/main//pg_ident.conf:
```
   ticket-app      catalog                 catalog
   ticket-app      carruth                 carruth
```

### sudo -u catalog psql tickets -c '\dp'
```
                                         Access privileges
    Schema |        Name        |   Type   |    Access privileges    | Column access privileges 
   --------+--------------------+----------+-------------------------+--------------------------
    public | conference         | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=rDxt/carruth    | 
    public | game               | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=rDxt/carruth    | 
    public | game_id_seq        | sequence | carruth=rwU/carruth    +| 
           |                    |          | catalog=rU/carruth      | 
    public | team               | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=rDxt/carruth    | 
    public | team_id_seq        | sequence | carruth=rwU/carruth    +| 
           |                    |          | catalog=rU/carruth      | 
    public | ticket             | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=arwdDxt/carruth | 
    public | ticket_id_seq      | sequence | carruth=rwU/carruth    +| 
           |                    |          | catalog=rwU/carruth     | 
    public | ticket_lot         | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=arwdDxt/carruth | 
    public | ticket_lot_id_seq  | sequence | carruth=rwU/carruth    +| 
           |                    |          | catalog=rwU/carruth     | 
    public | ticket_user        | table    | carruth=arwdDxt/carruth+| 
           |                    |          | catalog=arwdDxt/carruth | 
    public | ticket_user_id_seq | sequence | carruth=rwU/carruth    +| 
           |                    |          | catalog=rwU/carruth     | 
   (11 rows)
```

### sudo -u catalog psql tickets -c "select * from conference;"
```
     abbrev_name  |             name             |               logo               
   ---------------+------------------------------+----------------------------------
    ACC           | Atlantic Coast Conference    | Atlantic_Coast_Conference.png
    Big_12        | Big 12 Conference            | Big_12_Conference.png
    Big_Ten       | Big Ten Conference           | Big_Ten_Conference.png
    Pac-12        | Pacific 12 Conference        | Pacific_12_Conference.png
    SEC           | Southeastern Conference      | Southeastern_Conference.png
    C-USA         | Conference USA               | Conference_USA.png
    MAC           | Mid-American Conference      | Mid-American_Conference.png
    American      | American Athletic Conference | American_Athletic_Conference.png
    Mountain_West | Mountain West Conference     | Mountain_West_Conference.png
    Sun_Belt      | Sun Belt Conference          | Sun_Belt_Conference.png
   (10 rows)

```

## Apache2 Configuration

### symlinks in /etc/apache2/sites-enabled
```
   000-udacity-project.conf -> ../sites-available/000-udacity-project.conf
```

### /etc/apache2/sites-available/000-udacity-project.conf
```
   <If "%{HTTP_HOST} != 'ec2-52-33-68-114.us-west-2.compute.amazonaws.com'">
       Redirect "/" "http://ec2-52-33-68-114.us-west-2.compute.amazonaws.com/"
   </If>
   <VirtualHost *:80>
       ServerName ec2-52-33-68-114.us-west-2.compute.amazonaws.com
       ServerAdmin webmaster@localhost
       DocumentRoot /var/www/html
       LogLevel info
       ErrorLog ${APACHE_LOG_DIR}/error.log
       CustomLog ${APACHE_LOG_DIR}/access.log combined
       #### Tickets'R'Us app
       Include /etc/apache2/sites-available/tickets-r-us.conf
       #### Random Name app
       Include /etc/apache2/sites-available/random-names.conf
   </VirtualHost>
```

### /etc/apache2/sites-available/random-names.conf
```
      WSGIDaemonProcess random-names user=catalog group=catalog threads=1
      WSGIScriptAlias /random-names /var/www/html/random-names/app.wsgi
      Alias /random-names/static /var/www/html/random-names/static
      <Location /random-names>
          ExpiresActive On
          ExpiresByType image/gif A2592000
          ExpiresByType image/jpeg A2592000
          ExpiresByType image/png A2592000
      </Location>
      <Directory /var/www/html/random-names>
          Options -Indexes
          WSGIProcessGroup random-names
          WSGIApplicationGroup %{GLOBAL}
          Order allow,deny
          Allow from all
      </Directory>
```

### /etc/apache2/sites-available/tickets-r-us.conf
```
       WSGIDaemonProcess tickets user=carruth group=carruth threads=1
       WSGIScriptAlias /tickets /var/www/html/tickets/tickets.wsgi
       Alias /tickets/static /var/www/html/tickets/static
       <Location /tickets>
           ExpiresActive On
           ExpiresByType image/gif A2592000
           ExpiresByType image/jpeg A2592000
           ExpiresByType image/png A2592000
       </Location>
       <Directory /var/www/html/tickets>
           WSGIProcessGroup tickets
           WSGIApplicationGroup %{GLOBAL}
           Order allow,deny
           Allow from all
       </Directory>
```


