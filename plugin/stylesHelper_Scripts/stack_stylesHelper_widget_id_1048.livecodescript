Script "stack_stylesHelper_widget_id_1048"

/*
# Name: widget "infoIcon" of card "styleSheetCd" of stack "stylesHelper"
# ID: widget id 1048 of card id 1002 of stack "stylesHelper"
# Widget Kind: com.livecode.widget.svgpath
*/



on mouseUp
   if the shiftKey is "down" then
      toplevel "instructionsStack"
   else
      modeless "instructionsStack"
   end if
end mouseUp


on mouseEnter
   set the highlight of me to true
end mouseEnter


on mouseLeave
   set the highlight of me to false
end mouseLeave


on mouseRelease
   set the highlight of me to false
end mouseRelease
