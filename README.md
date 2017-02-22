# Udacity FSND Project 5 LinuxServer Configuration

## Secure Shell Access for `grader`

You'll be able to login to the server as follows:

`$ ssh -p 2200 -i grader-key.pem grader@34.200.104.130`

where `grader-key.pem` is the key file provided during project submission.
Also, in order to sudo you'll need a password and I'll provide this as well.

 - host: ec2-34-200-104-130.compute-1.amazonaws.com
 - ip_addr: 34.200.104.130
 - ssh port: 2200

## Accessing the Web Applications Site

This project includes two WSGI apps and an index.html "landing page" which
contains links to each of the WSGI apps.

 - [Tickets-R-Us](https://github.com/alcarruth/fullstack-p3-item-catalog)
   is the FSND item catalog app
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

## Web Applications Installation Note

The github repositories for this project and the two WSGI apps were cloned
into the `/opt/git/` directory.  Symbolic links were then made in the 
`/var/www/html/tickets/` and `/var/www/html/random-names/` directories.

The tickets app (item catalog) required some tweaking for this project.  In particular,
the `reset_db.sh` script now drops the `carruth` and `catalog` users and recreates
them.  Then nessary access is granted to `catalog` so that the wsgi app process, which 
is owned by `catalog`, can perform its functions appropriately.  The user permissions
are summarized in the Configuration Summary section below.

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

The rest of this README section is a copy of the output from `test_config.sh`.



### User

```
   carruth:x:1001:1001:Al Carruth,,,:/home/carruth:/bin/bash
   grader:x:1002:1002:Udacity Grader,,,:/home/grader:/bin/bash
   catalog:x:1003:1003:Catalog DB User,,,:/home/catalog:/bin/bash
```


### Security



#### /etc/sudoers:

```
   #includedir /etc/sudoers.d
```


#### /etc/sudoers.d:

```
   carruth ALL=(ALL:ALL) ALL
   grader ALL=(ALL:ALL) ALL
```




#### /etc/ssh/sshd_config:

```
   Port 2200
   PermitRootLogin no
   RSAAuthentication yes
   AllowUsers carruth grader
```


#### ufw status:

```
   Status: active
   To                         Action      From
   123                        ALLOW       Anywhere                  
   80                         ALLOW       Anywhere                  
   2200/tcp                   ALLOW       Anywhere                  
   123 (v6)                   ALLOW       Anywhere (v6)             
   80 (v6)                    ALLOW       Anywhere (v6)             
   2200/tcp (v6)              ALLOW       Anywhere (v6)             
```




### Application Update Status

```
# apt update && apt list --upgradable
```
```
Hit:1 http://us-east-1.ec2.archive.ubuntu.com/ubuntu xenial InRelease
Get:2 http://us-east-1.ec2.archive.ubuntu.com/ubuntu xenial-updates InRelease [102 kB]
Get:3 http://us-east-1.ec2.archive.ubuntu.com/ubuntu xenial-backports InRelease [102 kB]
Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
Fetched 204 kB in 0s (858 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.
Listing...
```




### Public IP and Hostname

```
   /etc/hostname: 
   ec2-34-200-104-130.compute-1.amazonaws.com

   HOSTNAME: 
   ec2-34-200-104-130.compute-1.amazonaws.com

   get_public_host(): 
   ec2-34-200-104-130.compute-1.amazonaws.com

   apache2 ServerName: 
   ec2-34-200-104-130.compute-1.amazonaws.com

```


### PostgreSQL Configuration



#### /etc/postgresql/9.5/main/pg_hba.conf:

```
   local   all             postgres                                peer
   local   all             all                                     peer map=ticket-app
   host    all             all             127.0.0.1/32            md5
   host    all             all             ::1/128                 md5
```




#### /etc/postgresql/9.5/main/pg_ident.conf:

```
   ticket-app      carruth                 carruth
   ticket-app      catalog                 catalog
```




#### sudo -u catalog psql tickets -c '\dp'

```
                                           Access privileges
    Schema |        Name        |   Type   |    Access privileges    | Column privileges | Policies 
   --------+--------------------+----------+-------------------------+-------------------+----------
    public | conference         | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=r/carruth       |                   | 
    public | game               | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=r/carruth       |                   | 
    public | game_id_seq        | sequence | carruth=rwU/carruth    +|                   | 
           |                    |          | catalog=r/carruth       |                   | 
    public | team               | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=rw/carruth      |                   | 
    public | team_id_seq        | sequence | carruth=rwU/carruth    +|                   | 
           |                    |          | catalog=rw/carruth      |                   | 
    public | ticket             | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=arwd/carruth    |                   | 
    public | ticket_id_seq      | sequence | carruth=rwU/carruth    +|                   | 
           |                    |          | catalog=rw/carruth      |                   | 
    public | ticket_lot         | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=arwd/carruth    |                   | 
    public | ticket_lot_id_seq  | sequence | carruth=rwU/carruth    +|                   | 
           |                    |          | catalog=rw/carruth      |                   | 
    public | ticket_user        | table    | carruth=arwdDxt/carruth+|                   | 
           |                    |          | catalog=arwd/carruth    |                   | 
    public | ticket_user_id_seq | sequence | carruth=rwU/carruth    +|                   | 
           |                    |          | catalog=rw/carruth      |                   | 
   (11 rows)

```


#### sudo -u catalog psql tickets -c "select * from conference;"

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


### Apache2 Configuration



#### symlinks in /etc/apache2/sites-enabled

```

   -> ../sites-available/000-udacity-project.conf
```


#### /etc/apache2/sites-available/000-udacity-project.conf


```
   <If "%{HTTP_HOST} != 'ec2-34-200-104-130.compute-1.amazonaws.com'">
       Redirect "/" "http://ec2-34-200-104-130.compute-1.amazonaws.com/"
   </If>
   <VirtualHost *:80>
       ServerName ec2-34-200-104-130.compute-1.amazonaws.com
       ServerAdmin webmaster@localhost
       DocumentRoot /var/www/html
       LogLevel info
       ErrorLog ${APACHE_LOG_DIR}/error.log
       CustomLog ${APACHE_LOG_DIR}/access.log combined
       # Tickets'R'Us app
       Include /etc/apache2/sites-available/tickets-r-us.conf
       # Random Name app
       Include /etc/apache2/sites-available/random-names.conf
   </VirtualHost>
```




#### /etc/apache2/sites-available/random-names.conf


```
      WSGIDaemonProcess random-names user=carruth group=carruth threads=1
      WSGIScriptAlias /random-names /var/www/html/random-names/app.wsgi
      Alias /random-names/ /var/www/html/random-names/static/
      <Location /random-names/>
          ExpiresActive On
          ExpiresByType image/gif A2592000
          ExpiresByType image/jpeg A2592000
          ExpiresByType image/png A2592000
      </Location>
      <Directory /var/www/html/random-names/static>
          WSGIProcessGroup random-names
          WSGIApplicationGroup %{GLOBAL}
          Order allow,deny
          Allow from all
      </Directory>
```




#### /etc/apache2/sites-available/tickets-r-us.conf


```
       WSGIDaemonProcess tickets user=catalog group=catalog threads=1
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


## License

   Copyright 2017 Al Carruth

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0
     
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
