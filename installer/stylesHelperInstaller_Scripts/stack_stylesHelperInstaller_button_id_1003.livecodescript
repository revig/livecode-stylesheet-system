Script "stack_stylesHelperInstaller_button_id_1003"

/*
# Name: button "installBtn" of card "installationCd" of stack "stylesHelperInstaller"
# ID: button id 1003 of card id 1002 of stack "stylesHelperInstaller"
# Behavior: button id 1005 of stack "stylesHelperInstaller"
*/



on mouseUp pMouseButton
   if pMouseButton=3 then
      storeStylesTreeViewLCE
      storeStylesHelper
   else
      installStylesTreeViewWidget
      installStylesHelperPlugin
   end if
end mouseUp
