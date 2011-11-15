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
import flash.utils.Dictionary;

import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;


/**
 * Custom ItemRenderer class that implements dynamic styling feature of an AdvancedDataGridItemRenderer
 * class.
 **/
public class AdvancedBaseItemRenderer extends AdvancedDataGridItemRenderer
{
	include "../../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructore
	 **/
	public function AdvancedBaseItemRenderer()
	{
		super();	
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Internal Dictionary instance that holds information on style definitions.
	 **/
	private var styleDict:Dictionary = new Dictionary();
	
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
		if (value) {
			if (styleFunction != null) {
				applyStyle();
			}
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
	 * Internal function that is used to apply dynamic styling of an itemRenderer. 
	 **/
	private var _styleFunction:Function;
	
	/**
	 * @private
	 **/
	public function set styleFunction(value:Function):void {
		_styleFunction = value;
	}
	
	/**
	 * A property to specify an external style function. If unspecified, no style is applied to
	 * this itemRenderer. A style function should be implemented like
	 * <listing>
	 * public function styleFunc(item:Object):Object {
	 * 		if (item.A == 10) {
	 * 			return {color:'red'};
	 * 		} 
	 * 		return null;
	 * }
	 * </listing>
	 * where item is a each row item object.
	 **/
	public function get styleFunction():Function {
		return _styleFunction;
	}
	
	

    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Internal method to apply style to this itemRenderer instance. 
	 **/
	private function applyStyle():void {
		var result:Object = styleFunction(data);
		var prop:String;
		for (prop in styleDict) {
			this.setStyle(prop, styleDict[prop]);
		}
		var init:Boolean = styleDict?true:false;
		if (result) {
			for (prop in result) {
				styleDict[prop] = this.getStyle(prop);
				this.setStyle(prop, result[prop]);
			}
		} 
	}

}
}