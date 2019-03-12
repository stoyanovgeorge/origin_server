# A simple script how to create an origin server

### Description

This is a simple bash script how you can create an NGINX origin server where you can store HLS chunks and manifest files from a remote server using the HTTP PUT method. 

My test scenario is a server running ffmpeg creating the HLS chunks and the manifest file pushing the content to a remote web server running NGINX. The script installs automatically NGINX and do the required changes in the NGINX configuration files using the [SED](http://www.grymoire.com/Unix/Sed.html 'SED syntax') command. The name of the script is [origin.sh](https://github.com/stoyanovgeorge/origin_server/blob/master/origin.sh 'Origin Server Creation Script'), you just need to clone it and run it.

In general the first part of the script is checking if the user input is a valid IP address or netmask and if it is or if it is left empty, it is adapting the `scripts/origin_server` configuration file. The script is having 4 different functions:
1. `nginx-install` updating the target system and installing the full NGINX package
2. `dir-creation` - creates the specified in the `origin_server` configuration
3. `autodelete` - creates a crontab job every minute to check and delete in the defined directories files older than 1 minute.
4. `nginx_configuration` - which is inserting the specified user IP address or netmask in step #1, copying the `origin_server` configuration to `/etc/nginx/sites-available` and creating a symbolic link of this file in `/etc/nginx/sites-enabled`. It also increases the maximum upload limit to 50Mb and restarts the NGINX in case there aren't any errors in the configuration file, in order to apply the changes. 

Please note that step#3 `autodelete` is optional since most of the packagers are sending HTTP DELETE requests, to delete the old chunks and these requests are respected by the NGINX. 

### Origin_Server Configuration

It sets the location of the NGINX log files to `/var/log/nginx/origin_server` and defines the publish directory to `/var/www/html/live/upload` for live content, `/var/www/html/vod/upload` for VoD content and also the playback URL: `/live/public` for live and `/vod/public` for VoD content. 
Please note that `/live/public` is actually an alias of `/var/www/html/live/upload`, the same applies for `/vod/public` - alias to `/var/www/html/vod/upload` so `http://hostname/live/upload` should be used as a publish URL and `http://hostname/live/public/` as a playback URL. Similarly `http://hostname/vod/upload` is the publish URL and `http://hostname/vod/public` is the playback URL. 
The playback URLs are accepting GET requests from all the private networks and also from the initially defined by the user IP address or network. The publish URLs are accepting only PUT and DELETE HTTP requests. 

I have also created a WIKI page where I have explained in details the commands and how you can harden the access to the origin server. So make sure to check my [WIKI](https://github.com/stoyanovgeorge/origin_server/wiki 'Origin Server Wiki').

### Bugs and Missing Features

Please use [Github Issues](https://github.com/stoyanovgeorge/origin_server/issues 'Issues') in case you spot a bug or have an idea how to optimize the scripts.

### External Links

* [FFMPEG Generic Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide/Generic "FFMPEG Generic Compilation Guide")
* [FFMPEG Ubuntu Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu "FFMPEG Ubuntu Compilation Guide")
* [FFMPEG Syntax](https://ffmpeg.org/ffmpeg-all.html "FFMPEG Syntax")
* [SED Syntax](http://www.grymoire.com/Unix/Sed.html 'SED syntax')
* [NGINX Configuration and File Structure](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts 'NGINX Configuration Examples')
