package org.openzet.controls
{
import mx.controls.Tree;
import mx.core.ClassFactory;
import mx.core.mx_internal;
import mx.events.ListEvent;

use namespace mx_internal;

	/**
 *  TreeComboBox class extends ZetComboBox by implementing a Tree control as its dropdown. 
 *  This class defines selectedField property to allow users to select a single cell in a DataGrid control.
 *  
 * 
 * @see org.openzet.controls.ZetComboBox
 * 
 * @includeExample TreeComboBoxExample.mxml
 */
public class TreeComboBox extends ZetComboBox
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 * 
	 * 
	 * <p>Sets labelField property as @label since normally we provide XML data as Tree control's dataProvider.
	 * You can also go ahead and set this control's labelField whatever you want but need to make sure that
	 * you add @ character when you provide XML data as a dataProvider. </p>
	 * 
	 * <p>Also this constructor method sets dropdownFactory as that of Tree classFactory. </p>
	 **/
	public function TreeComboBox()
	{
		super();
		this.labelField = "@label";
		this.dropdownFactory = new ClassFactory(Tree);		
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Overriden method to expand all children nodes of Tree dropdown.
	 * 
	 **/
	override mx_internal function onTweenEnd(value:Number):void {
		super.onTweenEnd(value);
		if (dropdown && dropdown.dataProvider) {
			Tree(dropdown).expandChildrenOf(dropdown.dataProvider[0], true);
			Tree(dropdown).validateNow();
			dropdown.selectedIndex = dropdownSelectedIndex; 
		}
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		invalidateDisplayList();
	}
	
	override protected function dropDownItemClickHandler(event:ListEvent):void
	{
		super.dropDownItemClickHandler(event);
		invalidateProperties();
		dispatchEvent(event);
	}
	
	/**
	 * @private
	 * 
	 * Overriden method to update the display.
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		if (selectedItem) {
			textInput.text = selectedItem[this.labelField];
			textInput.invalidateDisplayList();
            textInput.validateNow();
		} 
	}
}
}