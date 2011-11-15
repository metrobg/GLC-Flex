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
package org.openzet.gantt.events
{
import flash.events.Event;

import org.openzet.gantt.controls.Task;

public class TaskEvent extends Event
{
	public static const ITEM_CLICK:String = "itemClick";
	public static const UNSELECTED:String = "unselected";
	public static const EXPAND_TO_LEFT:String = "expandToLeft";
	public static const EXPAND_TO_RIGHT:String = "expandToRight";
	public static const ITEM_MOVE:String = "itemMove";
	public static const CURSOR_CHANGE:String = "cursorChange";
	
	public function TaskEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, item:Task = null)
	{
		super(type, bubbles, cancelable);
		this.item = item;
	}
	
	public var item:Task;
	
	override public function clone():Event {
		return new TaskEvent(type, bubbles, cancelable);
	}
}
}