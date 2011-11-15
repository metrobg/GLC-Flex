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
package org.openzet.controls.dataGridClasses.filter
{
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.controls.PopUpButton;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.managers.PopUpManager;

import org.openzet.utils.PopUpUtil;

/**
 * An ItemRenderer class that implements Excel-like data filtering feautre on a 
 * DataGrid's header. 
 * 
 * @see org.openzet.dataGridClasses.filter.FilterManager
 * @see org.openzet.dataGridClasses.filter.FilterHelper
 * @see org.openzet.dataGridClasses.filter.FilterPopUp
 **/
public class FilterItemRenderer extends PopUpButton
{
	include "../../../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function FilterItemRenderer()
	{
		super();
		// disables mousChildren property so that any children of this instance
		// should not be mouse reactive.
		this.mouseChildren=true;
	}

	
 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Internal Sprite object used to mark a hit area of a PopUpButton.
	 * 
	 **/
	private var _hitArea:Sprite;
	
	/**
	 * @private
	 * Internal data property
	 **/
	private var _data:Object;
	
	/**
	 * @private
	 * 
	 **/
	override public function set data(value:Object):void {
		_data = value;
	}
	
	/**
	 * @private
	 * 
	 * Internal filter_popUp instance that is used to show filtering data of a certain column. FilterPopUp
	 * instance is used as a PopUp display object to allow users to apply custom filtering on each column.
	 */
	private var filter_popUp:FilterPopUp;
	
	/**
	 * @private
	 * 
	 * Internal FilterHelper instance that is used to help apply filtering logic. 
	 */
	private var filterHelper:FilterHelper;
	
	
	 //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Internal mouseClick event handler method to tackle mouse click event on a hitArea. This method
	 * pops up FilterPopUp instance provides dataProvider using this instance's owner property.
	 **/
	private function arrowClickHandler(event:MouseEvent):void {
		PopUpUtil.removePopUpInstanceOf(FilterPopUp);
		filter_popUp = PopUpManager.createPopUp(mx.core.Application.application as Sprite,FilterPopUp) as FilterPopUp;
		filterHelper = FilterManager.getInstance().getFilter(this.listData.owner);
		filter_popUp.owner = this.listData.owner as DisplayObjectContainer;
		if (!filterHelper.dataProvider) filterHelper.dataProvider = Object(this.listData.owner).dataProvider;
		
		filter_popUp.filterHelper = filterHelper;
		
		if (_data is DataGridColumn) {
			filter_popUp.dataField = DataGridColumn(_data).dataField;
		} else {
			filter_popUp.dataField = AdvancedDataGridColumn(_data).dataField;
		}
		
		filter_popUp.width = 180;
		filter_popUp.height = 220;
		
		var point:Point = new Point(_hitArea.x,_hitArea.y);
		point = this.localToGlobal(point);
		filter_popUp.x = point.x - filter_popUp.width + 20;
		filter_popUp.y = point.y + 22; 
	}
	
		
	/**
	 * @private
	 * 
	 * Overriden method to add a hitArea sprite to a child of this instance and register a mouseClick
	 * event thereupon.
	 **/
	override protected function createChildren():void {
		super.createChildren();
		_hitArea = new Sprite();
		addChild(_hitArea);
		_hitArea.mouseEnabled=true;
		_hitArea.mouseChildren=true;
		_hitArea.addEventListener(MouseEvent.CLICK, arrowClickHandler, false, 0, true);
	}
		
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
		/**
	 * @private
	 * 
	 * Overriden method to refresh drawing loginc on a hitArea whenever superClass' updateDisplay method
	 * is being called.
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		_hitArea.x = unscaledWidth - _hitArea.width;
		_hitArea.width = 20;
		_hitArea.height = 20;
		var g:Graphics = _hitArea.graphics;
		g.clear();
		g.lineStyle(0,0,0);
		g.beginFill(0xFFFFFF,0);
		g.drawRect(0,0,20,20);
		g.endFill(); 
	}
	
    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Internal method to adjust position of a FilterPopUp instance.
	 **/
	private function pointPopUp():void {
		var point:Point = new Point(_hitArea.x,_hitArea.y);
		point = this.localToGlobal(point);
		filter_popUp.x = point.x - filter_popUp.width + 20;
		filter_popUp.y = point.y + 20;
	}
	
}
}