Script "stack_instructionsStack_field_id_1010"

/*
# Name: field "chaptersListFld" of bkgnd "topicsListGrp" of stack "instructionsStack" of stack "stylesHelper"
# ID: field id 1010 of bkgnd id 1014 of stack "instructionsStack" of stack "stylesHelper"
*/


--on selectionChanged
--   go cd (the hilitedLine of me)
--   focus on me
--   pass selectionChanged
--end selectionChanged


on selectionChanged
   local tGrpName, tEffect, tElement, tWhat
   
   put line (the hilitedLine of me) of me into tGrpName
   put "push left" into tEffect
   put the long id of grp tGrpName into tElement
   put "show" into tWhat
   
   set the uSelectedTopic of this cd to tElement
   
   switchContent tEffect, tElement, tWhat
end selectionChanged

