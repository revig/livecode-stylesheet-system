Script "stack_instructionsStack_widget_id_1078"

/*
# Name: widget "revealTopicsList" of card "instructionsCd" of stack "instructionsStack" of stack "stylesHelper"
# ID: widget id 1078 of card id 1002 of stack "instructionsStack" of stack "stylesHelper"
# Widget Kind: com.livecode.widget.svgpath
*/


on mouseUp
   local tEffect, tElement, tWhat
   
   put "push right" into tEffect
   put the uSelectedTopic of this cd into tElement
   put "hide" into tWhat
   
   set the hilitedLine of fld "chaptersListFld" to empty
   
   switchContent tEffect, tElement, tWhat
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
