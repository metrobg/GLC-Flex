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
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

import org.openzet.utils.ArrayCollectionUtil;


/**
 * DataGridHeaderCheckBox class is one that extends DataGridCheckBoxRenderer class and
 * provides features like selecting and unselecting all items on a certain column.
 * 
 * @see mx.controls.CheckBox
 * @see org.openzet.dataGridClasses.DataGridCheckBoxRenderer
 * 
 * @includeExample DataGridCheckBoxRendererExample.mxml
 **/
public class DataGridHeaderCheckBox extends DataGridCheckBoxRenderer
{
	
	include "../../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	public function DataGridHeaderCheckBox()
	{
		super();
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Internal data property
	 **/
	private var _data:Object;

	/**
	 * @private
	 **/
	override public function set data(value:Object):void {
		_data = value;
		if (value) {
			this.selected = value.headerText =="true"?true:false;				
		}
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	
	/**
	 * @private
	 * 
	 * Internal property used to judge whether to change selected property of a certain row item object.
	 **/
	private var _compareFunction:Function;
	
	/**
	 * @private
	 **/
	public function set compareFunction(value:Function):void {
		_compareFunction = value;
	}
	/**
	 * A property to specify an external function by which to judge whether to forcefully set specific CheckBox
	 * item's selected status or not.  A  comareFunction should be implemented like
	 * <listing>
	 * public function compareFunc(item:Object):Boolean {
	 * 		if (item.A == 10) {
	 * 			return true;
	 * 		} 
	 * 		return false;
	 * }
	 * </listing> 
	 *  where item is an each row item object.
	 **/
	public function get compareFunction():Function {
		return _compareFunction;
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Overriden method to change CheckBox itemRenderer instances' selected status of a given column.
	 **/
	override protected function clickHandler(event:MouseEvent):void {
		super.clickHandler(event);
		if (_data) {
			_data.headerText = this.selected?"true":"false";
			var dataProvider:ArrayCollection = Object(this.listData.owner).dataProvider as ArrayCollection;
			
			if (compareFunction == null) {
				ArrayCollectionUtil.setValuesByKey(dataProvider, _data.dataField, this.selected);
			} else {
				if (dataProvider) {
					var len:int = dataProvider.length;
					for (var i:int = 0; i <len; i++) {
						if (compareFunction(dataProvider[i])) {
							dataProvider[i][_data.dataField] = this.selected;
						}
					}
				}
			}
		}
	}
}
}