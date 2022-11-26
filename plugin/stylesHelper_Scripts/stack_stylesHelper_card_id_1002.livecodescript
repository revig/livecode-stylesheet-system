Script "stack_stylesHelper_card_id_1002"

/*
# Name: card "styleSheetCd" of stack "stylesHelper"
# ID: card id 1002 of stack "stylesHelper"
*/



local sCurrentListLineNum, sSelectedControlLongName

on preOpenCard
   local tStylesFile
   
   -- if the arrayData of widget "stylesTrv" <> empty then
      set the uStylesheetPath of this stack to empty
      set the arrayData of widget "stylesTrv" to empty
   -- end if
   
   put getStyleSheet() into tStylesFile
   initStyles tStylesFile
   
   insert the script of btn "backScriptBtn" into back
end preOpenCard



on returnKey
   hideBubble
   pass returnKey
end returnKey



on enterKey
   hideBubble
   pass enterKey
end enterKey



command targetsPopup pBtn
   local tOpenStacks
   
   put the openStacks into tOpenStacks
   set the text of btn pBtn to tOpenStacks
   
   popup btn pBtn
end targetsPopup



command targetMenuPicked pChosenItem
   set the label of btn "targetBtn" to pChosenItem
   # CHECK IF stylesLib IS LOADED, IF THE uStylesheetPath OF TARGET STACK
   # IS SET, AND IF applyStyles HANDLER IS INCLUDED IN THE TARGET STACK SCRIPT
   prepareTarget pChosenItem
end targetMenuPicked



on dragEnter
   if the short name of the target is among the items of "stylesTrv,loadStylesBtn" then
      set the acceptDrop to true
   end if
end dragEnter



on dragDrop
   local tStylesFilePath
   
   if the dragData = empty then exit dragDrop -- error
   
   if the dragData["files"] is empty then -- it is text or another kind of data
      exit dragDrop
   else
      put the dragData into tStylesFilePath
      initStyles tStylesFilePath, TRUE
   end if
end dragDrop






command displaySelectorsOfControl pControlInfoA
   local tSelectorsList, tNameText, tListLineNum
   
   if pControlInfoA["selectors"] is not empty then
      repeat for each item tItem in pControlInfoA["selectors"]
         put tItem & return after tSelectorsList
      end repeat
      
      -- delete char -1 of tSelectorsList
      -- else
      -- put empty into tSelectorsList
      -- put return into tSelectorsList ------------ test
   end if
   
   put pControlInfoA["longName"] into sSelectedControlLongName
   put "Selectors of" && pControlInfoA["name"] into tNameText
   put the number of lines of tSelectorsList into tListLineNum
   
   controlSelectorsListAnim true, tListLineNum, tNameText, tSelectorsList
end displaySelectorsOfControl




command controlSelectorsListAnim pShow pListLines, pNameText, pSelectorsList
   local tEffect
   
   if (the visible of grp "controlInfoGrp") and (pShow is false) then
      put "push down" into tEffect
      _hideControlSelectorsList tEffect
      
   else if (not the visible of grp "controlInfoGrp") and (pShow is true) then
      put "push up" into tEffect
      _showControlSelectorsList pListLines, tEffect, pNameText, pSelectorsList
      
      # THE NUMBER OF SELECTORS TO DISPLAY HAS CHANGED
   else if (the visible of grp "controlInfoGrp") and (pShow is true) then
      
      -- if pListLines <> sCurrentListLineNum then
      --      if pListLines < sCurrentListLineNum then
      --         put "push down" into tEffect
      --      else
      --         put "push up" into tEffect
      --      end if
      -- end if
      
      _showControlSelectorsList pListLines, tEffect, pNameText, pSelectorsList, true
   end if
end controlSelectorsListAnim




private command _hideControlSelectorsList pEffect
   local tControlInfoGrpBottom, tGrpRect
   
   put (the height of stack "stylesHelper" - 139) into tControlInfoGrpBottom
   
   put the rect of grp "controlInfoGrp" into tGrpRect
   
   set the effectRate to 1000
   
   lock screen for visual effect in rect tGrpRect
   
   set the rect of widget "stylesTrv" to 26,72,330,tControlInfoGrpBottom
   hide grp "controlInfoGrp"
   set the hilitedLine of fld "controlSelectorsFld" to empty
   
   unlock screen with visual effect pEffect very fast
   
   put 0 into sCurrentListLineNum
end _hideControlSelectorsList




private command _showControlSelectorsList pListLines pEffect pNameText pSelectorsList pRedisplay
   local tControlInfoGrpBottom, tListHeight, tNameFldHeight, tGrpHeight
   local tGrpTop, tGrpRect, tListTop, tNameTop, tTrvBottom
   
   put pListLines into sCurrentListLineNum
   
   put (the height of stack "stylesHelper" - 139) into tControlInfoGrpBottom
   
   # MAX NUMBER OF LINES IN SELECTORS LIST = 10
   if pListLines > 10 then
      put 10 into pListLines
      set the vScrollbar of fld "controlSelectorsFld" to true
   else
      set the vScrollbar of fld "controlSelectorsFld" to false
   end if
   
   # GET RECT OF CONTROL INFO GROUP INCLUDING ONE EMPTY LIST LINE
   put (the effective textHeight of fld "controlSelectorsFld" * (pListLines + 1)) \
         + (the margins of fld "controlSelectorsFld" + 1) into tListHeight
   
   put the height of fld "controlNameFld" into tNameFldHeight
   
   put tListHeight + tNameFldHeight + 2 into tGrpHeight -- 2 = 2 * borderWidth
   put tControlInfoGrpBottom - tGrpHeight into tGrpTop
   
   put "26," & tGrpTop & ",330,573" into tGrpRect
   
   # GET TOP OF SELECTORS LIST
   put tControlInfoGrpBottom - tListHeight - 1 into tListTop -- 1 = borderWidth
   
   # GET TOP OF CONTROL NAME FIELD
   put tListTop - tNameFldHeight into tNameTop
   
   # GET BOTTOM OF TREE VIEW
   put tControlInfoGrpBottom - tGrpHeight + 1 into tTrvBottom -- 1 = borderWidth
   
   if pRedisplay then
      lock screen
   else
      set the effectRate to 1000
      lock screen for visual effect in rect tGrpRect
   end if
   
   set the text of fld "controlNameFld" of grp "controlInfoGrp" to pNameText
   set the text of fld "controlSelectorsFld" of grp "controlInfoGrp" to pSelectorsList
   
   set the top of widget "hideSelectorsIcon" to tGrpTop + 10
   
   set the rect of widget "stylesTrv" to 26,72,330,tTrvBottom
   set the rect of grp "controlInfoGrp" to tGrpRect
   set the rect of fld "controlSelectorsFld" to 27,tListTop,329,(tControlInfoGrpBottom - 1)
   set the rect of fld "controlNameFld" to 27,tNameTop,329,tListTop
   
   show grp "controlInfoGrp"
   
   
   if pRedisplay then
      unlock screen
   else
      unlock screen with visual effect pEffect very fast
   end if
end _showControlSelectorsList






command selectorsGrpClicked pTargetName
   local tSelector
   
   if pTargetName is "controlSelectorsFld" then
      
      if the visible of grp "selectorsBubbleGrp" then
         hideSelectorsBubble
      end if
      
      set the foldState of widget "stylesTrv" to empty
      
      put line (the hilitedLine of fld pTargetName) of fld pTargetName into tSelector
      set the hilitedElement of widget "stylesTrv" to tSelector
      
      set the hilitedElementFoldState of widget "stylesTrv" to "unfolded"
      set the scrollHilitedElementIntoView of widget "stylesTrv" to true
   end if
end selectorsGrpClicked




command selectorsGrpDoubleClicked pTargetName
   local tSelector
   
   if pTargetName is "controlSelectorsFld" then
      put line (the hilitedLine of fld pTargetName) of fld pTargetName into tSelector
      
      set the text of fld "bubbleFld" of grp "selectorsBubbleGrp" to tSelector
      
      _positionSelectorsBubble the clickLoc
      _showSelectorsBubble
   end if
end selectorsGrpDoubleClicked



private command _positionSelectorsBubble pClickloc
   local tBubbleLoc, tMinLeftLoc, tMaxRightLoc
   
   put pClickLoc into tBubbleLoc
   
   # KEEP THE BUBBLE WITHIN THE BOUNDARIES OF THE TREEVIEW WIDGET
   put the left of grp "controlInfoGrp" into tMinLeftLoc
   put the right of grp "controlInfoGrp" into tMaxRightLoc
   if ((item 1 of tBubbleLoc) - ((the width of grp "selectorsBubbleGrp") / 2)) < tMinLeftLoc then
      put tMinLeftLoc + ((the width of grp "selectorsBubbleGrp") / 2) into item 1 of tBubbleLoc
   end if
   
   if ((item 1 of tBubbleLoc) + ((the width of grp "selectorsBubbleGrp") / 2)) > tMaxRightLoc then
      put tMaxRightLoc - ((the width of grp "selectorsBubbleGrp") / 2) into item 1 of tBubbleLoc
   end if
   #
   
   # PLACE THE BUBBLE ABOVE THE CLICKED LINE
   put (item 2 of tBubbleLoc) - ((the height of grp "selectorsBubbleGrp") / 2) - 4 into item 2 of tBubbleLoc
   set the loc of grp "selectorsBubbleGrp" to tBubbleLoc
end _positionSelectorsBubble



private command _showSelectorsBubble
   show grp "selectorsBubbleGrp"
   select the text of fld "bubbleFld" of grp "selectorsBubbleGrp"
end _showSelectorsBubble



command hideSelectorsBubble
   hide grp "selectorsBubbleGrp"
end hideSelectorsBubble




command returnInSelectorBubble
   local tBubbleText, tPrevNumLines, tLineNum, tSelectorsList
   local tNewSelectorsList, tCurrentNumLines, tNameText
   
   hide the owner of the target
   put the text of the target into tBubbleText
   
   put the number of lines of fld "controlSelectorsFld" into tPrevNumLines
   
   put the hilitedLine of fld "controlSelectorsFld" into tLineNum
   set the text of line tLineNum of fld "controlSelectorsFld" to tBubbleText
   
   if line tLineNum of fld "controlSelectorsFld" is empty then
      delete line tLineNum of fld "controlSelectorsFld"
   end if
   
   # ADJUST CUSTOM PROPERTY uStyleSelectors OF THE SELECTED CONTROL
   put the text of fld "controlSelectorsFld" into tSelectorsList
   
   if (char -1 of the text of fld "controlSelectorsFld") is return then
      delete char -1 of tSelectorsList
   end if
   
   replace return with comma in tSelectorsList
   
   if sSelectedControlLongName <> empty then
      set the uStyleSelectors of sSelectedControlLongName to tSelectorsList
   end if
   
   
   if tSelectorsList is not empty then
      repeat for each item tItem in tSelectorsList
         put tItem & return after tNewSelectorsList
      end repeat
      
      -- else
      -- put return into tNewSelectorsList
   end if
   
   set the text of fld "controlSelectorsFld" to tNewSelectorsList
   
   put the number of lines of fld "controlSelectorsFld" into tCurrentNumLines
   
   if tCurrentNumLines <> tPrevNumLines then
      put the text of fld "controlNameFld" of grp "controlInfoGrp" into tNameText
      _showControlSelectorsList tCurrentNumLines, , tNameText, tNewSelectorsList, true
   end if
end returnInSelectorBubble






command storeScript pWhich
   local tPlugin, tScriptFile, tScriptFileDATA
   
   switch pWhich
      case "stylesLib"
         answer file "Locate the stylesLib library:"
         
         break
      case "applyStylesHandler"
         answer file "Locate the applyStyles handler:"
   end switch
   
   put it into tScriptFile
   
   if tScriptFile is empty then
      exit storeScript
   end if
   
   # STORE THE SCRIPT IN A CUSTOM PROPERTY
   put URL format("file:%s", tScriptFile) into tScriptFileDATA
   switch pWhich
      case "stylesLib"
         set the uStylesLib of stack "stylesHelper" to tScriptFileDATA
         
         break
      case "applyStylesHandler"
         set the uScriptInjection of stack "stylesHelper" to tScriptFileDATA
   end switch
end storeScript



