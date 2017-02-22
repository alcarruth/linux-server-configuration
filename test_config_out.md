

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
   AllowUsers carruth grader ubuntu
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




### Applications up-to-date



```
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


