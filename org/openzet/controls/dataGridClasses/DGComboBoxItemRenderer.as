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
package org.openzet.controls.dataGridClasses
{
import flash.events.Event;
import flash.utils.Dictionary;

import mx.controls.dataGridClasses.DataGridListData;
import mx.utils.UIDUtil;

import org.openzet.controls.DGComboBox;
import org.openzet.events.DGComboEvent;

/**
 * This class extends DGComboBox class to implement an itemRenderer for a DataGrid
 * that has a DataGrid as its dropdown. 
 * 
 **/
public class DGComboBoxItemRenderer extends DGComboBox
{
	include "../../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Internal dictionary used to track information on which item in a ComboBox has been selected.
	 * 
	 **/
	private static var dictionary:Dictionary = new Dictionary(true);
	
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function DGComboBoxItemRenderer()
	{
		super();
		this.addEventListener(DGComboEvent.SELECTED_FIELD_CHANGED, selectedFieldChangeHandler, false, 0, true);
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 **/
	override public function set data(value:Object):void {
		super.data = value;
		if (this.dropdown && this.dataProvider && this.dataProvider.length>0) {
			var item:Object = dictionary[comboUID];
			if (item) {
				this.selectedField = item.selectedField;
				this.selectedItem = item.data;
			} else {
				reset();
			}
		} else {
			reset();
		}
	}	
	
	

 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


	/**
	 * Getter method to return unique identifier. This method makes a unique identifier by combining column's dataField and data property's
	 * mx_internal_uid string.
	 **/
	public function get comboUID():String {
		var item_uid:String = UIDUtil.getUID(data);
		var result:String = columnField + item_uid;
		return result;
	}
	
	/**
	 * @private 
	 * Internal method to return column's dataField.
	 **/
	private function get columnField():String {
		return DataGridListData(this.listData).dataField;
	}
	
	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------


	/**
	 * @private
	 * Internal method to reset selectedItem and selectedField and prompt properties.
	 **/
	private function reset():void {
		this.selectedItem = null;
		this.selectedField = null;
		this.prompt = data[DataGridListData(this.listData).dataField];
	}
	

 	//--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------

	/**
	 * @private
	 * Internal hanlder method to take care of DGComboEvent.SELECTED_FIELD_CHANGED event.
	 **/
	private function selectedFieldChangeHandler(event:Event):void {
		var item:Object = {};
		item.data = this.dropdown.selectedItem;
		item.selectedField = this.selectedField;
		dictionary[comboUID] = item;
		data[DataGridListData(this.listData).dataField] = this.dropdown.selectedItem[this.selectedField];
	}
}
}