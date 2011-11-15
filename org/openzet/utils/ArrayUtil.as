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
/**
 * A static class that defines methods used for an Array instance.
 **/
public class ArrayUtil
{
	include "../core/Version.as";	
	/**
	 * A static method that extracts distinct elements of an Array. This method also provides additional parameters
	 * to specify whether resulting array should be sorted descendingly or ascendingly.
	 * 
	 * @param arr An Array instance from which to extract distinct elements.
	 * @param sort A flag whether resulting array should be sorted.
	 * @param sortDescending A flag whether resulting array should be sorted in a descending way.
	 * 
	 * @result Returns a new Array instance with distinct elements extracted (and optionally sorted) from the original array.
	 **/
	public static function getDistinctElements(arr:Array, sort:Boolean = false, sortDescending:Boolean = false):Array {
		if (!arr) return null;
		var result:Array = [];
		var len:Number = arr.length;
		for (var i:int = 0; i < len; i++) {
			if (result.indexOf(arr[i]) == -1) {
				result.push(arr[i]);
			}
		}
		if (sort) {
			sortArray(result, sortDescending);				
		}
		return result;
	}
	
	/**
	 * @private
	 * 
	 * Internal static method used to sort array in a descending or ascending way.
	 **/
	private static function sortArray(arr:Array, sortDescending:Boolean = false):void {
		if (sortDescending) {
			arr.sort(Array.DESCENDING);
		} else {
			arr.sort();
		}
	}
	
}
}