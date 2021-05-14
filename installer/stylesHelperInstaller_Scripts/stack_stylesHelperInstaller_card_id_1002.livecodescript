Script "stack_stylesHelperInstaller_card_id_1002"

/*
# Name: card "installationCd" of stack "stylesHelperInstaller"
# ID: card id 1002 of stack "stylesHelperInstaller"
*/





command storeStylesTreeViewLCE
   local tLCEfile, tLCEfileData
   
   answer file "Locate the lce file to be stored in a custom property:"
   put it into tLCEfile
   
   if tLCEfile is empty then
      exit storeStylesTreeViewLCE
   end if
   
   set itemdel to slash
   # STORE THE NAME OF THE LCE FILE IN A CUSTOM PROPERTY
   set the uLCE of stack "stylesHelperInstaller" to item -1 of tLCEfile
   
   # STORE THE STYLES TREE VIEW WIDGET IN A CUSTOM PROPERTY
   put URL format("binfile:%s", tLCEfile) into tLCEfileData
   set the uStylesTreeViewWidget of stack "stylesHelperInstaller" to tLCEfileData
end storeStylesTreeViewLCE




command storeStylesHelper
   local tPlugin
   
   answer file "Locate the stylesHelper plugin:"
   put it into tPluginFile
   
   if tPluginFile is empty then
      exit storeStylesHelper
   end if
   
   # STORE THE stylesHelper PLUGIN IN A CUSTOM PROPERTY
   put URL format("binfile:%s", tPluginFile) into tPluginFileDATA
   set the uStylesHelperPlugin of stack "stylesHelperInstaller" to tPluginFileDATA
end storeStylesHelper




command installStylesTreeViewWidget
   local tWidgetData, tWidgetName
   
   set cursor to watch
   
   put the uStylesTreeViewWidget of stack "stylesHelperInstaller" into tWidgetData
   put the uLCE of stack "stylesHelperInstaller" into tWidgetName
   put the temporary folder & tWidgetName into tTempWidgetPath
   
   # INSTALL THE STYLES TREE VIEW WIDGET
   put tWidgetData into URL("binfile:" & tTempWidgetPath)
   revIDEExtensionInstall tTempWidgetPath, "widget"
   
   wait 1 second with messages
   delete file tTempWidgetPath
   
   answer "Installed the styles tree view widget."
end installStylesTreeViewWidget




command installStylesHelperPlugin
   local tPluginData, tPluginPath
   
   # INSTALL THE stylesHelper PLUGIN
   put the uStylesHelperPlugin of stack "stylesHelperInstaller" into tPluginData
   put revEnvironmentUserPluginsPath() & "/" & the uPluginName of stack "stylesHelperInstaller" into tPluginPath
   
   _installerWriteFile tPluginPath, tPluginData
   
   if the result is TRUE then
      answer "Installed the stylesHelper plugin. Please quit and restart LiveCode." with "Cancel" or "Quit"
      
      if it is "Quit" then
         quit
      end if
   else
      answer "Failed to install the stylesHelper plugin. Would you like to remove the styles tree view widget?." with "No" or "Yes"
      if it is "Yes" then
         _uninstallWidget TRUE
      end if
   end if
   
end installStylesHelperPlugin




command uninstallWidgetAndPlugin
   _uninstallWidget
   _uninstallPlugin
   
   answer "Uninstalled the styles tree view widget and the stylesHelper plugin. Please quit and restart LiveCode." with "Cancel" or "Quit"
   
   if it is "Quit" then
      quit
   end if
end uninstallWidgetAndPlugin




private command _uninstallWidget pQuit
   local tWidgetName
   
   # GET NAME OF STYLES TREE VIEW WIDGET
   set the itemDel to "."
   put item 1 to -5 of the uLCE of stack "stylesHelperInstaller" into tWidgetName
   
   revIDEExtensionUninstall tWidgetName
   wait 1 second with messages
   
   if pQuit is TRUE then
      answer "Uninstalled the styles tree view widget. Please quit and restart LiveCode." with "Cancel" or "Quit"
      
      if it is "Quit" then
         quit
      end if
   end if
end _uninstallWidget




private command _uninstallPlugin pQuit
   local tPluginData, tPluginPath
   
   # UNINSTALL THE stylesHelper PLUGIN
   put the uStylesHelperPlugin of stack "stylesHelperInstaller" into tPluginData
   put revEnvironmentUserPluginsPath() & "/" & the uPluginName of stack "stylesHelperInstaller" into tPluginPath
   
   delete file tPluginPath
   
   if pQuit is TRUE then
      answer "Uninstalled the stylesHelper plugin. Please quit and restart LiveCode." with "Cancel" or "Quit"
      
      if it is "Quit" then
         quit
      end if
   end if
end _uninstallPlugin
   
   
   
   
private command _installerWriteFile pFile pData
   try
      put pData into URL ("binfile:" & pFile)
   catch err
      return FALSE
   end try
   return TRUE
end _installerWriteFile





