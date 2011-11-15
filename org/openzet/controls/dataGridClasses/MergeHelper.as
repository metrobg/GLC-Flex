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

import mx.controls.listClasses.IListItemRenderer;
import mx.utils.UIDUtil;

/**
 * A Custom Dictionary class to help merging data of a ZetDataGrid and AdvancedZetDataGrid.
 * 
 * @see org.openzet.controls.dataGridClasses.MergeItem
 **/
public dynamic class MergeHelper extends Dictionary
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
	public function MergeHelper(weakKeys:Boolean, paddingTop:Number, paddingBottom:Number, maxHeight:Number)
	{
		super(weakKeys);			
		this.paddingTop = paddingTop;
		this.paddingBottom = paddingBottom;
		this.maxHeight = maxHeight;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


	/**
	 * @private
	 * 
	 * Internal property to save a DataGrid's cachedPaddingTop value.
	 **/
	private var paddingTop:Number ;
	/**
	 * @private
	 * 
	 * Internal property to save a DataGrid's cachedPaddingBottom value.
	 **/
	private var paddingBottom:Number;
	
	/**
	 * @private
	 * 
	 * Internal property to save a DataGrid's listContent height.
	 **/
	private var maxHeight:Number;
	
	/**
	 * @private
	 * 
	 * Internal MergeItem instance that holds reference to the current item being merged.
	 **/
	private var _currentMergeItem:MergeItem;
	
	/**
	 * @private
	 * 
	 * Internal String property to indcate current dataField being merged. 
	 **/
	private var _currentDataField:String;
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 **/
	private function set currentDataField(value:String):void {
		if (!_currentDataField ||  _currentDataField != value) {
			reset();
			_currentDataField = value;
		}
	}
	
	/**
	 * @private
	 * 
	 * Internal String property to indicate current dataField where data merge is being acted.
	 **/
	private function get currentDataField():String {
		return _currentDataField;
	}
	

    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

	/**
	 * Merges item1 and item2 vertically of a given DataGridColumn. 
	 * 
	 * @param item1 Item1 to merge
	 * @parem item2 Item2 to merge
	 * @param dataField The datafield where to apply data merge  
	 * 
	 **/
	public function addMergeItem(item1:IListItemRenderer, item2:IListItemRenderer, dataField:String):void {
		currentDataField = dataField;
		mergeNextItem(item1, item2);
		
	}
	
		/**
	 * @private
	 * 
	 * Internal method to nullify current MergeItem
	 **/
	public function reset():void {
		_currentMergeItem = null;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to apply data merge. 
	 **/
	private function mergeNextItem(item1:IListItemRenderer, item2:IListItemRenderer):void {
		if (isMergeable(item1,item2)) {
			merge(item1, item2);
		} else {
			reset();
		}
	}
		
		/**
	 * @private
	 * 
	 * Internal method to indicate whether item1 and item2 are mergeable or not.
	 **/
	private function isMergeable(item1:IListItemRenderer, item2:IListItemRenderer):Boolean {
		if (item1 && item1.data && item2 && item2.data) {
			if (item1.data[currentDataField] == item2.data[currentDataField] && Object(item1).hasOwnProperty("height") && Object(item2).hasOwnProperty("height")) {
				if (!_currentMergeItem) {
					setCurrentMergeItem(item1);
				} 
				return true;
			} else {
				reset();
			}
		} else {
			reset(); 
		}
		return false;
	}
	
		/**
	 * @private
	 * 
	 * Internal method to register a given item as a current merge item.
	 **/
	private function setCurrentMergeItem(item:IListItemRenderer):void {
		
		registerMergeItem(item);
	}
	
		/**
	 * @private
	 * 
	 * Internal method to save a merge item's information such as its original y position, its unique id,
	 * its itemRenderer instance, etc. 
	 **/
	private function registerMergeItem(item:IListItemRenderer):void {
		var mergeItem:MergeItem = new MergeItem();
		mergeItem.item = item;
		mergeItem.originY = item.y;
		//trace("originY = ", mergeItem.originY);
		mergeItem.originHeight = item.height + this.paddingBottom;
		var uid:String = UIDUtil.getUID(item.data);
		this[currentDataField+uid] = mergeItem;
		_currentMergeItem = mergeItem;
		_currentMergeItem.addedHeight = 0;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to adjust itemRenderer instances' height with given information. ItemRenderer instances
	 * below other instances of the same data value give their height to those above and have their
	 * height value as zero.
	 **/
	private function merge(item1:IListItemRenderer, item2:IListItemRenderer):void {
		_currentMergeItem.addedHeight += item2.height;
		if (_currentMergeItem.addedHeight >= maxHeight) {
			_currentMergeItem.addedHeight = maxHeight;
		}
		_currentMergeItem.totalHeight = _currentMergeItem.originHeight + this.paddingTop + _currentMergeItem.addedHeight;
		item2.height = 0;
		_currentMergeItem.item.y = _currentMergeItem.originY + (_currentMergeItem.addedHeight)/2;
		_currentMergeItem.item.height = _currentMergeItem.totalHeight - (_currentMergeItem.item.y - _currentMergeItem.originY) - this.paddingTop;
	}
}
}
