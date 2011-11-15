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
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.controls.TextInput;
import mx.controls.listClasses.ListBase;
import mx.events.FlexEvent;
import mx.events.FlexMouseEvent;
import mx.events.ListEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
import mx.utils.UIDUtil;

import org.openzet.utils.DataUtil;
import org.openzet.utils.HangulFilter;

/***
 * Flex version of SuggestInput class that extends TextInput class. This class provides dropdown list control
 * to show possible candiates of words that users might chooose.
 **/
public class SuggestInput extends TextInput
{

	include "../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *
	 * Constructor
	 *
	 * <p>Adds event listeners to handle events such as keyDown, resize events, etc.</p>
	 */
	public function SuggestInput()
	{
		super();
		this.addEventListener(FlexEvent.CREATION_COMPLETE, completeHandler, false, 0, true);
		this.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler, false, 0, true);
		this.addEventListener(ResizeEvent.RESIZE,resizeHandler, false, 0, true);
	}

	/**
	 * @private
	 * Character code table
	 **/
	private var charCodeTable:Dictionary;





	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 **/
	private var _listBase:ListBase;
	/**
	 * @private
	 */
	public function set list(value:ListBase):void
	{
		if(!_listBase)
		{
			_listBase = value;
			list.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,listMouseDownOutsideHandler);
			list.addEventListener(ListEvent.ITEM_CLICK,itemClickHandler);
			list.addEventListener(KeyboardEvent.KEY_DOWN,listKeyDownHandler);
			dispatchEvent(new Event("listChanged"));
		}
	}

	/**
	 * Property to specify a list-like control to use as a dropdown control.
	 **/
	[Bindable("listChanged")]
	[Inspectable(type="mx.controls.listClasses.ListBase")]
	public function get list():ListBase
	{
		return _listBase;
	}

	/**
	 * @private
	 **/
	private var _dataProvider:Object;

	/**
	 * @private
	 */
	public function set dataProvider(value:Object):void
	{
		_dataProvider = DataUtil.objectToArrayCollection(value);
		list.dataProvider = dataProvider;
		DataUtil.applyUID(_dataProvider as ArrayCollection);
		charCodeTable = HangulFilter.hashToCharMap(_dataProvider as ICollectionView, displayField);
		dataProvider.filterFunction = filterFunc;
		dispatchEvent(new Event("dataProviderChanged"));
	}

	/***
	 * Dataprovider property to provide dropdown control with a dataProvider.
	 **/
	[Bindable("dataProviderChanged")]
	public function get dataProvider():Object
	{
		return _dataProvider;
	}

	private var _displayField:String;
	/**
	 * @private
	 */
	public function set displayField(value:String):void
	{
		_displayField = value;
	}

	/**
	 * Property to specify a field name of the dataProvider on which to apply data filtering.
	 * This property should always be set, otherwise this control would not function correctly.
	 **/
	public function get displayField():String
	{
		return _displayField;
	}

	/**
	 * @private
	 *
	 * Internal setter method specifying whether to show dropdown control or not.
	 **/
	private function set showDropDown(value:Boolean):void
	{
		list.visible = value;
	}

	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

	/**
	 * @private
	 *
	 * Internal method to layout dropdown list control.
	 **/
	private function applyLayout():void
	{
		var point:Point = new Point(this.x,this.y);
     	point = this.localToGlobal(point);
        list.x = point.x;
        list.y = point.y + this.height;
      	list.width =  list.width ==  0 ? this.width : list.width;
      	list.height =  list.height ==  0 ? 200: list.height;
	}


		/**
	 * @private
	 *
	 * Internal filterFunction method used to filter data in a dropdown control.
	 */
	private function filterFunc(item:Object):Boolean {
		var uid:String = mx.utils.UIDUtil.getUID(item);
		var codesArr:Array = charCodeTable[uid];
		var flag:Boolean = HangulFilter.containsChar(this.textField.text, codesArr);
		return flag;
	 }


 	//--------------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------------
    /**
    * @private
    *
    * Overriden method to handle keyUp event.
    *
    **/
    override protected function keyUpHandler(event:KeyboardEvent):void {
    	super.keyUpHandler(event);
    	dataProvider.refresh();
    	showDropDown = StringUtil.trim(this.textField.text).length == 0?false:true;
    }


	//--------------------------------------------------------------------------
    //
    //  EventHandler
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    *
    * Internal complete event handler method.
    *
    **/
	private function completeHandler(e:FlexEvent):void
	{
		this.textField.alwaysShowSelection = true;
    	applyLayout();
    	PopUpManager.addPopUp(list,this);
    	showDropDown = false;
	}

	/**
    * @private
    *
    * Internal keyDown event handler method. Allows keybord selection of dropdown control's selectedIndex.
    *
    **/
	private function keyHandler(e:KeyboardEvent):void
	{
		if (e.keyCode == Keyboard.BACKSPACE ) {
	 		if (this.textField.text.length==0) {
	 			showDropDown = false;
	 		}
     	}
 		if (e.keyCode == Keyboard.DOWN) {
 			showDropDown = true;
   			list.setFocus();
   			list.invalidateDisplayList();
   			list.selectedIndex=0;
   		}
	}

	/**
    * @private
    *
    * Internal itemClick event handler method.
    **/
	private function itemClickHandler(e:ListEvent):void
	{
		var index:int = e.rowIndex;
	     if (index >= 0) {
		      this.textField.text = list.selectedItem[displayField];
		      showDropDown = false;
		      list.selectedIndex = -1;
		      this.setFocus();
	     }
	}

	/**
    * @private
    *
    * Internal keyDown event handler method for a dropdown control.
    **/
	private function listKeyDownHandler(e:KeyboardEvent):void
	{
		if(list.selectedIndex != -1)
		{
			this.textField.text = list.selectedItem[displayField];
		}
		if (e.keyCode == Keyboard.ENTER) { //엔터를 칠 경우..
   			showDropDown = false;
   			list.selectedIndex = -1;
   		}
	}

		/**
    * @private
    *
    * Internal resize event handler method to hide dropdown.
    **/
	private function resizeHandler(e:ResizeEvent):void
	{
		showDropDown = false;
	}

	/**
    * @private
    *
    * Internal mouseDownOutside event handler method to hide dropdown.
    **/
	private function listMouseDownOutsideHandler(e:FlexMouseEvent):void
	{
		showDropDown = false;
	}
}
}