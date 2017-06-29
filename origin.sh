#!/bin/bash

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
sudo chown -R www-data:www-data /var/www/html/vod

echo "Change of the NGINX configuration"

# Here you can change the client_max_body_size to a custom value, it is set to 50Mb, so files larger than 50Mb won't be accepted.

sudo sed -i '14i\t#File upload size increased by origin.sh script\
	client_max_body_size 50m;' /etc/nginx/nginx.conf

# Make sure to change the allowed IP address to the network / address which will push the cunks. Please refer to the wiki if you need any further information.

sudo sed -i '49i\tlocation /vod { \
                dav_methods  PUT;\
                limit_except  GET HEAD {\
                        allow IP.AD.DR.ES/32;\
                        deny  all;\
                }\
        }' /etc/nginx/sites-available/default

echo "NGINX restart"

sudo service nginx restart

echo "The installation of Origin Server finished successfully"
