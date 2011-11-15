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
import flash.geom.Rectangle;

import mx.controls.listClasses.IListItemRenderer;

/**
 * Class that holds information on each merge item.
 * 
 * @see org.openzet.controls.dataGridClasses.MergeHelper
 **/
public class MergeItem
{
	include "../../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 **/
	public function MergeItem()
	{
	}
	
	/**
	 * @private
	 * Internal property to hold reference to an itemRenderer instance being merged. 
	 **/
	private var _item:IListItemRenderer;
	
	/**
	 * @private
	 */
	public function set item (value:IListItemRenderer):void {
		_item = value;
	}	
		
	/**
	 * An IListItemRenderer type of property to store an itemRenderer instance.  
	 **/
	public function get item():IListItemRenderer {
		return _item;
	}
	
	/**
	 * @private
	 * Internal property to save unique id.
	 **/
	private var _uid:String;
	
		/**
	 * @private
	 */
	public function set uid (value:String):void {
		_uid = value;
	}
	
		/**
	 * An itemRenderer instance's mx_internal_uid property.
	 **/
	public function get uid():String {
		return _uid;
	}
	
	/**
	 * @private
	 * Internal property to save total height of the merged item.
	 **/
	private var _totalHeight:Number;
	
		/**
	 * @private
	 */
	public function set totalHeight (value:Number):void {
		_totalHeight = value;
	}
	
		/**
	 * Total height of a merged itemRenderer instance. This height is only set by MergeHelper instance internally.
	 **/
	public function get totalHeight():Number {
		return _totalHeight;
	}
	
	/**
	 * @private
	 * Internal property to save original y position of the merged item.
	 **/
	private var _originY:Number;
	
	
		/**
	 * @private
	 */
	public function set originY (value:Number):void {
		_originY = value;
	}
	
		/**
	 * Original y position of a merged itemRenderer instance. Original y position of an itemRenderer instance
	 * is stored so that later we can draw rect starting from this y position no matter where we place a merged
	 * item to set its vertical alignment to center. 
	 **/
	public function get originY():Number {
		return _originY;
	}
	
		/**
	 * @private
	 * Internal property to save original height of the merged item.
	 **/
	private var _originHeight:Number;
	
	/**
	 * @private
	 */
	public function set originHeight (value:Number):void {
		_originHeight = value;
	}
	
	/**
	 * Original height property of a merged itemRenderer instance. This height is saved so that later
	 * we can figure what what height the actual itemRenderer should have. 
	 **/
	public function get originHeight():Number {
		return _originHeight;
	}
	
	/**
	 * @private
	 * Internal property to save added height of the merged item.
	 **/
	private var _addedHeight:Number;
	
		/**
	 * @private
	 */
	public function set addedHeight(value:Number):void {
		_addedHeight = value;
	}
	
		/**
	 * Height added to a merged item compared to its original height. Added height could vary depending on
	 * each row's height etc. 
	 **/
	public function get addedHeight():Number {
		return _addedHeight;
	}
	
}
}