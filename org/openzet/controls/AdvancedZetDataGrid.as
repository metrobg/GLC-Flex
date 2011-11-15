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
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.Application;
import mx.core.ClassFactory;
import mx.core.FlexShape;
import mx.core.FlexSprite;
import mx.core.mx_internal;
import mx.events.AdvancedDataGridEvent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;

import org.openzet.controls.advancedDataGridClasses.AdvancedZetDataGridColumn;
import org.openzet.controls.dataGridClasses.*;
import org.openzet.controls.dataGridClasses.filter.FilterItemRenderer;
import org.openzet.controls.dataGridClasses.filter.FilterManager;
import org.openzet.controls.dataGridClasses.filter.FilterPopUp;
import org.openzet.utils.ChildHierarchyUtil;
import org.openzet.utils.ListBaseUtil;
import org.openzet.utils.PopUpUtil;

use namespace mx_internal;	

/**
 *  The <code>AdvancedZetDataGrid</code> control is a subClass that extends AdvancedSelectionDataGrid. This class provides
 *  all the functionalities implemented by its super classes while providing additional features 
 *  such as row span, and easy-to-use data filtering. 
 *  <p>
 *  The <code>AdvancedZetDataGridZetDataGrid</code> control provides the following features:
 *  <ul>
 *  <li>Provides row span functionality when a dataGridColumn's enableMerge property is set to <code>true</code>.</li>
 *  <li>Provides <code>enableFilter</code> property to allow users to filter data on various conditions</li>
 *  </p>
 * 
 *  @see org.openzet.controls.advancedDataGridClasses.AdvancedZetDataGridColumn
 *  @see org.openzet.controls.ZetDataGrid
 **/
public class AdvancedZetDataGrid extends AdvancedSelectionDataGrid implements IZetDataGrid
{
	
	
  	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Due to internal bug of Flex's DataGrid class, we record previous vertical scroll position in a 
	 * private variable so that we can catch a case when previous and current vertical scroll position
	 * both equal to zero.
	 **/
	 private var prevVertPos:int;
	 
	/**
	 * @private 
	 * 
	 * Internal MergeHelper instance that is used to take care of data merge
	 **/
	 private var mergeHelper:MergeHelper;
	 
	 /**
	 * @private
	 * Internal variable to store sortableColumns property.
	 **/
	private var oldSortableColumns:Boolean;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
		/**
	 * Constructor
	 **/
	public function AdvancedZetDataGrid()
	{
		super();
		this.addEventListener(FlexEvent.CREATION_COMPLETE, completeHandler, false, 0, true);
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------
	/**********
	 * Overriden property to fix Flex DataGrid's bug with regard to setting vertical scroll position. 
	 */
	override public function set verticalScrollPosition(value:Number):void {
		
		//due to internal AdvancedDataGrid's bug,
		//if previous verticalScrollPosition and new value are both zero
		//we do nothing! 
		if (prevVertPos == 0 && value ==0) {
		} else {
			super.verticalScrollPosition = value;
		}
		prevVertPos = value;
	}
	
 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

		/**
	 * @private
	 * 
	 * A Boolean property to enable or disable data filtering
	 **/
	private var _enableFilter:Boolean;
	
	/**
	 * @private
	 **/
	public function set enableFilter(value:Boolean):void {
		_enableFilter = value;
		var i:int = 0;
		if (value) {
			this.sortableColumns = false;
			this.addEventListener(ResizeEvent.RESIZE, resizeHandler, false, 0, true);
			this.addEventListener(AdvancedDataGridEvent.COLUMN_STRETCH, stretchHandler, false, 0, true);
			for (i = 0; i < columns.length; i++) {
				columns[i].headerRenderer = new ClassFactory(FilterItemRenderer);
			}
		} else {
			this.sortableColumns = oldSortableColumns;
			
			for (i = 0; i < columns.length; i++) {
				columns[i].headerRenderer = null;
			}
			if (this.dataProvider && this.dataProvider.hasOwnProperty("filterFunction")) {
				this.dataProvider.filterFunction = null;
				this.dataProvider.refresh();
			}
			FilterManager.getInstance().getFilter(this).reset();
		}
		this.invalidateProperties();
	}
	
		/**
	 * A Boolean property to specify whether to enable or disable data filtering. If set to true, ZetDataGrid
	 * automatically sets every column's headerRenderer to org.openzet.controls.dataGridClasses.filter.FilterItemRenderer and
	 * takes care of data filtering on its own. Default value is false.
	 **/
	public function get enableFilter():Boolean {
		return _enableFilter;
	}
	
	private var _baseColorField:String;
	
	public function set baseColorField(value:String):void 
	{
		_baseColorField = value;
		invalidateProperties();
	}
	
	public function get baseColorField():String
	{
		return _baseColorField;
	}
	
	private var _cellColorFunction:Function;
	
	public function set cellColorFunction(value:Function):void 
	{
		_cellColorFunction = value;
	}
	
	public function get cellColorFunction():Function
	{
		return _cellColorFunction; 
	}
	
	/**
	 * @private
	 * Internal method to indicate whether any of the columns is type of IMergeable. If so, returns true, otherwise false.
	 */
	private function get isMergeMode():Boolean {
		var len:int = this.visibleColumns.length;
		for (var i:int = 0; i < len; i++) {
			if (this.visibleColumns[i] is IMergeable && IMergeable(this.visibleColumns[i]).enableMerge) {
				return true;
			}
		}
		return false;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
	
	/***
	 * @private
	 * 
	 * Overriden method to take care of data merge. 
	 */
	override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean=false, rowsNeeded:uint=0):Point {
		var pt:Point = super.makeRowsAndColumns(left, top, right, bottom, firstCol, firstRow, byCount, rowsNeeded);
		if (isMergeMode) 
		{
			init();
			var columnCnt:Number = this.visibleColumns.length;
			var len:Number = this.listItems.length - 1;
			var maxHeight:Number = this.listContent.height;
			var paddingTop:Number = this.cachedPaddingTop;
			var paddingBottom:Number = this.cachedPaddingBottom;
			var dataField:String;
			var item:IDropInListItemRenderer;
			//trace("paddings", paddingTop, paddingBottom);
			mergeHelper = new MergeHelper(false,paddingTop, paddingBottom, maxHeight);
			for (var i:Number = 0; i < columnCnt;i++) {
				dataField = visibleColumns[i].dataField;
				for (var j:Number = 0; j< len;j++) {
					item  = listItems[j][i];
					if (!item || item.listData == null) {
						continue;
					}
					if (isMergeMode && isMergeable(visibleColumns[i])) {
						mergeHelper.addMergeItem(listItems[j][i],listItems[j+1][i], dataField);
					} 
				}
			}
		}
	
		return pt;
	}
	
		/**********
	 * @private
	 * 
	 * Overriden method to draw row background. This method internally calls drawBackground() 
	 * when merge mode is enabled. 
	 */
	override protected function drawRowBackground(s:Sprite, rowIndex:int,
                                     y:Number, height:Number, color:uint, dataIndex:int):void
  	{
  		super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
  		if (isMergeMode) {
	         if (rowIndex == listItems.length - 1) 
	         {
		         drawBackground();
	         }
  		} 
	}
	
	/**********
	 * @private
	 * 
	 * Overriden method to draw horizontal line on a DataGrid. This method is overriden so that we don't
	 * draw a line across a merged item. 
	 */
	override protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean):void {
		super.scrollHorizontally(pos, deltaPos, scrollUp);
		this.invalidateList();
	}    
	
		
	/**********
	 * @private
	 * 
	 * Overriden method to draw horizontal line on a DataGrid. This method is overriden so that we don't
	 * draw a line across a merged item. 
	 */
	override protected function drawHorizontalLine(s:Sprite, rowIndex:int, color:uint, y:Number):void {
		if (isMergeMode) {
    		var g:Graphics = s.graphics;

        	if (lockedRowCount > 0 && rowIndex == lockedRowCount-1)
            		g.lineStyle(1, 0);
        	else
            		g.lineStyle(1, color);
        
 			var columnCnt:Number = this.visibleColumns.length;
 			g.moveTo(0, y);
 			var item:IListItemRenderer;
 			var nextItem:IListItemRenderer;
 			var dataField:String;
 			var nextIndex:int = rowIndex + 1; 
 			for (var i:int = 0; i < columnCnt; i++) {
 				if (rowIndex <= listItems.length -2 ) {
 					item = listItems[rowIndex][i];
 					nextItem = listItems[nextIndex][i];
 					if (item && nextItem && item.data && nextItem.data) {
						dataField = visibleColumns[i].dataField;
						if (visibleColumns[i] is IMergeable && IMergeable(visibleColumns[i]).enableMerge && item.data[dataField] == nextItem.data[dataField]) {
							//if next item in the same calumn has the same data with the one up above
							//just pass on to the next item renderer in the same row
							g.moveTo(item.x + item.width, y);
						} else {
							//draws line startring from the item renderer's x position to the end of the item renderer
							g.lineTo(item.x + item.width, y);
						}
 					} else {
 						//just draws line to the end of the dataGrid
 						g.lineTo(this.listContent.width,y);
 					}
 				}
 			}       
		} else {
			super.drawHorizontalLine(s, rowIndex, color, y);
		}
	}
	
	/**********
	 * @private
	 * 
	 * Overriden method to regenerate itemRenderer instances when verticall scroll position changes.
	 * Basically, flex's Datagrid doesn't recreate itemRenderers when users scroll up and down the
	 * DataGrid since it could be cpu intensive. Yet we have to regenerate every time scroll moves
	 * up and down since we dynamically merge row items. Also we need to update rowInfo's data
	 * which is being refreshed whenever itemRenderers are regenerated. Otherwise, rowInfo's data
	 * tend to have old values which don't quite represent itemRenderers shown on a DataGrid. 
	 */
	override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean):void {
		super.scrollVertically(pos, deltaPos, scrollUp);
		//forcefully draws line and column background 
		//since vertical scrolling doesn't trigger line drawing OTL 
		if (isMergeMode) {
    		drawLinesAndColumnBackgrounds(); 
    		hideHightlightLayer();
    		//*very important*
			//we need to update rowInfo's data so should call
			//invalidateList() here to update rowInfos and trigger redrawing of item renderers.
			this.invalidateList();
		}
		//callLater(hideHightlightLayer);
	}
	
	/**
	 * @private
	 * 
	 * Overriden method to update the display. 
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		hideDefaultSelection();
	}
	
	/**
	 * @private 
	 * 
	 * Overriden method to apply checkBox itemRenderers using AdvancedZetDataGridColumn's property value.
	 * */
	override mx_internal function getRenderer(c:AdvancedDataGridColumn, itemData:Object, forDragProxy:Boolean = false ):IListItemRenderer
	{
		var renderer:IListItemRenderer = super.getRenderer(c, itemData, forDragProxy);
		if (c is AdvancedZetDataGridColumn && AdvancedZetDataGridColumn(c).checked && c.itemRenderer is DataGridCheckBoxRenderer == false) { 
			c.itemRenderer = new ClassFactory(DataGridCheckBoxRenderer);
		}
		return renderer;
	}
	
	
	
	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------
	
	/**
	 * Moves selectedItem(s) one index up.
	 **/
	public function moveSelectedItemsUp():void {
		ListBaseUtil.moveItemUp(this);
	}
	/**
	 * Moves selectedItem(s) one index down.
	 **/
	public function moveSelectedItemsDown():void {
		ListBaseUtil.moveItemDown(this);
	}
	
	/***
	 * @private 
	 * 
	 * Internal method to draw row background of cells. 
	 */
	private function drawBackground():void {
		var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
        if (!rowBGs)
        {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            listContent.addChildAt(rowBGs, 0);
        }
		var len:Number = this.listItems.length;
		var columnCnt:Number = this.visibleColumns.length;
		var colors:Array = getStyle("alternatingItemColors");
		var k:Number = 0;
		var item:IListItemRenderer;
		var color:uint;
		var dataField:String;
		var g:Graphics;
		for (var i:Number = 0; i< columnCnt; i++) {
			k = 0;
			dataField = visibleColumns[i].dataField;
			if (baseColorField && baseColorField != dataField)
			{
				continue;
			} 
			for (var j:Number = 0; j < len ; j++) 
			{
				var background:Shape;
        		if (j < rowBGs.numChildren)
        		{
            		background = Shape(rowBGs.getChildAt(j));
        		}
        		else
        		{
           			 background = new FlexShape();
            		 background.name = "background";
            		 rowBGs.addChild(background);
        		}
				item = this.listItems[j][i];
				background.y = rowInfo[j].y;
				if (item) 
				{
					if (item.data && cellColorFunction != null) 
					{
						color = cellColorFunction(item.data);
						g = background.graphics;
						g.beginFill(color, getStyle("backgroundAlpha"));
						g.drawRect(item.x, 0, item.width, rowInfo[j].height);
					} else 
					{
						if (j == 0) {
							color = colors[k%colors.length];
						} else {
							if (visibleColumns[i] is IMergeable && IMergeable(visibleColumns[i]).enableMerge && item.data && item.data[dataField] == listItems[j-1][i].data[dataField]) {
								color = colors[k%colors.length];
							} else {
								k++;
								color = colors[k%colors.length];
							}
						}
						g = background.graphics;
						g.beginFill(color, getStyle("backgroundAlpha"));
						if (baseColorField) 
						{
							g.drawRect(0, 0, unscaledWidth, rowInfo[j].height);
						} else 
						{
							g.drawRect(item.x, 0, item.width, rowInfo[j].height);
						}
						
					}
				} else 
				{
					k++;
					color = colors[k%colors.length];
					g = background.graphics;
					g.beginFill(color, getStyle("backgroundAlpha"));
					g.drawRect(0, 0, unscaledWidth, rowInfo[j].height);
				}
			} 
		}
		try {
			g.endFill();
		} catch (e:Error) {
			
		}
		
	}
	
		/**
	 * @private
	 * 
	 * Internal method to set every itemRenderer instance in listItems array to
	 * its original status. Uses rowInfo to reference itemRenderers' original height.
	 * This method is required since we forecefully sets many itemrenderers' height to zero
	 * to show as if they were merged vertically. 
	 **/	
	private function init():void {
		var len:int = this.listItems.length;
		var columnCnt:int = this.visibleColumns.length;
		var dataField:String;
		var flag:Boolean = this.variableRowHeight;
		var column:AdvancedDataGridColumn;
		for (var i:int= 0; i < columnCnt; i++) {
			dataField = visibleColumns[i].dataField;
			column = visibleColumns[i];
			for (var j:int = 0; j <len; j++) {
				var item:IListItemRenderer = this.listItems[j][i];
				if (item && item.data) {
					//var mergeItem:MergeItem  = mergeHelper[dataField + itemToUID(item.data)];
					//item.y = mergeItem? mergeItem.originY: item.y;
					item.y = rowInfo[j].y;
 					if (item)
					{
						item.y = this.rowInfo[j].y;
						if (item is AdvancedDataGridItemRenderer) 
						{
							item.height = this.rowInfo[j].height;
						} else 
						{
							item.height = this.rowInfo[j].height - this.cachedPaddingTop - this.cachedPaddingBottom;
						}
					}
				}
			}
		}
	}

	
	/**
	 * @private
	 * 
	 * Internal function called by mouseOverHandler to draw mouseOver highlight on a DataGrid.
	 **/
	private function drawRect(event:MouseEvent = null, isRollOver:Boolean = true):void {
		var layer:Sprite = getHighlightLayer();
		var pt:Point  = new Point(event.stageX, event.stageY);
		var rect:Rectangle = getDrawingRect(pt);
		var g:Graphics = layer.graphics;
		g.clear();
		var color:uint = isRollOver?getStyle("rollOverColor"):getStyle("selectionColor");
		if (rect) {
			g.moveTo(rect.x, rect.y);
			g.beginFill(color, 1);
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
			g.endFill();
		}
	}
	
	
	/**
	 * @private
	 * 
	 * Internal method used to hide default hightlight rectangle. 
	 **/
	private function hideDefaultSelection():void {
		var len:int = this.selectionLayer.numChildren;
		for (var i:int = 0; i < this.selectionLayer.numChildren; i++) {
			var child:DisplayObject = this.selectionLayer.getChildAt(i);
			if (this.selectionLayer.contains(child) && child.name.indexOf("SpriteAsset") != -1) {
				child.visible = false;
			}
		}
	}
	
		/**
	 * @private
	 * 
	 * Internal method used to calculate the hightlight rectangle area of a certain point.  
	 **/
	private function getDrawingRect(pt:Point):Rectangle {
		var rect:Rectangle;
		var columnIdx:int = getMouseColumnIndex(pt);
		var len:int = this.listItems.length;
		var item:IListItemRenderer;
		var dataField:String = visibleColumns[columnIdx].dataField;
		var itemPoint:Point;
		var i:int;
		var mergeItem:MergeItem;
		var rollOverItem:IListItemRenderer;
		for (i = 0; i <len; i++) {
			item = listItems[i][columnIdx];
			if (item) {
				itemPoint = new Point(item.x, rowInfo[i].y);
				itemPoint = localToGlobal(itemPoint);
				if (pt.x >= itemPoint.x && pt.x <= itemPoint.x + item.width && pt.y >= itemPoint.y && pt.y <= itemPoint.y + rowInfo[i].height) {
					if (item.height != 0) {
						mergeItem = mergeHelper[dataField + itemToUID(item.data)];
						if (mergeItem && mergeItem.item == item) {
							rect = new Rectangle(item.x, mergeItem.originY, item.width, mergeItem.totalHeight - this.cachedPaddingTop - this.cachedPaddingBottom);
						} else {
							if (item is AdvancedDataGridItemRenderer) 
							{
								rect = new Rectangle(item.x, item.y, item.width, item.height);
								
							} else 
							{
								rect = new Rectangle(item.x, item.y, item.width, item.height + this.cachedPaddingBottom + this.cachedPaddingTop);
							}
						}
						return rect;
					} else {
						rollOverItem = item;
						break;
					}
				}
			}
		}
		if (!rollOverItem) {
			 return null; 
		}
		for (i = 0; i < len ; i++) {
			item = listItems[i][columnIdx];
			mergeItem = mergeHelper[dataField + itemToUID(item.data)];
			if (mergeItem) {
				if (rollOverItem.y >= mergeItem.originY && rollOverItem.y <= mergeItem.originY + mergeItem.totalHeight) {
					rect = new Rectangle(item.x, mergeItem.originY, item.width, mergeItem.totalHeight - this.cachedPaddingTop - this.cachedPaddingBottom);
					return rect;
				}
			} 
		} 
		return rect;
	}
	
	/**
	 * @private
	 * 
	 * Internal method used to return a columnIndex based on a mouse point.
	 **/
	private function getMouseColumnIndex(pt:Point):int {
		var columnCnt:Number = this.visibleColumns.length;
		var index:int;
		var itemPoint:Point = new Point();
		for (var i:int=0; i < columnCnt; i++) {
			if (listItems[0][i]) {
				itemPoint.x  = listItems[0][i].x;
				itemPoint = this.localToGlobal(itemPoint);
				if (pt.x >= itemPoint.x && pt.x <= itemPoint.x + listItems[0][i].width) {
					index = i;
					break;
				}
			}
		}
		return index; 
	}

	/**
	 * Accepts an item renderer as its parameter
	 * and returns corresponding AdvancedDataGridColumn instance
	 * to which the renderer belongs.
	 * 
	 * */
	private function itemToDataGridColumn(item:IListItemRenderer):AdvancedDataGridColumn {
       var c:AdvancedDataGridColumn = columnMap[item.name];
       return c;
	}
	
		/**
	 * Internal method to hide custom hightlight layer.
	 * */
	private function hideHightlightLayer():void {
		var g:Graphics = getHighlightLayer().graphics;
		g.clear();
	}
	
	/**
	 * Internal method to return a custom hightlight layer.
	 * */
	private function getHighlightLayer():Sprite {
		var layer:Sprite = this.selectionLayer.getChildByName("drawLayer") as Sprite;
		if (!layer) {
			layer = new Sprite();
			layer.name = "drawLayer";
			this.selectionLayer.addChild(layer);
		}
		return layer;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to indicate whether a column is IMergeable or not. A column should be IMergeable
	 * type to allow data merge of that column. An implementation of IMergeable type is ZetDataGridColumn.
	 * 
	 **/
	private function isMergeable(c:IMergeable):Boolean {
		if (c is IMergeable && IMergeable(c).enableMerge) {
			return true;
		}
		return false;
	}
	
	/**
	 * @private
	 * 
	 * Internal method used to layout FilterPopUp instance's position.
	 */
	private function setFilterPopUpPosition():void {
		var len:int = Application.application.systemManager.numChildren;
		var popUp:FilterPopUp = PopUpUtil.getPopUpInstanceOf(FilterPopUp) as FilterPopUp;
		if (popUp  && popUp.owner) {
			var field:String = popUp.dataField;
			len = this.visibleColumns.length;
			var startX:int = this.x - popUp.width+2;
			var startY:int = this.y;
			for (var i:int=0; i<len;i++) {
				startX += visibleColumns[i].width;
				if (visibleColumns[i].dataField == field) {
					break;
				}
			}
			var point:Point = new Point(startX,startY+24);
			point = this.localToGlobal(point);
			popUp.x =point.x;
			popUp.y = point.y;
		}
	}
	
	/**
	 * @private
	 * Internal method to hide filter popup.
	 **/
	private function hideFilterPopUp():void {
		var len:int = mx.core.Application.application.systemManager.numChildren;
		for (var i:int = 0; i < len; i++) {
			var filterPopUp:FilterPopUp = Application.application.systemManager.getChildAt(i) as FilterPopUp;
			if (filterPopUp && filterPopUp.owner == this) {
				mx.managers.PopUpManager.removePopUp(filterPopUp);
			}
		}
	}
	
	
	//--------------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------------
	
	/**
	 * @private
	 * 
	 * Overriden method to handle mouseOver event. Since we merge items vertically, we apply
	 * our own logic to show mouseOver highlight on a DataGrid. 
	 **/
	override protected function mouseOverHandler(event:MouseEvent):void {
		if (isMergeMode) {
			drawRect(event,true);
		} else {
			super.mouseOverHandler(event);
		}
	}
	
	/**
	 * @private
	 * 
	 * Overriden method to handle mouseDown event. This method hides default selection layer and
	 * draws a custom rectangle highlight on a DataGrid. 
	 **/
	override protected function mouseDownHandler(event:MouseEvent):void {
		super.mouseDownHandler(event);
		//finds the currently selected item and clears its highlight
		/* var item:IListItemRenderer = mouseEventToItemRenderer(event);
		if (item) clearHighlight(item);  */
		if (isMergeMode) {
    		hideDefaultSelection();
    		drawRect(event, false);
		} 
	}
		/**
	 * @private
	 * 
	 * Overriden method to tackle mouseOut event. Also tries to hide default selection highlight.
	 **/
	override protected function mouseOutHandler(event:MouseEvent):void {
		super.mouseOutHandler(event);
		if (isMergeMode) hideHightlightLayer();
	}
	
	//--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
	
	/**
	 * @private
	 * complete event handler method.
	 **/
	 private function completeHandler(event:FlexEvent):void {
		this.removeEventListener(FlexEvent.CREATION_COMPLETE, completeHandler);
		systemManager.addEventListener(Event.RESIZE, systemResizeHandler, false, 0, true);
		systemManager.addEventListener(MouseEvent.MOUSE_DOWN, systemMouseDownHandler, false, 0, true);
		
		this.oldSortableColumns = this.sortableColumns;
		
		if (enableFilter) {
			var len:int = this.visibleColumns.length;
			for (var i:int = 0; i < len; i++) {
				visibleColumns[i].headerRenderer = new ClassFactory(FilterItemRenderer);
			}
		} 
		this.invalidateDisplayList();
	} 
	
	/**
	 * @private
	 * system's mouseDown event handler method to hide filterPopUp.
	 **/
	private function systemMouseDownHandler(event:MouseEvent):void {
		var len:int = mx.core.Application.application.systemManager.numChildren;
		for (var i:int = 0; i < len; i++) {
			var filterPopUp:FilterPopUp = Application.application.systemManager.getChildAt(i) as FilterPopUp;
			if (filterPopUp && filterPopUp.owner == this) {
				if (!ChildHierarchyUtil.contains(filterPopUp, event.target as DisplayObject)) {
					mx.managers.PopUpManager.removePopUp(filterPopUp);
				}
			}
		}
	}
	/**
	 * @private
	 * system's resize event handler method to hide filterPopUp.
	 **/
	private function systemResizeHandler(event:Event):void {
		hideFilterPopUp();
	}
	
	/**
	 * @private
	 * Internal resize handler method. Uses callLater method to trigger new layout of FilterPopUp instance
	 * 
	 **/
	private function resizeHandler(event:ResizeEvent):void {
		hideFilterPopUp();
	}
	
		
	/**
	 * @private
	 * Internal columnStretch handler method. Uses callLater method to trigger new layout of FilterPopUp instance
	 * 
	 **/
	private function stretchHandler(event:AdvancedDataGridEvent):void {
		hideFilterPopUp();
	}
	
}
}