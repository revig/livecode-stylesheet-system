Script "stack_stylesHelper_button_id_1042"

/*
# Name: button "backScriptBtn" of card "styleSheetCd" of stack "stylesHelper"
# ID: button id 1042 of card id 1002 of stack "stylesHelper"
*/




on mouseMove
   local tTargetStack, tControlNum, tLongName, tControlSytleInfoA, tName
   local tStrOffset, tNameEnd
   
   if (the environment is "development") and (the shiftKey is down) then
      -- put the uStyleSelectors of the target
      
      put the label of btn "targetBtn" of cd "styleSheetCd" of stack "stylesHelper" into tTargetStack
      put word -1 of the mouseControl into tControlNum
      
      if tControlNum <> empty then
         put the long name of control tControlNum into tLongName
         
         # CHECK IF THE TARGET IS A GROUP
         if (the controlKey is down) and ("of group" is in tLongName) then
            put (offset("of group", tLongName) + 3) into tStrOffset
            put char tStrOffset to -1 of tLongName into tLongName
         end if
         
      else
         put the long name of the target into tLongName
         
         # CHECK IF THE TARGET IS A STACK
         if the controlKey is down then
            if word 1 of tLongName is "card" then
               set the itemDel to quote
               put "stack" && quote & item -1 of tLongName & quote into tLongName
            end if
         end if
         
      end if -- if tControlNum <> empty
      
      if (there is a stack tTargetStack) and (tTargetStack is in tLongName) then
         put tLongName into tControlSytleInfoA["longName"]
         
         put offset("of", tLongName) -2 into tNameEnd
         put char 1 to tNameEnd of tLongName into tName
         replace quote with empty in tName
         
         if word 1 of tLongName is "stack" then
            # GET STACK SELECTORS
            put "stack" && tTargetStack into tControlSytleInfoA["name"]
            put the uStyleSelectors of stack tTargetStack into tControlSytleInfoA["selectors"]
            
         else
            # GET CARD, GROUP OR CONTROL SELECTORS
            put tName into tControlSytleInfoA["name"]
            put the uStyleSelectors of tLongName into tControlSytleInfoA["selectors"]
         end if
         
         dispatch "displaySelectorsOfControl" to cd "styleSheetCd" of stack "stylesHelper" with tControlSytleInfoA
      end if
      
   end if
   pass mouseMove
end mouseMove
