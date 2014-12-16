

<cfsilent>
<cfparam name="attributes.partNumber" default=""/>
<cfparam name="attributes.deleted" default="" />
<cfif not structKeyExists(session, "myitems")>
<cfset Items = 0>
<cfelse>
	<cfif IsArray(session.myItems)>
		<cfif ArrayLen(session.myItems) gte 1>
			<cfset Items = 1>
			<cfelse>
			<cfset Items = 0>
		</cfif>
		<cfelse>
		<cfset session.myItems = ArrayNew(1)>
	</cfif>
</cfif>
<!--- get the part information for the given partNumber --->
</cfsilent>
<cfoutput>
<h1 class="boom">My Quote Items</h1>

<div style="padding:20px; line-height:15px;">
<span class="smalltext">
	This quote list simply remembers the items you would like to receive a cost quote from our salesman. 
	<strong>You can click as many as 10 items.</strong> When you are ready to proceed to our contact form, simply click 
	the link below. The items in your quote list will appear on the contact form with options on how many you would 
	like to be quoted. 
	<strong>No financial information is required.</strong>
</span>
<br /><br />
	
	<cfif Items NEQ 0>
		<cfloop from="1" to="#arrayLen(session.myitems)#" index="i">
				<cfquery name="getPartClass" datasource="CMS">
					SELECT classID
					FROM part
					WHERE part.name = <cfqueryparam value="#session.myitems[i]#">
				</cfquery>
				<cfif getPartClass.recordCount lt 1>
				<cfquery name="getPartClass" datasource="CMS">
				select options_class_link.classID,  part_class.partClassName
				from options_part
				inner join options_class_link
				on options_class_link.optionsID = options_part.optionsID
				inner join part_class
				on options_class_link.classID = part_class.classID
				where options_part.name = <cfqueryparam value="#session.myitems[i]#">
				</cfquery>
				</cfif>
 		        
				&bull; <a href="http://#cgi.server_name#/?mf=browse.showpart&partClassID=#getPartClass.classID#"><strong>#session.myitems[i]#</strong></a>
				<a href="?mf=reports.removeItem&item=#session.myitems[i]#&arrPos=#i#&view=1" rel="noindex, nofollow"><img src="/global/images/remove.gif" border="0" alt="remove" title="remove" /></a><br />	<br />					
				
		</cfloop><br />
		<a href="?mf=contact.contact"> &gt;&gt; Proceed to contact form</a>	
	            <cfelse><h1>No Items are in your Quote List.</h1>
	 </cfif>
	
	
<br />


<br />
<br />
<a href="#self#">Keep Shopping</a>
</div>
<!--- display array as it builds --->
<!--- <cfdump var="#session.myitems#"/> --->
</cfoutput>
