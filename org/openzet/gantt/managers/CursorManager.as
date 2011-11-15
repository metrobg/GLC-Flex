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
package org.openzet.gantt.managers
{
import mx.core.Singleton;
import mx.managers.CursorManager;
public class CursorManager
{
	private static var instance:CursorManager; 
	
	public static function getInstance():CursorManager 
	{
		if (!instance) 
		{
			instance = new CursorManager(new Singleton());
		}
		return instance;
	}
	
	public function CursorManager(instance:Singleton) 
	{
		
	}
	
	private var _cursor:Class;
	
	
	public function set cursor(value:Class):void 
	{
		reset();
		if (value) {
			_cursor = value;
			var inst:* = new value();
			var widthOffset:Number = -1 * inst.width/2;
			var heightOffset:Number = -1 * inst.height/2;
			mx.managers.CursorManager.setCursor(value, 2, widthOffset, heightOffset);
		} 
	}
	
	public function get cursor():Class {
		return _cursor;
	}
	
	
	public function reset():void {
		mx.managers.CursorManager.removeAllCursors();
	}

}
}

class Singleton 
{
	public function Singleton()
	{
		
	}	
}
