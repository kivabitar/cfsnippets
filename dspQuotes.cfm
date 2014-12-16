

<cfsilent>
<cfparam name="attributes.partNumber" default=""/>
<cfparam name="attributes.isOpt" default=""/>
<cfparam name="attributes.deleted" default="" />
<cfparam name="dupe" default="" />

<cfif not structKeyExists(session, "myitems")>
<cfset SESSION.myItems = ArrayNew(1)>
<cfelse>
	<cfif ArrayLen(session.myItems) gte 1>
		<cfset myItems = 1>
		<cfelse>
		<cfset SESSION.myItems = ArrayNew(1)>
	</cfif>
</cfif>
<!--- <cfscript>
// if the session array of items doesn't exist, create it
if(not structKeyExists(session, "myitems"))
{
session["myitems"] = arrayNew(1);
}
</cfscript>  --->

<!--- get the part information for the given partNumber --->

<cfif attributes.isOpt eq 1>
	<cfquery name="getPart" datasource="CMS">
	select options_part.name, options_class_link.classID,  part_class.partClassName
	from options_part
	inner join options_class_link
	on options_class_link.optionsID = options_part.optionsID
	inner join part_class
	on options_class_link.classID = part_class.classID
	where options_part.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partNumber#"/>
	</cfquery>
<cfelse>
<cfquery name="getPart" datasource="CMS">
select p.classID, pc.partClassName, p.name
from part p
inner join part_class pc
on p.classID=pc.classID
where p.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partNumber#"/>
</cfquery>
</cfif>

</cfsilent>

<!--- append the part number to the array of items for this session provided there are not more than 10 items already --->
<cfif ARRAYLEN(session.myitems) LTE 10>
	
	<!--- check to see if the item exists --->
	<cfloop from="1" to="#arrayLen(session.myitems)#" index="i">
		<cfif session.myitems[i] eq getPart.Name>
			<cfset dupe = 1>
		</cfif>
	</cfloop>
	<cfif dupe NEQ 1>
		<cfset arrayAppend(session.myitems, getPart.name)>	
	</cfif>
<!--- <cfset arrayAppend(session.myitems, getPart.name & ' ' & getPart.partClassName)> --->

<cfoutput>
<div style="padding:10px; line-height:18px;">
<h1><a href="?mf=browse.myQuoteList">My Quote Items</a></h1>

	<cfif getPart.recordCount>
		<strong>#getPart.name# - <cfif attributes.isOpt eq 1>Option for #getPart.partClassName#<cfelse>#getPart.partClassName#</cfif> <cfif dupe NEQ 1>added to your Quote list!</strong><cfelse>is already on your quote list. You can choose the quantity of the item at the <a href="index.cfm?mf=contact.contact">next step.</a></strong> </cfif><br/><br/>
		<strong>My quote list</strong><br />
		<ul>
		<cfloop from="1" to="#arrayLen(session.myitems)#" index="i">
		
		<li><strong>#session.myitems[i]#</strong> <a href="index.cfm?mf=reports.removeItem&item=#session.myitems[i]#&arrPos=#i#&view=2"><img src="/global/images/remove.gif" border="0" alt="remove" title="remove" /></a></li>
	
		</cfloop>
		</ul>
		<span id="redText">Choose Quantity of each item at the <a href="index.cfm?mf=contact.contact">contact form.</a></span>
		<cfelse>
			<h2>No part number was defined.</h2>
				<cfloop from="1" to="#arrayLen(session.myitems)#" index="i">
				<li><strong>#session.myitems[i]#</strong> <a href="?mf=reports.removeItem&item=#session.myitems[i]#&arrPos=#i#&view=2" rel="noindex, nofollow"><img src="/global/images/remove.gif" border="0" alt="remove" title="remove" /></a></li>
				</cfloop>
			
	</cfif>
</cfoutput>
	<cfelse>
	<strong>You have reached your maximum allowed items of 10.</strong> Please contact a sales rep at <strong>1-800-338-1382 </strong>for larger orders.<br /><br />
	<cfloop from="1" to="#arrayLen(session.myitems)#" index="i">
				<cfoutput>
				<li><strong>#session.myitems[i]#</strong> <a href="?mf=reports.removeItem&item=#session.myitems[i]#&arrPos=#i#&view=2" rel="noindex, nofollow"><img src="/global/images/remove.gif" border="0" alt="remove" title="remove" /></a></li>
				</cfoutput>
	</cfloop>
</cfif>
<br />
<cfoutput>
<span class="smalltext">
	This quote list simply remembers the items you would like to receive a cost quote from our salesman. <br />
	<strong>You can click as many as 10 items.</strong> When you are ready to proceed to our contact form, simply click <br />
	the link below. The items in your quote list will appear on the contact form with options on how many you would <br />
	like to be quoted. 
	<strong>No financial information is required.</strong>
</span>
<br />
<br />
<a href="#CGI.HTTP_REFERER#">Keep Shopping</a> | <a href="?mf=contact.contact">Continue to Contact Form</a>
</div>
<!--- display array as it builds --->
<!--- <cfdump var="#session.myitems#"/> --->
</cfoutput>
