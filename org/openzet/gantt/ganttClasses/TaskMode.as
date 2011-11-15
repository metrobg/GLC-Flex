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
package org.openzet.gantt.ganttClasses
{
public class TaskMode
{
	
	public static const EXPAND_TO_LEFT:String = "expandToLeft";
	public static const EXPAND_TO_RIGHT:String = "expandToRight";
	public static const DRAG:String = "drag";
	public static const IDLE:String = "idle";
	
	public function TaskMode()
	{
		
	}
	private var _mode:String = IDLE;
	
	public function set mode (value:String):void 
	{
		if (_mode != value) 
		{
			_mode = value;
		}
	}
	
	public function get mode():String 
	{
		return _mode;
	}
	
	public function get isExpanding():Boolean {
		if (mode != EXPAND_TO_LEFT && mode != EXPAND_TO_RIGHT) 
		{
			return false;
		}
		return true;
	}
}
}