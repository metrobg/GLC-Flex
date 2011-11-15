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

import mx.controls.CheckBox;
import mx.controls.dataGridClasses.DataGridListData;
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

/**
 * CheckBox ItemRenderer class that extends CheckBox class. 
 * 
 * @see mx.controls.CheckBox
 * @see org.openzet.dataGridClasses.DataGridHeaderCheckBox
 * 
 * @includeExample DataGridCheckBoxRendererExample.mxml
 **/
public class DataGridCheckBoxRenderer extends CheckBox
{
	include "../../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------
	/**
	 * Static variable that indicates iconWidth. Default value is 14. 
	 * 
	 **/
	public static var iconWidth:Number = 14;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function DataGridCheckBoxRenderer()
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
	 */
	override public function set data(value:Object):void {
		super.data = value
		if (value && labelField) {
			this.label = value[labelField];
		}
		if (enableFunction != null) {
			this.enabled = enableFunction(value);	
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
	 * Internal variable to indicate the dataField which has label values for each CheckBox ItemRenderer instances.
	 * 
	 **/
	private var _labelField:String;
	
	/**
	 * @private
	 **/
	public function set labelField(value:String):void {
		_labelField = value;
	}
	
	/**
	 * A property to specify a dataField which has label data values for each instance. By default, this instance
	 * sets its selected value as true/false through the dataField this itemRenderer instance is being applied.
	 * Yet if you specify a labelField, you can also show specific label along with CheckBox's selected/unselected status. 
	 **/
	public function get labelField():String {
		return _labelField;
	}
	
	/**
	 * @private
	 **/
	private var _enableFunction:Function;
	
	
	/**
	 * @private
	 **/
	public function set enableFunction(value:Function):void {
		_enableFunction = value;
	}
	
	/**
	 * A flag to specify an external function to enable or disable CheckBox instance. 
	 * External enableFunction should be implemented in a way like 
	 * 
	 * <listing>
	 * public function enableFunc(item:Object):Boolean {
	 * 		if (item.A == 10) {
	 * 			return true;
	 * 		} 
	 * 		return false;
	 * }
	 * </listing>
	 *  where item is an each row item object.
	 **/
	public function get enableFunction():Function {
		return _enableFunction; 
	}
	
	
	
	/**
	 * Internal mouseClick event handler method.
	 * 
	 */		
	override protected function clickHandler(event:MouseEvent):void {
		super.clickHandler(event);
		if (data) {
			data[DataGridListData(this.listData).dataField] = event.currentTarget.selected;
		}	
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Overriden method to update current view of this itemRenderer instance.
	 * 
	 * @param unscaledWidth
	 * @param unscaledHeight
	 * 
	 */		
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var totalWidth:Number = iconWidth + this.textField.measuredWidth;
		var xPos:Number = (unscaledWidth - totalWidth)/2;
		this.currentIcon.x = xPos;
		this.textField.x = this.currentIcon.x + this.currentIcon.width;
	}
	

}
}