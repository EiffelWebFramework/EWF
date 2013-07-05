<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-10-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-10-0 http://www.eiffel.com/developers/xml/configuration-1-10-0.xsd" name="${APPNAME}" uuid="${UUID}" library_target="${APPNAME}">
	<target name="_common" abstract="true">
		<file_rule>
			<exclude>/EIFGENs$</exclude>
			<exclude>/CVS$</exclude>
			<exclude>/.svn$</exclude>
		</file_rule>
		<option warning="true" is_attached_by_default="true" void_safety="all" syntax="transitional">
			<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
		</option>
		<library name="base" location="$ISE_LIBRARY\library\base\base-safe.ecf"/>
		<library name="http" location="$ISE_LIBRARY\contrib\library\network\protocol\http\http-safe.ecf"/>
		<library name="wsf" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\wsf-safe.ecf"/>
	</target>
	<target name="${APPNAME}_any" extends="_common">
		<root class="${APP_ROOT}" feature="make_and_launch"/>
		<library name="cgi" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\connector\cgi-safe.ecf"/>
		<library name="libfcgi" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\connector\libfcgi-safe.ecf"/>
		<library name="nino" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\connector\nino-safe.ecf"/>
		<cluster name="launcher" location=".\launcher\any\" recursive="true"/>
		<cluster name="src" location=".\src\" recursive="true"/>
	</target>
	<target name="${APPNAME}_nino" extends="_common">
		<root class="${APP_ROOT}" feature="make_and_launch"/>
		<library name="default_nino" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\default\nino-safe.ecf"/>
		<cluster name="launcher" location=".\launcher\default\" recursive="true"/>
		<cluster name="src" location=".\src\" recursive="true"/>
	</target>
	<target name="${APPNAME}_cgi" extends="_common">
		<root class="${APP_ROOT}" feature="make_and_launch"/>
		<library name="default_cgi" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\default\cgi-safe.ecf"/>
		<cluster name="launcher" location=".\launcher\default\" recursive="true"/>
		<cluster name="src" location=".\src\" recursive="true"/>
	</target>
	<target name="${APPNAME}_libfcgi" extends="_common">
		<root class="${APP_ROOT}" feature="make_and_launch"/>
		<library name="default_libfcgi" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\default\libfcgi-safe.ecf"/>
		<cluster name="launcher" location=".\launcher\default\" recursive="true"/>
		<cluster name="src" location=".\src\" recursive="true"/>
	</target>

	<target name="${APPNAME}" extends="${APPNAME}_nino"/>
</system>

