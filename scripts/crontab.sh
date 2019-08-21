#!/bin/bash

# Scheduling a task to remove all the TS files from /var/www/html/live which are older than 1 minute.
crontab -l $USERNAME | echo "* * * * * sudo find /var/www/html/live/ -name '*.ts' -mmin +1 -exec rm -f {} \;" | crontab -

# Reloading the cron service.
sudo service cron reload
