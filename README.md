

# LiveCode stylesheet system

The LiveCode stylesheet system can be used to quickly change the appearance of an entire LiveCode stack with all its cards, groups, and controls by simply swapping "stylesheets". It includes a plugin that allows you to create or modify CSS-like stylesheets in JSON format. These "stylesheets" contain "selectors" with property-key-value pairs that specify a skin or design theme, so to speak.  



## Package content

- Installer named "stylesHelperInstaller.livecode" which is used to install the stylesHelper plugin and the Style Tree View widget which is a modified version of the LiveCode Tree View widget
- Plugin "stylesHelper.livecode"
- Style Tree View widget package
- Library "stylesLib.livecodescript"
- Script "applyStylesScript.lc", this script is added to the target stack script by the stylesHelper plugin


## Installation

There is a LiceCode stack "stylesHelperInstaller.livecode" (located in the "installer" folder) which you can use to install the stylesHelper plugin and the Style Tree View widget which is a modified version of the LiveCode Tree View widget. The Style Tree View widget is required by the plugin without which the plugin will not work.  

**Note:** The widget is not needed by standalones.  



## Instructions

### General information

The terminology around this "stylesheet" system is borrowed from CSS, the language used to describe how HTML elements should be displayed. Like in CSS there is a stylesheet, in this case a JSON file, which includes selectors (classes) and the associated key-value pairs (properties and property values).  For the "stylesheet" system to work the relevant stack needs to include the path to a "stylesheet" and the path to the stylesLib library. Also all elements like controls, groups, cards or the stack itself that are intended to be involved need a custom property named "uStyleSelectors" where selector names or selector name lists, comma delimited "classes" like ".someClass,.anotherClass", are stored. The naming of the selectors (classes) is completely arbitrary, they don't need a dot as prefix but of course they must match the selectors (classes) defined in the stylesheet. The selectors work like classes in CSS, which means that unique style properties can be applied to a specific group of elements.  

**Note:** All the mentioned custom properties are set by the stylesHelper plugin.  


### The stylesHelper plugin

#### General information

Use the stylesHelper plugin to create or edit "stylesheets", to apply styles to stacks and to add selectors (stored in custom properties) to controls, groups, cards or stacks. Of course you can create and edit "stylesheets" in a text editor as well.  

##### How to create a new stylesheet?

Provided that there is no stack loaded that is already prepared for applying styles, whenever you select the stylesHelper plugin from the Plugins menu in the IDE, a dialog pops up where you can select an existing stylesheet or create a new one. In case there is a stack that was previously prepared by the stylesHelper plugin, i.e. the stack contains a path to a stylesheet file in a custom property "uStylesheetPath", you will be asked if you would like to work with the stack in question using the provided stylesheet. You can create a new stylesheet or select an existing one at any time by clicking the button to the right of the "Styles File:" label. Creating or selecting  a stylesheet adds a "uStylesheetPath" custom property to the target stack provided that there is a target selected.  


##### How to select a stack to apply styles to?

Click the pulldown menu to the right of the "Target:" label and choose the stack to which you would like to apply styles. In case you select a stack that has not been previously prepared by the stylesHelper plugin to handle stylesheets, the following modifications are applied to the stack:  

- The stylesHelper plugin adds an "applyStyles" handler to the stack script. This handler is used to apply stylesheet data to the stack regardless of the availability of the plugin, i.e. the look and feel of a standalone can be changed by simply swapping the stylesheet and calling the "applyStyles" handler, provided the stylesLib library is loaded.
- A custom property "uStylesLibPath" is added to the stack, which contains the path to the stylesLib library stored in the directory you choose.


#### Editing a stylesheet in the Style Tree View

**Note:** Any change in the Style Tree View is immediately saved and applied to the target stack, provided that there is a target stack selected of course.  

##### How to add a new class (selector) to the stylesheet?

In the Styles Tree View, click on "Add new class". This adds a new numbered entry. Double-click the new entry, write a class name in the popover and press Enter.  


##### How to edit a class (selector) name?

As long as there are no child nodes you can double-click a class name and change the name in the popover, then press Enter.  


##### How to add a property to a class (selector)?


Click the plus icon to the right of the relevant class name. This adds a new numbered node to the class. Double-click the node, write a property name in the popover and press Enter.  


##### How to add a value to a newly created property?

Double-click the node containing the relevant property, write the value in the popover and press Enter.  


##### How to edit a property value?

 
Double-click the node containing the relevant property, change the value in the popover and press Enter.  


##### How to edit a property name?

Press the Alt key and double-click the node containing the relevant property, change the property name in the popover and press Enter.  


##### How to delete property nodes or classes (selectors)?

Click the dustbin icon to the right of the relevant property name or class name.  


##### How to swap stylesheets?

You can swap stylesheets simply by drag-dropping a stylesheet file on the Style Tree View, or click the button to the right of the "Styles File:" label and select a stylesheet file.  

**Note:** To apply the new styles to the current target stack click the "Apply Styles" button.  


#### Managing selectors (classes) in custom properties of the target stack


##### How to add selectors (classes) to a control or card?


Press the Shift key and move the pointer over the control or card in question. This causes the styleHelper plugin to open a list of selectors associated with the control or card. Double-click the empty list line, enter a name in the popover and press Enter. The styleHelper plugin then adds a custom property "uStyleSelectors" to the control, which contains all associated selectors as a comma-separated list.  


##### How to remove selectors (classes) from  a control or card?

Press the Shift key and move the pointer over the control in question. This causes the styleHelper plugin to open a list of selectors associated with the control. Double-click the selector, clear the name in the popover and press Enter.  


##### How to quickly view all properties associated with a control's selector?

Click the selector in the selectors list of the relevant control. This unfolds the node containing the associated properties in the Style Tree View widget.  


##### How to view and edit selectors (classes) of groups?

Press the Shift and Control keys and move the pointer over a control that belongs to the group in question. This causes the styleHelper plugin to open a list of selectors associated with the group. Editing the selector list is done in the same way as for controls.  



##### How to view and edit selectors (classes) of a stack?

Press the Shift and Control keys and move the pointer over a card area that is free of controls. This causes the styleHelper plugin to open a list of selectors associated with the stack. Editing the selector list is done in the same way as for controls.  



#### Editing "stylesheets" in a text editor

Provided that a target stack and a stylesheet is selected in the stylesHelper plugin, apply the styles to the target stack by clicking the "Apply Styles" button of the stylesHelper plugin after saving the stylesheet in the text editor.  


### Nonstandard properties for controls

The stylesheet system handles two nonstandard properties "padding" and "align". "Padding" is similar to "padding" as used in CSS, although there is no distinction between top, right, bottom or left. The applied value only affects the horizontal extent of the control. The other nonstandard property "align" just defines the direction of the extent. Possible values for the property "align" are "left", "right" or "center", the value for "padding" must be an integer.  




## Meta

- Version: 1.0.3  
- Web Site: <https://revigniter.com/>  
- Author:  [Ralf Bitter](mailto:rabit@revigniter.com)  



