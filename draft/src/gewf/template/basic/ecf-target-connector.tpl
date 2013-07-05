	<target name="${APPNAME}_${EWF.connector}" extends="_common">
		<root class="${APP_ROOT}" feature="make_and_launch"/>
		<library name="default_${EWF.connector}" location="$ISE_LIBRARY\contrib\library\web\framework\ewf\wsf\default\${EWF.connector}-safe.ecf"/>
		<cluster name="launcher" location=".\launcher\default\" recursive="true"/>
		<cluster name="src" location=".\src\" recursive="true"/>
	</target>
