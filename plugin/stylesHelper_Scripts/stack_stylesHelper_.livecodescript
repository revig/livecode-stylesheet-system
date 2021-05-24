Script "stack_stylesHelper_"

/*
# Name: stack "stylesHelper"
# ID: stack "stylesHelper"
*/


--==================================================================--
--
-- stylesHelper
--
-- Plugin which helps to create and modify CSS like stylesheets
-- in JSON format.
-- Add comma delimited "classes" like ".someFields,.someButtons" to a
-- custom property named "uStyleSelectors" of controls, cards or stacks
-- to which the styles should be applied to. Alternatively use this
-- plugin to add "classes" to controls, cards or stacks.
--
-- ©2021 revIgniter.com
--
-- Version 1.0.2
--
-- License: Apache License, Version 2.0, see http://www.apache.org/licenses/LICENSE-2.0
--
--==================================================================--


local sStylesA -- JSON stylesheet data converted to an array
local sClickedNodeKeys -- comma delimited list of the clicked node path
local sCurrentBubble -- type of text bubble to show, key or value
local sClickedKey -- name of the clicked key
local sClickedValue -- the value of the clicked node path
local sClickedKeyParent -- name of the parent node of the clicked key
local sStylesDataChecksum -- a checksum of the stylesheet / JSON file
local sLoc -- the stack location



on preOpenStack
   if sLoc is empty then
      set the loc of this stack to the screenloc
   else
      try
         set the loc of this stack to sLoc
      end try
   end if
   
   put the short name of me && "version" && the uEMCI["version"] of me \
         into fld "versionFld" of grp "versionGrp" of cd "styleSheetCd" of me
   put the uEMCI["copyright"] of me into fld "copyrightFld" \ 
         of grp "versionGrp" of cd "styleSheetCd" of me
end preOpenStack



on moveStack
   put the loc of this stack into sLoc
end moveStack




# CHECK IF THERE IS A STACK WHICH HAS A STYLESHEET PATH PROPERTY
# GET THE PATH TO THE JSON FILE
function getStyleSheet
   local tOpenStacks, tStack, tStylesFile
   
   put the openStacks into tOpenStacks
   
   set the label of btn "loadStylesBtn" to " "
   set the text of btn "targetMenBtn" to tOpenStacks
   set the label of btn "targetBtn" to " "
   
   repeat for each line tStack in tOpenStacks
      if (the uStylesheetPath of stack tStack <> empty) and (the short name of me <> tStack) then
         answer "Would you like to select stack" && tStack && "to apply styles to it?" with "No" or "Yes"
         
         if it is "yes" then
            put the uStylesheetPath of stack tStack into tStylesFile
            set the uStylesheetPath of me to tStylesFile
            set the itemDel to "/"
            set the label of btn "loadStylesBtn" to item -1 of tStylesFile
            set the label of btn "targetBtn" to tStack
            
            exit repeat
         end if
      end if
   end repeat
   
   return tStylesFile
end getStyleSheet



# INITIALIZATION, LOAD A STYLESHEET OR CREATE ONE IF THERE IS NONE
command initStyles pStylesFile pEnforceLoad pPrepareTarget
   local tStylesFile, tSuccess
   
   # HIDE SELECTORS LIST OF SELECTED CONTROL
   dispatch "controlSelectorsListAnim" to cd "styleSheetCd" with false
   
   
   if pStylesFile is empty then
      answer "Do you want to create a new stylesheet or select an existing one?" with "Create" or "Select" or "Neither"
      
      if it is "Select" then
         answer file "Select a stylesheet (a .json file):"
         put it into tStylesFile
         
      else if it is "Create" then
         answer folder "If you like to create a new stylesheet please choose a folder:"
         
         if it <> empty then
            put it into tStylesDir
            
            if _canWriteFileTo(tStylesDir) is TRUE then
               put tStylesDir & "/styles.json" into tStylesFile
               
               if there is not a file tStylesFile then
                  _writeFile tStylesFile
                  
                  if the result is false then
                     answer error "Could not write file:" && tStylesFile
                     put empty into tStylesFile
                  end if
               end if -- if there is not a file tStylesFile
               
            else
               answer error "Folder is not writable!"
            end if -- if _canWriteFileTo(tStylesDir) is TRUE
         end if -- if it <> empty
         
      else
         put empty into tStylesFile
      end if -- if it is "Select"
      
   else
      put pStylesFile into tStylesFile
   end if -- if pStylesFile is empty
   
   if tStylesFile <> empty then
      put TRUE into tSuccess
      _loadStyles tStylesFile, pEnforceLoad, tSuccess
      
      if tSuccess then
         _displayStylesData
         
         if pPrepareTarget <> FALSE then
            prepareTarget
         end if
      end if
   end if
end initStyles
   
   
   
   
private command _loadStyles pStylesFile pEnforceLoad @pSuccess
   local tStylesFile, tStylesData
   
   if ((sStylesA is not an array) or (pEnforceLoad is TRUE)) and (pStylesFile <> empty) then
      set the itemDel to "/"
      
      put pStylesFile into tStylesFile
      
      set the uStylesheetPath of me to tStylesFile
      set the label of btn "loadStylesBtn" to item -1 of tStylesFile
      
      put url ("file:" & tStylesFile) into tStylesData
      put textEncode(tStylesData,"UTF-8") into tStylesData
      # KEEP A CHECKSUM OF THE STYLESHEET
      put messageDigest(tStylesData, "SHA-256") into sStylesDataChecksum
      
      try
         put JSONToArray(tStylesData) into sStylesA
      catch e
         put empty into sStylesA
         if "could not decode JSON" is in e then
            # DO NOT SHOW AN ERROR IF IT IS A NEW EMPTY FILE
            if tStylesData <> empty then
               answer error "Error: File is not a valid JSON file!"
               put FALSE into pSuccess
            else
               put TRUE into pSuccess
            end if
         else
            answer error "Error: Failed to decode file" && tStylesFile && e
            put FALSE into pSuccess
         end if
         
      end try
   end if -- if sStylesA is not an array
end _loadStyles
   
   
   
   
private command _displayStylesData 
   if sStylesA is an array then
      set the arrayData of widget "stylesTrv" to sStylesA
      -- log ArrayToJSON(sStylesA, , true)
   end if
end _displayStylesData
   
   
   
   
   # SHOW THE TEXT BUBBLE AND SET THE TEXT TO THE NAME OF THE CLICKED KEY
command showKeyBubble pClickLoc pPathToNode pTreeA
   put item 1 of pPathToNode into sClickedKeyParent
   put item -1 of pPathToNode into sClickedKey
   
   # SHOW BUBBLE ONLY IF A PATH TO A STYLESHEET IS DEFINED
   if (the label of btn "loadStylesBtn" <> empty) and (the label of btn "loadStylesBtn" <> " ") then
      put "key" into sCurrentBubble
      
      if "1" is among the items of pPathToNode then
         set the text of fld "bubbleFld" to "1"
      else
         set the text of fld "bubbleFld" to item -1 of pPathToNode
      end if
      
      _positionBubble pClickLoc
      _showBubble
      -- log item 1 of pPathToNode && item 2 of pPathToNode
      
   end if
end showKeyBubble
   
   
   
   
   # SHOW THE TEXT BUBBLE AND SET THE TEXT TO THE VALUE OF THE CLICKED KEY
command showValueBubble pClickLoc pPathToNode
   # SHOW BUBBLE ONLY IF A PATH TO A STYLESHEET IS DEFINED
   if (the label of btn "loadStylesBtn" <> empty) and (the label of btn "loadStylesBtn" <> " ") then
      put "value" into sCurrentBubble
      _positionBubble  pClickLoc
      
      put item -1 of pPathToNode into sClickedKey
      
      set the text of fld "bubbleFld" to _clickedValue(pPathToNode)
      
      _showBubble
   end if
end showValueBubble
   
   
   
   
   # CALCULATE THE LOCATION OF THE TEXT BUBBLE
private command _positionBubble  pClickLoc
   local tBubbleLoc, tMinLeftLoc, tMaxRightLoc
   
   put pClickLoc into tBubbleLoc
   
   # KEEP THE BUBBLE WITHIN THE BOUNDARIES OF THE TREEVIEW WIDGET
   put the left of widget "stylesTrv" into tMinLeftLoc
   put the right of widget "stylesTrv" into tMaxRightLoc
   if ((item 1 of tBubbleLoc) - ((the width of grp "bubbleGrp") / 2)) < tMinLeftLoc then
      put tMinLeftLoc + ((the width of grp "bubbleGrp") / 2) into item 1 of tBubbleLoc
   end if
   
   if ((item 1 of tBubbleLoc) + ((the width of grp "bubbleGrp") / 2)) > tMaxRightLoc then
      put tMaxRightLoc - ((the width of grp "bubbleGrp") / 2) into item 1 of tBubbleLoc
   end if
   #
   
   # PLACE THE BUBBLE ABOVE THE CLICKED LINE
   put (item 2 of tBubbleLoc) - ((the height of grp "bubbleGrp") / 2) - 4 into item 2 of tBubbleLoc
   set the loc of grp "bubbleGrp" to tBubbleLoc
end _positionBubble
   
   
   
   
   
private command _showBubble
   show grp "bubbleGrp"
   select the text of fld "bubbleFld"
end _showBubble
   
   
   
   
command hideBubble
   hide grp "bubbleGrp"
end hideBubble
   
   
   
   
   # GET THE VALUE OF THE CLICKED KEY
private function _clickedValue pPathToNode
   put pPathToNode into sClickedNodeKeys
   
   split pPathToNode by comma
   
   put TRUE into tSuccess
   _loadStyles the uStylesheetPath of me, FALSE, tSuccess
   
   if tSuccess then
      put sStylesA[pPathToNode] into sClickedValue
   else
      return "NA"
   end if
   
   return sClickedValue
end _clickedValue
   
   
   
   
   # WRITE MODIFIED STYLESHEET TO DISK AND APPLY
   # MODIFICATIONS TO THE TARGET STACK
command returnInBubble
   local tBubbleText, tTarget, tPathToNode, tStylesJSON
   
   hide the owner of the target
   put the text of the target into tBubbleText
   
   put the label of btn "targetBtn" into tTarget
   
   put sClickedNodeKeys into tPathToNode
   split tPathToNode by comma
   
   if sCurrentBubble is "value" then
      put tBubbleText into sStylesA[tPathToNode]
      # CHECK INPUT FOR CUSTOM STYLE PROPERTY
      if (sClickedKey is "align") and (tBubbleText is not among the items of "left,right,center") then
         answer error "Wrong format, custom style property" && quote & "align" & quote && "could not be set!"
         put sClickedValue into sStylesA[tPathToNode]
      end if
      
      put empty into sClickedNodeKeys
      
      -- log sStylesA[tKey1][tKey2]
      _displayStylesData
      
      put ArrayToJSON(sStylesA, , true) into tStylesJSON
      _writeStyles tStylesJSON
      -- log ArrayToJSON(sStylesA, , true)
      
      applyStyles tTarget
      
   else if sCurrentBubble is "key" then
      put ArrayToJSON(the arrayData of widget "stylesTrv", "object", true) into tStylesJSON
      
      if sClickedKeyParent <> empty then
         # GET CLASS DATA
         put lineOffset(sClickedKeyParent, tStylesJSON) into tParentNodeLine
         put lineOffset("}", tStylesJSON, tParentNodeLine) into tClosingOffset
         put tParentNodeLine + tClosingOffset into tClosingLine
         put line tParentNodeLine to tClosingLine of tStylesJSON into tCurrentClassData
         #
         put tCurrentClassData into tNewClassData
         
         # REPLACE INITIAL PROPERTY NAME OR PROPERTY NAME
         replace (quote & "1" & quote & ":") with (quote & tBubbleText & quote & ":") in tStylesJSON
         replace (quote & sClickedKey & quote & ":") with (quote & tBubbleText & quote & ":") in tNewClassData
         
         # REPLACE CLASS DATA IN JSON DATA
         replace tCurrentClassData with tNewClassData in tStylesJSON
         
      end if
      put empty into sClickedKeyParent
      put empty into sClickedKey
      put empty into sClickedValue
      
      # DO NOT ALLOW ARRAYS
      if ("[" is in tStylesJSON) then
         replace "[" with "{" in tStylesJSON
         replace "]" with "}" in tStylesJSON
         -- log tStylesJSON
      end if
      ##
      
      put JSONToArray(tStylesJSON) into sStylesA
      
      _displayStylesData
      _writeStyles tStylesJSON
   end if -- if sCurrentBubble is "value"
end returnInBubble
   
   
   
command applyStyles pTarget pCompareChecksum
   if pTarget is empty then
      put the label of btn "targetBtn" into pTarget
   end if
   
   if pCompareChecksum and (the num of chars of the label of btn "loadStylesBtn" of me > 1) then
      _compareDataChecksums
      if the result is FALSE then
         # THE JSON FILE DATA HAS CHANGED
         put the uStylesheetPath of me into tStylesFile
         initStyles tStylesFile, TRUE, FALSE
      end if
   end if
   
   if (pTarget <> empty) and (pTarget <> " ") then
      if there is a stack pTarget then
         dispatch "syNewlook" to stack pTarget with sStylesA
         
         if it <> "handled" then
            answer warning "Message was not handled! Please make sure that the target loads the stylesLib library."
            _loadStylesLibFromTemp pTarget
         end if
      end if
      
   else
      answer warning "Please select a target stack."
   end if
end applyStyles
   
   
   
# COMPARE CHECKSUM OF FILE DATA WITH CHECKSUM STORED IN A VARIABLE
private command _compareDataChecksums
   local tStylesFile, tStylesData, tFileDataChecksum
   
   put the uStylesheetPath of me into tStylesFile
   put url ("file:" & tStylesFile) into tStylesData
   put textEncode(tStylesData,"UTF-8") into tStylesData
   
   put messageDigest(tStylesData, "SHA-256") into tFileDataChecksum
   
   return (tFileDataChecksum is sStylesDataChecksum)
end _compareDataChecksums




private command _writeStyles pStylesJSON
   local tStylesFile
   
   if the uStylesheetPath of me <> empty then
      put the uStylesheetPath of me into tStylesFile
      
      put "file:" & tStylesFile into tStylesFile
      put pStylesJSON into URL tStylesFile
      
      if the result is not empty then
         answer error "Error:" && the result && tStylesFile && "(" & the sysError & ")"
         exit _writeStyles
      end if
      
      put messageDigest(pStylesJSON, "SHA-256") into sStylesDataChecksum
   end if -- if the uStylesheetPath of me <> empty
end _writeStyles
   
   
   
   
   
command treeDataChanged pArrayData
   local tStylesJSON
   
   if (the label of btn "loadStylesBtn" is empty) or (the label of btn "loadStylesBtn" is " ") then
      put empty into sStylesA
      set the arrayData of widget "stylesTrv" to empty
      initStyles
      exit treeDataChanged
   end if
   
   put ArrayToJSON(pArrayData, , true) into tStylesJSON
   -- log tStylesJSON
   
   if (quote & "1" & quote & ":" is not in tStylesJSON) and ("[" is not in tStylesJSON) then
      put pArrayData into sStylesA
      _writeStyles tStylesJSON
      
      # DO NOT ALLOW ARRAYS
   else if ("[" is in tStylesJSON) then
      replace "[" with "{" in tStylesJSON
      replace (quote & quote) with (quote & "1" & quote & ":" && quote & quote) in tStylesJSON
      replace "]" with "}" in tStylesJSON
      -- log tStylesJSON
      put JSONToArray(tStylesJSON) into sStylesA
      set the arrayData of widget "stylesTrv" to sStylesA
      _writeStyles tStylesJSON
   end if
end treeDataChanged
   
   
   
   
   # RESET STYLESHEET IF USER ENTERED INCORRECT PROPERTY VALUES
   # AS DETECTED BY THE STYLES LIBRARY
command correctionFromLib pStylesA
   local tStylesJSON
   
   put pStylesA into sStylesA
   
   put ArrayToJSON(sStylesA, , true) into tStylesJSON
   _writeStyles tStylesJSON
   _displayStylesData
end correctionFromLib




# PREPARE THE TARGET STACK, STORE / START USING THE STYLES LIBRARY,
# SET CUSTOM PROPERTY uStylesheetPath AND INJECT HANDLER applyStyles
command prepareTarget
   local tTarget, tStylesLibID, tScriptToInject, tStylesLibDir
   local tStylesLibPath, tTargetLoaded, tStylesLibOfTarget
   local tRemoteScriptTestResult, tRemoteScriptVersion
   local tVersionOfScriptToInject
   local tHandlerNotFound = FALSE
   local tScriptNeedsUpdate = FALSE
   local tStylesLibFile = ""
   
   put the label of btn "targetBtn" into tTarget
   put _targetLoaded() into tTargetLoaded
   
   # IF IN USE GET PATH TO stylesLib LIBRARY
   if "stylesLib" is among the lines of stacksInUse then
      put "inUse" into tStylesLibFile
      
      put the long ID of stack "stylesLib" into tStylesLibID
      set the itemDel to quote
      put item 2 of tStylesLibID into tStylesLibPath
   end if
   
   # CHECK IF THE uStylesLibPath OF THE TARGET IS SET
   # AND START USING STACK stylesLib
   if tTargetLoaded then
      put the uStylesLibPath of stack tTarget into tStylesLibOfTarget
      if there is a file tStylesLibOfTarget then
         if tStylesLibFile is not "inUse" then
            start using stack tStylesLibOfTarget
            put "inUse" into tStylesLibFile
         end if
         
         put tStylesLibOfTarget into tStylesLibPath
      end if -- if there is a file tStylesLibOfTarget
   end if -- if tTargetLoaded
   
   # CHECK IF stylesLib IS IN USE IN CASE THE TARGET STACK IS LOADED
   if ("stylesLib" is not among the lines of stacksInUse) and tTargetLoaded then
      answer folder "Please choose a folder to store the styles library in:"
      
      if it <> empty then
         put it into tStylesLibDir
         if _canWriteFileTo(tStylesLibDir) is TRUE then
            put tStylesLibDir & "/stylesLib.livecodescript" into tStylesLibPath
            
            if there is not a file tStylesLibPath then
               _writeFile tStylesLibPath, the uStylesLib of me
               
               if the result is false then
                  answer error "Could not write file:" && tStylesLibPath
                  
               else
                  start using stack tStylesLibPath
                  put "inUse" into tStylesLibFile
               end if
               
            else -- if there is not a file tStylesLibPath
               start using stack tStylesLibPath
               put "inUse" into tStylesLibFile
            end if -- if there is not a file tStylesLibPath
            
         else
            answer error "Folder is not writable!"
         end if -- if _canWriteFileTo(tStylesLibDir) is TRUE
         
         
      end if -- if it <> empty
      
   else
      put "inUse" into tStylesLibFile
   end if -- if "stylesLib" is not among the lines of stacksInUse
   
   # SET THE uStylesheetPath AND THE uStylesLibPath OF TARGET STACK
   # AND ADD applyStyles HANDLER TO THE TARGET STACK
   if tTargetLoaded then
      if tStylesLibFile is "inUse" then
         set the uStylesLibPath of stack tTarget to tStylesLibPath
      else
         _loadStylesLibFromTemp tTarget
      end if
      
      if the uStylesheetPath of me <> empty then
         set the uStylesheetPath of stack tTarget to the uStylesheetPath of me
         -- answer "Path to stylesheet set in custom property uStylesheetPath of the target stack."
      else if the uStylesheetPath of stack tTarget <> empty then
         set the uStylesheetPath of me to the uStylesheetPath of stack tTarget
         initStyles the uStylesheetPath of stack tTarget, , FALSE
      end if
      
      # CHECK IF applyStyles HANDLER IS INCLUDED IN THE TARGET STACK
      # AND IF IT SHOULD BE UPDATED
      put the uVersionOfScriptToInject of me into tVersionOfScriptToInject
      dispatch "applyStyles" to stack tTarget with TRUE
      put it into tRemoteScriptTestResult
      if tRemoteScriptTestResult <> "handled" then
         put TRUE into tHandlerNotFound
      else
         # INJECTED SCRIPT FOUND, CHECK VERSION
         put the result into tRemoteScriptVersion
         
         if tRemoteScriptVersion <> tVersionOfScriptToInject then
            put TRUE into tScriptNeedsUpdate
         end if
      end if
      
      if tHandlerNotFound then
         _injectScript tTarget, tVersionOfScriptToInject
      else if tScriptNeedsUpdate then
         _updateInjectedScript tTarget, tVersionOfScriptToInject
      end if
      
   end if -- if there is a stack tTarget
end prepareTarget
   
   
   
   
   
private command _injectScript pTarget pVersion
   local tScriptToInject, tVersionOfScriptToInject, tTargetScript
   
   put the uScriptInjection of me into tScriptToInject
   put quote & pVersion & quote into tVersionOfScriptToInject
   put merge(tScriptToInject) into tScriptToInject
   
   
   put the script of stack pTarget into tTargetScript
   put tTargetScript & return & return & return & tScriptToInject into tTargetScript
   set the script of stack pTarget to tTargetScript
   
   answer "applyStyles handler added to script of target stack."
end _injectScript




private command _updateInjectedScript pTarget pVersion
   local tVersionOfScriptToInject, tRemoteStackScript
   local tRemoteInjectedScriptStart, tRemoteInjectedScriptEnd
   local tRemoteScript, tScriptToInject, tScriptToInjectStart
   local tScriptToInjectEnd
   
   # GET REMOTE applyStyles HANDLER SCRIPT
   put the script of of stack pTarget into tRemoteStackScript
   put offset("command applyStyles", tRemoteStackScript) into tRemoteInjectedScriptStart
   put offset("end applyStyles", tRemoteStackScript) + 13 into tRemoteInjectedScriptEnd
   put char tRemoteInjectedScriptStart to tRemoteInjectedScriptEnd of tRemoteStackScript into tRemoteScript
   
   # GET applyStyles HANDLER SCRIPT FROM CUSTOM PROPERTY
   put the uScriptInjection of this Stack into tScriptToInject
   put offset("command applyStyles", tScriptToInject) into tScriptToInjectStart
   put offset("end applyStyles", tScriptToInject) + 13 into tScriptToInjectEnd
   put char tScriptToInjectStart to tScriptToInjectEnd of tScriptToInject into tScriptToInject
   
   # REPLACE REMOTE applyStyles HANDLER SCRIPT
   put quote & pVersion & quote into tVersionOfScriptToInject
   put merge(tScriptToInject) into tScriptToInject
   replace tRemoteScript with tScriptToInject in tRemoteStackScript
   set the script of stack pTarget to tRemoteStackScript
end _updateInjectedScript
   
   
   
   
   
private function _targetLoaded
   local tTarget
   
   put the label of btn "targetBtn" into tTarget
   return (there is a stack tTarget)
end _targetLoaded
   
   
   
   
   # IN CASE THERE IS NO STYLES LIBRARY STORE IT IN THE TEMP FOLDER
private command _loadStylesLibFromTemp pTarget
   local tStylesLibFile
   
   answer "Would you like to load the styles library from the temp folder?" with "Yes" or "Cancel"
   
   if it is "Yes" then
      set the itemDel to "/"
      put item 1 to -2 of the tempName & "/stylesLib.livecodescript" into tStylesLibFile
      
      -- if there is not a file tStylesLibFile then
      _writeFile tStylesLibFile, the uStylesLib of me
      
      if the result is false then
         answer error "Could not write file:" && tStylesLibFile
         put empty into tStylesLibFile
         
      else
         start using stack tStylesLibFile
      end if
      
      -- else
      -- start using stack tStylesLibFile
      -- end if -- if there is not a file tStylesLibFile
   end if -- if it is "Yes"
   
   if (pTarget <> empty) and (tStylesLibFile <> empty) then
      applyStyles pTarget
   end if
end _loadStylesLibFromTemp




# CHECK IF DIRECTORY IS WRITEABLE
private function _canWriteFileTo pLocation
   put pLocation & "/temp" & random(9999) into randomFileName
   open file randomFileName for write -- try creating a file
   if the result is empty then -- success!
      close file randomFileName
      delete file randomFileName -- get rid of the test file
      
      if the result is not empty then
         answer error "Error:" && the result && randomFileName && "(" & the sysError & ")"
      end if
      
      return true
      
   else
      answer error "Error:" && the result && randomFileName && "(" & the sysError & ")"
   end if
   
   # FAILED - COULDN'T CREATE A FILE THERE
   return false
end _canWriteFileTo






private command _writeFile pFile pData
   try
      put pData into URL ("file:" & pFile)
   catch err
      return FALSE
   end try
   return TRUE
end _writeFile




on log pData
   if the uDebugMode of me is TRUE then
      put return & pData after msg
   end if
end log





