##Run simple_html example on Apache with FCGI on Windows.



####Prerequisites

* This tutorial was written for people working under Windows environment, and using Apache Server with FCGI connector
* Compile the ewf application from command line.
* Assuming you have installed Apache Server under C:/home/server/Apache24.
* Assuming you have placed your current project under C:/home/server/Apache24/fcgi-bin.
* Assuming you have setted the Listen to 8888, the defautl value is 80 .



####FCGI module
If you don't have the FCGI module installed, you can get it from https://www.apachelounge.com/download/, download the   module based on your platform [modules-2.4-win64-VC11.zip](https://www.apachelounge.com/download/VC11/modules/modules-2.4-win64-VC11.zip) or [modules-2.4-win32-VC11.zip](https://www.apachelounge.com/download/VC11/modules/modules-2.4-win32-VC11.zip), uncompress it
and copy the _mod_fcgid.so_ to C:/home/server/Apache24/modules

####Compile the project simple_html using the fcgi connector.

	ec -config simple_html.ecf -target simple_html_fcgi -finalize -c_compile -project_path .

Copy the genereted exe to C:/home/server/Apache24/fcgi-bin folder.	

Check if you have _libfcgi.dll_ in your PATH.


####Apache configuration
Add to httpd.conf the content, you can get the configuration file [here](config.conf) 

```
LoadModule fcgid_module modules/mod_fcgid.so

<IfModule mod_fcgid.c>
  <Directory "C:/home/server/Apache24/fcgi-bin">
    SetHandler fcgid-script
    Options +ExecCGI +Includes +FollowSymLinks -Indexes
    AllowOverride All
    Require all granted
  </Directory>
  ScriptAlias /simple "C:/home/server/Apache24/fcgi-bin/simple_html.exe"
</IfModule>
```

Test if your httpd.conf is ok
>httpd -t

Luanch the server
>httpd

Check the application
>http://localhost:8888/simple
