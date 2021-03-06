Nav: [Workbook](../workbook.md)

EWF Deployment 
==============

# Apache on Windows#

1. Apache Install
2. Deploying EWF CGI
3. CGI overview
  1. Build EWF application
  2. Copy the generated exe file and the www content .htaccess CGI
4. Deploying EWF FCGI
5. FCGI overview
  1. Build EWF application
  2. Copy the generated exe file and the www content.htaccess CGI



## Apache on Windows

### Apache Install

>Check the correct version (Win 32 or Win64)
>Apache Version:  Apache 2.4.4 
>Windows: http://www.apachelounge.com/download/

note: on linux (debian), use 
> sudo apt-get install apache2

#### Deploying EWF CGI

#### CGI overview
>A new process is started for each HTTP request. So if there are N requests to the same 
>CGI program, the code of the CGI program is loaded into memory N times.
>When a CGI program finishes handling a request,  the program terminates.

* Build EWF application

```ec -config [app.ecf] -target [app_cgi] -finalize -c_compile -project_path```


>Note: change app.ecf and target app_cgi  based on your own configuration.

* Copy the generated exe file and the www content 

Copy the app.exe and the folder _www_  into a folder served by apache2, for example under.


```
        <APACHE_PATH>/htdocs. 
        
         <APACHE_PATH> = path to your apache installation

          Edit httpd.conf under c:/<APACHE_PATH>/conf

          DocumentRoot "c:/<APACHE_PATH>/htdocs"

         <Directory "c:/<APACHE_PATH>/htdocs">
            AllowOverride All   --
            Require all granted -- this is required in Apache 2.4.4
         </Directory>
```

Check that you have the following modules enabled

```
    LoadModule cgi_module modules/mod_cgi.so
    LoadModule rewrite_module modules/mod_rewrite.so
```

#### Tip:
>To check the syntax of your httpd.conf file. From command line run the following 

    $>httpd - t


>.htaccess CGI
    http://perishablepress.com/stupid-htaccess-tricks/

#### .htaccess

```
    Options +ExecCGI +Includes +FollowSymLinks -Indexes
    AddHandler cgi-script exe
    
    <IfModule mod_rewrite.c>
      RewriteEngine on
    
      RewriteRule ^$ $service [L]
    
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteCond %{REQUEST_URI} !$service
      RewriteRule ^(.*)$ $service/$1 
      
      RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
    </IfModule>
```

>Replace $service with the name of your executable service, for example app_service.exe


#### Deploying EWF FCGI
>To deploy FCGI you will need to download the mod_fcgi module. 
>You can get it from here http://www.apachelounge.com/download/

note: on linux (debian), use 
> sudo apt-get install libapache2-mod-fastcgi

#### FCGI overview
>FastCGI allows a single, long-running process to handle more than one user request while keeping close to the CGI programming model, retaining the simplicity while eliminating the overhead of creating a new process for each request. Unlike converting an application to a web server plug-in, FastCGI applications remain independent of the web server.

* Build EWF application

```    ec -config [app.ecf] -target [app_fcgi] -finalize -c_compile -project_path .```

>Note: change app.ecf and target app_fcgi  based on your own configuration.

* Copy the generated exe file and the www content 

Copy the app.exe and the folder "www"  into a folder served by apache2, for example under

```
    <APACHE_PATH>/htdocs. 
    
    <APACHE_PATH> = path to your apache installation

    Edit httpd.conf under c:/<APACHE_PATH>/conf

    DocumentRoot "c:/<APACHE_PATH>/htdocs"

    <Directory "c:/<APACHE_PATH>/htdocs">
      AllowOverride All   --
      Require all granted -- this is required in Apache 2.4.4
    </Directory>
```

>Check that you have the following modules enabled

    LoadModule rewrite_module modules/mod_rewrite.so
    LoadModule fcgid_module modules/mod_fcgid.so

>NOTE: By default Apache does not come with fcgid module, so you will need to download it, and put the module under Apache2/modules

It is also possible to set various parameters in the apache site configuration file such as:
```
	<IfModule mod_fcgid.c>
		# FcgidIdleTimeout 600
		# FcgidBusyScanInterval 120
		# FcgidProcessLifeTime 3600
		# FcgidMaxProcesses 5
		# FcgidMaxProcessesPerClass 100
		# FcgidMinProcessesPerClass 100
		# FcgidConnectTimeout 8
		# FcgidIOTimeout 60
		# FcgidBusyTimeout 1200
	</IfModule>
```		
See https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html for more information.

# .htaccess FCGI

```
http://perishablepress.com/stupid-htaccess-tricks/
```

#### .htaccess
```
    Options +ExecCGI +Includes +FollowSymLinks -Indexes
    
    <IfModule mod_fcgid.c>
	    AddHandler fcgid-script .ews
    	FcgidWrapper $FULL_PATH/$service .ews
    </IfModule>
    
    
    <IfModule mod_rewrite.c>
      RewriteEngine on
    
      RewriteBase /
      RewriteRule ^$ service.ews [L]
    
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteCond %{REQUEST_URI} !=/favicon.ico
      RewriteCond %{REQUEST_URI} !service.ews
      RewriteRule ^(.*)$ service.ews/$1 
      
      
      RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]
    </IfModule>
```

Replace $service with the name of your executable $service, for example app_service.exe
You will need to create an service.ews file, this file will be located at the same place where you copy your app service executable.

Nav: [Workbook](../workbook.md)
