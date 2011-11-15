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
package org.openzet.controls
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuBuiltInItems;
import flash.ui.ContextMenuItem;
import flash.ui.Mouse;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridListData;
import mx.core.Application;
import mx.core.DragSource;
import mx.core.FlexSprite;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.AdvancedDataGridEvent;
import mx.events.ResizeEvent;
import mx.managers.CursorManager;
import mx.managers.DragManager;
import mx.managers.SystemManager;

import org.openzet.controls.dataGridClasses.ICellSelectable;
import org.openzet.display.DashedRectangle;
import org.openzet.display.DrawingLayer;
import org.openzet.events.SelectionDataGridEvent;
import org.openzet.utils.ChartUtil;
import org.openzet.utils.ChildHierarchyUtil;

use namespace mx_internal;


//------------------------------------------
//  Events
//------------------------------------------
/**
 *	Dispatched when a child node is expanded.
 * 
 *  @eventType org.openzet.events.TreeDataGridEvent
 */
[Event(name="dragSelectionStart", type="org.openzet.events.SelectionDataGridEvent")]

/**
 *	Dispatched when a child node is closed.
 *  
 *  @eventType org.openzet.events.TreeDataGridEvent
 */
[Event(name="dragSelectionEnd", type="org.openzet.events.SelectionDataGridEvent")]




//------------------------------------------
//  Styles
//------------------------------------------
/**
*  Drag selection color
*
*  @default 0x6378ed
*/
[Style(name="dragSelectionColor", type="uint", format="Color", inherit="yes")]


/**
*  Drag selection color
*
*  @default 0.5
*/
[Style(name="dragSelectionAlpha", type="Number", format="Color", inherit="yes")]

/**
*  Drag selection color
*
*  @default 3
*/
[Style(name="dragLineThickness", type="uint", format="Color", inherit="yes")]

/**
*  Drag move arrow 
*/
[Style(name="moveArrow", type="Class", format="EmbeddedFile", inherit="yes")]

/**
*  Drag move arrow 
*/
[Style(name="handDown", type="Class", format="EmbeddedFile", inherit="no")]


/**
* DashLine Style
*/
[Style(name="dashLine", type="Class", format="EmbeddedFile", inherit="no")]



/**
 *  The <code>AdvancedSelectionDataGrid</code> control expands on the functionality of AdvancedTreeDataGrid except that it can 
 *  allow drag selection of cells in a DataGrid.
 *  <p>
 *  The AdvancedSelectionDataGrid control provides the following features:
 *  <ul>
 *  <li>Provides enableDragSelection property to allow drag selection of cells in a DataGrid</li>
 *  <li>Provides dragSelectionData property which maps to an ArrayCollection instance of drag-selected data</li>
 *  <li>Provides showChart property to provide a chart view of drag-selected data</li>
 *  </p>
 *  The AdvancedSelectionDataGrid class is a base Class for AdvancedZetDataGrid.
 * 
 * @includeExample SelectionDataGridExample.mxml
 **/
public class AdvancedSelectionDataGrid extends AdvancedTreeDataGrid implements ICellSelectable
{
	
	include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function AdvancedSelectionDataGrid() {
		super();
		this.draggableColumns=false;
		this.sortableColumns=false;
		this.addEventListener(ResizeEvent.RESIZE,resizeHandler, false, 0, true);
		this.addEventListener(AdvancedDataGridEvent.COLUMN_STRETCH,columnStretchHandler);
	}
	
	
 	 //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**
    * Arrow class to represent an icon when drag-moving data to other controls. 
    **/
	[Bindable]
	public var moveArrow:Class;
	
	/**
    * Hand class to represent an icon when drag-moving data to other controls. 
    **/
	[Bindable]
	public var handCursor:Class;
	
	
	/**
	 * @private
	 * 
	 * Internal property to store the first item renderer instance that user has pressed on. 
	 **/
	protected var startPointItem:Object;
	
	/**
	 * @private
	 * 
	 * Internal Point instance that stores information on the x and y coordinate of the Point where user
	 * has first pressed on.
	 **/
	protected var startPoint:Point;
	
	/**
	 * @private
	 * 
	 * Internal Point instance that stores information on the x and y coordinate of the Point where user
	 * has last dragged over.
	 **/
	protected var endPoint:Point;
		/**
	 * @private
	 * 
	 * Internal Object that stores information such as startIndex, endIndex, startColumnIndex, endColumnIndex
	 * etc to track from where to where items are selected.
	 **/
	protected var selectionInfo:Object= {};
	
		/**
	 * @private
	 * 
	 * Internal context menu of this DataGrid.
	 **/
	protected var dgContextMenu:ContextMenu;
	
	/**
	 * @private
	 * 
	 * Internal flag to indicate whether user has already pressed on a certain item and is currently
	 * dragging cells on a DataGrid.
	 */
	private var allowDragMove:Boolean;
	
	
	
	/**
	 * @private
	 * 
	 * Internal flag to indicate whether user has pressed on a certain cell. Drag selection will be allowed
	 * only when this value is true.
	 **/
	private var isPressed:Boolean;
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * A Boolean property to allow drag selection of cells in a DataGrid.
	 */	
	private var _enableDragSelection:Boolean;
	
	/**
	 * @private
	 * 
	 **/
	public function set enableDragSelection(value:Boolean):void {
		_enableDragSelection = value;
	}
	
	/**
	 * A Boolean property to allow drag selection of cells in a DataGrid. If set to true, users can
	 * press on any itemRenderer instance shown on a DataGrid and start dragging cells scrolling up and down
	 * moving Mouse's position from left to right and vice versa. 
	 * 
	 **/
	public function get enableDragSelection():Boolean {
		return _enableDragSelection;
	}
	
	/**
	 * @private
	 * String representation of chart type to show through a context menu.
	 **/
	private var _seriesType:String = "ColumnSeries";
	
	/**
	 * @private
	 **/
	[Inspectable(enumeration="ColumnSeries,LineSeries,BarSeries,AreaSeries", defaultValue="ColumnSeries")] 
	public function set seriesType(value:String):void {
		_seriesType = value;
		
	}
	
	/**
	 * Specifies the type of chart to show through context menu when user drag-selects
	 * cells of this DataGrid.
	 **/
	public function get seriesType():String {
		return _seriesType;
	}
	
	
			/**
	 * @private
	 * String to specify xField to assign chart series as a yField property.
	 **/
	private var _xField:String;
	
	/**
	 * @private
	 **/
	public function set xField(value:String):void {
		_xField = value;
	}
	
	/**
	 * xField property to assign to a chart series shown through a context menu. Default value is null.
	 **/
	public function get xField():String {
		return _xField;
	}
	
		/**
	 * @private 
	 * Property to specify drag mode.
	 **/
	private var _dragMode:String = "outerDrag";
	
	/**
	 * @private 
	 **/
	[Inspectable(enumeration="outerDrag,handDrag", defaultValue="outerDrag")] 
	public function set dragMode(value:String):void {
		_dragMode = value;
	}
	
	/**
	 * Property to specify drag mode.
	 **/
	public function get dragMode():String {
		return _dragMode;
	}
	
	/**
	 * A method that returns drag-selected data as type of ArrayCollection. 
	 * 
	 * @return A data object that holds all the data of the drag-selected area. 
	 **/
	public function get dragSelectionData():Object {
		var selectionInfo:Object = getSelectionInfo();
		var fields:Array = getDragFields();
		if (selectionInfo) {
			var result:ArrayCollection = new ArrayCollection();
			for (var i:int = selectionInfo.startIndex; i <= selectionInfo.endIndex;i++) {
				result.addItem({});
				result[result.length-1].mx_internal_uid = dataProvider[i].mx_internal_uid;
				for (var j:int = 0; j < fields.length; j++) {
					result[result.length-1][fields[j]] = dataProvider[i][fields[j]];
				}
			}
		} else {
			return null;
		}
		return result;
	}
	
	/**
	 * @private
	 * 
	 * Internal function to return a drawingLayer on which to draw drag-selected area. 
	 **/
	protected function get drawingLayer():DrawingLayer {
		var layer:DrawingLayer = this.getChildByName("dragSelectionLayer") as DrawingLayer;
		if (!layer) {
			layer = new DrawingLayer(this.getStyle("dragSelectionColor"), this.getStyle("dragSelectionAlpha"), this.getStyle("dragLineThickness"));
			layer.name = "dragSelectionLayer";
			this.addChild(layer);
			if (dragMode == "handDrag") {
				layer.addEventListener(MouseEvent.MOUSE_DOWN, layerDownHandler, false, 0, true);
			} else {
	   			layer.addEventListener(MouseEvent.MOUSE_OVER, layerOverHandler, false, 0, true);
			}
			layer.addEventListener(MouseEvent.MOUSE_OUT, lineOutHandler, false, 0, true);
			layer.addEventListener(MouseEvent.MOUSE_MOVE, dragMoveHandler, false, 0, true);
		}
   		return layer;
	}
	
	/**
	 * @private
	 **/
	private var _isArrowMode:Boolean;
	
		/**
	 * @private
	 **/
	private function set isArrowMode (value:Boolean):void {
		_isArrowMode = value;
		if (value) {
			Mouse.hide();
			if (!moveArrow) moveArrow = this.getStyle("moveArrow");
			CursorManager.setCursor(moveArrow, 2, -7.5, -7.5);
		} else {
			CursorManager.removeAllCursors();
		}
	}
		/**
	 * @private
	 * Flag to indicate whether moveArrow is currently used or not. 
	 **/
	private function get isArrowMode():Boolean {
		return _isArrowMode; 
	}
   
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * Overriden method to update drag selection view of a DataGrid when
	 * user scrolls up and down the DataGrid. 
	 **/
	override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean):void {
		super.scrollVertically(pos, deltaPos, scrollUp);
		if (enableDragSelection) drawSelection();
	}

		/**
	 * @private
	 * 
	 * Overriden method to add context menu to show chart data of selected cells.
	 **/
	override protected function initializationComplete():void {
		super.initializationComplete();
		if (enableDragSelection) {
			dgContextMenu = new ContextMenu();
			removeDefaultItems();
			addCustomMenuItems();
			this.contextMenu = dgContextMenu;
		}
	}
	
    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------
	
		
	
	 	/**
	 * A method that resets all the drag selection activity.
	 **/
	public function reset():void {
		drawingLayer.clear();
        selectionInfo.startIndex = undefined;
        selectionInfo.endIndex = undefined;
	}
	
	/**
	 * @private
	 * 
	 * Internal method that returns an object holding information on start row index, end row Index,
	 * start column index, end column index, etc of the selected area.
	 **/
	public function getSelectionInfo():Object {
		
		if (selectionInfo && selectionInfo.startIndex == undefined || selectionInfo.endIndex == undefined) {
			return null;
		} 
		var result:Object = {};
		
		var startIndex:int = Math.min(selectionInfo.startIndex,selectionInfo.endIndex);
		//trace("startIndex :",startIndex,selectionInfo.startIndex,selectionInfo.endIndex);
		var endIndex:int = Math.max(selectionInfo.startIndex,selectionInfo.endIndex);
		
		var startColumnIndex:int = Math.min(selectionInfo.startColumnIndex,selectionInfo.endColumnIndex);
	
		var endColumnIndex:int = Math.max(selectionInfo.startColumnIndex,selectionInfo.endColumnIndex);
		
		var startPoint:Point = new Point(startColumnIndex,startIndex);
		var endPoint:Point = new Point(endColumnIndex,endIndex);
   		result.startIndex= startIndex;
		result.endIndex= endIndex;
		result.startColumnIndex= startColumnIndex;
		result.endColumnIndex= endColumnIndex;

		result.startPoint = startPoint;
		result.endPoint = endPoint;
		
		return result;
	}
	
	/**
	 * @private
	 * 
	 * Internal method that returns an itemRenderer instance based on a specific Point.
	 **/
	protected function updateIndexes(point:Point):void {
		var itemRenderer:Object;
		for (var i:int = 0; i < listItems.length; i++) {
			for (var j:int = 0; j < visibleColumns.length; j++) {
				itemRenderer = listItems[i][j];
				if (itemRenderer && hasXY(itemRenderer)) {
					if (itemRenderer.x <= point.x && itemRenderer.x + itemRenderer.width >= point.x) {
						updateColumnIndexes(j);
					}
					if (itemRenderer.y <= point.y && itemRenderer.y + itemRenderer.height >= point.y) {
						updateRowIndexes(this.dataProvider.getItemIndex(itemRenderer.data));
					}
					if (i == listItems.length -1 && point.y >= itemRenderer.y + itemRenderer.height) {
						updateRowIndexes(i + this.verticalScrollPosition);
					}
				} 
			}
		}
	} 
	
	/**
	 * @private
	 * Internal method to update drag selection using selectionInfo object's data
	 * such as its startIndex, endIndex, startColumnIndex and endColumnIndex plus listItems'
	 * current values.
	 **/
	 
	protected function updateSelection():void {
		var vIndex:int = this.verticalScrollPosition;
		var result:Object = getSelectionInfo();
		drawingLayer.clear();
		if (result) {
	  		var startItem:Object;
    		var endItem:Object;
    		
    		var startIndex:int = result.startIndex -vIndex;
    		var endIndex:int = result.endIndex-vIndex;
    		
    		if (startIndex <= 0) {
    			startIndex = 0;
    		}
    		if (endIndex < 0) {
    			return;
    		} 
    		if (endIndex>=listItems.length-1) {
    			endIndex = listItems.length-1;
    		}
    		if (endIndex >= 0) {
    			try {
    				startItem = listItems[startIndex][result.startColumnIndex];
		    		endItem = listItems[endIndex][result.endColumnIndex];
		    		
		    		if (startItem && endItem) {
		    		
		    			var width:Number = endItem.x + endItem.width - (startItem.x);
			    		var height:Number = endItem.y + endItem.height - (startItem.y);
			    		if (startItem.y + height>=this.height) {
			    			height= this.height - startItem.y;
			    		}
			    		drawingLayer.drawRect(startItem.x, startItem.y, width, height);
		    		}
    			} catch (e:Error) {
    			}
    		}
		}
		this.invalidateDisplayList();
	}
	
	/**
	 * @private
	 * 
	 * Internal method that returns true if an itemRenderer instance has both x and y properties.
	 **/
	protected function hasXY(item:Object):Boolean {
		if (item.hasOwnProperty("x") && item.hasOwnProperty("y")) {
			return true;
		}
		return false;
	}
	
		/**
	 * @private
	 * Internal method to add context menu on a DataGrid to show chart of the drag-selected area.
	 **/
	protected function addCustomMenuItems():void {
        var item:ContextMenuItem = new ContextMenuItem("show Chart");
        dgContextMenu.customItems.push(item);
        item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuHandler, false, 0, true);
    }
    
	/**
	 * @private
	 * Internal method to show chart.
	 **/
	protected function makeChart():void {
		ChartUtil.showPopUpChart(seriesType, this.dragSelectionData);
	}
		/**
	 * @private
	 * Internal function to draw cells in a DataGrid.
	 **/
	private function drawSelection():void {
		var pt:Point = new Point(this.x,this.y);
		pt = this.localToGlobal(pt);
		var result:Object;
		var item:Object;
		if (Application.application.mouseY > pt.y && isPressed) {
			result= getSelectionInfo();
			if (this.verticalScrollPosition == this.maxVerticalScrollPosition) {
				selectionInfo.endIndex = this.dataProvider.length-1;
			} else {
				selectionInfo.endIndex = this.verticalScrollPosition + listItems.length-1;
			}  
		} else if (Application.application.mouseY < pt.y && isPressed) {
			result = getSelectionInfo();
		} 
		updateSelection(); 
	}
	
	/**
	 * @private
	 * 
	 * Internal method used to update endColumnIndex of the currently drag-selected area. 
	 **/
	private function updateColumnIndexes(value:int):void {
		selectionInfo.endColumnIndex = value;
	}
	
	/**
	 * @private
	 * 
	 * Internal method used to update end row index of the currently drag-selected area. 
	 **/
	private function updateRowIndexes(value:int):void {
		selectionInfo.endIndex = value;
	}
	
	/**
	 * @private
	 * 
	 * Internal method that returns drag-selected dataFields as Array.
	 **/
	private function getDragFields():Array {
		var selectionInfo:Object = getSelectionInfo();
		if (selectionInfo) {
			var fields:Array = [];
			for (var i:int = selectionInfo.startColumnIndex;i < selectionInfo.endColumnIndex+1;i++) {
				fields.push(this.columns[i].dataField);
			}
		} else {
			return null;
		}
		return fields;
	}
	
	/**
	 * @private
	 * Internal method to remove default context menu items. 
	 **/
	private function removeDefaultItems():void {
		dgContextMenu.hideBuiltInItems();
        var defaultItems:ContextMenuBuiltInItems = dgContextMenu.builtInItems;
        defaultItems.print = true;
	}
	
	//--------------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------------
	/**
	 * @private
	 * Overriden method to start drag selection when user presses on an itemRenderer instance
	 * on a DataGrid.
	 **/
	override protected function mouseDownHandler(event:MouseEvent):void {
		super.mouseDownHandler(event);
		if (isArrowMode) {
			allowDragMove = true;
		}
		var s:Sprite = Sprite(selectionLayer.getChildByName("headerSelection"));
   	    if (!s)
        {
            s = new FlexSprite();
            s.name = "headerSelection";
            selectionLayer.addChild(s);
        }
        var g:Graphics = s.graphics;
        g.clear();
   		var pt:Point = new Point(event.stageX,event.stageY);
   		pt =  listContent.globalToLocal(pt);
   		var item:Object = mouseEventToItemRenderer(event);
   		if (item) {
   			if (enableDragSelection) {
   				allowDragMove = false;
   				systemManager.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,false,0,true);
   				systemManager.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);
   				stage.addEventListener(Event.MOUSE_LEAVE,leaveHandler,false,0,true);
   				stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDownHandler, false, 0, true);
   				
   				isPressed = true; 	
	   			
	   			startPointItem = item;
	   			startPoint = new Point(item.x,item.y);
	   			
	   			selectionInfo.startIndex= this.dataProvider.getItemIndex(item.data);
	   			selectionInfo.startColumnIndex=DataGridListData(item.listData).columnIndex;
	   			var rowIndex:int = DataGridListData(item.listData).rowIndex;
	   			var offset:Number=0;
   				if (item.y >= this.headerHeight) {
	   				
		   			if (item.y + item.height>=this.listContent.height) {
		   				offset = this.listContent.height - (item.y + item.height);
		   			}
		   			
		   			drawingLayer.drawRect(item.x, item.y, item.width, item.height);
   				}
	   			selectionInfo.endIndex= selectionInfo.startIndex;
	   			selectionInfo.endColumnIndex= selectionInfo.startColumnIndex;
	   			selectionInfo.data = item.data;
   			}
   		}
	} 
	
	/**
	 * @private
	 * Overriden method to update drag selection when user moves Mouse here and there. 
	 **/
	override protected function mouseMoveHandler(event:MouseEvent):void {
		super.mouseMoveHandler(event);
		if (isPressed && enableDragSelection && event.currentTarget is SystemManager) {
			updateIndexes(new Point(this.mouseX,this.mouseY));
			if (startPoint) {
				updateSelection();
			}  
		} 
	}
		
		/**
	 * @private
	 * 
	 * Overriden method to respond to mouseUp event. When a mouseUp event occurs, every flag sets its
	 * value to default values and all drag selection acitivity ends.
	 **/
	override protected function mouseUpHandler(event:MouseEvent):void {
		super.mouseUpHandler(event);
		if (enableDragSelection) {
			isPressed = false;
			allowDragMove = false;
			startPointItem = null;
			startPoint=null;
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		} 
	}
	
	/**
	 * @private
	 * 
	 * Overriden headerRelease event handler to reset dragSelection. 
	 */
	override protected function headerReleaseHandler(event:AdvancedDataGridEvent):void {
		super.headerReleaseHandler(event);
		reset();
		
	}
	 //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
	
	/**
	 * @private 
	 * 
	 * Custom event handler to handle an event when mouse pointer rolls over the line layer. 
	 **/
	private function layerOverHandler(event:MouseEvent):void {
		if (!isPressed) {
    		if (dragMode == "outerDrag" && event.target.name == "lineLayer") {
	    		isArrowMode = true;
    		} 
		}
	}
	
	private function layerDownHandler(event:MouseEvent):void {
		if (!isPressed) {
			if (!systemManager.hasEventListener(MouseEvent.MOUSE_UP)) {
				systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true); 
			}
			flash.ui.Mouse.hide();
			CursorManager.removeAllCursors();
			handCursor = getStyle("handDown");
			CursorManager.setCursor(handCursor);
			allowDragMove = true;
		}
	}
	/**
	 * @private 
	 * 
	 * Custom event handler to handle an event when mouse pointer rolls out the line layer. 
	 **/
	private function lineOutHandler(event:MouseEvent):void {
		CursorManager.removeAllCursors();
		if (event.target.name == "lineLayer") {
    		isArrowMode = false;
		} 
	}
	
		/**
	 * @private
	 * 
	 * Internal click event handler for a sprite used as a drag selection layer.
	 **/
	private function dragMoveHandler(event:MouseEvent):void {
		if (allowDragMove) {
			var spr:Sprite = new Sprite();
   			spr.name="dragSelectionLayer";
    		var dragSource:DragSource = new DragSource();
    		var result:Object = getSelectionInfo();
    		dragSource.addData(result,'result');
    		var img:UIComponent = new UIComponent();
    		var startItem:Object;
    		var endItem:Object;
    		var startIndex:int = result.startIndex - this.verticalScrollPosition;
    		var endIndex:int = result.endIndex-this.verticalScrollPosition;
    		
    		if (startIndex <= 0) {
    			startIndex = 0;
    		}
    		if (endIndex <= 0) {
    			endIndex = 0;
    		}
    		if (endIndex >= listItems.length) {
    			endIndex = listItems.length-1;
    		}
    		if (endIndex >= 0) {
				startItem = listItems[startIndex][result.startColumnIndex];
	    		endItem = listItems[endIndex][result.endColumnIndex];
	    		if (startItem && endItem) {
	    			var width:Number = endItem.x + endItem.width - (startItem.x);
		    		var height:Number = (result.endIndex - result.startIndex + 1)*this.rowHeight;
		    		if (height == 0) {
		    			height = rowInfo[endIndex].height;
		    		}
		    		var dr:DashedRectangle = new DashedRectangle(true);
		    		dr.contentWidth = width;
		    		dr.contentHeight = height;
		    		dr.source = this.getStyle("dashLine");
		    		img.addChild(dr);
		    		//DashedLine.drawDashedRect(img.graphics,startItem.x,startItem.y,width,height,0x000000,2);
					DragManager.doDrag(this,dragSource,event,img,-startItem.x, -startItem.y);
	    		}
    		}
		}
	}
	
	/**
	 * @private
	 * 
	 * Internal mouseLeave event handler that sets various flags and variables to their default values.
	 **/
	private function leaveHandler(event:Event):void {
		isPressed = false;
		allowDragMove = false;
		startPointItem = null;
		startPoint=null;
		if (stage) stage.removeEventListener(Event.MOUSE_LEAVE,leaveHandler);
	}
	
	/**
	 * @private
	 * Internal handler method to take care of ContexMenuEvent.
	 **/
	private function contextMenuHandler(event:ContextMenuEvent):void {
		switch (event.currentTarget.caption) {
			case "show Chart":
			makeChart();
			break;
		}
	}
	
	/**
	 * @private
	 * Internal handler method to take care of stage's mouseDown event.
	 **/
	private function stageDownHandler(event:MouseEvent):void {
		if (!ChildHierarchyUtil.contains(this, event.target as DisplayObject)) {
			reset();
		}
	}
	
	
	/**
	 * @private
	 * 
	 * Internal resize event handler method that uses callLater method to update drag selection status
	 * of cells in a DataGrid.
	 **/
	private function resizeHandler(event:ResizeEvent):void {
		callLater(updateSelection);
	}
	
	/**
	 * @private
	 * 
	 * Internal columnStretch event handler method that uses callLater method to update drag selection status
	 * of cells in a DataGrid.
	 **/
	private function columnStretchHandler(event:AdvancedDataGridEvent):void {
		callLater(updateSelection);
	}
}
}
