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
public class CursorType
{
	public static const LEFT:String = "left";
	
	public static const RIGHT:String = "right";
	
	public static const MOVE:String = "move";
	
	public static const NONE:String = "none";

	public function CursorType()
	{
	}
	
	private var _type:String = NONE;
	
	public function set type (value:String):void
	{
		_type = value;
	} 
	
	public function get type():String 
	{
		return _type;
	}

}
}