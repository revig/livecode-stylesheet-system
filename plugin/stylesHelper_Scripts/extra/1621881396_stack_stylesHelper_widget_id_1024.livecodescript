Script "stack_stylesHelper_widget_id_1024"

/*
# Name: widget "stylesTrv" of card "styleSheetCd" of stack "stylesHelper"
# ID: widget id 1024 of card id 1002 of stack "stylesHelper"
# Widget Kind: commmunity.livecode.modbyrabit.widget.stylestreeview
*/


-- Sent when a leaf node of the tree view is double-clicked
-- pPathToNode is a comma-delimited list of keys in the underlying array
on actionDoubleClick pPathToNode
   if ("1" is among the items of pPathToNode) or (the altKey is down) or (the number of items of pPathToNode is 1) then
      showKeyBubble the clickLoc, pPathToNode, the arrayData of me
   else
      showValueBubble the clickLoc, pPathToNode
   end if
end actionDoubleClick


on dataChanged
   treeDataChanged the arrayData of me
end dataChanged


