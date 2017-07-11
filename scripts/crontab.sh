#!/bin/bash

crontab -l $USERNAME | echo "* * * * * sudo find /var/www/html/live/ -name '*.ts' -mmin +1 -exec rm -f {} \;" | crontab -

sudo service cron reload
