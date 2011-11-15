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
import flash.display.Graphics;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;

import org.openzet.gantt.containers.GanttSheet;
import org.openzet.gantt.ganttClasses.DateSelectorMode;
import org.openzet.gantt.utils.DateRangeUtil;
import org.openzet.utils.DateUtil;
/**
*  FontWeight style to assign to internal textfield.
*
*  @default normal
*/
[Style(name="fontWeight", type="String", inherit="yes")]

/**
*  FontWeight style to assign to internal textfield.
*
*  @default normal
*/
[Style(name="headerColors", type="Array", format="color", inherit="yes")]
public class DateSelector extends UIComponent
{
	public function DateSelector()
	{
		super();
	}
	private var dataProviderChanged:Boolean;
	private var _dataProvider:Object;
	
	private var dateMode:DateSelectorMode = new DateSelectorMode();
	
	
	public function updateDates(startDate:Date, endDate:Date):void
	{
		dataProvider = DateRangeUtil.getDateHeaders(startDate, endDate, dateMode.mode);
	}
	
	public function set dataProvider(value:Object):void 
	{
		if (_dataProvider == value) return; 
		_dataProvider = value;
		dataProviderChanged = true;
		this.invalidateProperties();
	}
	
	public var headers:Array = [];
	
	public var headerDetails:Array = [];
	
	public function get dataProvider():Object 
	{
		return _dataProvider; 
	}
	
	private var _sheet:GanttSheet;
	
	public function set sheet(value:GanttSheet):void
	{
		_sheet = value;
		invalidateProperties();
	}
	
	public function get sheet():GanttSheet
	{
		return _sheet;
	}
	override protected function commitProperties():void 
	{
		super.commitProperties();
		
		if (dataProviderChanged && dataProvider) 
		{
			dataProviderChanged = false;
			
			var len:Number = dataProvider.length; 
			var i:int;
			var header:DateItem;
			
			if (this.numChildren > len) 
			{
				while (this.numChildren > len)
				{
					this.removeChildAt(len);
				}
			}
			
			if (this.numChildren < len) 
			{
				for (i = numChildren; i < len; i++) 
				{
					header = new DateItem();
					addChild(header);
					header.addEventListener(MouseEvent.CLICK, headerClickHandler, false, 0, true);
				}
			} 
			
			headers = [];
			
			for (i = 0; i < this.numChildren; i++)
			{
				headers.push(this.getChildAt(i));
			}
			
		   
			
			for (i = 0; i < len; i++) 
			{
				DateItem(this.getChildAt(i)).text = dataProvider[i].label;
				DateItem(this.getChildAt(i)).startDate = dataProvider[i].START_DATE;
				DateItem(this.getChildAt(i)).endDate = dataProvider[i].END_DATE;
			}  
			var details:ArrayCollection = DateRangeUtil.getDateDetails(sheet.startDate, sheet.endDate, dateMode.mode);
		    
			var detailWidth:Number = unscaledWidth/details.length;
			
			headerDetails = [];
			
			for (i = 0; i < details.length; i++) 
			{
				var headerDetail:DateItem = new DateItem();
				headerDetail.text = details[i].label;
				headerDetail.startDate = details[i].START_DATE;
				headerDetail.endDate = details[i].END_DATE;
				headerDetail.addEventListener(MouseEvent.CLICK, headerDetailClickHandler, false, 0, true);
				headerDetails.push(headerDetail);
				addChild(headerDetail);
			}
				
		}
		this.invalidateDisplayList();
	}
	
 	protected function get datePerPixel():Number {
		var result:Number = DateUtil.getDateDiff(sheet.startDate, sheet.endDate);
		result = unscaledWidth/result;
		return result;
	} 
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var dateItem:DateItem;
		var dayCount:int;
		var itemWidth:Number;
		var tempWidth:Number;
		var xPos:Number;
		for (var i:int = 0; i < headers.length; i++) {
			dateItem = headers[i];
			dayCount = DateUtil.getDateDiff(dateItem.startDate, dateItem.endDate) + 1;
			tempWidth = datePerPixel*dayCount;
			xPos = (i == 0)? 0 : headers[i-1].x + headers[i-1].width;
			if (xPos + tempWidth >= unscaledWidth)
			{
				itemWidth = unscaledWidth - xPos;
			} else
			{
				itemWidth = tempWidth;
			}
			
			dateItem.setActualSize(itemWidth, unscaledHeight/2);
			dateItem.move(xPos, 0);
		} 
		for (i = 0; i < headerDetails.length; i++) {
			dateItem = headerDetails[i];
			dayCount = 1 + DateUtil.getDateDiff(dateItem.startDate, dateItem.endDate);
			tempWidth = datePerPixel*dayCount;
			xPos = (i == 0)? 0 : headerDetails[i-1].x + headerDetails[i-1].width;
			if (xPos + tempWidth >= unscaledWidth)
			{
				itemWidth = unscaledWidth - xPos;
			} else
			{
				itemWidth = tempWidth;
			}
			dateItem.setActualSize(itemWidth, unscaledHeight/2);
			dateItem.move(xPos, unscaledHeight/2 - 2);
		}
		var g:Graphics = this.graphics;
		g.clear();
		g.lineStyle(1, 0xCCCCCC);
		g.moveTo(0, unscaledHeight/2);
		g.lineTo(unscaledWidth, unscaledHeight/2);
	}

	private function headerClickHandler(event:MouseEvent):void
	{
		if (dateMode.mode == DateSelectorMode.YEAR_DAY)
		{
			return; 
		}
		sheet.startDate = event.currentTarget.startDate;
		sheet.endDate = event.currentTarget.endDate;
		switch (dateMode.mode) 
		{
			case DateSelectorMode.YEAR_QUARTER:
				dateMode.mode = DateSelectorMode.YEAR_MONTH;
				sheet.endDate = new Date(event.currentTarget.startDate.getFullYear(), 11, 31);
			break;
			
			case DateSelectorMode.YEAR_MONTH:
				dateMode.mode = DateSelectorMode.YEAR_WEEK;
			break;
			
			case DateSelectorMode.YEAR_WEEK:
				dateMode.mode = DateSelectorMode.YEAR_WEEK_DETAIL;
			break;
			
			case DateSelectorMode.YEAR_WEEK_DETAIL:
				dateMode.mode = DateSelectorMode.YEAR_DAY;
			break;
		}
	}
	
	private function headerDetailClickHandler(event:MouseEvent):void
	{
		if (dateMode.mode == DateSelectorMode.YEAR_DAY)
		{
			return; 
		}
		sheet.startDate = event.currentTarget.startDate;
		sheet.endDate = event.currentTarget.endDate;
		switch (dateMode.mode)
		{
			case DateSelectorMode.YEAR_QUARTER:
				dateMode.mode = DateSelectorMode.YEAR_WEEK;
			break;
			
			case DateSelectorMode.YEAR_MONTH:
				dateMode.mode = DateSelectorMode.YEAR_WEEK;
			break;
			
			case DateSelectorMode.YEAR_WEEK:
				dateMode.mode = DateSelectorMode.YEAR_DAY;
			break;
			
			case DateSelectorMode.YEAR_WEEK_DETAIL:
				dateMode.mode = DateSelectorMode.YEAR_DAY;
			break;
		}
	}
	
}
}