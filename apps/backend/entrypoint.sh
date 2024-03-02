#!/bin/bash

APP_PORT=${PORT:-8000}

ech "Waiting for postgres.." 
sleep 5 
echo "Postgres started" 

echo "Migrating database..." 
/opt/venv/bin/python manage.py makemigrations --noinput
/opt/venv/bin/python manage.py migrate --noinput
echo "Database migrated" 

echo "creating superuser..." 
/opt/venv/bin/python manage.py superuser --noinput 
echo "Superuser created" 

echo "Collecting static files..." 
/opt/venv/bin/python manage.py collectstatic --noinput
echo "Static files collected" 

echo "Starting server..." 
/opt/venv/bin/gunicorn backend.wsgi:application --bind "0.0.0.0:${APP_PORT}" -workers 4