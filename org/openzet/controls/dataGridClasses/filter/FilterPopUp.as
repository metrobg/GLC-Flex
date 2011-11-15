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
import flash.display.Graphics;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Button;
import mx.controls.CheckBox;

import org.openzet.utils.PopUpUtil;

//------------------------------------------
//  Styles
//------------------------------------------


/**
 *  @copy mx.core.Container#paddingLeft
 * 
 *  @default 5
 */
[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#paddingRight
 * 
 *  @default 5
 */
[Style(name="paddingRight", type="Number", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#paddingTop
 * 
 *  @default 5
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#paddingBottom
 * 
 *  @default 5
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#dropShadowEnabled
 * 
 *  @default true
 */
[Style(name="dropShadowEnabled", type="Boolean", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#borderStyle
 * 
 *  @default solid
 */
[Style(name="borderStyle", type="String", format="Length", inherit="no")]

/**
 *  @copy mx.core.Container#cornerRadius
 * 
 *  @default 3
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]


/**
 * PopUp class that extends VBox class to show distinct data of a specific column with CheckBoxes
 * and Buttons.
 * 
 * @see org.openzet.dataGridClasses.filter.FilterHelper
 * @see org.openzet.dataGridClasses.filter.FilterItemRenderer
 * @see org.openzet.dataGridClasses.filter.FilterManager
 **/
public class FilterPopUp extends VBox
{
	
	include "../../../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 * 
	 * Sets its default styles.
	 **/
	public function FilterPopUp() {
		super();
	}
	
	
  //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

		/**
	 * @private
	 * 
	 * Internal ArrayCollection instance used to hold data for this instance. This property's value is set
	 * along with dataField property.
	 * 
	 **/
	private var dataProvider:ArrayCollection;

 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


	/**
	 * @private 
	 * Internal dataField property to represent a column's dataField where this popUp instance belongs.
	 **/
	private var _dataField:String;
	
	/**
	 * @private
	 **/
	public function set dataField(value:String):void {
		_dataField = value;
		if (this.numChildren>0) this.removeAllChildren();
		dataProvider = filterHelper.getDataByField(this.dataField);
		makeInfo();
	}
	
	/**
	 * A property to specify a column's dataField to which this instance conceptually maps. When this property is set,
	 * this instance automatically gets its dataProvider using FilterHelper instance specified by filterHelper property.
	 * 
	 **/
	public function get dataField():String {
		return _dataField;
	}
	
	/**
	 * @private
	 * 
	 * Internal FilterHelper instance that holds reference to the FilterHelper instance used to apply
	 * data filtering on the current DataGrid instance.
	 * 
	 **/
	private var _filterHelper:FilterHelper;
	
	/**
	 * @private
	 **/
	public function set filterHelper(value:FilterHelper):void {
		_filterHelper = value;
	}
	
	/**
	 * A property to specify FilterHelper instance. FilterHelper instance is specified by FilterManager class
	 * and always set before this instance's dataProvider property. 
	 **/
	public function get filterHelper():FilterHelper {
		return _filterHelper;
	}
	
	/**
	 * @private
	 * 
	 * Internal getter method to indicate whether All checkBox has been checked or not.
	 * 
	 **/
	private function get isAllChecked():Boolean {
		var checkedItems:Array = getCheckedItems();
		if (checkedItems && checkedItems.length == this.numChildren - 2) {
			return true;
		}
		return false;
	}
	
	/**
	 * @private
	 * 
	 * Internal getter method to indicate whether All checkBox has been unchecked or not.
	 * 
	 **/
	private function get isAllUnchecked():Boolean {
		var uncheckedItems:Array = getUncheckedItems();
		if (uncheckedItems && uncheckedItems.length == this.numChildren - 2) {
			return true;
		} 
		return false;
	}
	
		
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------


		/**
	 * @private
	 * 
	 * Overriden method to draw a visible rectangle around the instance's border.
	 * 
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		var g:Graphics = this.graphics;
		g.clear();
		g.lineStyle(1,0xcccccc);
		g.beginFill(0xFFFFFF);
		g.drawRect(0,0,unscaledWidth,unscaledHeight);
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
	 * Internal method to dynamically generate CheckBox and Button instances with the given information. Now
	 * the given information is managed by FilterHelper instance and FilterManager class. FilterManager class
	 * chooses the right FilterHelper instance for each FilterPopUp instance and FilterHelper class then gets
	 * appropriate data for each dataField with its own filtering logic.
	 **/
	private function makeInfo():void {
		var total:CheckBox = new CheckBox();
		total.label = "All";
		addChild(total);
		var filterData:Array = filterHelper.getFilterDataByField(this.dataField);
		total.addEventListener(MouseEvent.CLICK, allClickHandler, false, 0, true);
		total.selected = filterData?false:true;
		var i:int = 0;
		var cb:CheckBox;
		if (filterData) {
			var counter:int = 0;
			for (i = 0; i <dataProvider.length; i++) {
				cb = new CheckBox();
				cb.addEventListener(MouseEvent.CLICK, cbClickHandler, false, 0, true);
				cb.label = dataProvider[i][dataField];
				addChild(cb);
				for (var j:int = 0; j < filterData.length; j++) {
					if (dataProvider[i][dataField] == filterData[j].value) {
						cb.selected = true;
						counter++;
						break;
					}
				}
			}
			if (counter == dataProvider.length) total.selected = true;
		} else {
			for (i = 0; i <dataProvider.length; i++) {
				cb = new CheckBox();
				cb.addEventListener(MouseEvent.CLICK, cbClickHandler, false, 0, true);
				cb.label = dataProvider[i][dataField];
				cb.selected = true;
				addChild(cb);
			}
			total.selected = true;
		}
	
		var hBox:HBox = new HBox();
		hBox.percentWidth = 100;
		var confirm:Button = new Button();
		confirm.label="Confirm";
		confirm.name = "Confirm";
		confirm.addEventListener(MouseEvent.CLICK,bnClickHandler,false,0,true);
		var cancel:Button = new Button();
		cancel.name = "Cancel";
		cancel.label="Cancel";
		cancel.addEventListener(MouseEvent.CLICK,bnClickHandler,false,0,true);
		hBox.addChild(confirm);
		hBox.addChild(cancel);
		addChild(hBox);
	}
	
	/**
	 * @private
	 * 
	 * Internal method to track which items of all checkBoxes have been checked.
	 * 
	 **/
	private function getCheckedItems():Array {
		var result:Array;
		for (var i:int=0; i<this.numChildren;i++) {
			if (this.getChildAt(i) is CheckBox) {
				if (CheckBox(this.getChildAt(i)).label !="All" &&CheckBox(this.getChildAt(i)).selected) {
					if (!result) result = [];
					var filter:Object ={};
					filter.field = dataField;
					filter.value = CheckBox(this.getChildAt(i)).label;
					result.push(filter);
				}
			}
		}
		return result;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to track which items of all checkBoxes have been unchecked.
	 * 
	 **/
	private function getUncheckedItems():Array {
		var result:Array;
		for (var i:int=0; i<this.numChildren;i++) {
			if (this.getChildAt(i) is CheckBox) {
				if (CheckBox(this.getChildAt(i)).label !="All" && !CheckBox(this.getChildAt(i)).selected) {
					if (!result) result = [];
					var filter:Object ={};
					filter.field = dataField;
					filter.value = CheckBox(this.getChildAt(i)).label;
					result.push(filter);
				}
			}
		}
		return result;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to disable Confirm button when no checkbox is checked at all.
	 * 
	 **/
	private function changeConfirmState():void {
		var hBox:HBox = this.getChildAt(this.numChildren - 1) as HBox;
		if (isAllUnchecked) {
			Button(hBox.getChildByName("Confirm")).enabled = false;
		} else {
			Button(hBox.getChildByName("Confirm")).enabled = true;
		}
	}
	
	//--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------

	
	/**
	 * @private
	 * 
	 * Internal mouseClick event handler to handle a case when user clicked All checkbox at the top.
	 **/
	private function allClickHandler(event:MouseEvent):void {
		var len:int = this.numChildren - 1;
		for (var i:int = 1; i <len; i++) {
			if (this.getChildAt(i) is CheckBox) {
				CheckBox(this.getChildAt(i)).selected = event.currentTarget.selected;
			}
		}
		changeConfirmState();
	}
	
	/**
	 * @private
	 * 
	 * Internal mouseClick event handler to handle a CheckBox's mouseClick event.
	 **/
	private function cbClickHandler(event:MouseEvent):void {
		changeConfirmState();
	}
	
	/**
	 * @private
	 * 
	 * Internal mouseClick event handler to Button's click event.
	 */
	private function bnClickHandler(event:MouseEvent):void {
		if (event.currentTarget.label=="Confirm") {
			if (isAllChecked) {
				filterHelper.addAllField(this.dataField);
			} else {
				var check_result:Array = getCheckedItems();
				var uncheck_result:Array = getUncheckedItems();
				filterHelper.addFilters(check_result, uncheck_result, isAllChecked);
			}
		} 
		PopUpUtil.removePopUpInstanceOf(FilterPopUp);
	}
}
}