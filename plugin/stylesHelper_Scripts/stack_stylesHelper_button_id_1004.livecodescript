Script "stack_stylesHelper_button_id_1004"

/*
# Name: button "applyStylesBtn" of card "styleSheetCd" of stack "stylesHelper"
# ID: button id 1004 of card id 1002 of stack "stylesHelper"
# Behavior: button id 1022 of stack "stylesHelper"
*/



on mouseUp pMouseButton
   if pMouseButton=3 then
      storeScript "stylesLib"
      storeScript "applyStylesHandler"
   else
      applyStyles , TRUE
   end if
end mouseUp




