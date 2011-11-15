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
package org.openzet.gantt.utils
{
import mx.collections.ArrayCollection;

import org.openzet.gantt.controls.DateItem;
import org.openzet.gantt.ganttClasses.DateSelectorMode;
import org.openzet.gantt.vo.DateVO;
import org.openzet.utils.DateUtil;

public class DateRangeUtil
{
	private static var monthFullNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	
	public static function getDateHeaders(startDate:Date, endDate:Date, mode:String):ArrayCollection
	{
		var result:ArrayCollection = new ArrayCollection();
		var count:int 
		var i:int;
		var item:DateVO;
		var months:Array;
		var tempDate:Date;
		
		switch (mode)
		{
			case DateSelectorMode.YEAR_QUARTER:
			var startYear:int = startDate.getFullYear();
			var endYear:int = endDate.getFullYear();
			
			for (i = startYear; i <= endYear; i++)
			{
				item = new DateVO(); 
				item.label = i.toString();
				tempDate = new Date(i, 0, 1);
				if (i == startYear)
				{
					tempDate = startDate;
					item.START_DATE = startDate;
					if (startYear == endYear)
					{
						item.END_DATE = endDate;
					} else
					{
						item.END_DATE = new Date(i, 11, 31);
					}
					
				} else if (i == endYear)
				{
					tempDate = endDate;	
					if (startYear == endYear)
					{
						item.START_DATE = startDate;;
					} else
					{
						item.START_DATE = new Date(i, 0, 1);
						item.END_DATE = endDate;
					}
				} else
				{
					item.START_DATE = tempDate;
					item.END_DATE = new Date(i, 11, 31); 
				}
				result.addItem(item);
			}	
		
			break;
			
			case DateSelectorMode.YEAR_MONTH:
			var year:int = startDate.getFullYear();
			for (i = 1; i <= 4; i++) 
			{
				item = new DateVO();
				item.label = "Q"+ i + "," + " " + year;
				item.START_DATE = new Date(year, (i - 1)*3, 1);
				item.END_DATE = new Date(year, i*3, 0);
				result.addItem(item);
			}
			break;
			
			case DateSelectorMode.YEAR_WEEK:
			case DateSelectorMode.YEAR_WEEK_DETAIL:
			months = DateUtil.getMonthsBetween(startDate, endDate);
			for (i = 0; i < months.length; i++)
			{
				item = new DateVO();
				var start_date:Date = new Date(startDate.getFullYear(), startDate.getMonth() + i, 1);
				item.label = monthFullNames[months[i]] + " " + start_date.getFullYear();
				item.START_DATE = start_date;
				var dayCount:Number = DateUtil.getDaysOfMonth(start_date.getFullYear(), start_date.getMonth());
				item.END_DATE = new Date(start_date.getFullYear(), start_date.getMonth(), dayCount);
				if (Number(item.START_DATE) < Number(startDate)) item.START_DATE = startDate;
				if (Number(item.END_DATE) > Number(endDate)) item.END_DATE = endDate; 
					
				result.addItem(item);
			}
			break;
			
			case DateSelectorMode.YEAR_DAY:
			var weekNumber:int = DateUtil.getWeekNumber(startDate);
			months = DateUtil.getMonthsBetween(startDate, endDate);
			for (i = 0; i < months.length; i++)
			{
				item = new DateVO();
				item.label = weekNumber + "W , " + monthFullNames[months[i]] + " " + startDate.getFullYear();
				item.START_DATE = startDate;
				item.END_DATE = endDate;
				result.addItem(item);
			}
			break; 
		}
		return result; 
	}

	public static function getDateDetails(startDate:Date, endDate:Date, mode:String):ArrayCollection
	{
		var result:ArrayCollection = new ArrayCollection();
		var count:int 
		var i:int;
		var item:DateVO;
		var tempDate:Date;
		switch (mode)
		{
			case DateSelectorMode.YEAR_QUARTER:
			var startYear:int = startDate.getFullYear();
			var endYear:int = endDate.getFullYear();
			for (i = startYear; i <= endYear; i++)
			{
				var yearStartDate:Date;
				var yearEndDate:Date;
				if (i == startYear)
				{
					yearStartDate = startDate;
					if (i == endYear)
					{
						yearEndDate = endDate;
					} else
					{
						yearEndDate = new Date(i, 11, 31);
					}
				} else if (i == endYear)
				{
					yearStartDate = new Date(i, 0, 1);
					yearEndDate = endDate;
					
				} else 
				{
					yearStartDate = new Date(i, 0, 1);
					yearEndDate = new Date(i, 11, 31);	
				}
				var startQuarter:int = DateUtil.getQuarter(yearStartDate);
				var endQuarter:int = DateUtil.getQuarter(yearEndDate);
				for (var j:int = startQuarter; j <= endQuarter; j++) 
				{
					item = new DateVO();
					item.label = "Q" + j;
					item.START_DATE = new Date(i, (j-1)*3, 1);
					item.END_DATE = new Date(i, j*3, 0);
					if (Number(item.START_DATE) < Number(startDate)) item.START_DATE = startDate;
					if (Number(item.END_DATE) > Number(endDate)) item.END_DATE = endDate; 
					
					result.addItem(item);
				}
				
			}	
			break;
			
			case DateSelectorMode.YEAR_MONTH:
			var months:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Oct", "Sep", "Oct", "Nov", "Dec"];
			for (i = 0; i < months.length; i++)
			{
				item = new DateVO();
				item.label = months[i];
				item.START_DATE = new Date(startDate.getFullYear(), i, 1);
				var dayCount:int = DateUtil.getDaysOfMonth(startDate.getFullYear(), i);
				item.END_DATE = new Date(startDate.getFullYear(), i, dayCount);
				result.addItem(item);
			}
			break;
			
			case DateSelectorMode.YEAR_WEEK:
			case DateSelectorMode.YEAR_WEEK_DETAIL:
			var weekCount:int = int(DateUtil.getDateDiff(startDate, endDate)/7);
			for (i = 0; i <= weekCount; i++) 
			{
				item = new DateVO();
				tempDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + i*7);
				var weekNum:int = DateUtil.getWeekNumber(tempDate);
				item.label = weekNum+ "W";
				item.START_DATE = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + i*7);
				item.END_DATE = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + i*7 + 6);
				if (Number(item.START_DATE) < Number(startDate)) item.START_DATE = startDate;
				if (Number(item.END_DATE) > Number(endDate)) item.END_DATE = endDate; 
					
				result.addItem(item);
			}
			break;
			
			case DateSelectorMode.YEAR_DAY:
			for (i = 0; i < 7; i++) 
			{
				item = new DateVO();
				tempDate = DateUtil.getDateFromDate(startDate, i);
				item.label = tempDate.getDate().toString();
				item.START_DATE = tempDate;
				item.END_DATE = tempDate;
				result.addItem(item);
			}
			break; 
		}
		return result; 
	}
}
}