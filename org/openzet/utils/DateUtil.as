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
import mx.formatters.DateFormatter;

/**
 *  All static utility class that implements methods related with dates. 
 */
public class DateUtil
{
	include "../core/Version.as";
    //--------------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function DateUtil(){}
    
    //--------------------------------------------------------------------------------
    //
    //  Static Methods
    //
    //--------------------------------------------------------------------------------
    
    /**
     *  Returns the string representation of a Date object using specific format.
     *  @param date Date object
     *  @param formatString format string such as YYYYMMDD
     * 
     *  @return Returns formatted string representation of date.
     */
    public static function dateToString(date:Date, formatString:String):String
    {
        var df:DateFormatter = new DateFormatter();
        
        df.formatString = formatString;
        return df.format(date);
    }
    
    /** 
     *  Interprets 8 digit string and returns converted Date object.
     *  @param date String containing year, month and date. 
     */
    public static function stringToDate(date:String):Date
    {
        var month:String;
        month = String(int(date.substr(4, 2)) - 1);
        return new Date(date.substr(0, 4), month, date.substr(6, 2));
    }
    
    /**
     *  Interprets 6 digit string and returns converted Date object.
     *  @param date String containing year and month. 
     */
    public static function stringToMonth(date:String):Date
    {
        var month:String;
        month = String(int(date.substr(4, 2)) - 1);
        return new Date(date.substr(0, 4), month, 1);
    }
    
    
    /**
     *  Returns current date.
     */
    public static function getDate():Number
    {
        return new Date().getDate();
    }
    
    /**
     *  Returns current month. 
     */
    public static function getMonth():Number
    {
        return new Date().getMonth() + 1;
    }
    
    /**
     *  Returns current year. 
     */
    public static function getFullYear():Number
    {
        return new Date().getFullYear();
    }
    
    public static function getDaysOfYear(year:int):int 
		{
			var startDate:Date = new Date(year, 0, 1);
			var endDate:Date = new Date(year+1, 0, 1);
			return (getDateDiff(startDate, endDate));
		}
		
		public static function getDaysOfMonth(year:int, month:int):int
		{
			var startDate:Date = new Date(year, month, 1);
			var endDate:Date = new Date(year, month + 1, 1);
			return (getDateDiff(startDate, endDate));
			
		}
		
		public static function getMonthlyDayCounts(year:int):Array
		{
			var result:Array = [];
			var startDate:Date;
			var endDate:Date;
			var monthlyDayCount:int;
			for (var i:int = 0; i < 12; i++) 
			{
				startDate = new Date(year, i, 1);
				endDate = new Date(year, i +1, 1);
				monthlyDayCount = getDateDiff(startDate, endDate); 
				result.push(monthlyDayCount);
			}
			return result;
		}
		
		public static function getDateDiff(startDate:Date, endDate:Date):int 
		{
			var diff:Number = (Number(endDate) - Number(startDate))/(3600000*24);
			return diff;
		}
		
		public static function compare(date1:Date, date2:Date):int 
		{
			if (Number(date1) < Number(date2)) 
			{
				return -1
			}
			if (Number(date1) == Number(date2)) 
			{
				return 0;
			}
			return 1;
		}
		
		public static function convertStringToDate(dateStr:String):Date
		{
			var date:Date = new Date(dateStr.substr(0, 4), Number(dateStr.substr(4, 2)) - 1, dateStr.substr(6, 2));
			return date; 
		}
		
		public static function formatDateString(dateStr:String, delimeter:String = "/"):String
		{
			return dateStr.substr(0, 4) + delimeter + dateStr.substr(4, 2) + delimeter + dateStr.substr(6, 2);
			
		}
		
		public static function getDateFromDate(baseDate:Date, count:int):Date 
		{
			return new Date(baseDate.getFullYear(), baseDate.getMonth(), baseDate.getDate() + count);
		}
		
		public static function convertToDateString(date:Date):String
		{
			var year:String = date.getFullYear().toString();
			var month:String = Number(date.getMonth() + 1) < 10 ? "0" + String(date.getMonth() + 1): String(date.getMonth() + 1);
			var dates:String = Number(date.getDate()) < 10 ? "0" + String(date.getDate()): String(date.getDate());
			return year + month + dates;
		}
		
		public static function getWeekNumber(date:Date, countFirstWeek:Boolean = true, startWeekDay:String = "Sunday"):int
		{
			//retrieves the first day of the month
			var firstDateOfYear:Date = getYearlyFirstDateForDay(date.getFullYear(), startWeekDay, countFirstWeek);
			var diff:int = getDateDiff(firstDateOfYear, date);
			//retrieves the day of the search date
			var baseDay:int = convertDayToInt(startWeekDay);
			var day:int = date.getDay();
			if (day == baseDay) 
			{
				if (diff == 0)
				{
					return 1;
				}
				return diff/7 + 1; 
			} else 
			{
				var tempDate:Date = new Date(date.getFullYear(), date.getMonth(), date.getDate());
				while (tempDate.getDay() != baseDay) 
				{
					tempDate = DateUtil.getDateFromDate(tempDate, -1);
				}
				diff = getDateDiff(firstDateOfYear, tempDate);
				diff = diff/7 + 1;
			}
			return diff;
		}
		
		private static var dayNames:Array = ["SUN", "MON", "TUE", "WED", "THIR", "FRI", "SAT"];
		
		public static function getYearlyFirstDateForDay(year:int, dayType:String = "SUN", inspectPreviousYear:Boolean = false):Date 
		{
			var date:Date = new Date(year, 0, 1);
			var day:int = convertDayToInt(dayType);
			if (inspectPreviousYear) 
			{
				while (date.getDay() != day) 
				{
					date = DateUtil.getDateFromDate(date, -1);
				}
			} else 
			{
				while (date.getDay() != day) 
				{
					date = DateUtil.getDateFromDate(date, 1);
				}
			}
			return date;
		}
		
		public static function getMonthlyFirstDateForDay(year:int, month:int, dayType:String, inspectPreviousMonth:Boolean = false):Date 
		{
			var date:Date = new Date(year, month - 1, 1);
			var day:int = convertDayToInt(dayType);
			if (inspectPreviousMonth) 
			{
				while (date.getDay() != day) 
				{
					date = DateUtil.getDateFromDate(date, -1);
				}
			} else 
			{
				while (date.getDay() != day) 
				{
					date = DateUtil.getDateFromDate(date, 1);
				}
			}
			return date;
		}
		
		public static function convertDayToInt(day:String):int 
		{
			var result:int;
			var dayStr:String = day.toUpperCase();
			for (var i:int = 0; i < dayNames.length; i++) 
			{
			 	if (dayStr.indexOf(dayNames[i]) != -1)  
			 	{
			 		result = i;
			 		break; 
			 	}	
			}
			return result;
		}
		public static function getYearDiff(startDate:Date, endDate:Date):int
		{
			var dateDiff:int = getDateDiff(startDate, endDate);
			return int(dateDiff/365);
		}
		
		public static function addMonth(date:Date):Date
		{
			var result:Date = new Date(date.getFullYear(), date.getMonth() + 1, date.getDate());
			return result;
		}	
		
		public static function passToNextMonth(date:Date):Date
		{
			var result:Date = new Date(date.getFullYear(), date.getMonth() + 1, 1);
			return result;
		}
	
		public static function getMonthsBetween(startDate:Date, endDate:Date):Array
		{
			var result:Array = [];
			if (startDate.getFullYear() == endDate.getFullYear() && startDate.getMonth() == endDate.getMonth())
			{
				return [startDate.getMonth()];
			} else
			{
				var tempDate:Date = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate());
				while (compare(tempDate, endDate) == -1)
				{
					result.push(tempDate.getMonth());
					tempDate = passToNextMonth(tempDate);
				}
				if (result[result.length - 1] != endDate.getMonth()) 
				{
					result.push(endDate.getMonth());
				}
			}
			
			return result;
		}
		
		public static function getQuarter(date:Date):int
		{
			var month:int = date.getMonth();
			if (month <= 2)
			{
				return 1;
			}
			if (month <= 5)
			{
				return 2;
			}
			if (month <= 8)
			{
				return 3;	
			}
			return 4;
		}
		
		public static function getQuarterlyFirstDay(year:int, quarter:int):Date
		{
			var result:Date = new Date(year, (quarter - 1)*3, 1);
			return result;
		}
		
		public static function getQuarterlyLastDay(year:int, quarter:int):Date
		{
			var result:Date = new Date(year, (quarter - 1)*3 + 2, DateUtil.getDaysOfMonth(year, (quarter - 1)*3 + 2));
			return result;
		}
		
		public static function getQuarterlyDayCount(year:int, quarter:int):int
		{
			var startDate:Date = getQuarterlyFirstDay(year, quarter);
			var endDate:Date = getQuarterlyLastDay(year, quarter);
			var result:int = DateUtil.getDateDiff(startDate, endDate) + 1;
			return result;
		}
		
		public static function getQuarterlyPositionForDate(year:int, quarter:int, date:Date):Number
		{
			var startDate:Date = getQuarterlyFirstDay(year, quarter);
			var quarterDays:int = getQuarterlyDayCount(year, quarter);
			var dateDiff:int = DateUtil.getDateDiff(startDate, date);
			return dateDiff/quarterDays;
		}
		
		public static function getAnnualPositionForDate(year:int, date:Date):Number
		{
			var startDate:Date = new Date(year, 0, 1);
			var endDate:Date = new Date(year, 11, 31);
			var yearDays:int = DateUtil.getDaysOfYear(year);
			var dateDiff:int = DateUtil.getDateDiff(startDate, date);
			return dateDiff/yearDays;
		} 
    	
    	public static function getDateCountFromTo(startDate:Date, endDate:Date):int
    	{
    		return (DateUtil.getDateDiff(startDate, endDate) + 1);
    	}
}
}