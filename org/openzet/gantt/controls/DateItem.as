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
package org.openzet.gantt.controls
{
public class DateItem extends GradientLabel
{
	public function DateItem()
	{
	}
	
	private var _startDate:Date;

	public function set startDate(value:Date):void
	{
		_startDate = value;
	}
	
	public function get startDate():Date 
	{
		return _startDate;
	}
	
	private var _endDate:Date;
	
	public function set endDate(value:Date):void
	{
		_endDate = value;
	}
	
	public function get endDate():Date
	{
		return _endDate;
	}

}
}