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
package org.openzet.gantt.containers
{
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.containers.Canvas;
import mx.core.UIComponent;

import org.openzet.gantt.controls.DateItem;
import org.openzet.gantt.controls.DateSelector;
import org.openzet.gantt.controls.Task;
import org.openzet.gantt.events.TaskEvent;
import org.openzet.gantt.ganttClasses.CursorType;
import org.openzet.gantt.ganttClasses.TaskMode;
import org.openzet.gantt.managers.CursorManager;
import org.openzet.utils.*;


/**
*  Drag move arrow 
*/
[Style(name="moveArrow", type="Class", format="EmbeddedFile", inherit="yes")]

/**
*  Left arrow 
*/
[Style(name="leftArrow", type="Class", format="EmbeddedFile", inherit="yes")]

/**
*  Right arrow 
*/
[Style(name="rightArrow", type="Class", format="EmbeddedFile", inherit="yes")]

/**
*  Click arrow 
*/
[Style(name="clickArrow", type="Class", format="EmbeddedFile", inherit="yes")]

/**
*  FontWeight style to assign to internal textfield.
*
*  @default [0xE7E7E7, 0XFFFFFF]
*/
[Style(name="alternatingItemColors", type="Array", format="Color", inherit="yes")]

/**
*  FontWeight style to assign to internal textfield.
*
*  @default normal
*/
[Style(name="fontWeight", type="String", inherit="yes")]
public class GanttSheet extends Canvas
{
	
	public function GanttSheet()
	{
		super();
		this.addEventListener(MouseEvent.MOUSE_DOWN, sheetDownHandler, false, 0, true);
	}
	
	
	private var dateChanged:Boolean;
	private var dataProviderChanged:Boolean;
	private var _dataProvider:Object;
	private var _startDate:Date;
	private var _endDate:Date;
	private var cursorType:CursorType = new CursorType();
	
	
	private var itemMode:TaskMode = new TaskMode();
	
	public function set startDate(value:Date):void
	{
		_startDate = value;
		dateChanged = true;
		this.invalidateProperties();
	}
	
	public function get startDate():Date
	{
		return _startDate;
	}
	
	public function set endDate(value:Date):void
	{
		_endDate = value;
		dateChanged = true;
		this.invalidateProperties();
	}
	
	public function get endDate():Date
	{
		return _endDate; 
	}
	
	protected var dateSelector:DateSelector;
	protected var listOwner:UIComponent;
	protected var drawLayer:Sprite = new Sprite();
	protected var contentMask:Shape = new Shape();
	protected var lines:Shape = new Shape();
	
	public function set dataProvider(value:Object):void 
	{
		if (_dataProvider == value) return; 
		_dataProvider = value;
		dataProviderChanged = true;
		this.invalidateProperties();
	}
	
	public function get dataProvider():Object 
	{
		return _dataProvider;
	} 

	protected function get datePerPixel():Number {
		var result:Number = DateUtil.getDateDiff(startDate, endDate);
		result = unscaledWidth/result;
		return result;
	}
	
	override protected function commitProperties():void 
	{
		super.commitProperties();
		
		if  (dateChanged) 
		{
			dateChanged = false;
			if (dateSelector) 
			{
				dateSelector.updateDates(startDate, endDate);
			}
		}
		if (dataProviderChanged)
		{
			dataProviderChanged = false;
			for (var i:int = 0; i < dataProvider.length; i++) 
			{
				var task:Task = new Task();
				task.height = 20;
				task.y = 100*i + 30;
				task.data = dataProvider[i];
				listOwner.addChild(task);
			}
		}
		invalidateDisplayList();
	}
	
	override protected function createChildren():void 
	{
		super.createChildren();
		this.rawChildren.addChild(drawLayer);
		this.rawChildren.addChild(lines);
		
		dateSelector = new DateSelector();
		dateSelector.sheet = this;
		addChild(dateSelector);
		dateSelector.percentWidth = 100;
		dateSelector.height = 50;
		
		listOwner = new UIComponent();
		listOwner.percentWidth = 100;
		listOwner.percentHeight = 100;
		listOwner.y = dateSelector.height;
		addChild(listOwner);
		
		this.rawChildren.addChild(contentMask);
	}
	
	protected function drawBackgrounds():void
	{
		var colors:Array = this.getStyle("alternatingItemColors");
		
		var g:Graphics = drawLayer.graphics;
		g.clear();
		
		var rowCount:int = Math.floor(unscaledHeight/30);
		var k:int;
		for (var i:int = 0; i < rowCount; i++)
		{
			var color:uint = colors[k%colors.length];
			g.beginFill(color, 1);
			g.drawRect(0, 48 + 30*i, unscaledWidth, 30);
			k++;
		}
	}
	
	protected function drawDashedLines():void
	{
		var len:int = dateSelector.headerDetails.length;
		var headerDetail:DateItem;
		var g:Graphics = lines.graphics;
		g.clear();
		for (var i:int = 1; i < len; i++) 
		{
			headerDetail = dateSelector.headerDetails[i];
			g.moveTo(headerDetail.x, 50);
			var pt:Point = new Point(headerDetail.x, 50);
			var endPt:Point = new Point(headerDetail.x, unscaledHeight);
			DashedLine.drawDashedLine(g, pt, endPt, 0xCCCCCC);
		}
	}
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var g:Graphics = contentMask.graphics;
		g.clear();
		g.beginFill(0xFFFFFF, 0);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		listOwner.mask = contentMask;
		
		drawBackgrounds();
		
		for (var i:int = 0; i < listOwner.numChildren; i++) 
		{
			var task:Task = listOwner.getChildAt(i) as Task;
			task.addEventListener(TaskEvent.EXPAND_TO_LEFT, leftHandler, false, 0, true);
			task.addEventListener(TaskEvent.EXPAND_TO_RIGHT, rightHandler, false, 0, true);
			task.addEventListener(TaskEvent.ITEM_MOVE, moveHandler, false, 0, true);
			task.addEventListener(TaskEvent.ITEM_CLICK, itemClickHandler, false, 0, true); 
			task.addEventListener(TaskEvent.CURSOR_CHANGE, cursorChangeHandler, false, 0, true);
			var data:Object = task.data;
			var taskStartDate:Date = DateUtil.convertStringToDate(data.START_DATE);
			var taskEndDate:Date = DateUtil.convertStringToDate(data.END_DATE);
			var startDateDiff:Number = DateUtil.getDateDiff(this.startDate, taskStartDate);
			var dateDiff:Number = DateUtil.getDateDiff(taskStartDate, taskEndDate);
			var tempX:Number = datePerPixel*startDateDiff;
			var tempWidth:Number = datePerPixel*dateDiff;
			task.x = tempX;
			task.width = tempWidth;
			task.maxGradientWidth = unscaledWidth;
		}
		callLater(drawDashedLines);
	}
	
	
	private function leftHandler(event:TaskEvent):void 
	{
		var task:Task = event.item;
		if (task.data) 
		{
			var data:Object = task.data;
			var width:Number = task.width;
			var taskEndDate:Date = task.endDate;
			var days:Number = int(width/datePerPixel);
			var startDate:Date = DateUtil.getDateFromDate(taskEndDate, -days);
			task.startDate = startDate;
			data.START_DATE = DateUtil.convertToDateString(startDate);
			
		}
		itemMode.mode = Task(event.currentTarget).getMode();
	}
	
	private function rightHandler(event:TaskEvent):void 
	{
		var task:Task = event.item;
		if (task.data) 
		{
			var data:Object = task.data;
			var width:Number = task.width;
			var taskStartDate:Date = task.startDate;
			var days:Number = int(width/datePerPixel);
			var endDate:Date = DateUtil.getDateFromDate(taskStartDate, days);
			data.END_DATE = DateUtil.convertToDateString(endDate);
			task.endDate = endDate;
			
		}
		itemMode.mode = Task(event.currentTarget).getMode();
	}
	
	private function moveHandler(event:TaskEvent):void 
	{
		var task:Task = event.item;
		var x:Number = task.x;
		var width:Number = task.width; 
		var counts:int = int(x/datePerPixel);
		var counts2:int = int((x+width)/datePerPixel);
		var startDate:Date = DateUtil.getDateFromDate(this.startDate, counts);
		var endDate:Date = DateUtil.getDateFromDate(this.startDate, counts2);
		task.startDate = startDate;
		task.data.START_DATE = DateUtil.convertToDateString(startDate);
		task.endDate = endDate; 
		task.data.END_DATE = DateUtil.convertToDateString(endDate);
		itemMode.mode = Task(event.currentTarget).getMode();
	}
	
	private var selectedTask:Task;
	
	private function itemClickHandler(event:TaskEvent):void 
	{
		for (var i:int = 0; i < listOwner.numChildren; i++) {
			if (listOwner.getChildAt(i) != event.item) 
			{
				Task(listOwner.getChildAt(i)).removeSystemListeners();
			}
		}
		selectedTask = event.currentTarget as Task;
	}
	private var pt:Point;
	
	
	public function get draggable():Boolean
	{
		if (itemMode.mode == TaskMode.IDLE)
		{
			return true;
		}
		return false;
	}
	
	private function sheetDownHandler(event:MouseEvent):void 
	{
		if (cursorType.type == CursorType.LEFT || cursorType.type == CursorType.RIGHT)
		{
			return; 
		}
		this.systemManager.addEventListener(MouseEvent.MOUSE_UP, sheetMouseUpHandler, false, 0, true);
		if (draggable && event.target is DateItem == false && event.target is Task == false)
		{
			pt = new Point(this.mouseX, this.mouseY);
			this.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, sheetMoveHandler, false, 0, true);
			selectedTask = null;
			var cursor:Class = getStyle("clickArrow");
			CursorManager.getInstance().cursor = cursor;
		} 
	}
	
	
	private function sheetMoveHandler(event:MouseEvent):void
	{
		if (draggable && pt)
		{
			var xDiff:Number = pt.x - this.mouseX;
			var datesDiff:Number = int(xDiff/datePerPixel);
			this.startDate = DateUtil.getDateFromDate(this.startDate, -datesDiff);
			this.endDate = DateUtil.getDateFromDate(this.endDate, -datesDiff); 
		} else 
		{
			if (selectedTask)
			{
				var diff:int;
				if (DateUtil.compare(selectedTask.startDate, this.startDate) == -1) 
				{
					diff = DateUtil.getDateDiff(selectedTask.startDate, this.startDate);
					this.startDate = DateUtil.getDateFromDate(this.startDate, -diff);
					this.endDate = DateUtil.getDateFromDate(this.endDate, -diff);
				}
				if (DateUtil.compare(selectedTask.endDate, this.endDate) == 1) 
				{
					diff = DateUtil.getDateDiff(this.endDate, selectedTask.endDate);
					this.startDate = DateUtil.getDateFromDate(this.startDate, diff);
					this.endDate = DateUtil.getDateFromDate(this.endDate, diff);
				}
			}
		}
	}
	
	private function sheetMouseUpHandler(event:MouseEvent):void
	{
		systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, sheetMoveHandler);
		systemManager.removeEventListener(MouseEvent.MOUSE_UP, sheetMouseUpHandler);
		itemMode.mode = TaskMode.IDLE;
		pt = null;
		CursorManager.getInstance().cursor = null;
		this.invalidateDisplayList();
		
	}
	
	private function cursorChangeHandler(event:TaskEvent):void
	{
		cursorType.type = Task(event.currentTarget).getCursorType();
	}
}
}