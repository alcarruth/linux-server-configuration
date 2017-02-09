#!/bin/bash

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
