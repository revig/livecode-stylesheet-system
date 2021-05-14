Script "stack_stylesHelperInstaller_button_id_1005"

/*
# Name: button "btnsBehavior" of card "installationCd" of stack "stylesHelperInstaller"
# ID: button id 1005 of card id 1002 of stack "stylesHelperInstaller"
*/



local sIcons = "infoIcon,backIcon"

on mouseEnter
   if the short name of the target is not among the items of sIcons then
      set the borderColor of me to "0,190,255"
   else
      set the highlight of me to true
   end if
end mouseEnter


on mouseLeave
   if the short name of the target is not among the items of sIcons then
      set the borderColor of me to "0,110,255"
   else
      try
         set the highlight of me to false
      end try
   end if
end mouseLeave
