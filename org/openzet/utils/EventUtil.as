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
import flash.events.EventDispatcher;

/**
 * Static class that defines static methods used in relation with event dispatching. 
 **/
public class EventUtil
{
	include "../core/Version.as";
	/**
	 * Static addEventListener method to make it easier to register event listeners with useWekReference paremeter set to true.
	 * 
	 * @param target Any EventDispatcher (or its subclass) instance to register an event listener.
	 * @param type Event type string.
	 * @param listener Event handler method.
	 * @param useWeakReference A flag whether to set useWeakReference to true. Default value is true.
	 * @param useCapture A flag whether to set useCapture to true. Default value is false.
	 * @param priority A parameter to specify event priority. Default value is 0. 
	 **/
	public static function addEventListener(target:Object, type:String, listener:Function, useWeakReference:Boolean = true, useCapture:Boolean = false, priority:int = 0):void {
		EventDispatcher(target).addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

}
}