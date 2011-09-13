= How to make this works with Apache =
* In the apache's configuration file, be sure to add the following, or similar
 LoadModule fcgid_module modules/mod_fcgid.so
 <IfModule mod_fcgid.c>
	FcgidIdleTimeout 60
	FcgidBusyScanInterval 120
	FcgidProcessLifeTime 1600 
	#7200
	FcgidMaxProcesses 5
	FcgidMaxProcessesPerClass 100
	FcgidMinProcessesPerClass 100
	FcgidConnectTimeout 8
	FcgidIOTimeout 3000
	FcgidBusyTimeout 3200
	FcgidMaxRequestLen 10000000
	FcgidPassHeader Authorization 
 </IfModule>


 alias /REST/ "c:/_dev/Dev-Process/src/server/htdocs/"
 <directory "c:/_dev/Dev-Process/src/server/htdocs/">
 AllowOverride All
 Order allow,deny
 Allow from all
 </directory>

* You can use <Location>, but then the AllowOverride All, should be somewhere else, since <Location> does not allow it.

* And then, check the .htaccess from this folder for additional settings (but required)


