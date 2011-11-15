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
public class DateSelectorMode
{
	public static const YEAR_QUARTER:String = "year_quarter";
	public static const YEAR_MONTH:String = "year_month";
	public static const YEAR_WEEK:String = "year_week";
	public static const YEAR_WEEK_DETAIL:String = "year_week_detail";
	public static const YEAR_DAY:String = "year_day";
	
	private var depths:Array = [YEAR_QUARTER, YEAR_MONTH, YEAR_WEEK, YEAR_DAY];
	
	
	public function DateSelectorMode()
	{
		
	}
	
	
	private var _mode:String = YEAR_QUARTER;
	
	public function set mode(value:String):void 
	{
		_mode = value;
	}
	
	public function get mode():String 
	{
		return _mode;
	}
	
	public function getNextMode():String
	{
		for (var i:int = 0; i < depths.length; i++) 
		{
			if (mode == depths[i] && i != depths.length - 1)
			{
			 	return depths[i + 1];
			}
		}
		return null;
	}
	
	public function getPrevMode():String
	{
		for (var i:int = 0; i < depths.length; i++) 
		{
			if (mode == depths[i] && i != 0)
			{
			 	return depths[i - 1];
			}
		}
		return null;
	}
}
}