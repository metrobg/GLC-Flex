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
 * Static class that defines static methods used with regard to generic Object.
 * 
 **/
public class ObjectUtil
{
	include "../core/Version.as";
	/**
	 * Extracts a generic object's properties and returns an Array containing all of them.
	 * 
	 * @param item An object to extract properties.
	 * 
	 * @return Returns an array of properties in a generic object. 
	 **/
	public static function cloneFields(item:Object):Array {
		if (!item) return null;
		var fields:Array = [];
		for (var prop:String in item) {
			fields.push(prop);
		}
		return fields;
	}

}
}