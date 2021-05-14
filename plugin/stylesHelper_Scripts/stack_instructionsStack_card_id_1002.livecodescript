Script "stack_instructionsStack_card_id_1002"

/*
# Name: card "instructionsCd" of stack "instructionsStack" of stack "stylesHelper"
# ID: card id 1002 of stack "instructionsStack" of stack "stylesHelper"
*/




command switchContent pEffect pElement pWhat
   local tRect
   
   put the rect of fld "chaptersListFld" into tRect
   
   set the effectRate to 1400
   lock screen for visual effect in rect tRect
   
   switch pWhat
      case "show"
         show pElement
         show widget "revealTopicsList"
         break
         
      case "hide"
         set the uSelectedTopic of this cd to empty
         hide pElement
         hide widget "revealTopicsList"
   end switch
   
   unlock screen with visual effect pEffect very fast
end switchContent
