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

import mx.core.Application;

/**
 * Static class that defines static methods used to handle PopUp instances.
 **/
public class PopUpUtil
{
	include "../core/Version.as";
	/**
	 * Removes all popUps, every single one of them. 
	 **/
	public static function removeAllPopUps():void {
		while (Application.application.systemManager.numChildren>1) {
			Application.application.systemManager.removeChildAt(1);
		}
	}
	
	/**
	 * Returns whether an instance of certain class is being popped up.
	 * 
	 * @param popUpClass Class of the possible popUp instance.
	 * 
	 * @return Returns true if any instance of the Class has been popped up, otherwise false.
	 **/
	public static function hasInstanceOf(popUpClass:Class):Boolean {
		var len:int = getPopUpCount();
		for (var i:int =0; i < len; i++) {
			if (Application.application.systemManager.getChildAt(i) is popUpClass) {
				return true;
			}
		}
		return false;
	}

		/**
	 * Returns whether a certain instance is being popped up.
	 * 
	 * @param popUp A reference to a certain instance
	 * 
	 * @return Returns true if the instance has been popped up, otherwise false.
	 **/
	public static function isPopUp(popUp:DisplayObject):Boolean {
		var len:int = getPopUpCount(); 
		for (var i:int =0; i < len; i++) {
			if (Application.application.systemManager.getChildAt(i) == popUp) {
				return true;
			}
		}
		return false;
	}
	
		/**
	 * Returns a popUp instance of certain Class.
	 * 
	 * @param className PopUp instance's class
	 * 
	 * @return Returns an instance of a certain class if it has been popped up, otherwise null.
	 **/
	public static function getPopUpInstanceOf(className:Class):DisplayObject {
		var len:int = getPopUpCount();
		for (var i:int =0; i < len; i++) {
			if (Application.application.systemManager.getChildAt(i) is className) {
				return Application.application.systemManager.getChildAt(i);
			}
		}
		return null;
	}	
	
	/**
	 * @private
	 * 
	 * Internal method to return the number of popup counts.
	 * 
	 * @return Returns the number of popup counts.
	 **/
	private static function getPopUpCount():int {
		return Application.application.systemManager.numChildren;
	}
	
	/**
	 * 
	 * Removes popUp instances of a certain class.
	 * 
	 * @param className Class, instances of which to remove
	 * 
	 **/
	public static function removePopUpInstanceOf(className:Class):void {
		for (var i:int =0; i < Application.application.systemManager.numChildren; i++) {
			if (Application.application.systemManager.getChildAt(i) is className) {
				Application.application.systemManager.removeChildAt(i);
				i--;
			}
		}
	}
}
}