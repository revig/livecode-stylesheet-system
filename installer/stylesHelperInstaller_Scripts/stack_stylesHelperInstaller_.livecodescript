Script "stack_stylesHelperInstaller_"

/*
# Name: stack "stylesHelperInstaller"
# ID: stack "stylesHelperInstaller"
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
   
   try
      put the uEMCI["name"] of this stack into fld "titleFld"
   end try
   
   put the short name of this stack && "version" && the uEMCI["version"] of this stack & return & \
         the uEMCI["copyright"] of this stack into fld "versionFld" of grp "versionGrp" of cd "infoCd" of this stack
   put the uEMCI["description"] of this stack into fld "descriptionFld" of cd "infoCd" of this stack
end preOpenStack



on moveStack
   put the loc of this stack into sLoc
end moveStack



command goCardVisual pCd pEffect pRect
   set the highlight of the target to FALSE
   set the effectRate to 1000
   lock screen for visual effect in rect pRect
   go cd pCd of stack "stylesHelperInstaller"
   unlock screen with visual effect pEffect very fast -- slow
end goCardVisual





