#!/bin/bash

# regex for the IP address validity
n='([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])'
m='([0-9]|[12][0-9]|3[012])'

printf "Please define the IP address or network from which you are going to stream the HLS content followed by / and the network mask. For example 192.168.178.0/24 will allow all IPs from this network, while 192.168.178.100/32 will allow only this particular IP. You can also leave it empty and only access from the private IP networks will be allowed.\n\n"

# While loop until the user input is a valid IP adress or empty.
while true
do
    IFS= read -rp "IP Address(/Mask): " ipaddr
    if [[ -z "$ipaddr" ]] || [[ $ipaddr =~ ^$n(\.$n){3}/$m$ ]] || [[ $ipaddr =~ ^$n(\.$n){3}$ ]]; then
        break
    else
        printf "\nPlease enter a valid IP address!\n\n"
    fi
done

function nginx_install {
    # Updates and install the full NGINX server
    echo "System update"
    sudo apt update 1> /dev/null
    sudo apt upgrade -y 1> /dev/null
    sudo apt dist-upgrade -y 1> /dev/null
    sudo apt autoremove -y 1> /dev/null
    echo "NGINX Installation with dav_ext_methods support"
    sudo apt install nginx-full -y 1> /dev/null
}

function dir_creation {
    echo "Destination directory creation"
    # You can change here the destination directory. In this script all the chunks and manifest files will be stored in /var/www/html/vod directory.
    sudo mkdir /var/www/html/vod/upload
    sudo mkdir /var/www/html/vod/tmp
    sudo mkdir /var/www/html/live/upload
    sudo mkdir /var/www/html/live/tmp
    sudo mkdir /var/log/nginx/origin_server
    sudo chown -R www-data:www-data /var/www/html/vod /var/www/html/live
    
    # Checks if /var/www/html/index.nginx-debian.html exists and if it does, it deletes it.
    if [ -f /var/www/html/index.nginx-debian.html ];
    then
        sudo rm /var/www/html/index.nginx-debian.html
    fi
}

function autodelete {
    # Most of the packagers nowadays have such a built-in function so this is an optional step
    echo "Creation of auto-delete script and putting it in the crontab"

    # This script will add a line in the crontab for deletion of files older than 1 minute in the /var/www/html/live directory. 

    sh scripts/crontab.sh
}

function nginx_configuration {
    echo "Change of the NGINX configuration"

    # Here you can change the client_max_body_size to a custom value, it is set to 50Mb, so files larger than 50Mb won't be accepted.
    sudo sed -i '14i\\tclient_max_body_size 50m;' /etc/nginx/nginx.conf
    
    # Make sure to change the allowed IP address to the network / address which will push the cunks. Please refer to the wiki if you need any further information.
    if [ ! -z "$ipaddr" ];
    then
        sed -i "22 a \ \ \ \ \ \ \ \ \ \ \ \ allow $ipaddr;" scripts/origin_server 
        sed -i "42 a \ \ \ \ \ \ \ \ \ \ \ \ allow $ipaddr;" scripts/origin_server 
    fi  
    sudo cp scripts/origin_server /etc/nginx/sites-available
    sudo ln -s /etc/nginx/sites-available/origin_server /etc/nginx/sites-enabled/origin_server

    # Checks if the nginx configuration is correct
    if sudo nginx -t &> /dev/null
        then
        echo "NGINX will be restarted"
        sudo service nginx restart
        echo "The installation of Origin Server finished successfully"
    else
        printf "\nThe NGINX configuration file check failed with the following error:\n\n"
        sudo nginx -t
        echo
    fi
}

# Execution of the main program
nginx_install
dir_creation
autodelete
nginx_configuration
