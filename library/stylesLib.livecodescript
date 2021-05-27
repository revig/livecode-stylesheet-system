script "stylesLib"

--==================================================================--
--
-- stylesLib
--
-- Library of handlers and functions which helps to set the properties
-- of controls, groups, cards or stacks using "classes" like in CSS.
-- Use the stylesHelper plugin to create and modify CSS like stylesheets
-- in JSON format.
-- Add comma delimited "classes" like ".someClass,.anotherClass"
-- to a "uStyleSelectors" custom property of controls, groups,  cards
-- or stacks to which the styles should be applied to. Alternatively use
-- the stylesHelper plugin to add "classes" to controls, cards or stacks.
--
-- copyright 2021 revIgniter.com
--
-- Version 1.0.3
--
-- License: Apache License, Version 2.0, see http://www.apache.org/licenses/LICENSE-2.0
--
--==================================================================--




--> Library
--==================================================================--
--
-- Start using/Stop using
--

on libraryStack
   if the short name of the target = the short name of me then
      -- Put initialization stuff here:
			# NOTE DON'T LOAD STYLES HERE, USE THE stylesHelper PLUGIN WHICH ADDS
			# THE STYLESHEET FILE PATH AS A CUSTOM PROPERTY "cStylesheetPath"
			# TO THE TARGET STACK AND LOADS THE STYLESHEET
			-- syLoadStyles

      if the environment is "development" then
         answer the target & " got libraryStack message"
      end if
      --
   else
      pass libraryStack
   end if
end libraryStack


on releaseStack
   if the short name of the target = the short name of me then
      -- Put cleanup stuff here:

      if the environment is "development" then
         answer the target & " got releaseStack message"
      end if
      --
   else
      pass releaseStack
   end if
end releaseStack


--==================================================================--
--
-- Main Stuff
--

--> Declarations
local sStylesA, sOverwriteStylesheet




/*----------------------------------------------------------------------
--| COMMAND syLoadStyles
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2021-03-19
--| Last Mod: 2021-03-19
--| Requires: --
--|
--| Summary: Load style sheet in JSON format and convert it into an array.
--|
--| Format: syLoadStyles
--|
--| Parameters: string <pStylesFilePath>
--|
--| Return: empty
----------------------------------------------------------------------*/

command syLoadStyles pStylesFilePath
   local tStylesFilePath

	 if pStylesFilePath is empty then
		 answer file "Select stylesheet:"
		 put it into tStylesFilePath
	 else
		 put pStylesFilePath into tStylesFilePath
	 end if

	 put url ("file:" & tStylesFilePath) into tStylesData
	 put textEncode(tStylesData,"UTF-8") into tStylesData

		 try
			 put JSONToArray(tStylesData) into sStylesA
		 catch e
			 put empty into sStylesA
			 if "could not decode JSON" is in e then
				 answer error "Error: File is not a JSON file!"
			 else
				 answer error "Error: Failed to decode file" && tStylesFilePath && e
			 end if
		 end try
end syLoadStyles





/*----------------------------------------------------------------------
--| COMMAND syApplyStyles
--|
--| Author: rabit
--| Version:  1.2
--| Created: 2021-03-19
--| Last Mod: 2021-05-27
--| Requires: syResizeElement
--|
--| Summary: Loop through the list of selectors of a control and apply the appropriate property values.
--|
--| Format:  syApplyStyles param1
--|
--| Parameters: integer <pControlID>
--|
--| Return: empty
----------------------------------------------------------------------*/

command syApplyStyles pControlID
	local tSelectors, tSelector, tProp, tAlignment, tCurrentPropVal
  local tControlPropsA, tPropSynos

	put the uStyleSelectors of control id pControlID into tSelectors

	if tSelectors <> empty then

		# GET ALIGNMENT (LEFT, RIGHT OR CENTER)
		put empty into tAlignment
		repeat for each item tSelector in tSelectors
			if sStylesA[tSelector] is an array then
				if sStylesA[tSelector]["align"] <> empty then
					if sStylesA[tSelector]["align"] is not among the items of "left,right,center" then
						syErrorHandling "Wrong format, custom style property" && quote & "align" & quote && "could not be set!"

						put empty into sStylesA[tSelector]["align"]
						# SET FLAG TO RESAVE JSON FILE USING CURRENT VALUE
						put TRUE into sOverwriteStylesheet

					else
						put sStylesA[tSelector]["align"] into tAlignment
					end if -- if sStylesA[tSelector]["align"] is not among the items of "left,right,center"
				end if -- if sStylesA[tSelector]["align"] <> empty
			end if -- if sStylesA[tSelector] is an array
		end repeat
		##

		repeat for each item tSelector in tSelectors
			if sStylesA[tSelector] is an array then
				repeat for each key tProp in sStylesA[tSelector]
					switch tProp
						# "padding" AND "align" ARE SPECIAL CASES (CUSTOM STYLE PROPERTIES)
						case "padding"
							syResizeElement pControlID, sStylesA[tSelector]["padding"], tAlignment

						break
					default
					# SET STANDARD LIVECODE PROPERTIES
						if tProp <> "align" then

              # CHECK IF THE PROPERTY NAME IS VALID
              # EXCLUDE WIDGETS WHICH DO NOT HAVE A PROPERTIES PROPERTY
              if word 1 of the name of control id pControlID <> "widget" then
                put the properties of control id pControlID into tControlPropsA
                if tProp is not among the lines of the keys of tControlPropsA then
                  put "foregroundColor,firstcolor,textcolor,thumbcolor,fillfore,penfore,forecolor,backgroundColor,secondcolor,backcolor,width,height,loc,location,left,top,right,bottom,layer" into tPropSynos

                  if tProp is not among the items of tPropSynos then
                    delete variable sStylesA[tSelector][tProp]
                    answer warning "Invalid property name:" && quote & tProp & quote & "! Property name removed."

                    # SET FLAG TO RESAVE JSON FILE
                    put TRUE into sOverwriteStylesheet

                    next repeat
                  end if
                end if -- if tProp is not among the lines of the keys of tControlPropsA
              end if -- if word 1 of the name of control id pControlID <> "widget"

							put the tProp of control id pControlID into tCurrentPropVal

							try
								set the tProp of control id pControlID to sStylesA[tSelector][tProp]
							catch e
							# NOTE debugging
								syErrorHandling "Wrong format, property could not be set!"

								set the tProp of control id pControlID to tCurrentPropVal
								put tCurrentPropVal into sStylesA[tSelector][tProp]

								# SET FLAG TO RESAVE JSON FILE USING CURRENT VALUE
								put TRUE into sOverwriteStylesheet
							end try

						end if -- if tProp <> "align"
					end switch
				end repeat
			end if -- if sStylesA[tSelector] is an array
		end repeat
	end if
end syApplyStyles





/*----------------------------------------------------------------------
--| FUNCTION JSONToArray
--|
--| Author: LiveCode
--|
--| Summary: Parse JSON to a LiveCode array.
--|
--| Format:  JSONToArray(param1)
--|
--| Parameters: string <pJSON>
--|
--| Return: array
----------------------------------------------------------------------*/

private function JSONToArray pJSON
   local tArray,tKey

   repeat for each line tKey in mergJSONDecode(pJSON,"tArray")
      put JSONToArray(tArray[tKey]) into tArray[tKey]
   end repeat
   return tArray
end JSONToArray






/*----------------------------------------------------------------------
--| COMMAND syNewLook
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2021-03-19
--| Last Mod: 2021-03-19
--| Requires: _syApplyStylesToStackOrCard, syApplyStyles
--|
--| Summary: Apply styles to the stack or card, loop through the list of controls and apply
--|            the appropriate style properties.
--|
--| Format:  syNewLook [param1]
--|
--| Parameters: array <pStylesA> (optional)
--|
--| Return: empty
----------------------------------------------------------------------*/

command syNewLook pStylesA
	local tStackSelectors, tCardSelectors, tNumCtrls
	local tCurrentPropVal, tControlID, tCurrentCdID
   -- put the keys of sStylesA into msg ----------- selectors
   -- put the keys of sStylesA[".default"] into msg ------ properties
   -- put displayArrayData(sStylesA) into msg
   -- put displayArrayData(sStylesA[".default"]["padding"]) into msg

   if pStylesA <> empty then
      put pStylesA into sStylesA
   end if

	 put the uStyleSelectors of this stack into tStackSelectors
	 put the id of this cd into tCurrentCdID

   lock screen
	 lock messages

	 # STACK
	 if tStackSelectors <> empty then
		 put the long id of this stack into tObject
		 _syApplyStylesToStackOrCard tObject, tStackSelectors
	 end if


	 repeat with i = 1 to the number of lines of the cardIDs of this stack
		 go cd id (line i of the cardIDs of this stack)

		 put the uStyleSelectors of this cd into tCardSelectors
		 put the number of controls of this cd into tNumCtrls

		 # CARD
		 if tCardSelectors <> empty then
			 put the long id of this cd into tObject
			 _syApplyStylesToStackOrCard tObject, tCardSelectors
		 end if

		 # CONTROLS
		 repeat with tCtrl = 1 to tNumCtrls
			 put the id of control tCtrl into tControlID
			 syApplyStyles tControlID
		 end repeat

	 end repeat

	 go cd id tCurrentCdID

	 unlock messages
   unlock screen

	 # SAVE CORRECTED JSON FILE, IN CASE THE PROPERTY FORMAT WAS INCORRECT
	 if sOverwriteStylesheet is TRUE then
		 put FALSE into sOverwriteStylesheet
		if there is a stack "stylesHelper" then
			dispatch "correctionFromLib" to stack "stylesHelper" with sStylesA
		end if
	 end if
end syNewLook







/*----------------------------------------------------------------------
--| COMMAND _syApplyStylesToStackOrCard
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2021-03-19
--| Last Mod: 2021-03-19
--| Requires: --
--|
--| Summary: Apply styles to the stack or card.
--|
--| Format:  _syApplyStylesToStackOrCard param1, param2
--|
--| Parameters: array <pStylesA> (optional)
--|
--| Return: empty
----------------------------------------------------------------------*/

private command _syApplyStylesToStackOrCard pObject pSelectors
	local tSelector, tProp, tCurrentPropVal

  repeat for each item tSelector in pSelectors
     if sStylesA[tSelector] is an array then
        repeat for each key tProp in sStylesA[tSelector]
					# KEEP THE CURRENT VALUE AS A FALLBACK IN CASE THE PROPERTY FORMAT IS WRONG
					put the tProp of pObject into tCurrentPropVal
					try
						set the tProp of pObject to sStylesA[tSelector][tProp]
					catch e
			       syErrorHandling "Wrong format, property could not be set!"

						set the tProp of pObject to tCurrentPropVal
						put tCurrentPropVal into sStylesA[tSelector][tProp]

						# SET FLAG TO RESAVE JSON FILE USING CURRENT VALUE
						put TRUE into sOverwriteStylesheet
					end try
        end repeat
     end if
  end repeat
end _syApplyStylesToStackOrCard







/*----------------------------------------------------------------------
--| COMMAND syResizeElement
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2021-03-19
--| Last Mod: 2021-03-19
--| Requires: --
--|
--| Summary: Resize and align control according to padding, margin and align values.
--|
--| Format:  syResizeElement param1, param2[, param3]
--|
--| Parameters: integer <pControlID>, integer <pPadding>,
--|               string <pAlignment> left, right or center (optional)
--|
--| Return: empty
----------------------------------------------------------------------*/

command syResizeElement pControlID, pPadding, pAlignment
   local tTextSize, tMargins, tTextWidth, tRight, tLeft
   local tHorizontalPadding, tLabelShortName

   if pAlignment is empty then
      put "center" into pAlignment
   end if

	 # GET TEXT SIZE OF CONTROL
   switch word 1 of the long name of control id pControlID
      case "field"
         if the dontWrap of control id pControlID is true then
            put measureText(the text of control id pControlID, control id pControlID, "size") into tTextSize
         else

         end if

         break
      case "button"
         put measureText(the label of control id pControlID, control id pControlID, "size") into tTextSize

         break
      default
			# OTHER?
         -- default code
   end switch
	 ##

   # HORIZONTAL PADDING
   put the margins of control id pControlID into tMargins
   if tMargins <> empty then
      if (item 1 of pPadding) < tMargins then
         put tMargins into item 1 of pPadding
      end if
   end if

   put item 1 of tTextSize into tTextWidth
   put 2 * (item 1 of pPadding) into tHorizontalPadding
   ##

	 # TODO vertical padding
	 ##

	 # SET RECT OF CONTROL
   switch pAlignment
      case "right"
         put the right of control id pControlID into tRight
         put (tRight - tTextWidth) - tHorizontalPadding into tLeft

         break
      case "left"
         put the left of control id pControlID into tLeft
         put (tLeft + tTextWidth) + tHorizontalPadding into tRight

         break
      case "center"
         set the width of control id pControlID to (tTextWidth + tHorizontalPadding)
         put the right of control id pControlID into tRight
         put left of control id pControlID into tLeft

         break
      default
			# OTHER?
         syErrorHandling "Value of property" && quote & "align" & quote && "has wrong format:" && pAlignment & ". Use left, right or center."
				 exit syResizeElement
   end switch

   set the rect of control id pControlID to tLeft, the top of control id pControlID, tRight, the bottom of control id pControlID

   # ALIGN LINKED LABEL IF ANY
   if (word 1 of the long name of control id pControlID is "button") and (the uLabel of btn id pControlID <> empty) then
      put the uLabel of btn id pControlID into tLabelShortName
      if tLabelShortName <> empty then
         set the right of fld tLabelShortName to the left of btn id pControlID
      end if
   end if
end syResizeElement




/*----------------------------------------------------------------------
--| COMMAND syErrorHandling
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2021-03-25
--| Last Mod: --
--| Requires: --
--|
--| Summary: Save or display errors. Calls an optional error handling handler (log)
--|            which is not included!
--|
--| Format:  syErrorHandling param1
--|
--| Parameters: string <pError>
--|
--| Return: empty
----------------------------------------------------------------------*/

command syErrorHandling pError
   try
      log pError
   catch e
      answer pError
   end try
end syErrorHandling




--| END OF stylesLib.livecodescript
----------------------------------------------------------------------
