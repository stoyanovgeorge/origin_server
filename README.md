# A simple script how to create an origin server

### Description

I have created a simple bash script how you can create an NGINX origin server where you can store HLS chunks and manifest files from a remote server using the HTTP PUT method. 

My test scenario is a server running ffmpeg creating the HLS chunks and the manifest file pushing the content to a remote web server running NGINX. The script installs automatically NGINX and do the required changes in the NGINX configuration files using the [SED](http://www.grymoire.com/Unix/Sed.html 'SED syntax') command. The name of the script is [origin.sh](https://github.com/stoyanovgeorge/origin_server/blob/master/origin.sh 'Origin Server Creation Script'), you just need to clone it and edit it in order to fit your use case. I have inserted comments where it needs eventually some change from your side. 

I have also created a WIKI page where I have explained in details the commands and how you can harden the access to the origin server. So make sure to check my [WIKI](https://github.com/stoyanovgeorge/origin_server/wiki 'Origin Server Wiki')

### Bugs and Missing Features

Please use [Github Issues](https://github.com/stoyanovgeorge/origin_server/issues 'Issues') in case you spot a bug or have an idea how to optimize the scripts.

### External Links

* [FFMPEG Generic Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide/Generic "FFMPEG Generic Compilation Guide")
* [FFMPEG Ubuntu Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu "FFMPEG Ubuntu Compilation Guide")
* [FFMPEG Syntax](https://ffmpeg.org/ffmpeg-all.html "FFMPEG Syntax")
* [SED Syntax](http://www.grymoire.com/Unix/Sed.html 'SED syntax')
* [NGINX Configuration and File Structure](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts 'NGINX Configuration Examples')
