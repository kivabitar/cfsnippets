<cfset cmsFunctions = createObject("component","CMS.cmsCFCs.CMSfunctions")>
<cfset exPath = expandPath('/reports')>

<cfquery name="getClasses" datasource="CMS">
    SELECT part_class.classID, part_class.partClassName, part_class.partClassDesc, manufacturer.manufactName
    FROM part_class, manufacturer
    WHERE part_class.manufactID = manufacturer.manufactID
</cfquery>

<cfset theData = ''>

<cfloop query="getClasses">
    <cfset dollarSignPoint = 0>
    <cfset decimalPoint = 0>
    <cfset thePrice = 0>
    <cfset cutCount = 0>
    <cfif getClasses.partClassDesc neq "">
        <cfset myDesc = cmsFunctions.removeHTML(getClasses.partClassDesc)>
    <cfelse>
        <cfset myDesc = "Material Flow stocks a wide variety of material handling equipment offering a huge selection of conveyors, storage rack shelving, pallet jacks, casters, steel shelving, rack systems, plastic products, cabinets, lift equipment, label holders and more. You can find products here from leading manufacturers like Lyon, Vestil, Roach Conveyors, Wesco, Stanley Vidmar, Buckhorn, Dutro, Handy, Hillman Rollers, Lewis Bins, Metro, Presto Lifts and many more. We are constantly adding more products with wholesale pricing and that make us the best place to shop for material handling equipment.">
    </cfif>
   
    <cfquery name="getImg" datasource="CMS">
        SELECT imageID,tImageFileName
        FROM part_class_images
        WHERE parentID = #classID#
        ORDER BY orderID
    </cfquery>
    <cfif getImg.recordCount gt 0>
        <cfquery name="getAttriID" datasource="CMS">
            SELECT attriID
            FROM attribute
            WHERE name = 'Price Ea.'
            AND classID = #getClasses.classID#
        </cfquery>
        <cfif getAttriID.recordCount gt 0>
            <cfquery name="getParts" datasource="CMS">
                SELECT partID,name
                FROM part
                WHERE classID = #classID#
            </cfquery>
            <cfloop query="getParts">
                <cfquery name="getPartPrice" datasource="CMS">
                    SELECT attriValue
                    FROM part_attribute
                    WHERE partID = #getParts.partID#
                    AND attriID = #getAttriID.attriID#
                </cfquery>
                <cfif getPartPrice.recordCount gt 0>
                    <cfset dollarSignPoint = find('$',getPartPrice.attriValue)>
                    <cfif dollarSignPoint neq 0>
                        <cfset decimalPoint = find('.',getPartPrice.attriValue,dollarSignPoint)>
                        <cfif decimalPoint neq 0>
                            <cfset cutCount = (decimalPoint + 2) - dollarSignPoint>
                            <cfset dollarSignPoint++>
                            <cfset thePrice = Mid(getPartPrice.attriValue,dollarSignPoint,cutCount)>
                            <cfset theData = theData & 'http://materialflow.com/index.cfm?mf=browse.showPart&partClassID=#getClasses.classID##chr(9)##getClasses.manufactName##chr(9)##getClasses.partClassName##getParts.name##chr(9)##myDesc##chr(9)#http://www.materialflow.com/global/images/part_class_images/thumbs/#getImg.tImageFileName[1]##chr(9)##thePrice##chr(9)##getParts.partID##chr(9)#new#chr(9)#Business & Industrial > Manufacturing#chr(10)##Chr(13)#'>
                        </cfif>
                    </cfif>   
                </cfif>
            </cfloop>
        </cfif>
    </cfif>
</cfloop>
<cffile action="write" file="#exPath#/froogle-feed.txt" output="link#chr(9)#brand#chr(9)#title#chr(9)#description#chr(9)#image_link#chr(9)#price#chr(9)#id#chr(9)#condition#chr(9)#product_type#chr(10)##theData#"/>
