<cfcomponent output="false">
	<cfset grid = createObject("component","materialflow.cfc.GridStuff")>
	<cfset optGrid = createObject("component","materialflow.cfc.optionsGrid")>
	
    <cffunction name="writeClass" access="remote" returntype="string" output="yes">
    <cfargument name="classID" required="yes" type="numeric">
	<cfargument name="phoneNum" required="no" type="string" default="1-800-338-1382">
		<cfset var tempHTML = "">  
		       
		<cfquery name="classRecord" datasource="CMS">
			SELECT * FROM part_class
			WHERE classID = #arguments.classID#
		</cfquery>
		
		<cfquery name="imageRecord" datasource="CMS">
			SELECT * FROM image
			WHERE imageID = #classRecord.imageID#
		</cfquery>

		<cfset gridStuff = grid.sendGridData(arguments.classID)>		
        <cfset attriQuery = gridStuff[1] />
        <cfset partQuery = gridStuff[2] />

		<cfquery name="fobPoint" datasource="CMS">
			SELECT * FROM fob
			WHERE fobID = #classRecord.fobID#	
		</cfquery>
		
        <cfquery name="manuRecord" datasource="CMS">
			SELECT * FROM manufacturer WHERE manufactID = #classRecord.manufactID#
		</cfquery>

		<cfset tempHTML = '<div class="global-float-left">' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & "<br />" & Chr(13) & Chr(10) />       
        <cfif classRecord.ImageID neq 0> 
            <cfset tempHTML = tempHTML & '<div id="img_container"><a href="#imageRecord.imagePath##imageRecord.imageFileName#" rel="ibox" title="#imageRecord.Alt#"><img src="#imageRecord.tImagePath##imageRecord.tImageFileName#" alt="#imageRecord.Alt#" /></a><br />Click To Enlarge</div>' & Chr(13) & Chr(10) />
        </cfif>
        <cfset tempHTML = tempHTML & '<div class="global-float-right">' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & '<h3>#classRecord.partClassName#</h3>' & Chr(13) & Chr(10) />
		
        <cfif classRecord.partClassDesc neq "" >
        	<cfset tempHTML = tempHTML & classRecord.partClassDesc & Chr(13) & Chr(10) />
        	<cfset tempHTML = tempHTML & '<br />' & Chr(13) & Chr(10) />
        </cfif>
		
        <cfset tempHTML = tempHTML & '<br />' & Chr(13) & Chr(10) />
        <!---build the table and fob info--->
        <cfif ArrayLen(partQuery) gt 0>
			<cfset tempHTML = tempHTML & '<table width="100%" border="0" cellspacing="1" cellpadding="3">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-head">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">#manuRecord.manufactName# #classRecord.partClassName# Part Details</td>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />			
            <cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-top">' & Chr(13) & Chr(10) />
            <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-modelno">Model No.</td>' & Chr(13) & Chr(10) />
            <cfloop from="1" to="#ArrayLen(attriQuery)#" index="i">
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#attriQuery[i].LABEL#</td>' & Chr(13) & Chr(10) />
            </cfloop>			
            <cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />						
			<cfloop from="1" to="#arrayLen(partQuery)#" index="i">
				<cfif i mod 2 eq 0>
					<cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-mid2">' & Chr(13) & Chr(10) />
				<cfelse>
					<cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-mid">' & Chr(13) & Chr(10) />
				</cfif>
				
	            <cfif partQuery[i].INSTOCK is true> 
	                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-instock">#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
	            <cfelse>
	                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
	            </cfif>
				<cfloop from="1" to="#ArrayLen(attriQuery)#" index="j">
					<cfset pTest = trim(attriQuery[j].LABEL) />
	                <cfif len(pTest)-5 gt 0>            	
	                    <cfset pTest = removeChars(pTest,6,len(pTest)-5) />
	                </cfif>
	            	<cfif lcase(pTest) is "price">
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-price">#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					</cfif>
				</cfloop>
				<cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
			</cfloop>							
            <cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-bottom">' & Chr(13) & Chr(10) />		
            <cfif fobPoint.fobID neq 0>
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">F.O.B. #fobPoint.fobLocation#</td>' & Chr(13) & Chr(10) />
            <cfelse>
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">&nbsp;</td>' & Chr(13) & Chr(10) />
            </cfif>
            
            <cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
            <cfset tempHTML = tempHTML & '</table>' & Chr(13) & Chr(10) />
            
            <cfif fobPoint.fobID neq 0>
                <cfset tempHTML = tempHTML & '<strong>Call us at <span class="product-tables-instock">#phoneNum#</span> to request a quote or</strong> <a href="/contact.php">email us via this form</a>' & Chr(13) & Chr(10) />
            </cfif>
        </cfif>
        
        <cfset tempHTML = tempHTML & '</div>' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & '</div>' & Chr(13) & Chr(10) />
        <cfreturn tempHTML>    
    </cffunction>

    <cffunction name="writeOptions" access="remote" returntype="string" output="yes">
    <cfargument name="optionsID" required="yes" type="numeric">
	<cfargument name="classID" required="yes" type="numeric">
	<cfargument name="phoneNum" required="no" type="string" default="1-800-338-1382">
		<cfset var tempHTML = "">
		        
		<cfquery name="optionsRecord" datasource="CMS">
			SELECT * FROM options
			WHERE optionsID = #arguments.optionsID#
		</cfquery>

		<cfquery name="classRecord" datasource="CMS">
			SELECT * FROM part_class
			WHERE classID = #arguments.classID#
		</cfquery>
						
		<cfquery name="imageRecord" datasource="CMS">
			SELECT * FROM image
			WHERE imageID = #optionsRecord.imageID#
		</cfquery>

		<cfset gridStuff = optGrid.sendGridData(arguments.optionsID)>		
        <cfset attriQuery = gridStuff[1] />
        <cfset partQuery = gridStuff[2] />

		<cfquery name="fobPoint" datasource="CMS">
			SELECT * FROM options_fob
			WHERE fobID = #optionsRecord.fobID#	
		</cfquery>
		
        <cfquery name="manuRecord" datasource="CMS">
			SELECT * FROM manufacturer WHERE manufactID = #optionsRecord.manufactID#
		</cfquery>
		
		<cfset tempHTML = '<div class="global-float-left-options">' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & "<br />" & Chr(13) & Chr(10) />       
        <cfif optionsRecord.ImageID neq 0> 
            <cfset tempHTML = tempHTML & '<div id="img_container"><a href="#imageRecord.imagePath##imageRecord.imageFileName#" rel="ibox" title="#imageRecord.Alt#"><img src="#imageRecord.tImagePath##imageRecord.tImageFileName#" alt="#imageRecord.Alt#" /></a><br />Click To Enlarge</div>' & Chr(13) & Chr(10) />
        </cfif>
        <cfset tempHTML = tempHTML & '<div class="global-float-right-options">' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & '<h3>#optionsRecord.name#</h3>' & Chr(13) & Chr(10) />
		
        <cfif optionsRecord.description neq "" >
        	<cfset tempHTML = tempHTML & optionsRecord.description & Chr(13) & Chr(10) />
        	<cfset tempHTML = tempHTML & '<br />' & Chr(13) & Chr(10) />
        </cfif>
		
        <cfset tempHTML = tempHTML & '<br />' & Chr(13) & Chr(10) />
        <!---build the table and fob info--->
        <cfif ArrayLen(partQuery) gt 0>
			<cfset tempHTML = tempHTML & '<table width="100%" border="0" cellspacing="1" cellpadding="3">' & Chr(13) & Chr(10) />
            <cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-top2">' & Chr(13) & Chr(10) />
            <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-modelno">Model No.</td>' & Chr(13) & Chr(10) />
            <cfloop from="1" to="#ArrayLen(attriQuery)#" index="i">
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#attriQuery[i].LABEL#</td>' & Chr(13) & Chr(10) />
            </cfloop>			
            <cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />						
			<cfloop from="1" to="#arrayLen(partQuery)#" index="i">
				<cfif i mod 2 eq 0>
					<cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-mid2">' & Chr(13) & Chr(10) />
				<cfelse>
					<cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-mid">' & Chr(13) & Chr(10) />
				</cfif>
				
	            <cfif partQuery[i].INSTOCK is true> 
	                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-instock">#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
	            <cfelse>
	                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
	            </cfif>
				<cfloop from="1" to="#ArrayLen(attriQuery)#" index="j">
					<cfset pTest = trim(attriQuery[j].LABEL) />
	                <cfif len(pTest)-5 gt 0>            	
	                    <cfset pTest = removeChars(pTest,6,len(pTest)-5) />
	                </cfif>
	            	<cfif lcase(pTest) is "price">
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td class="product-tables-price">#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td>#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					</cfif>
				</cfloop>
				<cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
			</cfloop>							
            <cfset tempHTML = tempHTML & Chr(9) & '<tr class="product-tables-bottom">' & Chr(13) & Chr(10) />		
            <cfif fobPoint.fobID neq 0>
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">F.O.B. #fobPoint.fobLocation#</td>' & Chr(13) & Chr(10) />
            <cfelse>
                <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">&nbsp;</td>' & Chr(13) & Chr(10) />
            </cfif>
            
            <cfset tempHTML = tempHTML & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
            <cfset tempHTML = tempHTML & '</table>' & Chr(13) & Chr(10) />
            
            <cfif fobPoint.fobID neq 0>
                <cfset tempHTML = tempHTML & '<strong>Call us at <span class="product-tables-instock">#phoneNum#</span> to request a quote or</strong> <a href="/contact.php">email us via this form</a>' & Chr(13) & Chr(10) />
            </cfif>
        </cfif>
        
        <cfset tempHTML = tempHTML & '</div>' & Chr(13) & Chr(10) />
        <cfset tempHTML = tempHTML & '</div>' & Chr(13) & Chr(10) />
        <cfreturn tempHTML>    
    </cffunction>
 	 
    <cffunction name="newWriter" access="remote" returntype="string" output="yes">
    <cfargument name="classID" required="yes" type="numeric">
	<cfargument name="phoneNum" required="no" type="string" default="1-800-338-1382">
	<cfargument name="useManufactName" required="no" type="numeric" default="0">
		<cfset var tempHTML = "">
		<cfset var getClass = QueryNew("") >
		<cfset var getClassImg = QueryNew("") >
		<cfset var getClassFOB = QueryNew("") >
		<cfset var gridStuff = QueryNew("") >
		<cfset var attriQuery = QueryNew("") >
		<cfset var partQuery = QueryNew("") >
		<cfset var getManu = QueryNew("") >
		<cfset var getManuImg = QueryNew("") >
		  
		<cfquery name="getClass" datasource="CMS">
			SELECT *
			FROM part_class
			WHERE classID = #int(arguments.classID)#
		</cfquery>
		
		<cfquery name="getClassImg" datasource="CMS">
			SELECT *
			FROM image
			WHERE imageID = #getClass.imageID#
		</cfquery>
		
		<cfquery name="getClassFOB" datasource="CMS">
			SELECT *
			FROM fob
			WHERE fobID = #getClass.fobID#
		</cfquery>
		
		<cfset gridStuff = grid.sendGridData(arguments.classID)>
		<cfset attriQuery = gridStuff[1] />
		<cfset partQuery = gridStuff[2] />
		
		<!---get manufact info--->
		<cfquery name="getManu" datasource="CMS">
			SELECT *
			FROM manufacturer
			WHERE manufacturer.manufactID = #getClass.manufactID#
		</cfquery>
		
		<cfquery name="getManuImg" datasource="CMS">
			SELECT *
			FROM image
			WHERE imageID = #getManu.imageID#
		</cfquery>  
		
		<cfset tempHTML = tempHTML & Chr(9) & '<div class="partContainer">' & Chr(13) & Chr(10) />  
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<div style="width:100%; clear:both;">' & Chr(13) & Chr(10) />
		
		<cfif getClass.imageID neq 0>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div id="img_container">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="#getClassImg.imagePath##getClassImg.imageFileName#" rel="ibox" title="#getClassImg.Alt#">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<img src="#getClassImg.tImagePath##getClassImg.tImageFileName#" alt="#getClassImg.Alt#" />' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</a>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & 'Click To Enlarge' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-right">' & Chr(13) & Chr(10) />
		<cfelse>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div>' & Chr(13) & Chr(10) />
		</cfif>
		
		<cfif arguments.useManufactName eq 0>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h3>#getClass.partClassName#</h3>' & Chr(13) & Chr(10) />
		<cfelse>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h3>#getManu.manufactName# #getClass.partClassName#</h3>' & Chr(13) & Chr(10) />
		</cfif>
			
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & #getClass.partClassDesc# & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />		
							
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		
		<!---write the table and fob info--->   
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<div style="width:100%; clear:both;">' & Chr(13) & Chr(10) />
		
		<cfif ArrayLen(partQuery) gt 0>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<table width="100%" border="0" cellspacing="1" cellpadding="3">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-head">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">#getManu.manufactName# #getClass.partClassName# Part Details</td>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />			
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-top">' & Chr(13) & Chr(10) />
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-modelno">Model No.</td>' & Chr(13) & Chr(10) />
		    <cfloop from="1" to="#ArrayLen(attriQuery)#" index="i">
		    	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td>#attriQuery[i].LABEL#</td>' & Chr(13) & Chr(10) />
		   	</cfloop>			
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />						
			<cfloop from="1" to="#arrayLen(partQuery)#" index="i">
				<cfif i mod 2 eq 0>
					<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-mid2">' & Chr(13) & Chr(10) />
				<cfelse>
					<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-mid">' & Chr(13) & Chr(10) />
				</cfif>
			
		        <cfif partQuery[i].INSTOCK is true> 
		        	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-instock">#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
				<cfelse>
		        	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td>#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
		       	</cfif>
				
				<cfloop from="1" to="#ArrayLen(attriQuery)#" index="j">
					<cfset pTest = trim(attriQuery[j].LABEL) />
					
		           	<cfif len(pTest)-5 gt 0>            	
		            	<cfset pTest = removeChars(pTest,6,len(pTest)-5) />
		            </cfif>
					
		          	<cfif lcase(pTest) is "price">
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-price">#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td>#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					</cfif>
				</cfloop>
				
				<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
			</cfloop>							
		         
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-bottom">' & Chr(13) & Chr(10) />		
		    <cfif getClass.fobID neq 0>
		   		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">F.O.B. #getClassFOB.fobLocation#</td>' & Chr(13) & Chr(10) />
		    <cfelse>
		    	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">&nbsp;</td>' & Chr(13) & Chr(10) />
		    </cfif>
		         
		   <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
		   <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</table>' & Chr(13) & Chr(10) />
		</cfif>
		
		<cfif getClass.fobID neq 0> 
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<strong>Call us at <span class="product-tables-instock">#arguments.phoneNum#</span> to request a quote or</strong> <a href="/contact.php">email us via this form</a>' & Chr(13) & Chr(10) />
		</cfif>
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		
		<cfreturn tempHTML>	
	</cffunction>

	<cffunction name="newOptWriter" access="remote" returntype="string" output="yes">
	<cfargument name="optionsID" required="yes" type="numeric">
	<cfargument name="phoneNum" required="no" type="string" default="1-800-338-1382">
		<cfset var tempHTML = "">
		<cfset var getOptions = QueryNew("")>
		<cfset var getOptionsImg = QueryNew("")>
		<cfset var getOptionsFOB = QueryNew("")>
		<cfset var gridStuff = QueryNew("")>
		<cfset var attriQuery = QueryNew("")>
		<cfset var partQuery = QueryNew("")>
		<cfset var getManu = QueryNew("")>
		  
		<cfquery name="getOptions" datasource="CMS">
			SELECT *
			FROM options
			WHERE optionsID = #arguments.optionsID#
		</cfquery>

		<cfquery name="getOptionsImg" datasource="CMS">
			SELECT *
			FROM image
			WHERE imageID = #getOptions.imageID#
		</cfquery>
		
		<cfquery name="getOptionsFOB" datasource="CMS">
			SELECT *
			FROM fob
			WHERE fobID = #getOptions.fobID#
		</cfquery>
			
		<cfset gridStuff = optGrid.sendGridData(arguments.optionsID)>		
	    <cfset attriQuery = gridStuff[1] />
	    <cfset partQuery = gridStuff[2] />
	
		<cfquery name="getManu" datasource="CMS">
			SELECT *
			FROM manufacturer
			WHERE manufacturer.manufactID = #getOptions.manufactID#
		</cfquery>	
		
		<cfset tempHTML = Chr(9) & '<div class="optionContainer">' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<div style="width:100%; clear:both;">' & Chr(13) & Chr(10) />
		
		<cfif getOptions.imageID neq 0>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div id="img_container">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="#getOptionsImg.imagePath##getOptionsImg.imageFileName#" rel="ibox" title="#getOptionsImg.Alt#">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<img src="#getOptionsImg.timagePath##getOptionsImg.timageFileName#" alt="#getOptionsImg.Alt#" />' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</a>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & 'Click To Enlarge' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-right">' & Chr(13) & Chr(10) />
		<cfelse>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<div>' & Chr(13) & Chr(10) />
		</cfif>
		
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h3>#getOptions.name#</h3>' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '#getOptions.description#' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />			
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '<div style="width:100%; clear:both;">' & Chr(13) & Chr(10) />
		<cfif ArrayLen(partQuery) gt 0>
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<table width="100%" border="0" cellspacing="1" cellpadding="3">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-head">' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">#getManu.manufactName# #getOptions.name# Part Details</td>' & Chr(13) & Chr(10) />
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />			
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-top2">' & Chr(13) & Chr(10) />
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-modelno">Model No.</td>' & Chr(13) & Chr(10) />
		    <cfloop from="1" to="#ArrayLen(attriQuery)#" index="i">
		    	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) &  Chr(9) & Chr(9) & Chr(9) & '<td>#attriQuery[i].LABEL#</td>' & Chr(13) & Chr(10) />
		   	</cfloop>			
		    <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />						
			<cfloop from="1" to="#arrayLen(partQuery)#" index="i">
				<cfif i mod 2 eq 0>
					<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-mid2">' & Chr(13) & Chr(10) />
				<cfelse>
					<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-mid">' & Chr(13) & Chr(10) />
				</cfif>
			
		        <cfif partQuery[i].INSTOCK is true> 
		        	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-instock">#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
				<cfelse>
		        	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td>#partQuery[i].NAME#</td>' & Chr(13) & Chr(10) />
		       	</cfif>
				
				<cfloop from="1" to="#ArrayLen(attriQuery)#" index="j">
					<cfset pTest = trim(attriQuery[j].LABEL) />
					
		           	<cfif len(pTest)-5 gt 0>            	
		            	<cfset pTest = removeChars(pTest,6,len(pTest)-5) />
		            </cfif>
					
		          	<cfif lcase(pTest) is "price">
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td class="product-tables-price">#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td>#partQuery[i]["#attriQuery[j].DATA#"]#</td>' & Chr(13) & Chr(10) />
					</cfif>
				</cfloop>
				
				<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
			</cfloop>							
		         
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<tr class="product-tables-bottom">' & Chr(13) & Chr(10) />		
		    <cfif getOptions.fobID neq 0>
		   		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">F.O.B. #getOptionsFOB.fobLocation#</td>' & Chr(13) & Chr(10) />
		    <cfelse>
		    	<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td colspan="#ArrayLen(attriQuery)+1#">&nbsp;</td>' & Chr(13) & Chr(10) />
		    </cfif>
		         
		   <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
		   <cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '</table>' & Chr(13) & Chr(10) />
		</cfif>
		
		<cfif getOptions.fobID neq 0> 
			<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<strong>Call us at <span class="product-tables-instock">#arguments.phoneNum#</span> to request a quote or</strong> <a href="/contact.php">email us via this form</a>' & Chr(13) & Chr(10) />
		</cfif>
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		<cfset tempHTML = tempHTML & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		
		<cfreturn tempHTML>
	</cffunction>
	
	<cffunction name="writeClassAndOptions" access="public" returntype="string" output="false">
	<cfargument name="classRec" required="true" type="query">
	<cfargument name="domainQuery" required="true" type="query">
	<cfargument name="showManu" required="false" type="numeric" default="0">
		<cfset var returnString = "">
		
		<cfset returnString = '<div id="partClass">' & Chr(13) & Chr(10) />
		<cfset returnString = returnString & '<a name="a#arguments.classRec.partClassName#"></a>' & Chr(13) & Chr(10) />
				
        <cfset returnString = returnString & newWriter(arguments.classRec.classID,arguments.domainQuery.phoneNumber,arguments.showManu) />
		<!---end part class write code--->
		
		<!---write the options--->
		<cfquery name="getOptions" datasource="CMS">
			SELECT * FROM options_class_link
			WHERE classID = #arguments.classRec.classID#
			ORDER BY optOrder
		</cfquery>
		
		<cfif getOptions.RecordCount gt 0>						
			<cfset returnString = returnString & Chr(9) & '<input type="image" id="shwBtn#arguments.classRec.partClassName#" onclick="toggleOptions(''optn#arguments.classRec.partClassName#'',''shwBtn#arguments.classRec.partClassName#'',''images/template/v-options.png'',''images/template/h-options.png'',''none'');" src="images/template/v-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
			<cfset returnString = returnString & Chr(9) & '<div id="optn#arguments.classRec.partClassName#" style="display:none">' & Chr(13) & Chr(10) />
			
			<cfset returnString = returnString & Chr(9) & Chr(9) & '<div class="optional-items">' & Chr(13) & Chr(10) />
			<cfset returnString = returnString & Chr(9) & Chr(9) & '<h2>Optional items for #arguments.classRec.manufactName# #arguments.classRec.partClassName#</h2>' & Chr(13) & Chr(10) />
			<cfset returnString = returnString & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
			
			<!---opt gen codes goes here--->
			<cfloop query="getOptions">
				<cfset returnString = returnString & newOptWriter(getOptions.optionsID,arguments.domainQuery.phoneNumber,arguments.showManu)>
			</cfloop>
			<!---end opt gen funtions--->
			
			<cfset returnString = returnString &  Chr(9) & Chr(9) & '<input type="image" onclick="toggleOptions(''optn#arguments.classRec.partClassName#'',''optn#arguments.classRec.partClassName#'',''images/template/v-options.png'',''images/template/h-options.png'',''a#arguments.classRec.partClassName#'');" src="images/template/h-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
			<cfset returnString = returnString &  Chr(9) & '</div>' & Chr(13) & Chr(10) />
		</cfif>
		
		<cfset returnString = returnString & '</div>' & Chr(13) & Chr(10) />
		<cfreturn returnString>		
	</cffunction>
</cfcomponent>