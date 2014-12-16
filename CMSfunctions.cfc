<cfcomponent>
	<CFSET MYWRITER = CREATEOBJECT("COMPONENT","WRITER")>
	
	<cffunction name="buildList" access="remote" returntype="query">
	<cfargument name="SourceQuery" required="yes" type="query">
	<cfargument name="topItem" required="yes" type="string">
		<cfset domainList = queryNew("label,data")>
		
		<!---add the first item--->
		<cfset queryAddRow(domainList)>
		<cfset querySetCell(domainList,"label","#topItem#")>
		<cfset querySetCell(domainList,"data",0)>
		
		<!---add the data--->
		<cfloop query="SourceQuery">
			<cfset queryAddRow(domainList)>
			<cfset querySetCell(domainList,"label","#SourceQuery.label#")>
			<cfset querySetCell(domainList,"data","#SourceQuery.data#")>
		</cfloop>
		
		<!---return the list--->
		<cfreturn domainList>
	</cffunction>
	
	<cffunction name="dropListQuery" access="remote" returntype="query" output="yes">
    <cfargument name="sourceQuery" required="yes" type="query">
    <cfargument name="labelColumn" required="yes" type="string">
    <cfargument name="dataColumn" required="yes" type="string">
    <cfargument name="topItem" required="no" type="string" default="">
        <cfset dumpQuery = querynew("label,data") />
        <cfscript>
        queryaddrow(dumpQuery);
        querySetCell(dumpQuery,'data','0');
        querySetCell(dumpQuery,'label','#topItem#');
        </cfscript>   
        <cfloop from="1" to="#arguments.sourceQuery.recordcount#" index="i">
			<cfscript>
            queryaddrow(dumpQuery);
            querySetCell(dumpQuery,'data','#arguments.sourceQuery[dataColumn][i]#');
            querySetCell(dumpQuery,'label','#arguments.sourceQuery[labelColumn][i]#');
            </cfscript>
		</cfloop>
        <cfreturn dumpQuery>
	</cffunction>
      
    <cffunction name="deletePHP" access="remote" returntype="void" output="yes">
    <cfargument name="classID" required="yes" type="numeric">
		<cfset exPath = expandPath('/includes')>
		<cfquery name="getInclude" datasource="CMS">
			SELECT includeName FROM part_class WHERE classID = #arguments.classID#
		</cfquery>    
        <cfif getInclude.includeName neq "" and fileExists("#exPath#\#getInclude.includeName#")>
            <cffile action="delete" file="#exPath#\#getInclude.includeName#">
        </cfif>
    </cffunction>
    
    <cffunction name="buildMFCategoryPage" access="remote" returntype="string" output="yes">
    <cfargument name="catID" required="yes">
	<cfargument name="domainID" required="yes">
		<cfquery name="domainInfo" datasource="CMS">
			SELECT * FROM domains WHERE domainID = #arguments.domainID#
		</cfquery>
		<cfquery name="catRecord" datasource="CMS">
			SELECT * FROM category
			WHERE catID = #arguments.catID#
			AND domainID = #arguments.domainID#
		</cfquery>
		<cfquery name="partCatQuery" datasource="CMS">
			SELECT * FROM part_category
			WHERE catID = #catRecord.catID#
			ORDER BY partCatName
		</cfquery>
        <cfset exPath = expandpath("#domainInfo.path#") >
        
        <cfset tempPage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'  & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & '<head>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<title>#catRecord.catName# at MaterialFlow.com</title>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., MaterialFlow.com, #catRecord.catName#" />' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<meta name="description" content="Buy #catRecord.catName# through MaterialFlow.com or by calling Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<meta name="robots" content="index,follow" />' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" />
        <cfset tempPage = tempPage & Chr(13) & Chr(10) & Chr(9) & '</head>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '<div class="main">' & Chr(13) & Chr(10) />  
        
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<h1>#catRecord.catName#</h1>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '#catRecord.catDesc#' & Chr(13) & Chr(10) />
        <cfif catRecord.catDesc neq "">
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
        </cfif>
        
        <cfloop query="partCatQuery">
            <cfquery name="imageRecord" datasource="CMS">
				SELECT * FROM image WHERE imageID = #partCatQuery.imageID#
			</cfquery>
			<cfquery name="classQuery" datasource="CMS">
				SELECT * FROM part_class
				INNER JOIN part_class_link
				ON part_class.classID = part_class_link.classID
				WHERE partCatID = #partCatQuery.partCatID#
				ORDER BY partClassName
			</cfquery>
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-left">' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div id="category-mfg-photo"><img src="#imageRecord.timagePath##imageRecord.timageFileName#" alt="#imageRecord.Alt#" /></div>' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-right">' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h2>#partCatQuery.partCatName#</h2>' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '#partCatQuery.partCatDesc#' & Chr(13) & Chr(10) />
            <cfif partCatQuery.partCatDesc neq "">
                <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
            </cfif>
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dl>' & Chr(13) & Chr(10) />            
            <cfquery name="classManufacts" dbtype="query">
            	SELECT manufactID 
				FROM classQuery 
				GROUP BY manufactID
            </cfquery>

            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dt><h3>Click a manufacturer name below to view their #partCatQuery.partCatName#</h3></dt>' & Chr(13) & Chr(10) />
            
            <cfloop query="classManufacts">
				<cfquery name="manufactRecord" datasource="CMS">
					SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
				</cfquery>
                <cfset linkName = removeBadChars("#manufactRecord.manufactName#-#partCatQuery.partCatName#") >
                <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dd><a href="/#linkName#1.php">#manufactRecord.manufactName#</a></dd>' & Chr(13) & Chr(10) />
            </cfloop>
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</dl>' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
            <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
        </cfloop>
        
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & '</html>' & Chr(13) & Chr(10) />		
        
        <cfset catFileName = removeBadChars("#catRecord.catName#") >
        <cffile action="write" file="#exPath#\#catFileName#.php" output="#tempPage#"/>
        <cfreturn catRecord.catName>    
    </cffunction>
	
	<cffunction name="buildNewMFCategoryPage" access="remote" returntype="string" output="yes">
    <cfargument name="catID" required="yes">
		<cfset var myLink = "">
		
		<cfquery name="domainInfo" datasource="CMS">
			SELECT *
			FROM domains
			WHERE domainID = 1
		</cfquery>
		
		<cfquery name="getCat" datasource="CMS">
			SELECT *
			FROM category
			WHERE catID = #arguments.catID#
		</cfquery>
		
		<cfquery name="partCatImgs" datasource="CMS">
			SELECT *
			FROM part_category
			INNER JOIN image
			ON part_category.imageID = image.imageID
			WHERE catID = #getCat.catID#
			ORDER BY part_category.partCatOrder
		</cfquery>
		
		<cfset itemsPerRow = 3>
		<cfset boxCount = 1>
		<cfset rowCount = ceiling(partCatImgs.recordCount/itemsPerRow)>
		<cfset totalItems = (itemsPerRow * rowCount)>
		
        <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'  & Chr(13) & Chr(10) />
        <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<title>#getCat.catName# at MaterialFlow.com</title>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., MaterialFlow.com, #getCat.catName#" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Buy #getCat.catName# through MaterialFlow.com or by calling Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="robots" content="index,follow" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" />
        <cfset includePage = includePage & Chr(13) & Chr(10) & Chr(9) & '</head>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<h1>#getCat.catName#</h1>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & '#getCat.catDesc#' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<br/><br/>' & Chr(13) & Chr(10) />
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<table align="center" width="904" cellpadding="4" cellspacing="0">' & Chr(13) & Chr(10) />
		
		<cfloop from="1" to="#rowCount#" index="i">
			<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<tr>' & Chr(13) & Chr(10) />
				<cfloop from="1" to="#itemsPerRow#" index="j">
					<cfset myLink = removeBadChars("#partCatImgs.partCatName[boxCount]#-#partCatImgs.partCatID[boxCount]#-all1")>
					
					<cfif boxCount lte partCatImgs.recordCount>
						<cfoutput>
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td align="center" style="border:1px ##CCC solid" width="254">' & Chr(13) & Chr(10) />						
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="#myLink#.php">' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h3>#partCatImgs.partCatName[boxCount]#</h3>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<img src="/#partCatImgs.tImagePath[boxCount]##partCatImgs.tImageFileName[boxCount]#" alt="#partCatImgs.Alt[boxCount]#" border="0"/><br/>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</a>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & 'Click a link below to browse by manufacturer:<br/>' & Chr(13) & Chr(10) />
														
							<cfquery name="classQuery" datasource="CMS">
								SELECT part_class.manufactID, manufactName 
								FROM part_class
								INNER JOIN part_class_link
								ON part_class.classID = part_class_link.classID
								INNER JOIN manufacturer
								ON part_class.manufactID = manufacturer.manufactID
								WHERE partCatID = #partCatImgs.partCatID[boxCount]#
							</cfquery>
							
							<cfquery name="classManufacts" dbtype="query">
								SELECT manufactID,manufactName from classQuery GROUP BY manufactID,manufactName
							</cfquery>
							
							<cfloop query="classManufacts">
								<cfset manuLink = removeBadChars("#classManufacts.manufactName#-#partCatImgs.partCatName[boxCount]#")>
								<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '&bull; <a href="#manuLink#1.php">#classManufacts.manufactName#</a><br/>' & Chr(13) & Chr(10) />
							</cfloop>						

							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</td>' & Chr(13) & Chr(10) />
						</cfoutput>
						<cfset boxCount++>
					<cfelseif boxCount lte totalItems>
						<cfoutput>
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<td align="center">' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '&nbsp;' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</td>' & Chr(13) & Chr(10) />
						</cfoutput>
						<cfset boxCount++>			
					</cfif>
				</cfloop>
			<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
		</cfloop>
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & '</table>' & Chr(13) & Chr(10) />
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />
		
		<cfset exPath = expandpath("#domainInfo.path#") >
		<cfset catFileName = removeBadChars("#getCat.catName#") >
		<cffile action="write" file="#exPath#\#catFileName#.php" output="#includePage#"/>
	</cffunction>
	
    <cffunction name="buildPartClassPage" access="remote" returntype="string" output="yes">
    <cfargument name="catID" required="yes">
	<cfargument name="domainID" required="yes">
	<cfargument name="includesPerPage" required="no" type="numeric" default="10">
		<cfquery name="domainInfo" datasource="CMS">
			SELECT * FROM domains WHERE domainID = #arguments.domainID#
		</cfquery>
		<cfquery name="catRecord" datasource="CMS">
			SELECT * FROM category
			WHERE catID = #arguments.catID#
			AND domainID = #arguments.domainID#
		</cfquery>
		<cfquery name="partCatQuery" datasource="CMS">
			SELECT * FROM part_category
			WHERE catID = #catRecord.catID#
		</cfquery>
        <cfset exPath = expandpath("#domainInfo.path#") >
        
        <cfloop query="partCatQuery">
			<cfquery name="classQuery" datasource="CMS">
				SELECT * FROM part_class
				INNER JOIN part_class_link
				ON part_class.classID = part_class_link.classID
				WHERE partCatID = #partCatQuery.partCatID#
			</cfquery>
            <cfquery name="classManufacts" dbtype="query">
            	SELECT manufactID from classQuery GROUP BY manufactID
            </cfquery>
            
            <cfloop query="classManufacts">
				<cfset i = 1>
	        	<cfset k = 0>
	        	<cfset currPage = 1>
				<cfquery name="manufactRecord" datasource="CMS">
					SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
				</cfquery>

                <cfquery name="classIncludes" dbtype="query">
                	SELECT * from classQuery WHERE manufactID = #classManufacts.manufactID#
                </cfquery>
				
				<cfset pageCount = ceiling(classIncludes.recordCount/includesPerPage)>
                <cfloop query="classIncludes">
					<cfset k++>
					<cfif i eq 1>
						<cfset phpFileName = removeBadChars("#manufactRecord.manufactName#-#partCatQuery.partCatName#") >								
		                <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<title>MaterialFlow.com - #manufactRecord.manufactName# #partCatQuery.partCatName#</title>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., MaterialFlow.com, #manufactRecord.manufactName# #partCatQuery.partCatName#" />' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Buy #manufactRecord.manufactName# #partCatQuery.partCatName# through MaterialFlow.com or by calling Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="robots" content="index,follow" />' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" />
		        		<cfset includePage = includePage & Chr(13) & Chr(10) & Chr(9) & '</head>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '<div class="main">' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<h1>#manufactRecord.manufactName# #partCatQuery.partCatName#</h1>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & '<div style="width:100%;text-align:left;padding-top:20px;padding-bottom:20px;">' & Chr(13) & Chr(10) />
						<cfif currPage eq 1>
							<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfloop from="1" to="#pageCount#" index="j">
							<cfif currPage eq j>
								<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
							</cfif>
						</cfloop> 
						<cfif currPage eq pageCount>
							<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfset includePage = includePage & '</div><br/>' & Chr(13) & Chr(10) />
		            </cfif>						              
                
                    <cfset includePage = includePage & myWriter.writeClass(classIncludes.classID) />
                    <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<br />&nbsp;<br />' & Chr(13) & Chr(10) />
					
					<cfquery name="getOptions" datasource="CMS">
						SELECT * FROM options_class_link
						WHERE classID = #classIncludes.classID#
						ORDER BY optOrder
					</cfquery>
					<cfloop query="getOptions">
						<cfset includePage = includePage & myWriter.writeOptions(getOptions.optionsID,classIncludes.classID)>
						<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<br />&nbsp;<br />' & Chr(13) & Chr(10) />
					</cfloop>

					<cfif k eq classIncludes.RecordCount or i eq includesPerPage>
						<cfset includePage = includePage & '<div style="width:100%;text-align:left;padding-bottom:20px;">&nbsp;<br />' & Chr(13) & Chr(10) />
						<cfif currPage eq 1>
							<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfloop from="1" to="#pageCount#" index="j">
							<cfif currPage eq j>
								<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
							</cfif>
						</cfloop> 
						<cfif currPage eq pageCount>
							<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
						</cfif>                
		                <cfset includePage = includePage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />
                		<cffile action="write" file="#exPath#\#phpFileName##currPage#.php" output="#includePage#"/>
						<cfset currPage++>
		                <cfset i = 1>
		            <cfelse>
		            	<cfset i++>	                
		            </cfif>
		   		</cfloop>
            </cfloop>
        </cfloop>
    	<cfreturn catRecord.catName>    
    </cffunction>

	<cffunction name="buildGenMenu" access="remote" returntype="void">
	<cfargument name="domainQuery" type="query" required="yes">
	<cfargument name="domainID" type="numeric" required="yes">
	<cfargument name="searchBoxSize" type="numeric" required="no" default="15">	
		<cfloop query="domainQuery">
			<cfquery name="catQuery" datasource="CMS">
				SELECT * FROM category
				WHERE domainID = #arguments.domainID#
				ORDER BY catOrder
			</cfquery>
	        <cfset exPath = expandpath("#domainQuery.path#") >
			
			<cfset tempPage = '<ul id="MenuBar1" class="MenuBarHorizontal">' & Chr(13) & Chr(10) />
			<cfset tempPage = tempPage & Chr(9) & '<li><a href="/index.php">Home</a></li>' & Chr(13) & Chr(10) />
			
			<cfloop query="catQuery">
				<cfset tempPage = tempPage & Chr(9) & '<li><a class="MenuBarItemSubmenu">#catQuery.catName#</a>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & '<ul>' & Chr(13) & Chr(10) />		
	 			<cfquery name="partCatQuery" datasource="CMS">
					SELECT * FROM part_category
					WHERE catID = #catQuery.catID#
					ORDER BY partCatOrder
				</cfquery>				
				<cfloop query="partCatQuery">
					<cfquery name="classQuery" datasource="CMS">
						SELECT * FROM part_class
						INNER JOIN part_class_link
						ON part_class.classID = part_class_link.classID
						WHERE partCatID = #partCatQuery.partCatID#
					</cfquery>
		            <cfquery name="classManufacts" dbtype="query">
		            	SELECT manufactID from classQuery GROUP BY manufactID
		            </cfquery>
		            <cfloop query="classManufacts">
						<cfquery name="manufactRecord" datasource="CMS">
							SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
						</cfquery>
		                <cfset linkName = removeBadChars("#manufactRecord.manufactName#-#partCatQuery.partCatName#") >
		                <cfif domainQuery.dspManu eq 1>
		                	<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<li><a href="/#linkName#1.php" title="">#manufactRecord.manufactName# #partCatQuery.partCatName#</a></li>' & Chr(13) & Chr(10) />
		                <cfelse>
		                	<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<li><a href="/#linkName#1.php" title="">#partCatQuery.partCatName#</a></li>' & Chr(13) & Chr(10) />
		                </cfif>
		            </cfloop>
				</cfloop>
	            <cfset tempPage = tempPage & Chr(9) & Chr(9) & '</ul>' & Chr(13) & Chr(10) />
	            <cfset tempPage = tempPage & Chr(9) & '</li>' & Chr(13) & Chr(10) />
			</cfloop>
			<cfif domainQuery.blog neq ''>				
				<cfset tempPage = tempPage & Chr(9) & '<li><a href="#domainQuery.blog#" target="_blank" title="">Blog</a></li>' & Chr(13) & Chr(10) />
			</cfif>
			<cfset tempPage = tempPage & '<li><a href="/contact.php" title="">Contact Us</a></li>' & Chr(13) & Chr(10) />
	    	<cfset tempPage = tempPage & '<li id="search"><!-- Google CSE Search Box Begins -->' & Chr(13) & Chr(10) />
	  		<cfset tempPage = tempPage & '<form action="http://www.#domainQuery.domainName#/search.php" id="searchbox_011471051685618562904:c38-p-9cedk" method="get" style="margin:0px;">' & Chr(13) & Chr(10) />
	    	<cfset tempPage = tempPage & '<input type="hidden" name="cx" value="011471051685618562904:c38-p-9cedk" />' & Chr(13) & Chr(10) />
	    	<cfset tempPage = tempPage & '<input type="hidden" name="cof" value="FORID:11" />' & Chr(13) & Chr(10) />
	    	<cfset tempPage = tempPage & '<input type="text" name="q" size="#searchBoxSize#" />' & Chr(13) & Chr(10) />
	    	<cfset tempPage = tempPage & '<input type="submit" name="sa" value="Go" style="font-size:10px" />' & Chr(13) & Chr(10) />
	  		<cfset tempPage = tempPage & '</form>' & Chr(13) & Chr(10) />
	  		<cfset tempPage = tempPage & '<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_011471051685618562904%3Ac38-p-9cedk"></script>' & Chr(13) & Chr(10) />
			<cfset tempPage = tempPage & '<!-- Google CSE Search Box Ends --></li>' & Chr(13) & Chr(10) />
			<cfset tempPage = tempPage & '</ul>' & Chr(13) & Chr(10) />
			
			<cffile action="write" file="#exPath#\includes\template\menu.php" output="#tempPage#"/>
		</cfloop>				
	</cffunction>

	<cffunction name="buildMFAll" access="remote" returntype="void">
    <cfargument name="catID" required="yes" type="numeric">
	<cfargument name="includesPerPage" required="no" type="numeric" default="10">
		<cfset var i = 1>
       	<cfset var k = 0>
		<cfset var j = 0>
		<cfset var manuLinks = "">
        <cfset var currPage = 0>
		
		<cfquery name="domainQuery" datasource="CMS">
			SELECT *
			FROM domains
			WHERE domainID = 1
		</cfquery>
		
		<cfquery name="partCatQuery" datasource="CMS">
			SELECT * FROM part_category
			WHERE catID = #arguments.catID#
			ORDER BY partCatName
		</cfquery>
		
        <cfset exPath = expandpath("#domainQuery.path#") >			
	    <cfset optCounter = 0>
	     
		<cfloop query="partCatQuery">
			<cfquery name="classIncludes" datasource="CMS">
				SELECT manufacturer.manufactID, manufacturer.manufactName, part_class.classID, part_class.partClassName
				FROM part_class
				INNER JOIN manufacturer
				ON part_class.manufactID = manufacturer.manufactID
				INNER JOIN part_class_link
				ON part_class.classID = part_class_link.classID
				WHERE part_class_link.partCatID = #partCatQuery.partCatID#
				ORDER BY manufacturer.manufactName, part_class.partClassName
			</cfquery>

			<cfquery name="manuList" dbtype="query">
				SELECT manufactName
				FROM classIncludes
				GROUP BY manufactName
				ORDER BY manufactName
			</cfquery>
			
			<cfset manuLinks = "">
			<cfloop query="manuList">
				<cfset myLink = removeBadChars('#manuList.manufactName#-#partCatQuery.partCatName#1')>
				<cfset manuLinks = manuLinks & '&bull;<a href="#myLink#.php">#manuList.manufactName#</a>&nbsp;&nbsp;'>
				<cfif i eq 3>
					<cfset manuLinks = manuLinks & '<br/>' & Chr(13) & Chr(10) >
					<cfset i = 1>
				<cfelseif manuList.currentRow eq manuList.RecordCount>
					<cfset manuLinks = manuLinks & '<br/>' & Chr(13) & Chr(10) >
				<cfelse>
					<cfset i++>
				</cfif>
			</cfloop>
				
        	<cfset i = 1>
        	<cfset k = 0>
        	<cfset currPage = 1>
              
			<cfset pageCount = ceiling(classIncludes.recordCount/includesPerPage)>
               <cfloop query="classIncludes">
				<cfset optCounter++>
				<cfset k++>
				<cfif i eq 1>
					<cfset phpFileName = removeBadChars("#partCatQuery.partCatName#-#partCatQuery.partCatID#-all") >
	                <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />				
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<title>#domainQuery.domainName# - All #partCatQuery.partCatName#</title>' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., #domainQuery.domainName#, Material Handling Equipment" />' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Material Flow &amp; Conveyor Systems, Inc. offers a unique approach to storage, conveyor, and material handling needs. We are a  manufacturer, importer, general contractor, and wholesaler of material handling products.  Call Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />								
	                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & '</head>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />		             
	                <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<h1>All #partCatQuery.partCatName#</h1><br/>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '#partCatQuery.partCatDesc#<br/><br/><br/>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & '<div align="center" style="width:100%; background-color: ##ffcc00;">' & Chr(13) & Chr(10) />
	             
	                <!---manufact Nav--->
	                <cfset includePage = includePage & '<h2>You are currently browsing all of our #partCatQuery.partCatName#, to browse by manufacturer click a manufacturer name below:</h2>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & '#manuLinks#' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & '</div><br/>' & Chr(13) & Chr(10) />
	                
	                <!---nav div--->
					<cfset includePage = includePage & '<div align="left" style="width:100%;float:left;">' & Chr(13) & Chr(10) />
					<cfif currPage eq 1>
						<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
					</cfif>
					<cfloop from="1" to="#pageCount#" index="j">
						<cfif currPage eq j>
							<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
						</cfif>
					</cfloop> 
					<cfif currPage eq pageCount>
						<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
					</cfif>
					<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
	            </cfif>	
	            							
				<cfset includePage = includePage & '<br/><br/>' & Chr(13) & Chr(10) />
				<!---start actual db gen code--->
				<cfset includePage = includePage & '<div id="partClass">' & Chr(13) & Chr(10) />
				<cfset includePage = includePage & '<a name="a#optCounter#"></a>' & Chr(13) & Chr(10) />
				
				<!---write the part class--->
                <cfset includePage = includePage & myWriter.newWriter(classIncludes.classID,domainQuery.phoneNumber,1) />
				<!---end part class write code--->
				
				<!---write the options--->
				<cfquery name="getOptions" datasource="CMS">
					SELECT * FROM options_class_link
					WHERE classID = #classIncludes.classID#
					ORDER BY optOrder
				</cfquery>
				
				<cfif getOptions.RecordCount gt 0>						
					<cfset includePage = includePage & Chr(9) & '<input type="image" id="showBtn#optCounter#" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''none'');" src="images/template/v-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & '<div id="option#optCounter#" style="display:none">' & Chr(13) & Chr(10) />
					
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<div class="optional-items">' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<h2>Optional items for #classIncludes.manufactName# #classIncludes.partClassName#</h2>' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
					
					<!---opt gen codes goes here--->
					<cfloop query="getOptions">
						<cfif domainQuery.phoneNumber neq "">
							<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID,domainQuery.phoneNumber)>
						<cfelse>
							<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID)>
						</cfif>
					</cfloop>
					<!---end opt gen funtions--->
					
					<cfset includePage = includePage & Chr(9) & Chr(9) & '<input type="image" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''a#optCounter#'');" src="images/template/h-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				</cfif>				
				<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
				
				<cfif k eq classIncludes.RecordCount or i eq includesPerPage>
					<cfset includePage = includePage & '<div align="left" style="width:100%;float:left;">' & Chr(13) & Chr(10) />
					<cfif currPage eq 1>
						<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
					</cfif>
					<cfloop from="1" to="#pageCount#" index="j">
						<cfif currPage eq j>
							<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
						</cfif>
					</cfloop> 
					<cfif currPage eq pageCount>
						<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
					<cfelse>
						<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
					</cfif>
					<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />											
	                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
	                <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />										
	                <cffile action="write" file="#exPath#\#phpFileName##currPage#.php" output="#includePage#"/>
	                <cfset currPage++>
	                <cfset i = 1>
	            <cfelse>
	            	<cfset i++>	                
	            </cfif>
        	</cfloop>
		</cfloop>	
	</cffunction>
			
	<cffunction name="buildGenPage" access="remote" returntype="void">
    <cfargument name="catID" required="yes" type="numeric">
	<cfargument name="domainID" required="yes" type="numeric">
	<cfargument name="domainQuery" required="yes" type="query">
	<cfargument name="includesPerPage" required="no" type="numeric" default="10">		
		<cfloop query="domainQuery">
			<cfquery name="catRecord" datasource="CMS">
				SELECT * FROM category
				WHERE catID = #arguments.catID#
				AND domainID = #arguments.domainID#
				ORDER BY catName
			</cfquery>
			<cfquery name="partCatQuery" datasource="CMS">
				SELECT * FROM part_category
				WHERE catID = #catRecord.catID#
				ORDER BY partCatName
			</cfquery>
	        <cfset exPath = expandpath("#domainQuery.path#") >			
		    <cfset optCounter = 0> 
			<cfloop query="partCatQuery">
				<cfquery name="classQuery" datasource="CMS">
					SELECT * FROM part_class
					INNER JOIN part_class_link
					ON part_class.classID = part_class_link.classID
					WHERE partCatID = #partCatQuery.partCatID#
				</cfquery>
		        <cfquery name="classManufacts" dbtype="query">
		       		SELECT manufactID from classQuery GROUP BY manufactID
		        </cfquery>
		        <cfloop query="classManufacts">
		        	<cfset i = 1>
		        	<cfset k = 0>
		        	<cfset currPage = 1>
					<cfquery name="manufactRecord" datasource="CMS">
						SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
					</cfquery>
					
	                <cfquery name="classIncludes" dbtype="query">
	                	SELECT * from classQuery 
						WHERE manufactID = #classManufacts.manufactID#
						ORDER BY partClassName
	                </cfquery>
	               
					<cfset pageCount = ceiling(classIncludes.recordCount/includesPerPage)>
	                <cfloop query="classIncludes">
						<cfset optCounter++>
						<cfset k++>
						<cfif i eq 1>
							<cfset phpFileName = removeBadChars("#manufactRecord.manufactName#-#partCatQuery.partCatName#") >
			                <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />				
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<title>#domainQuery.domainName# - #manufactRecord.manufactName# #partCatQuery.partCatName#</title>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., #domainQuery.domainName#, Material Handling Equipment" />' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Material Flow &amp; Conveyor Systems, Inc. offers a unique approach to storage, conveyor, and material handling needs. We are a  manufacturer, importer, general contractor, and wholesaler of material handling products.  Call Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />								
			                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & '</head>' & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />		             
			                <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<h1>#manufactRecord.manufactName# #partCatQuery.partCatName#</h1>' & Chr(13) & Chr(10) />
			                <!---nav div--->
							<cfset includePage = includePage & '<div align="left" style="width:100%;float:left;padding-top:20px;padding-bottom:20px;">' & Chr(13) & Chr(10) />
							<cfif currPage eq 1>
								<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
							</cfif>
							<cfloop from="1" to="#pageCount#" index="j">
								<cfif currPage eq j>
									<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
								<cfelse>
									<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
								</cfif>
							</cfloop> 
							<cfif currPage eq pageCount>
								<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
							</cfif>
							<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
			            </cfif>								
						
						<!---start actual db gen code--->
						<cfset includePage = includePage & '<div id="partClass">' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & '<a name="a#optCounter#"></a>' & Chr(13) & Chr(10) />
						
						<!---write the part class--->
						<cfif domainQuery.phoneNumber neq "">
	                    	<cfset includePage = includePage & myWriter.newWriter(classIncludes.classID,domainQuery.phoneNumber) />
						<cfelse>
							<cfset includePage = includePage & myWriter.newWriter(classIncludes.classID) />
						</cfif>
						<!---end part class write code--->
						
						<!---write the options--->
						<cfquery name="getOptions" datasource="CMS">
							SELECT * FROM options_class_link
							WHERE classID = #classIncludes.classID#
							ORDER BY optOrder
						</cfquery>
						
						<cfif getOptions.RecordCount gt 0>						
							<cfset includePage = includePage & Chr(9) & '<input type="image" id="showBtn#optCounter#" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''none'');" src="images/template/v-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & '<div id="option#optCounter#" style="display:none">' & Chr(13) & Chr(10) />
							
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<div class="optional-items">' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<h2>Optional items for #manufactRecord.manufactName# #classIncludes.partClassName#</h2>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
							
							<!---opt gen codes goes here--->
							<cfloop query="getOptions">
								<cfif domainQuery.phoneNumber neq "">
									<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID,domainQuery.phoneNumber)>
								<cfelse>
									<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID)>
								</cfif>
							</cfloop>
							<!---end opt gen funtions--->
							
							<cfset includePage = includePage & Chr(9) & Chr(9) & '<input type="image" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''a#optCounter#'');" src="images/template/h-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
							<cfset includePage = includePage & Chr(9) & '</div>' & Chr(13) & Chr(10) />
						</cfif>				
						<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
						
						<cfif k eq classIncludes.RecordCount or i eq includesPerPage>
							<cfset includePage = includePage & '<div align="left" style="width:100%;float:left;padding-bottom:20px;">' & Chr(13) & Chr(10) />
							<cfif currPage eq 1>
								<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
							</cfif>
							<cfloop from="1" to="#pageCount#" index="j">
								<cfif currPage eq j>
									<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
								<cfelse>
									<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
								</cfif>
							</cfloop> 
							<cfif currPage eq pageCount>
								<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
							</cfif>
							<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />											
			                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
			                <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />										
			                <cffile action="write" file="#exPath#\#phpFileName##currPage#.php" output="#includePage#"/>
			                <cfset currPage++>
			                <cfset i = 1>
			            <cfelse>
			            	<cfset i++>	                
			            </cfif>
		        	</cfloop>
				</cfloop>
			</cfloop>
		</cfloop>	
	</cffunction>

	<cffunction name="buildLyonPage" access="remote" returntype="void">
    <cfargument name="catID" required="yes" type="numeric">
	<cfargument name="domainID" required="yes" type="numeric">
	<cfargument name="includesPerPage" required="no" type="numeric" default="10">
		<cfquery name="domainQuery" datasource="CMS">
			SELECT *
			FROM domains
			WHERE domainID = #arguments.domainID#
		</cfquery>		
		<cfquery name="catRecord" datasource="CMS">
			SELECT * FROM category
			WHERE catID = #arguments.catID#
			AND domainID = #arguments.domainID#
			ORDER BY catName
		</cfquery>
		<cfquery name="partCatQuery" datasource="CMS">
			SELECT * FROM part_category
			WHERE catID = #catRecord.catID#
			ORDER BY partCatName
		</cfquery>
        <cfset exPath = expandpath("#domainQuery.path#") >			
	    <cfset optCounter = 0> 
		<cfloop query="partCatQuery">
			<cfquery name="classQuery" datasource="CMS">
				SELECT * FROM part_class
				INNER JOIN part_class_link
				ON part_class.classID = part_class_link.classID
				WHERE partCatID = #partCatQuery.partCatID#
			</cfquery>
	        <cfquery name="classManufacts" dbtype="query">
	       		SELECT manufactID from classQuery GROUP BY manufactID
	        </cfquery>
	        <cfloop query="classManufacts">
	        	<cfset i = 1>
	        	<cfset k = 0>
	        	<cfset currPage = 1>
				<cfquery name="manufactRecord" datasource="CMS">
					SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
				</cfquery>
				
                <cfquery name="classIncludes" dbtype="query">
                	SELECT * from classQuery 
					WHERE manufactID = #classManufacts.manufactID#
					ORDER BY partClassName
                </cfquery>
               
				<cfset pageCount = ceiling(classIncludes.recordCount/includesPerPage)>
                <cfloop query="classIncludes">
					<cfset optCounter++>
					<cfset k++>
					<cfif i eq 1>
						<cfset phpFileName = removeBadChars("#manufactRecord.manufactName#-#partCatQuery.partCatName#") >
		                <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />				
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<title>#domainQuery.domainName# - #manufactRecord.manufactName# #partCatQuery.partCatName#</title>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., #domainQuery.domainName#, Material Handling Equipment" />' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Material Flow &amp; Conveyor Systems, Inc. offers a unique approach to storage, conveyor, and material handling needs. We are a  manufacturer, importer, general contractor, and wholesaler of material handling products.  Call Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />								
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<link href="css/style.css" rel="stylesheet" type="text/css" />' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<script type="text/javascript" src="css-js-spry/mfScript.js"></script>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<script type="text/javascript" src="css-js-spry/ibox.js"></script>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<link rel="stylesheet" href="css-js-spry/ibox.css" type="text/css" media="screen,projection" />' & Chr(13) & Chr(10) />					
						<cfset includePage = includePage & Chr(9) & '</head>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
		                <!---nav div--->
						<cfset includePage = includePage & '<div class="topNavNums">' & Chr(13) & Chr(10) />
						<cfif currPage eq 1>
							<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfloop from="1" to="#pageCount#" index="j">
							<cfif currPage eq j>
								<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
							</cfif>
						</cfloop> 
						<cfif currPage eq pageCount>
							<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<h1>#manufactRecord.manufactName# #partCatQuery.partCatName#</h1>' & Chr(13) & Chr(10) />
		            </cfif>								
					
					<!---start actual db gen code--->
					<cfset includePage = includePage & '<div class="partClass" align="left">' & Chr(13) & Chr(10) />
					<cfset includePage = includePage & '<a name="a#optCounter#"></a>' & Chr(13) & Chr(10) />
					
					<!---write the part class--->
					<cfif domainQuery.phoneNumber neq "">
                    	<cfset includePage = includePage & myWriter.newWriter(classIncludes.classID,domainQuery.phoneNumber) />
					<cfelse>
						<cfset includePage = includePage & myWriter.newWriter(classIncludes.classID) />
					</cfif>
					<!---end part class write code--->
					
					<!---write the options--->
					<cfquery name="getOptions" datasource="CMS">
						SELECT * FROM options_class_link
						WHERE classID = #classIncludes.classID#
						ORDER BY optOrder
					</cfquery>
					
					<cfif getOptions.RecordCount gt 0>
						<cfset includePage = includePage & Chr(9) & '<div class="optBtn">' & Chr(13) & Chr(10) />						
						<cfset includePage = includePage & Chr(9) & '<input type="image" id="showBtn#optCounter#" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''none'');" src="images/template/v-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & '</div>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & '<div id="option#optCounter#" class="classOptions" style="display:none">' & Chr(13) & Chr(10) />
						
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<div class="optional-items">' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<h2>Optional items for #manufactRecord.manufactName# #classIncludes.partClassName#</h2>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
						
						<!---opt gen codes goes here--->
						<cfloop query="getOptions">
							<cfif domainQuery.phoneNumber neq "">
								<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID,domainQuery.phoneNumber)>
							<cfelse>
								<cfset includePage = includePage & myWriter.newOptWriter(getOptions.optionsID)>
							</cfif>
						</cfloop>
						<!---end opt gen funtions--->
						<cfset includePage = includePage & Chr(9) & Chr(9) & '<input type="image" onclick="toggleOptions(''option#optCounter#'',''showBtn#optCounter#'',''images/template/v-options.png'',''images/template/h-options.png'',''a#optCounter#'');" src="images/template/h-options.png" class="input-buttons"/>' & Chr(13) & Chr(10) />
						<cfset includePage = includePage & Chr(9) & '</div>' & Chr(13) & Chr(10) />
					</cfif>				
					<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />
					
					<cfif k eq classIncludes.RecordCount or i eq includesPerPage>
						<cfset includePage = includePage & '<div class="navNums">' & Chr(13) & Chr(10) />
						<cfif currPage eq 1>
							<cfset includePage = includePage & '&laquo; Prev' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage-1#.php">&laquo; Prev</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfloop from="1" to="#pageCount#" index="j">
							<cfif currPage eq j>
								<cfset includePage = includePage & '#j#' & Chr(13) & Chr(10) />
							<cfelse>
								<cfset includePage = includePage & '<a href="#phpFileName##j#.php">#j#</a>' & Chr(13) & Chr(10) />
							</cfif>
						</cfloop> 
						<cfif currPage eq pageCount>
							<cfset includePage = includePage & 'Next &raquo;' & Chr(13) & Chr(10) />
						<cfelse>
							<cfset includePage = includePage & '<a href="#phpFileName##currPage+1#.php">Next &raquo;</a>' & Chr(13) & Chr(10) />
						</cfif>
						<cfset includePage = includePage & '</div>' & Chr(13) & Chr(10) />											
		                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
		                <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />										
		                <cffile action="write" file="#exPath#\#phpFileName##currPage#.php" output="#includePage#"/>
		                <cfset currPage++>
		                <cfset i = 1>
		            <cfelse>
		            	<cfset i++>	                
		            </cfif>
	        	</cfloop>
			</cfloop>
		</cfloop>	
	</cffunction>

	<cffunction name="buildLyonIndex" access="remote" returntype="void">
	<cfargument name="domainID" type="numeric" required="true">
		<cfset var tempPage = "">
		<cfset var exPath = "">
		
		<cfquery name="domainQuery" datasource="CMS">
			SELECT *
			FROM domains
			WHERE domainID = #arguments.domainID#
		</cfquery>
		
		<cfset exPath = expandpath("#domainQuery.path#") >
		
		<cfquery name="getCats" datasource="CMS">
			SELECT *
			FROM category
			WHERE domainID = #arguments.domainID#
		</cfquery>
		
		<cfquery name="getPartCats" datasource="CMS">
			SELECT *
			FROM part_category
			INNER JOIN image
			ON part_category.imageID = image.imageID
			WHERE catID = #getCats.catID#
		</cfquery>
		
        <cfset tempPage = '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & '<head>' & Chr(13) & Chr(10) />				
		<cfset tempPage = tempPage & Chr(9) & '<title>#domainQuery.domainName#</title>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., #domainQuery.domainName#, Material Handling Equipment" />' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<meta name="description" content="Material Flow &amp; Conveyor Systems, Inc. offers a unique approach to storage, conveyor, and material handling needs. We are a  manufacturer, importer, general contractor, and wholesaler of material handling products.  Call Oregon 1-800-338-1382 or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />								
		<cfset tempPage = tempPage & Chr(9) & '<link href="css/style.css" rel="stylesheet" type="text/css" />' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<script type="text/javascript" src="css-js-spry/mfScript.js"></script>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<script type="text/javascript" src="css-js-spry/ibox.js"></script>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<link rel="stylesheet" href="css-js-spry/ibox.css" type="text/css" media="screen,projection" />' & Chr(13) & Chr(10) />					
		<cfset tempPage = tempPage & '</head>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & '<body>' & Chr(13) & Chr(10) />
        <cfset tempPage = tempPage & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & '#getCats.catDesc#' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & '<table>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & '<tr>' & Chr(13) & Chr(10) />
		
		<cfloop query="getPartCats">
			<cfif getPartCats.currentRow mod 5 eq 0>
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<td>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBox">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeader">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeadText"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatName#</a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxImg"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php"><img src="#getPartCats.imagePath##getPartCats.imageFileName#" border="1" width="173" alt="#getPartCats.Alt#" /></a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxFooter">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatDesc#</a>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '</td>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & '</table>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & '<table>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & '<tr>' & Chr(13) & Chr(10) />
			<cfelseif getPartCats.currentRow eq getPartCats.recordCount>
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<td>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBox">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeader">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeadText"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatName#</a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxImg"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php"><img src="#getPartCats.imagePath##getPartCats.imageFileName#" border="1" width="173" alt="#getPartCats.Alt#" /></a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxFooter">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatDesc#</a>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '</td>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & '</tr>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & '</table>' & Chr(13) & Chr(10) />
			<cfelse>
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '<td>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBox">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeader">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxHeadText"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatName#</a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxImg"><a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php"><img src="#getPartCats.imagePath##getPartCats.imageFileName#" border="1" width="173" alt="#getPartCats.Alt#" /></a></div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="smallBoxFooter">' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<a href="lyon-#removeBadChars('#getPartCats.partCatName#')#1.php">#getPartCats.partCatDesc#</a>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
				<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '</td>' & Chr(13) & Chr(10) />
			</cfif>
		</cfloop>
		
		<cfset tempPage = tempPage & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & '</body>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & '</html>' & Chr(13) & Chr(10) />	
		                	
		<cffile action="write" file="#exPath#\index.php" output="#tempPage#"/>
	</cffunction>
		
	<cffunction name="delGenFiles" access="remote" returntype="void">
	<cfargument name="domainQuery" required="yes" type="query">
		<cfloop query="domainQuery">
			<cfset myPath = expandPath(domainQuery.path)>
			<cfdirectory action="list" directory="#myPath#" name="fileList">
			<cfloop query="fileList">
				<cfif fileList.name neq "contact.php" 
					  and fileList.name neq "delivery-methods-timing.php"
					  and fileList.name neq "index.php"
					  and fileList.name neq "search.php"
					  and fileList.name neq "privacy-policy.php"
					  and fileList.name neq "return-refund-policy.php"
					  and fileList.name neq "about-material-flow.php"
					  and fileList.name neq "freight-charges-explained.php"	
					  and fileList.name neq "robots.txt"
					  and fileList.name neq "favicon.ico"
					  and fileList.name neq "lyon-free-shipping-information.php"
					  and fileList.name neq "missing.html"
					  and fileList.name neq "google1a3e6d7953714b96.html"
					  and fileList.name neq "sitemap.xml">
					<cfif fileExists("#myPath#/#fileList.name#")>
						<cffile action="delete" file="#myPath#/#fileList.name#">
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>	
	</cffunction>
			
	<cffunction name="removeBadChars" access="remote" returntype="string">
	<cfargument name="sourceString" required="yes" type="string">
		<cfset returnString = replace("#sourceString#"," ","-","all") />
	    <cfset returnString = replace("#returnString#","\","-","all") />
	    <cfset returnString = replace("#returnString#","/","-","all") />
	    <cfset returnString = replace("#returnString#",":","-","all") />
	    <cfset returnString = replace("#returnString#","*","-","all") />
	    <cfset returnString = replace("#returnString#","?","-","all") />
	    <cfset returnString = replace("#returnString#",'"',"-","all") />
	    <cfset returnString = replace("#returnString#","<","-","all") />
	    <cfset returnString = replace("#returnString#",">","-","all") />
	    <cfset returnString = replace("#returnString#","|","-","all") />
	    <cfset returnString = replace("#returnString#",",","-","all") />
	    <cfset returnString = LCase(returnString)>
		<cfreturn returnString>
	</cffunction>
	
	<cffunction name="buildReport" access="remote" returntype="string">
	<cfargument name="domainID" required="yes" type="numeric">
		<cfset includePage = '<html>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & '<head>' & Chr(13) & Chr(10) />	
		<cfquery name="domainInfo" datasource="CMS">
			SELECT * 
			FROM domains 
			WHERE domainID = #arguments.domainID#
		</cfquery>
		<cfset includePage = includePage & '<title>Report for #domainInfo.domainName#</title>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & '</head>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & '<body>' & Chr(13) & Chr(10) />
		<cfquery name="catRecord" datasource="CMS">
			SELECT * FROM category
			WHERE domainID = #arguments.domainID#
		</cfquery>
		<cfloop query="catRecord">
			<cfset includePage = includePage & '<h1>#catRecord.catName#</h1>' & Chr(13) & Chr(10) />
			<cfquery name="partCatQuery" datasource="CMS">
				SELECT * FROM part_category
				WHERE catID = #catRecord.catID#
			</cfquery>
	        <cfset exPath = expandpath("#domainInfo.path#") >			
			<cfloop query="partCatQuery">
				<cfset includePage = includePage & '<h2>#partCatQuery.partCatName#</h2>' & Chr(13) & Chr(10) />
				<cfquery name="classQuery" datasource="CMS">
					SELECT * FROM part_class
					INNER JOIN part_class_link
					ON part_class.classID = part_class_link.classID
					WHERE partCatID = #partCatQuery.partCatID#
				</cfquery>
		        <cfquery name="classManufacts" dbtype="query">
		       		SELECT manufactID from classQuery GROUP BY manufactID
		        </cfquery>
		        <cfloop query="classManufacts">
					<cfquery name="manufactRecord" datasource="CMS">
						SELECT * FROM manufacturer WHERE manufactID = #classManufacts.manufactID#
					</cfquery>
					
	                <cfquery name="classIncludes" dbtype="query">
	                	SELECT * from classQuery WHERE manufactID = #classManufacts.manufactID#
	                </cfquery>
	                <cfloop query="classIncludes">
						<!---write the part class--->
	                    <cfset includePage = includePage & myWriter.writeClass(classIncludes.classID) />
	                    <cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<br />&nbsp;<br />' & Chr(13) & Chr(10) />
						
						<!---write the options--->
						<cfquery name="getOptions" datasource="CMS">
							SELECT * FROM options_class_link
							WHERE classID = #classIncludes.classID#
							ORDER BY optOrder
						</cfquery>
	
						<cfloop query="getOptions">
							<cfset includePage = includePage & myWriter.writeOptions(getOptions.optionsID,classIncludes.classID)>
							<cfset includePage = includePage & Chr(9) & Chr(9) & Chr(9) & '<br />&nbsp;<br />' & Chr(13) & Chr(10) />
						</cfloop>				
		        	</cfloop>
				</cfloop>
			</cfloop>
		</cfloop>
		<cfset includePage = includePage & '</body>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />
		<cffile action="write" file="#exPath#\#domainInfo.domainName#-report.php" output="#includePage#"/>
		<cfreturn includePage>
	</cffunction>
	
	<cffunction name="getSearchList" access="remote" returntype="array">
	<cfargument name="partNumber" type="string" required="yes">
		<cfset returnArray = ArrayNew(1)>
		<cfquery name="findPart" datasource="CMS">
			SELECT classID
			FROM part
			WHERE name = '#partNumber#'
			GROUP BY classID
		</cfquery>
		
		<cfif findPart.recordCount gt 0>
			<cfquery name="className" datasource="CMS">
				SELECT classID, partClassName
				FROM part_class
				WHERE classID = #findPart.classID#
			</cfquery>
			<cfset returnArray[1] = '#className#'>	
			<cfquery name="getPartCatIDs" datasource="CMS">
				SELECT *
				FROM part_class_link
				WHERE classID = #findPart.classID#
			</cfquery>
		
			<cfloop query="getPartCatIDs">
				<cfquery name="getPartCats" datasource="CMS">
					SELECT category.domainID, domains.domainName, category.catID, category.catName, part_category.partCatID, part_category.partCatName
					FROM part_category,category,domains
					WHERE part_category.partCatID = #getPartCatIDs.partCatID#
					AND category.catID = part_category.catID
					AND category.domainID = domains.domainID 
				</cfquery>
				<cfset returnArray[getPartCatIDs.currentRow + 1] = getPartCats>
			</cfloop>
		</cfif>

		<cfreturn returnArray>
	</cffunction>

	<cffunction name="buildMFManuPage" access="remote" returntype="void" output="yes">
		<cfquery name="domainInfo" datasource="CMS">
			SELECT * FROM domains WHERE domainID = 1
		</cfquery>
		
		<cfquery name="manufactQuery" datasource="CMS">
			SELECT * FROM manufacturer
		</cfquery>
		
		<cfset exPath = expandpath("#domainInfo.path#") >
		
		<cfloop query="manufactQuery">
			<cfset phpFileName = removeBadChars("#manufactQuery.manufactName#-products") >
			
	        <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<title>MaterialFlow.com - #manufactQuery.manufactName# Products</title>' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., MaterialFlow.com, #manufactQuery.manufactName# Products" />' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Buy #manufactQuery.manufactName# products through MaterialFlow.com or by calling Oregon #domainInfo.phoneNumber# or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="robots" content="index,follow" />' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" />
			<cfset includePage = includePage & Chr(13) & Chr(10) & Chr(9) & '</head>' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
	        <cfset includePage = includePage & Chr(9) & Chr(9) & '<div class="main">' & Chr(13) & Chr(10) />

			<cfset includePage = includePage & writeManufactCats(manufactQuery.manufactID)>
			
            <cfset includePage = includePage & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
            <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
			<cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
            <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
            <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />
          	<cffile action="write" file="#exPath#\#phpFileName#.php" output="#includePage#"/>			
		</cfloop>	
	</cffunction>

	<cffunction name="writeMFManuIndex" access="remote" returntype="void" output="yes">
		<cfquery name="domainInfo" datasource="CMS">
			SELECT * FROM domains WHERE domainID = 1
		</cfquery>
		
		<cfquery name="manufactQuery" datasource="CMS">
			SELECT * FROM manufacturer 
			ORDER BY manufactName
		</cfquery>
		
		<cfset exPath = expandpath("#domainInfo.path#") >
		
        <cfset includePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & '<html xmlns="http://www.w3.org/1999/xhtml">' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & '<head>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<title>MaterialFlow.com - #manufactQuery.manufactName# Products</title>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="keywords" content="Material Flow, Material Flow &amp; Conveyor Systems Inc., MaterialFlow.com, #manufactQuery.manufactName# Products" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="description" content="Buy #manufactQuery.manufactName# products through MaterialFlow.com or by calling Oregon #domainInfo.phoneNumber# or Alaska 1-877-868-3569" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & '<meta name="robots" content="index,follow" />' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & "<?php require_once('includes/template/head-meta-css-js-spry.php'); ?>" />
		<cfset includePage = includePage & Chr(13) & Chr(10) & Chr(9) & '</head>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & '<body>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-header.php'); ?>" & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<h1>MaterialFlow.com Manufacturer Index</h1>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & 'Click on a manufacturer name below to view all of their available products:<br/>' & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
		
		<cfloop query="manufactQuery">
			<cfset phpFileName = removeBadChars("#manufactQuery.manufactName#-products") >
			<cfset includePage = includePage & Chr(9) & Chr(9) & '&bull;<a href="#phpFileName#.php">#manufactQuery.manufactName#</a><br/>' & Chr(13) & Chr(10) />
		</cfloop>
		
		<cfset includePage = includePage & Chr(9) & Chr(9) & '<br/>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/global-footer.php'); ?>" & Chr(13) & Chr(10) />
		<cfset includePage = includePage & Chr(9) & Chr(9) & "<?php require_once('includes/template/googleanalytics.php'); ?>" & Chr(13) & Chr(10) />
        <cfset includePage = includePage & Chr(9) & '</body>' & Chr(13) & Chr(10) />
        <cfset includePage = includePage & '</html>' & Chr(13) & Chr(10) />
       	<cffile action="write" file="#exPath#\manufacturer-index.php" output="#includePage#"/>				
	</cffunction>
		
	<cffunction name="writeManufactCats" access="remote" returntype="string" output="yes">
	<cfargument name="manufactID" required="yes" type="numeric">
		<cfquery name="getManufacts" datasource="CMS">
			SELECT *
			FROM manufacturer
			WHERE manufactID = #arguments.manufactID#
		</cfquery>
		
		<cfquery name="getManuImg" datasource="CMS">
			SELECT *
			FROM image
			WHERE imageID = #getManufacts.imageID#
		</cfquery>
		
		<cfquery name="getCats" datasource="CMS">
			SELECT part_class_link.partCatID, part_category.partCatName
			FROM part_class_link
			INNER JOIN part_class
			ON part_class_link.classID = part_class.classID
			INNER JOIN part_category
			ON part_class_link.partCatID = part_category.partCatID
      		INNER JOIN category
     		ON category.catID = part_category.catID
			WHERE manufactID = #arguments.manufactID#
	      	AND category.domainID = 1
      		GROUP BY partCatName
		</cfquery>
		
		<cfset tempPage = Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-left">' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div id="category-mfg-photo"><img src="#getManuImg.timagePath##getManuImg.timageFileName#" alt="#getManuImg.Alt#" /></div>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<div class="global-float-right">' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<h2>#getManufacts.manufactName#</h2>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '#getManufacts.manufactDesc#' & Chr(13) & Chr(10) />
		<cfif getManufacts.manufactDesc neq "">
		    <cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
		</cfif>	
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<br />' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dl>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dt><h3>Products:</h3></dt>' & Chr(13) & Chr(10) />
		<cfloop query="getCats">
			<cfset myLink = lcase(removeBadChars(getManufacts.manufactName & '-' & getCats.partCatName))>
			<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '<dd><a href="/#myLink#1.php">#getCats.partCatName#</a></dd>' & Chr(13) & Chr(10) />
		</cfloop>
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</dl>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		<cfset tempPage = tempPage & Chr(9) & Chr(9) & Chr(9) & '</div>' & Chr(13) & Chr(10) />
		<cfreturn tempPage>	
	</cffunction>

	<cffunction name="buildSiteMap" access="remote" returntype="void" output="false" description="I write a sitemap">
	<cfargument name="domainQuery" required="true" type="query">
		<cfset var exPath = "">
		<cfloop query="arguments.domainQuery">
			<!---expand the path--->
			<cfset exPath = expandpath("#arguments.domainQuery.path#") >
			
			<!---find all php files in the dir--->
			<cfdirectory directory="#exPath#" action="list" name="phpFileInfo" filter="*.php" listinfo="name">
			
			<cfdump var="#phpFileInfo#">
			
			<!---build the xml doc--->
			<cfset xmlVar = '<?xml version="1.0" encoding="UTF-8"?>' & Chr(13) & Chr(10) />
			<cfset xmlVar = xmlVar & '<urlset'  & Chr(13) & Chr(10) &  'xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"' & Chr(13) & Chr(10) & 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' & Chr(13) & Chr(10) & 'xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9' & Chr(13) & Chr(10) & 'http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"' & Chr(13) & Chr(10) & '>'  & Chr(13) & Chr(10) />
			
			<cfloop query="phpFileInfo">
				<cfset xmlVar = xmlVar & Chr(9) & '<url>' & Chr(13) & Chr(10) />
				<cfset xmlVar = xmlVar & Chr(9) & Chr(9) &'<loc>http://www.' & lcase(arguments.domainQuery.domainName) & '/' & lcase(phpFileInfo.name) & '</loc>' & Chr(13) & Chr(10) /> 
				<cfset xmlVar = xmlVar & Chr(9) & '</url>' & Chr(13) & Chr(10) />
			</cfloop>
			
			<cfset xmlVar = xmlVar & '</urlset>'  & Chr(13) & Chr(10) />
			
			<!---write it--->
			<cffile action="write" file="#exPath#\sitemap.xml" output="#xmlVar#"/>
		</cfloop>
	</cffunction>
	
	<cffunction name="QueryToStruct" access="public" returntype="array">
	<cfargument name="sourceQry" type="query" required="true">
		<cfset var myStruct = StructNew()>
		<cfset var myQuery = arguments.sourceQry>
		<cfscript>
			
		// Define the local scope.
		myStruct.FromIndex = 1;
		myStruct.ToIndex = myQuery.RecordCount;
		
		myStruct.Columns = ListToArray( myQuery.ColumnList );
		myStruct.ColumnCount = ArrayLen( myStruct.Columns );
		
		myStruct.DataArray = ArrayNew( 1 );
		
		for (myStruct.RowIndex = myStruct.FromIndex ; myStruct.RowIndex LTE myStruct.ToIndex ; myStruct.RowIndex = (myStruct.RowIndex + 1)){
		
			ArrayAppend( myStruct.DataArray, StructNew() );
			myStruct.DataArrayIndex = ArrayLen( myStruct.DataArray );
		
			for (myStruct.ColumnIndex = 1 ; myStruct.ColumnIndex LTE myStruct.ColumnCount ; myStruct.ColumnIndex = (myStruct.ColumnIndex + 1)){
				myStruct.ColumnName = lcase(myStruct.Columns[ myStruct.ColumnIndex ]);
				myStruct.DataArray[ myStruct.DataArrayIndex ][ myStruct.ColumnName ] = myQuery[ myStruct.ColumnName ][ myStruct.RowIndex ];
			}
		}
		</cfscript>
		<cfreturn myStruct.dataArray>
	</cffunction>
	
	<cffunction name="removeHTML" output="false" returntype="string">
	<cfargument name="srcString" type="string" required="true">
	<cfargument name="strLength" type="numeric" required="false" default="0">
		<cfset var myString = arguments.srcString>
		<cfset var compChar = "">
		<cfset var cutStart = 0>
		<cfset var cutEnd = 0>
		
		<cfif len(myString) neq 0>
			<cfscript>
				compChar = myString.charAt(0);
				for(i = 0; i < myString.length(); i++){
					if(myString.charAt(i) == '<'){
						cutStart = i;
						for(j = i; j < myString.length(); j++){
							if(myString.charAt(j) == '>'){
								cutEnd = j+1;
								compChar = myString.subString(cutStart,cutEnd);
								myString = ReplaceNoCase(myString,compChar,'');
								break;
							}
						}	
					}
					
				}
			</cfscript>
		</cfif>
		
		<cfif arguments.strLength neq 0>
			<cfset myString = left(myString,arguments.strLength)>
		</cfif>
		
		<cfreturn StripCR(myString)>
	</cffunction>	
</cfcomponent>