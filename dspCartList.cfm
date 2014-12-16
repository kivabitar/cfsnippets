

<cfsilent>
<cfparam name="attributes.partNumber" default=""/>
<cfparam name="attributes.deleted" default="" />
<cfif not structKeyExists(session, "myCart")>
<cfset Items = 0>
<cfelse>
	<cfif IsArray(session.myCart)>
		<cfif ArrayLen(session.myCart) gte 1>
			<cfset Items = 1>
			<cfelse>
			<cfset Items = 0>
		</cfif>
		<cfelse>
		<cfset session.myCart = ArrayNew(1)>
	</cfif>
</cfif>
<!--- get the part information for the given partNumber --->
</cfsilent>
<cfoutput>
<h1 class="boom">My Shopping Cart</h1>

<div style="padding:20px; line-height:15px;">
<span class="smalltext">
	This is a list of items you intend on purchasing. If you are looking for quotes, please use the quote button on 
	the item of your choice.
</span>
<br /><br />
	<cfset myImageName = "">
	<cfif Items NEQ 0>
		<cfloop from="1" to="#arrayLen(session.myCart)#" index="i">
				<cfquery name="getPartClass" datasource="CMS">
					SELECT classID
					FROM part
					WHERE part.name = <cfqueryparam value="#session.myCart[i]#">
				</cfquery>
				<cfquery name="getImage" datasource="cms" >
					SELECT * FROM part_class_images
					WHERE parentID = #getPartClass.classID#
				</cfquery>
				<cfif getImage.recordCount NEQ 0>
					<cfset myImageName = "/global/images/part_class_images/thumbs/#getImage.tImageFileName#">
				</cfif>
				<cfif getPartClass.recordCount lt 1>
					<cfquery name="getPartClass" datasource="CMS">
						select options_class_link.classID,  part_class.partClassName
						from options_part
						inner join options_class_link
						on options_class_link.optionsID = options_part.optionsID
						inner join part_class
						on options_class_link.classID = part_class.classID
						where options_part.name = <cfqueryparam value="#session.myCart[i]#">
					</cfquery>
					<cfquery name="getImage" datasource="cms">
						SELECT * FROM options_images
						WHERE parentID = #getPartClass.optionsID#
					</cfquery>
					<cfif getImage.recordCount NEQ 0>
						<cfset myImageName = "/global/images/options_images/thumbs/#getImage.tImageFileName#">
					</cfif>
				</cfif>
 		        <cfif myImageName NEQ "">
					<img src="#myImageName#" style="border:0px;width:50px;" /> 
					<cfelse>
						<img src="/global/images/no_image.gif" style="border:0px;width:50px;" /> 
				</cfif>
				<a href="http://#cgi.server_name#/?mf=browse.showpart&partClassID=#getPartClass.classID#"><strong>#session.myCart[i]#</strong></a>
				<a href="?mf=reports.removeCartItem&item=#session.myCart[i]#&arrPos=#i#&view=1" rel="noindex, nofollow"><img src="/global/images/remove.gif" border="0" alt="remove" title="remove" /></a><br />	<br />					
				
		</cfloop><br />
		<a href="index.cfm?mf=cart.checkout"> &gt;&gt; Proceed to Checkout</a>	
	            <cfelse><h1>No Items are in your Shopping Cart</h1>
	 </cfif>
	
	
<br />


<br />
<br />
<a href="#self#">Keep Shopping</a>
</div>
<!--- display array as it builds --->
<!--- <cfdump var="#session.myCart#"/> --->
</cfoutput>
