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

import mx.controls.ComboBox;
import mx.controls.dataGridClasses.DataGridListData;
import mx.utils.UIDUtil;


/**
 * DataGrid ComboBox itemRenderer class that implements the functionality needed for a ComboBox
 * in a DataGrid.
 */
public class DataGridComboBoxRenderer extends ComboBox
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
	public function DataGridComboBoxRenderer()
	{
		super();
		this.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
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
			var selectedItem:Object = dictionary[comboUID];
			if (selectedItem) {
				 this.selectedItem = selectedItem;
				 this.prompt = selectedItem[this.labelField];
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
	 * A getter method that returns column's datafield + mx_internal_uid of a row item object as its unique
	 * identifier.
	 * 
	 * @return unique identifier string used to track information on this itemRenderer instance. 
	 **/
	public function get comboUID():String {
		var item_uid:String = UIDUtil.getUID(data);
		var result:String = columnField + item_uid;
		return result;
	}
	
		/**
	 * A getter method that returns column's datafield
	 * 
	 * @return A column's dataField where this itemRenderer instance is applied. 
	 **/
	public function get columnField():String {
		return DataGridListData(this.listData).dataField;
	}
	
	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Internal method to reset selectedItem and prompt properties.
	 */
	private function reset():void {
		this.selectedItem = null
		if (data) {
			this.prompt =  data[DataGridListData(this.listData).dataField];
		} else {
			this.prompt = "";			
		}
	}

 	//--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
	
	
		/**
	 * @private
	 * 
	 * Internal change event handler method.
	 **/
	private function changeHandler(event:Event):void {
		var item:Object = this.selectedItem;
		dictionary[comboUID] = item;
		data[DataGridListData(this.listData).dataField] = item[this.labelField];
	}
}
}