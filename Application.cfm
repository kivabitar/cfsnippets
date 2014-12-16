<cfsilent>
	<cfapplication name="kivastest" sessionmanagement="yes" loginstorage="session" sessiontimeout="12">
	<cfif right(cgi.script_name, len("index.cfm")) neq "index.cfm" and right(cgi.script_name, 3) neq "cfc" and listGetAt(cgi.script_name,1,'/') neq "blog">
		<cflocation url="index.cfm" addtoken="no" />
	</cfif>
	<cfset APPLICATION.hello = "Hello World!">

</cfsilent>