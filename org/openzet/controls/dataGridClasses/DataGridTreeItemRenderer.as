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
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

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
import mx.utils.UIDUtil;

/**
 * Default DataGridTreeItemRenderer class that is used within a TreeDataGrid and AdvancedTreeDataGrid.
 * 
 * @see org.openzet.controls.TreeDataGrid
 * @see org.openzet.controls.AdvancedTreeDataGrid
 **/
public class DataGridTreeItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
{
	include "../../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 **/
	public function DataGridTreeItemRenderer()
	{
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
	 * Internal IUITextField instance to represent text string.
	 **/
	protected var tf:IUITextField;
	
	
	/**
	 * @private
	 * Internal data property. An implementation of IDataRenderer interface. 
	 */
	private var _data:Object;
	
	/**
	 * @private
	 * Internal icon displayObject
	 **/
	private var icon:IFlexDisplayObject;
	
	/**
	 * Internal indent property
	 **/
	private var indent:Number;
	
	

 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

		/**
	 * Internal property to mark listData owner, which is normally DataGrid/AdvancedDataGrid or its subclass instances.
	 **/
	private var listOwner:ITreeDataGrid;
	
	/**
	 * @private
	 **/
	public function set data(value:Object):void {
		_data = value;
		invalidateProperties();
	}
	
		/**
	 * A property to specify a row item data of an itemRenderer.
	 **/
	public function get data():Object {
		return _data;
	}
	
	/**
	 * @private
	 * 
	 * Internal listData property.
	 **/
	private var _listData:BaseListData;
	
	/**
	 * @private
	 **/
	public function set listData(value:BaseListData):void {
		 _listData = DataGridListData(value);
		 if (!listOwner || value && listOwner != value ) {
		 	listOwner = ITreeDataGrid(value.owner);
		 }
    	 invalidateProperties();
	}
	
	/**
	 * An implementation of IDropInListItemRenderer interface. Now AdvancedDataGrid provides custom DataGriListData class
	 * called AdvancedDataGridListData to make a tree view in an AdvancedDataGrid. Yet here we don't define any custom ListData class
	 * yet internally uses Dictionary instances to track down tree view data. So you don't need to worry about what
	 * type of BaseListData you should provide here. Just leave either DataGrid or AdvancedDataGrid to do whatever they want.
	 **/
	public function get listData():BaseListData {
		return _listData; 
	}
	
	/**
	 * @private
	 * 
	 * Internal method to indicate whether current item is the root or not.
	 **/
	private function get isRoot():Boolean {
		var treeInfo:Dictionary = Object(this.listData.owner).treeInfo;
		if (treeInfo && treeInfo[treeUID] && !treeInfo[treeUID].parent) {
			return true;
		}
		return false;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to indicate whether current item has any children or not.
	 **/
	private function get isParentItem():Boolean {
		if (data) {
			var treeInfo:Dictionary = Object(this.listData.owner).treeInfo;
			if (treeInfo && treeInfo[treeUID] && treeInfo[treeUID].hasChildren) {
				return true;
			}
		}
		return false;
	}
		
	/**
	 * @private
	 * 
	 * Internal method to return distinct identifier. If we are seeing tree in a vertical way, we just
	 * return _data property. Yet if we are looking at a horizontal tree view, we also need column's dataField
	 * sinnc each row item object share the same data so they should be distinct by their unique column fields.
	 **/
	protected function get itemData():Object {
		if (listOwner.treeDirection == "vertical") {
			return _data;
		}
		return _data[dataField];
	}
	
	/**
	 * @private
	 * 
	 * Internal method to return start x position of this itemRenderer instance.
	 **/
	private function get startX():Number {
		if (icon) {
			return icon.x + icon.width + 5;
		}
		var treeInfo:Dictionary = Object(this.listData.owner).treeInfo;
		var x:Number = treeInfo[treeUID]?treeInfo[treeUID].indent:0;
		return x;
	}
	
		/**
	 * @private
	 * 
	 * Internal method to return column's dataField.
	 **/
	private function get dataField():String {
		var columnField:String;
		if (listOwner.treeDirection == "vertical") {
			columnField = listOwner.treeColumnField;
		} else {
			columnField = Object(listOwner).columns[listData.columnIndex].dataField;
		}
		return columnField;
	}
	
	/**
	 * @private
	 * 
	 * Internal method to return unique identifier of this instance. Uses both data property and dataField
	 * property to separate each cell of every row and column. 
	 **/
	private function get treeUID():String {
		if (_data) {
			var dataUID:String = mx.utils.UIDUtil.getUID(_data);
			return dataUID + dataField; 
		}
		return null;
	}
	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

		/**
	 * @private
	 * 
	 * Internal method to update the view on this itemRenderer instance. 
	 **/
	private function update():void {
		reset();
		if (_data) {
			var rendererData:Object = itemData?itemData:null;
			if (!rendererData) {
				rendererData = isRoot? _data:null;
			}
			var treeInfo:Dictionary = Object(this.listData.owner).treeInfo;
			if (rendererData) {
				if (isParentItem) {
					var iconClass:Class;
					if (treeInfo[treeUID].open) {
						iconClass = Object(listOwner).getStyle("openIcon");
					} else {
						iconClass = Object(listOwner).getStyle("closeIcon");
					}
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
		            icon.x = treeInfo[treeUID].indent;
					addChild(icon as DisplayObject);
					icon.addEventListener(MouseEvent.CLICK, iconClickHandler, false, 0, true);
					try {
						Object(icon).useHandCursor = true;
						Object(icon).buttonMode = true;
					}	catch (e:Error) {
						
					}
				}
				if (!tf) {
					tf = new UITextField();
					addChild(tf as DisplayObject);
				}
				if (rendererData is String || rendererData is Number) {
					tf.text = rendererData.toString();
				} else {
					if (isParentItem && rendererData.hasOwnProperty("GroupLabel") && rendererData.GroupLabel) {
						if (isRoot || !isRoot && rendererData) {
							tf.text = rendererData.GroupLabel;
						}
					} else {
						if (rendererData && rendererData.hasOwnProperty(dataField)) {
							tf.text = rendererData[dataField];
						} 
					}
				}
				tf.x = startX;
			}
		}
	}
		
	/**
	 * @private
	 * 
	 * Internal method to reset this itemRenderer instance's status.
	 **/
	private function reset():void {
		if (icon && this.contains(icon as DisplayObject)) {
			removeChild(icon as DisplayObject);
			icon = null;
		}
		if (tf && this.contains(tf as DisplayObject)) {
			this.removeChild(tf as DisplayObject);
			tf = null;
		}
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Overriden method to update this itemRenderer's view when its super class' commitProperties() method
	 * is being called.
	 **/
	override protected function commitProperties():void {
		super.commitProperties();
		update();
		this.invalidateDisplayList();
	} 
	
	/**
	 * @private
	 * 
	 * Overriden method to update this itemRenderer's view when its super class' updateDisplayList() method
	 * is being called.
	 **/
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		if (tf) {
			tf.x = startX;
			tf.setActualSize(unscaledWidth - startX, unscaledHeight);
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
	 * Internal mouseClick event handler method to either expand or collapse a tree node. This method
	 * calls listOwner's expandTreeItem() or collapseTreeItem() method, which is defined in 
	 * ITreeDataGrid interface.
	 **/
	private function iconClickHandler(event:MouseEvent):void {
		var treeInfo:Dictionary = Object(this.listData.owner).treeInfo;
		if (treeInfo[treeUID].open) {
			listOwner.collapseTreeItem(_data, dataField);
		} else {
			listOwner.expandTreeItem(_data, dataField);
		}
		treeInfo[treeUID].open = !treeInfo[treeUID].open;	
	}
}
}