<cfsilent>
<cfparam name="attributes.item" default=""/>
<cfparam name="attributes.view" default=""/>
</cfsilent>
<cfif attributes.view eq "">
	
	<cfif structKeyExists(session, "myitems")>
			<!--- Delete the item supplied --->
			<cfset arrayDeleteAt(session.myitems, attributes.arrPos)>
			<!--- <cfset arrayAppend(session.myitems, getPart.name & ' ' & getPart.partClassName)> --->
			
			<cfoutput>
				
			<cfif arrayLen(session.myitems) lt 1>
					<cfset ArrayClear(session.myitems)>
					<cflocation url="index.cfm?mf=contact.contact" addtoken="false">
			
				<cfelse>
					<cflocation url="index.cfm?mf=contact.contact" addtoken="false">
			</cfif>
			
			
			
			
			</cfoutput>
			<cfelse>
			<cflocation url="index.cfm?mf=browse.myQuoteList" addtoken="false">
	</cfif>
	
	<cfelse>
		<cfif structKeyExists(session, "myitems")>
			<cfset arrayDeleteAt(session.myitems, attributes.arrPos)>
			<!--- <cfset arrayAppend(session.myitems, getPart.name & ' ' & getPart.partClassName)> --->
			
			<cfoutput>
				
			<cfif arrayLen(session.myitems) lt 1>
					<cfset ArrayClear(session.myitems)>
					<cflocation url="index.cfm?mf=browse.myQuoteList" addtoken="false">
			
				<cfelse>
					<cflocation url="index.cfm?mf=browse.myQuoteList" addtoken="false">
			</cfif>
			
			
			
			
			</cfoutput>
				<cfelse>
				<h1>You have no items in your quote list</h1>
		</cfif>
</cfif>
