#!/bin/bash

echo "Please define the IP address or network from which you are going to stream the HLS content followed by / and the network mask. For example 192.168.178.0/24 will allow all IPs from this network, while 192.168.178.100/32 will allow only this particular IP and press [ENTER]:"

read ipadd

echo "System update"

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

echo "NGINX Installation"

sudo apt install nginx -y

echo "Destination directory creation"

# You can change here the destination directory. In this script all the chunks and manifest files will be stored in /var/www/html/vod directory.

sudo mkdir /var/www/html/vod
sudo mkdir /var/www/html/live
sudo chown -R www-data:www-data /var/www/html/vod /var/www/html/live

echo "Creation of auto-delete script and putting it in the crontab"

# This script will add a line in the crontab for deletion of files older than 1 minute in the /var/www/html/live directory. 

sh scripts/crontab.sh

echo "Change of the NGINX configuration"

# Here you can change the client_max_body_size to a custom value, it is set to 50Mb, so files larger than 50Mb won't be accepted.

sudo sed -i '14i\\t# File upload size increased by origin.sh script\
	client_max_body_size 50m;' /etc/nginx/nginx.conf

# Make sure to change the allowed IP address to the network / address which will push the cunks. Please refer to the wiki if you need any further information.

sudo sed -i '49i\\t# Custom block allowing HTTP PUT method only in /vod directory and only for the defined IP/network\
	\
	location /vod { \
                dav_methods  PUT;\
                limit_except  GET HEAD {\
                        allow '$ipadd';\
                        deny  all;\
                }\
        }\
	\
	location /live {\
		 dav_methods  PUT;\
                limit_except  GET HEAD {\
                        allow '$ipadd';\
                        deny  all;\
                }\
        }' /etc/nginx/sites-available/default

echo "NGINX restart"

sudo service nginx restart

echo "The installation of Origin Server finished successfully"
