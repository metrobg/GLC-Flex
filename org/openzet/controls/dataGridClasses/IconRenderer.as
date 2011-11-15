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
package org.openzet.controls.dataGridClasses
{
//--------------------------------------------------------------------------------
//
//  Imports
//
//--------------------------------------------------------------------------------
//----------------------------------------
//  Adobe Classes
//----------------------------------------
import flash.display.DisplayObject;
import flash.display.InteractiveObject;

import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IUITextField;
import mx.core.SpriteAsset;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.events.FlexEvent;
import mx.states.AddChild;

/**
 *  Custom itemRenderer class to display images for each file extension in a DataGrid.
 *
 *  @includeExample IconRendererExample.mxml
 */
public class IconRenderer extends UIComponent implements IDataRenderer, IListItemRenderer, IDropInListItemRenderer
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------------
    /**
     * Constructor
     *
     */
    public function IconRenderer():void
    {
        super();
    }

    //--------------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------------

    /**
     * @private
     *
     * IFlexDisplayObject to hold image class's instance
     */
    public var icon:IFlexDisplayObject;

    //--------------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------------

    private var tf:IUITextField;

    /**
	 * @private
	 *
	 * Internal data property. An implementation of IDataRenderer interface.
	 */
	private var _data:Object;

	public function set data(value:Object):void
	{
		_data = value;
		dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	}

	/**
	 * @public
	 *
	 * Implementation of IDataRenderer interface.
	 */
	public function get data():Object
	{
		return _data;
	}

	/**
    * @private
    */
    private var _listData:BaseListData;

	/**
    * @private
    */
    public function set listData(value:BaseListData):void
    {
      _listData = value;
    }

    /**
    * Implementation of IDropInListItemRenderer interface.
    */
    public function get listData():BaseListData
    {
      return _listData;
    }

    //--------------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------------

    /**
	 * @protected
	 *
	 */
	override protected function commitProperties():void
	{
		super.commitProperties();
        update();
	}

    //--------------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------------

    /**
    * @private
    *
    * Displays image icon for each file extenstion.
    */
    private function update():void
    {
        reset();
        if (_data)
        {
            if(_listData)
            {
            	var columnWidth:Number = DataGrid(listData.owner).columns[(listData.columnIndex)].width;

                if(DataGridListData(listData).label == "" || DataGridListData(listData).label == null)
                {
                	tf = new UITextField;
                	tf.text = "";
                	var tfWidth:Number = tf.getExplicitOrMeasuredHeight();
                    var tfX:Number = (columnWidth-tfWidth)/ 2;
                    tf.x = tfX;
                	this.addChild(tf as DisplayObject);
                }
                else
                {
                    var tempArr:Array = DataGridListData(listData).label.split(".");
        			var iconClass:Class = IconAsset.getIcon(tempArr[(tempArr.length-1)]);
                    var iconInstance:* = new iconClass();

                    if (!(iconInstance is InteractiveObject))
                    {
                        var wrapper:SpriteAsset = new SpriteAsset();
                        wrapper.addChild(iconInstance as DisplayObject);
                        icon = wrapper as IFlexDisplayObject;
                    }
                    else
                    {
                        icon = iconInstance;
                    }
                    var iconWidth:Number = icon.width;
                    var iconX:Number = (columnWidth - iconWidth) / 2;
                    icon.x = iconX;
        			addChild(icon as DisplayObject);
                }

            }
		}
    }

    /**
    * @private
    *
    * If DataGrid would be changed, this reset the ItemRenderer's DisplayObject.
    */
    private function reset():void
    {
		if (icon && this.contains(icon as DisplayObject))
		{
			removeChild(icon as DisplayObject);
			icon = null;
		}
		if (tf && this.contains(tf as DisplayObject))
		{
			this.removeChild(tf as DisplayObject);
			tf = null;
		}
	}
}
}