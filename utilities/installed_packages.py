#!/usr/bin/python -i
# -*- coding: utf-8 -*-

import readline
import rlcompleter
readline.parse_and_bind("tab: complete")

# installed by pip install
import dict2xml
import sqlalchemy
import flask
import flask_seasurf
import werkzeug
import oauth2client
import psycopg2

print 'sqlalchemy: %s' % sqlalchemy.__version__
print 'flask: %s' % flask.__version__
print 'flask_seasurf: %s' % flask_seasurf.__version__
print 'werkzeug: %s' % werkzeug.__version__
print 'oauth2client: %s' % oauth2client.__version__
print 'psycopg2: %s' % psycopg2.__version__
print 'dict2xml: %s' % '?'
