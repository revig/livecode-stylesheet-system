Script "stack_stylesHelper_button_id_1022"

/*
# Name: button "cBtnsBehavior" of card "styleSheetCd" of stack "stylesHelper"
# ID: button id 1022 of card id 1002 of stack "stylesHelper"
*/




on mouseEnter
   set the borderColor of me to "0,190,255"
   
   if the short name of me is "loadStylesBtn" then
      set the toolTip of me to the uStylesheetPath of this stack
   end if
end mouseEnter


on mouseLeave
   set the borderColor of me to "0,110,255"
end mouseLeave
