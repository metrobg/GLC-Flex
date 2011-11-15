////////////////////////////////////////////////////////////////////////////////
//
//  	Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//  	All Rights Reserved. 
//
//
//    	This file is part of OpenZet.
//
//    	OpenZet is free software: you can redistribute it and/or modify
//    	it under the terms of the GNU Lesser General Public License version 3 as published by
//    	the Free Software Foundation. 
//
//    	OpenZet is distributed in the hope that it will be useful,
//    	but WITHOUT ANY WARRANTY; without even the implied warranty of
//    	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    	GNU Lesser General Public License version 3 for more details.
//
//    	You should have received a copy of the GNU Lesser General Public License
//    	along with OpenZet.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////////////
package org.openzet.controls
{
	
import mx.controls.DataGrid;
import mx.core.ClassFactory;
import mx.events.ListEvent;

import org.openzet.events.DGComboEvent;

[Event(name="selectedFieldChanged", type="org.openzet.events.DGComboEvent")]
/**
 *  DGComboBox class extends ZetComboBox by implementing a DataGrid control as its dropdown. 
 *  This class defines selectedField property to allow users to select a single cell in a DataGrid control.
 *  
 * @includeExample DGComboBoxExample.mxml
 *
 */
public class DGComboBox extends ZetComboBox
{
	include "../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 * 
	 * <p>Sets its dropdownFactory as that of DataGrid.</p>
	 * 
	 **/
	public function DGComboBox()
	{
		super();
		this.dropdownFactory = new ClassFactory(DataGrid);
	}
	
 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


	/**
	 * @private
	 **/
	private var _selectedField:String;
	
	
	/**
	 * @private
	 * 
	 **/
	public function set selectedField(value:String):void {
		_selectedField = value;
	}
	
	/**
	 * Property to track which columnField has been selected when user has clicked on a specific cell.
	 **/
	public function get selectedField():String {
		return _selectedField;
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    * 
    * Overriden method to track which column has been itemClicked on.
    **/
	override protected function dropDownItemClickHandler(event:ListEvent):void 
	{
		super.dropDownItemClickHandler(event);
		var columnIndex:int = event.columnIndex;
		_selectedField = DataGrid(dropdown).columns[columnIndex].dataField;
		this.dispatchEvent(new DGComboEvent(DGComboEvent.SELECTED_FIELD_CHANGED));
		this.dispatchEvent(event);
		this.invalidateProperties();
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		invalidateDisplayList();
	}
	/**
	 * @private
	 * 
	 * Overriden method to update the display with selectedItem and selectedField properties.
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		if (selectedItem) {
			textInput.text = selectedItem[this.selectedField];
            textInput.invalidateDisplayList();
            textInput.validateNow();
		} 
	}
}
}