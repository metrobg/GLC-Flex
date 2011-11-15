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
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.IToolTip;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.managers.ToolTipManager;

import org.openzet.gantt.events.TaskEvent;
import org.openzet.gantt.ganttClasses.CursorType;
import org.openzet.gantt.ganttClasses.TaskMode;
import org.openzet.gantt.managers.*;
import org.openzet.utils.DateUtil;

	/**
*  An array of colors to fill the area of this component
*
*  @default [#6378ed, #ffffff]
*/
[Style(name="fillColors", type="Array", format="Color", inherit="no")]

/**
*  FontWeight style to assign to internal textfield.
*
*  @default normal
*/
[Style(name="fontWeight", type="String", inherit="yes")]

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

public class Task extends UIComponent
{
	public function Task()
	{
		super();
		this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
	}
	
	protected var itemMode:TaskMode = new TaskMode();
	protected var cursorType:CursorType = new CursorType();	
	
	public var tf:UITextField;
	protected var drawLayer:Sprite;
	protected var filterLayer:Sprite;
	
	private var fillColors:Array;
	
	private var _showToolTips:Boolean;
	
	public function getMode():String
	{
		return itemMode.mode;
	}
	
	public function getCursorType():String
	{
		return cursorType.type;
	}
	public function set showToolTips(value:Boolean):void {
		_showToolTips = value;
		invalidateProperties();
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
	public function get showToolTips():Boolean
	{
		return _showToolTips;
	}
	
	private var _maxGradientWidth:Number;
	
	public function set maxGradientWidth(value:Number):void
	{
		_maxGradientWidth = value;
		invalidateProperties();
	}
	
	public function get maxGradientWidth():Number
	{
		return _maxGradientWidth;
	}
	override protected function createChildren():void 
	{
		super.createChildren();
		
		if (!filterLayer) {
			filterLayer = new Sprite();
			addChild(filterLayer);
		}
		if (!drawLayer) {
			drawLayer = new Sprite();
			addChild(drawLayer);
		}
		if (!tf) {
			tf = new UITextField();
			tf.styleName = this;
			tf.setStyle("fontWeight", "bold");
			addChild(tf);
		}
	}
	private var textChanged:Boolean;
	private var _text:String;

	public function set text(value:String):void 
	{
		if (_text != value) {
			_text = value;
			textChanged = true;
		}
		
		invalidateProperties();
	}
	
	public function get text():String {
		return _text; 
	}
	
	private var cursorChanged:Boolean;
	
	private var _showHighLight:Boolean;
	
	public function set showHighLight(value:Boolean):void {
		_showHighLight = value;
		invalidateProperties();
	}
	
	public function get showHighLight():Boolean {
		return _showHighLight;
	}
	
	private function getToolTip():String
	{
		//data.DESCRIPTION + "\n" + "From : " +
		if (data) {
			return  "From : " + DateUtil.formatDateString(data.START_DATE) + "\n" + "To     : " + DateUtil.formatDateString(data.END_DATE);
		}
		return "";
	}
	override protected function commitProperties():void 
	{
		super.commitProperties();
		if (textChanged) {
			if (tf) tf.text = text;
			textChanged = false;
		}
		this.invalidateDisplayList();
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var g:Graphics = drawLayer.graphics;
		g.clear();
		var colors:Array = fillColors? fillColors: getStyle("fillColors");
		var alphas:Array = [1.0, 1.0];
		var ratios:Array = [0, 255];
		var matrix:Matrix = new Matrix();
		var tempWidth:Number = Math.min(unscaledWidth, maxGradientWidth);
		if (isNaN(tempWidth)) tempWidth = unscaledWidth;
		matrix.createGradientBox(tempWidth, unscaledHeight, Math.PI/2);
		g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		
		if (showHighLight && filterLayer) 
		{
			var hg:Graphics = filterLayer.graphics;
			hg.clear();
			hg.beginFill(0xFFFFFF, 1);
			hg.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 3, 3);
			hg.endFill();
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x6378ed;
			glow.alpha = 1;
			glow.blurX = 10;
			glow.blurY = 10;
			filterLayer.filters = [glow];
		} else 
		{
			if (filterLayer) 
			{
				g = filterLayer.graphics;
				g.clear();
				filterLayer.filters = [];
			}
		}
		tf.width = unscaledWidth;
		tf.height = unscaledHeight;
		if (tip) {
			try {
				ToolTipManager.destroyToolTip(tip);
			} catch (e:Error) {
				
			}
		}
		if (showToolTips) 
		{
			var pt:Point = new Point(0, 0);
			pt = this.localToGlobal(pt);
			if (itemMode.mode == TaskMode.EXPAND_TO_LEFT) {
				tip = ToolTipManager.createToolTip(getToolTip(), pt.x, pt.y + unscaledHeight);
			} else if (itemMode.mode == TaskMode.EXPAND_TO_RIGHT) {
				tip = ToolTipManager.createToolTip(getToolTip(), pt.x + unscaledWidth, pt.y + unscaledHeight);
			} else {
				tip = ToolTipManager.createToolTip(getToolTip(), pt.x + this.mouseX, pt.y + unscaledHeight);
			}
		}
	}
	private var tip:IToolTip;
	private var downPt:Point;
	private var downWidth:Number;
	private var _data:Object;
	
	public function set data (value:Object):void 
	{
		_data = value;
		if (value) 
		{
			this.startDate = DateUtil.convertStringToDate(value.START_DATE);
			this.endDate = DateUtil.convertStringToDate(value.END_DATE);
			this.text = value.DESCRIPTION;
			this.setStyle("fillColors", ColorManager.getColors(value.DESCRIPTION));
		}
	}
	private var isDragging:Boolean;
	
	public function get data():Object 
	{
		return _data;
	}
	private function mouseDownHandler(event:MouseEvent):void 
	{
		var lastIndex:int = this.parent.numChildren -1;
		this.parent.setChildIndex(this, lastIndex);
		
		if (cursorType.type != CursorType.LEFT && cursorType.type != CursorType.RIGHT) 
		{
			itemMode.mode = TaskMode.DRAG;
			this.startDrag();
			isDragging = true;
			if (cursorType.type == CursorType.NONE) 
			{
				var cursor:Class = getStyle("moveArrow");
				CursorManager.getInstance().cursor = cursor;
				cursorType.type = CursorType.MOVE;
				this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
			}
		} else 
		{
			downPt = new Point(this.x, this.y);
			downWidth = unscaledWidth;
			itemMode.mode = cursorType.type == CursorType.LEFT? TaskMode.EXPAND_TO_LEFT: TaskMode.EXPAND_TO_RIGHT;
		}
		this.dispatchEvent(new TaskEvent(TaskEvent.ITEM_CLICK, false, false, this));
		this.systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		this.stopDrag();
		isDragging = false; 
		this.dispatchEvent(new TaskEvent(TaskEvent.ITEM_MOVE, false, false, this));
		itemMode.mode = TaskMode.IDLE;
		cursorType.type = CursorType.NONE;
		this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
		downPt = null;
		CursorManager.getInstance().reset();
		removeSystemListeners();
		
	}
	
	public function removeSystemListeners():void 
	{
		this.systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, systemMouseMoveHandler);
		this.showToolTips = false;
	}
	
	private function mouseOverHandler(event:MouseEvent):void 
	{
		showHighLight = true;
		showToolTips = true;
		if (cursorType.type == CursorType.NONE) 
		{
			var cursor:Class = getStyle("moveArrow");
			CursorManager.getInstance().cursor = cursor;
			cursorType.type = CursorType.MOVE;
			this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
		}
		this.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, systemMouseMoveHandler, false, 0, true);
		this.invalidateDisplayList();
	}
	
	private function mouseOutHandler(event:MouseEvent):void 
	{
		if (cursorType.type == CursorType.MOVE || !itemMode.isExpanding) 
		{
			CursorManager.getInstance().reset();
			cursorType.type = CursorType.NONE;
			this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
			itemMode.mode = TaskMode.IDLE;
			showHighLight = false; 
		}
		
		showToolTips = false;
		
		this.invalidateDisplayList();
	}
	
	private function mouseMoveHandler(event:MouseEvent):void 
	{
		if (!itemMode.isExpanding) {
			var cursor:Class;
			if (event.localX <= 3) 
			{
				cursorType.type = CursorType.LEFT;
				cursor = getStyle("leftArrow");
				this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
			} else if (event.localX >= unscaledWidth - 3) 
			{
				cursorType.type = CursorType.RIGHT;
				cursor = getStyle("rightArrow");
				this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
			} else 
			{
				cursorType.type = CursorType.MOVE;
				cursor = getStyle("moveArrow");
				this.dispatchEvent(new TaskEvent(TaskEvent.CURSOR_CHANGE));
				this.dispatchEvent(new TaskEvent(TaskEvent.ITEM_MOVE, false, false, this));
			}
			CursorManager.getInstance().cursor = cursor;
		}
		showToolTips = true;
		this.invalidateDisplayList();
	}
	
	private function systemMouseMoveHandler(event:MouseEvent):void 
	{
		var pt:Point;
		var currentPt:Point;
		pt = new Point(this.x, this.y);
		pt = this.localToGlobal(pt);
		currentPt = new Point(this.x + this.mouseX, this.mouseY);
		currentPt = this.localToGlobal(currentPt);
		var taskEvent:TaskEvent;
		if (itemMode.mode == TaskMode.EXPAND_TO_RIGHT) 
		{
			this.width = currentPt.x - pt.x;
			if (this.width <= 3) 
			{
				this.width = 3;
			}
		//	trace(this.width, "width");
			showToolTips = true;
			taskEvent =  new TaskEvent(TaskEvent.EXPAND_TO_RIGHT, false, false, this);
			this.dispatchEvent(taskEvent);
			event.updateAfterEvent();
			this.invalidateDisplayList();
			return;
		} else if (itemMode.mode == TaskMode.EXPAND_TO_LEFT) 
		{
			this.x += this.mouseX;
			this.width = downPt.x + downWidth - this.x;
			if (this.width <= 3) 
			{
				this.width = 3;
				this.x = downPt.x + downWidth - 3;
			}
			showToolTips = true;
			taskEvent = new TaskEvent(TaskEvent.EXPAND_TO_LEFT, false, false, this);
			this.dispatchEvent(taskEvent);
			event.updateAfterEvent();
			this.invalidateDisplayList();
			return;
		} 
		this.invalidateDisplayList();
	}
}
}