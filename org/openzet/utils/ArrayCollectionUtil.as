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
package org.openzet.utils
{
import mx.collections.ArrayCollection;


/**
 * A static class that defines methods used for an ArrayCollection instance.
 **/
public class ArrayCollectionUtil
{
	include "../core/Version.as";
	/**
	 * A static method that returns an ArrayCollection instance's item values by key as Array.
	 * 
	 * @param arr ArrayCollection instance from which to extract values by key.
	 * @param key Key string to extract.
	 * 
	 * @return An array of values extracted from an ArrayCollection instance. This result only has 
	 * values and no keys.
	 **/
	public static function extracItemValuesByKey(arr:ArrayCollection, key:String):Array {
		if (!arr) return null;
		var len:Number = arr.length;
		var result:Array = [];
		for (var i:Number = 0; i < len; i++) {
			result.push(arr[i][key]);
		}
		return result;
	}
	
	/**
	 * A static method that returns a new ArrayCollection instance with distinct data for a specific field.
	 * 
	 * @param arr ArrayCollection instance from which to extract dictinct items by key.
	 * @param key Key string to extract.
	 * @param sort A flag indicating whether to sort or not.
	 * 
	 * @return An arrayCollection instance with distinct data of a single dataField. 
	 **/
	public static function extractDistinctItemsByKey(arr:ArrayCollection, key:String, sort:Boolean = false):ArrayCollection {
		var items:Array = extracItemValuesByKey(arr, key);
		items = ArrayUtil.getDistinctElements(items, sort);
		var len:int = items.length;
		var result:ArrayCollection = new ArrayCollection();
		var item:Object;
		for (var i:Number = 0; i < len; i++) {
			item = {};
			item[key] = items[i];
			result.addItem(item);
		}
		return result;
	}
	
		/**
	 * A static method that sets an ArrayCollection instance's item values of a specific field as a specific value.
	 * 
	 * @param arr ArrayCollection instance to apply new values.
	 * @param key Key string to indicate the dataField.
	 * @param value New value object to apply.
	 * 
	 **/
	public static function setValuesByKey(arr:ArrayCollection, key:String, value:Object):void {
		if (arr) {
			var len:Number = arr.length;
			for (var i:int = 0; i < len; i++) {
				arr[i][key] = value;
			}
		}
	}
}
}