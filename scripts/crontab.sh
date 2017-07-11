#!/bin/bash

crontab -l $USERNAME | echo "* * * * * find /var/www/html/live/*.ts -mmin +1 -exec sudo rm -f {} \;" | crontab -

sudo service cron reload
