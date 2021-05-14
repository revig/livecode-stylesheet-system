Script "stack_instructionsStack_"

/*
# Name: stack "instructionsStack" of stack "stylesHelper"
# ID: stack "instructionsStack" of stack "stylesHelper"
*/


local sLoc


on preOpenStack
   if sLoc is empty then
      set the loc of this stack to the screenloc
   else
      try
         set the loc of this stack to sLoc
      end try
   end if
end preOpenStack



on moveStack
   put the loc of this stack into sLoc
end moveStack
