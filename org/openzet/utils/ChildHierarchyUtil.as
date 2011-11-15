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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

/**
 * All static utility class that implements methods with child hierarchy.
 * 
 **/
public class ChildHierarchyUtil
{
	include "../core/Version.as";
	/**
	 * Returns whether a parent object or its children, if any, contains a specific child.
	 * 
	 * @param parent Top level parent display object from which to track down. 
	 * @param child child display object. 
	 * 
	 * @return Returns true if parent or its descendants contains child, otherwise false. 
	 * 
	 **/
	public static function contains(parent:DisplayObjectContainer, child:DisplayObject):Boolean {
		if (parent.contains(child)) {
			return true;
		}
		for (var i:int = 0; i < parent.numChildren; i++) {
			if (parent.getChildAt(i) is DisplayObjectContainer) {
				var result:Boolean = arguments.callee(DisplayObjectContainer(parent.getChildAt(i)), child)
				if (result) return result;
			}
		}
		return false; 
	}

}
}