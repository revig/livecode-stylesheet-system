Script "stack_stylesHelper_widget_id_1034"

/*
# Name: widget "hideSelectorsIcon" of group "controlInfoGrp" of card "styleSheetCd" of stack "stylesHelper"
# ID: widget id 1034 of group id 1027 of card id 1002 of stack "stylesHelper"
# Widget Kind: com.livecode.widget.svgpath
*/


on mouseEnter
   set the highlight of me to true
end mouseEnter


on mouseLeave
   set the highlight of me to false
end mouseLeave



on mouseUp
   controlSelectorsListAnim false
end mouseUp
