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
import flash.utils.Dictionary;

import mx.collections.*;
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderInfo;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.mx_internal;
import mx.events.AdvancedDataGridEvent;
import mx.utils.UIDUtil;

import org.openzet.controls.dataGridClasses.DataGridTreeItemRenderer;
import org.openzet.controls.dataGridClasses.ITreeDataGrid;
import org.openzet.events.TreeDataGridEvent;
import org.openzet.utils.ObjectUtil;

use namespace mx_internal;

//------------------------------------------
//  Events
//------------------------------------------
/**
 *	Dispatched when a child node is expanded.
 * 
 *  @eventType org.openzet.events.TreeDataGridEvent
 */
[Event(name="itemOpen", type="org.openzet.events.TreeDataGridEvent")]

/**
 *	Dispatched when a child node is closed.
 *  
 *  @eventType org.openzet.events.TreeDataGridEvent
 */
[Event(name="itemClose", type="org.openzet.events.TreeDataGridEvent")]

/**
 *	Dispatched when tree's direction is changed. 
 *  
 *  @eventType org.openzet.events.TreeDataGridEvent
 */
[Event(name="directionChanged", type="org.openzet.events.TreeDataGridEvent")]

//------------------------------------------
//  Styles
//------------------------------------------
/**
*  The indentation for each node of the navigation tree, in pixels.
*
*  @default 0
*/
[Style(name="indentation", type="Number", format="Length", inherit="no")]

/**
*  The icon that is displayed next to an open branch node of the navigation tree.
*
*  The default value is the icon_open.png file.
*/
[Style(name="openIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  The icon that is displayed next to a closed branch node of the navigation tree.
*
*  The default value is icon_close.png file.
*/
[Style(name="closeIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  The <code>AdvancedTreeDataGrid</code> control adds horizontal tree view feature on AdvancedDataGrid to  
 *  show data in a hierarchical tree way, horizontally and vertically.
 *  <p>
 *  The AdvancedTreeDataGrid control provides the following features:
 *  <ul>
 *  <li>Provides treedirection property to specify tree view modes, horizontal and vertical.</li>
 *  <li>Provides tree nodes property to specify tree fields in a horizontal hierarchical view of data.</li>
 *  <li>Internally sets tree node fields when a GroupingCollection is set as a dataProvider.</li>
 *  </ul>
 *  </p>
 *  The AdvancedTreeDataGrid class is a base Class for AdvancedZetDataGrid, which is a subclass of AdvancedSelectionDataGrid.
 *  
 *  @includeExample TreeDataGridExample.mxml
 **/
 
public class AdvancedTreeDataGrid extends AdvancedDataGrid implements ITreeDataGrid
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
	public function AdvancedTreeDataGrid()
	{
		super();			
		this.sortableColumns = false;
	}
	
	/**
	 * @private
	 * Internal IHierarchicalData type of data that holds dataProvider as its value
	 **/
	protected var model:IHierarchicalData;
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	/**
	 * A dictionary that saves information on which node has which information, such as
	 * whether a specific node has children, whether is has been opened or not. A node saves its information
	 * by combining mx_internal_uid of the node and its column dataField.  
	 **/
	public var treeInfo:Dictionary = new Dictionary();
	
	/**
	 * @private
	 * An instance that holds reference to a HierarchicalCollectionView instance through which
	 * tree data is generated and parsed. 
	 **/
	protected var hierarchicalCollectionInstance:HierarchicalCollectionView;
	
		/**
	 * A dictionary that saves information on how many items under a specific column have been opened.
	 * This dictionary is used to track children nodes that have been opened and closed on a specific
	 * column so that we can show and hide specific columns of a TreeDataGrid when children nodes change
	 * their status of openness. This dictionary is used only when treeDirection is set horizontal.
	 *
	 **/
	protected var treeColumnInfo:Dictionary = new Dictionary();
	
	/**
	 * Property to store GroupingCollection instance's source data or ArrayCollection instance itself
	 * to reuse original data.  
	 **/
	protected var source:Object;
	
	/**
	 * @private
	 * Internal array that saves dataFields that do not belong to treeFields. 
	 **/
	private var itemFields:Array = [];
	
	
 	//--------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * Overrides DataGrid's dataProvider property to show hierarchical data view
	 * on a AdvancedTreeDataGrid control. Sinced AdvancedDataGrid class automatically makes
	 * Tree view when dataProvider is IHierarchicalData type of data,
	 * we make HierarchicalCollectionView based on the value and gets its root data when
	 * <code>treeDirection</code> property is set to horizontal. 
	 * If value is just an arrayCollection we simply calls super.dataProvider = value
	 * and try to make treeData if treeFields are set. 
	 **/
	override public function set dataProvider(value:Object):void {
		if (value is IHierarchicalData) {
			source = mx.utils.ObjectUtil.copy(value.source);
			if (!expandToBottom) {
				model = value as IHierarchicalData;
				hierarchicalCollectionInstance = new HierarchicalCollectionView(model);
				if (!columns[0].itemRenderer) {
					columns[0].itemRenderer = new ClassFactory(DataGridTreeItemRenderer);
				}
				super.dataProvider = IHierarchicalData(model).getRoot();
				initTreeInfo();
				getTreeFields();
			} else {
				super.dataProvider = value;
			}
		} else {
			super.dataProvider = value;
			source = mx.utils.ObjectUtil.copy(value);
			makeGroupingCollection();
		}
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * An array that saves dataFields that are treeFields.  
	 **/
	private var _treeFields:Array;
	
	/**
	 * @private
	 **/
	public function set treeFields(value:Array):void {
		_treeFields = value;
		if (value) {
			var isEqual:Boolean;
			itemFields = [];
			for (var i:int = 0; i < this.columns.length; i++) {
				isEqual = false;
				var currentField:String  = this.columns[i].dataField;
				for (var j:int = 0; j < value.length; j++) {
					if (currentField == value[i]) {
						isEqual = true;
						break;
					}
				}
				if (!isEqual) itemFields.push(currentField);
			}
		}
	}
	
	/**
	 * An array type of property to set dataFields that should be used as tree dataFields. If not set, 
	 * you should always provide dataProvider as type of GroupingCollectionView. Otherwise, tree type of data 
	 * wouldn't show up correctly. Yet if you provide arrayCollection as a dataProvider along with treeFields 
	 * property, the data would show up correctly since TreeDataGrid control internally converts an arrayCollection
	 * dataProvider to a GroupingCollection instance with treeFields property's value. 
	 **/
	public function get treeFields():Array {
		return _treeFields;
	}
	
	/**
	 * @private
	 * TreeDirection property that sets TreeDataGrid's way of showing data. Default value is 'vertical'. 
	 **/
	private var _treeDirection:String = "vertical";
	
		/**
	 * @private
	 */ 
	[Inspectable(enumeration="vertical,horizontal", defaultValue="vertical")]
	public function set treeDirection(value:String):void {
		if (_treeDirection != value) {
			_treeDirection = value;
			
			if (value == "vertical") {
				var i:int;
				for (i = 0; i < visibleColumns.length; i++) {
					if (visibleColumns[i].dataField != treeColumnField) {
						if (IFactory(columns[i].itemRenderer) && IFactory(columns[i].itemRenderer).newInstance() is DataGridTreeItemRenderer) {
							columns[i].itemRenderer = null;
						}
					}
				}
				var columnWidth:Number = this.unscaledWidth/columns.length;
				for (i = 0; i < columns.length; i++) {
					columns[i].visible = true;
				}
				callLater(layoutColumns);
				columns[0].itemRenderer = null;
			}
			if (model) insertData();
		}
		
		this.dispatchEvent(new TreeDataGridEvent(TreeDataGridEvent.DIRECTION_CHANGE));
	}
	
	/**
	 * A property to set TreeDataGrid's data direction, horizontal or vertical. Default value is vertical. 
	 **/
	public function get treeDirection():String {
		return _treeDirection;
	}
	
	/**
	 * @private
	 * 
	 * Internal getter property to show whether tree data is being shown horizontally or vertically. 
	 **/
	private function get expandToBottom():Boolean {
		return treeDirection == "vertical";
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------
	
		/**
	 * public function to expand a child node's data either horizontally or vertically. This method
	 * is an implementation of ITreeDataGrid interface. 
	 * 
	 *  @param item A row data object
 	 *  @param dataField Column's dataField. Default value is null. 
	 **/
	public function expandTreeItem(item:Object, dataField:String = null, recursive:Boolean = false):void {
		var children:ICollectionView;
		var index:int = ListCollectionView(dataProvider).getItemIndex(item);
		var prevDepth:Number;
		var i:int;
		var treeUID:String;
		if (expandToBottom) {
		} else {
			if (!treeColumnInfo[dataField]) {
				treeColumnInfo[dataField] = {count:0};
			}
			treeColumnInfo[dataField].count++;  
			var rendererItem:Object  = item[dataField];
			if (!rendererItem) {
				rendererItem = item;
			}
			children = hierarchicalCollectionInstance.getChildren(rendererItem);
			if (!children) return;
			var child:Object = children[0];
			var columnsArr:Array;
			var column:AdvancedDataGridColumn;
			var columnField:String;
			var childItem:Object;
			columnsArr =  updateColumns(child);
			for (i = 0; i < children.length; i++) {
				childItem = children[i];
				if (childItem.GroupLabel) {
					if (i == 0) {
						column = columnsArr[0];
						columnField = column.dataField;
						item[columnField] = childItem;
						treeUID = UIDUtil.getUID(item) + columnField;
						if (!treeInfo[treeUID]) {
							saveInTreeInfo(childItem, columnField, 0, item);
						}
					} else {
						childItem[columnField] = childItem;
						treeUID = UIDUtil.getUID(childItem) + columnField;
						if (!this.containsItem(childItem)) ListCollectionView(dataProvider).addItemAt(childItem,++index);
						if (!treeInfo[treeUID]) {
							saveInTreeInfo(childItem, columnField, 0, childItem);
						}
					}
					column.itemRenderer = new ClassFactory(DataGridTreeItemRenderer);
				} else {
					var j:int;
					if (i == 0) {
						for (j = 0; j < itemFields.length; j++) {
							var currentField:String = itemFields[j];
							item[currentField] = childItem[currentField];
						}
						var itemIndex:int = ListCollectionView(dataProvider).getItemIndex(item);
						ListCollectionView(dataProvider)[itemIndex] = item;
					} else {
						for (j = 0; j < treeFields.length; j++) {
							childItem[treeFields[j]] = null;
						} 
						if (!this.containsItem(childItem)) ListCollectionView(dataProvider).addItemAt(childItem,++index);
					}
				}
			} 
			for (i = 0; i < children.length; i++) {
				childItem = children[i];
				if (childItem.GroupLabel) {
					if (i == 0) {
						treeUID = UIDUtil.getUID(item) + columnField;
						if (treeInfo[treeUID].open || treeInfo[treeUID].hasChildren && recursive) {
							treeInfo[treeUID].open = true;
							expandTreeItem(item, columnField, true);		
						}
					} else {
						treeUID = UIDUtil.getUID(childItem) + columnField;
						if (treeInfo[treeUID].open || treeInfo[treeUID].hasChildren && recursive) {
							treeInfo[treeUID].open = true;
							expandTreeItem(childItem, columnField, true);		
						}
					} 
				}
			}
		}
		var event:TreeDataGridEvent = new TreeDataGridEvent(TreeDataGridEvent.ITEM_OPEN, false, false, item, dataField, true);
		this.dispatchEvent(event);
	}
	
	/**
	 * public function to collapse a child node's data either horizontally or vertically. This method
	 * is an implementation of ITreeDataGrid interface. 
	 * 
	 *  @param item A row data object
 	 *  @param dataField Column's dataField. Default value is null. 
	 **/
	public function collapseTreeItem(item:Object, dataField:String = null, recursive:Boolean = false):void {
		var children:ICollectionView = hierarchicalCollectionInstance.getChildren(item);
		var index:int;
		var childItem:Object;
		var childItemUID:String;
		var i:int;
	 	if (expandToBottom) {
			for (i = 0; i < children.length; i++) {
				childItem = children[i];
				childItemUID = getItemUID(childItem);
				index = ListCollectionView(dataProvider).getItemIndex(childItem);
				if (index != -1) ListCollectionView(dataProvider).removeItemAt(index);
				if (treeInfo[childItemUID] && treeInfo[childItemUID].hasChildren && treeInfo[childItemUID].open) {
					collapseTreeItem(childItem);
				}
			}
	 	} else {
	 		if (!treeColumnInfo[dataField]) {
	 			return;
	 		}
	 		treeColumnInfo[dataField].count--;
	 		if (treeColumnInfo[dataField].count < 0) {
	 			treeColumnInfo[dataField].count = 0;
	 		}
	 		var rendererItem:Object;
	 		rendererItem = item[dataField];
			if (!rendererItem) {
				rendererItem = item;
			}
			children = hierarchicalCollectionInstance.getChildren(rendererItem);
			if (!children) return;
			var childItems:Array = [];
			var nextField:String;
			for (i = 0; i < children.length; i++) {
				childItem = children[i];
				nextField = getNextDataField(dataField);
				if (i == 0) {
					childItemUID = UIDUtil.getUID(item) + nextField;							
				} else {
					childItemUID = UIDUtil.getUID(childItem) + nextField;
				}
				if (nextField) {
					if (treeInfo[childItemUID] && treeInfo[childItemUID].hasChildren && treeInfo[childItemUID].open) {
						if (i == 0) {
							collapseTreeItem(item, nextField);
						} else {
							collapseTreeItem(childItem, nextField);
						}
					} else {
						item[nextField] = null;	
					}
				}
				index = ListCollectionView(dataProvider).getItemIndex(childItem);
				if (index != -1) ListCollectionView(dataProvider).removeItemAt(index);					
			}
			var deleteColumnFields:Array = mx.utils.ObjectUtil.copy(itemFields) as Array;
			var addtionalDeleteFields:Array = getTreeColumnsToDelete(dataField);
			if (addtionalDeleteFields) {
				deleteColumnFields = deleteColumnFields.concat(addtionalDeleteFields);
			} 
			for (i = 0; i < deleteColumnFields.length; i++) {
				item[deleteColumnFields[i]] = null;
			}
			var itemIndex:int =  ListCollectionView(dataProvider).getItemIndex(item);
			if (itemIndex != -1) ListCollectionView(dataProvider)[itemIndex] = item;
			
			if (treeColumnInfo[dataField].count == 0) {
				for (i = 0; i < columns.length; i++) {
					for (var j:int = 0; j < deleteColumnFields.length; j++) {
						if (columns[i].dataField == deleteColumnFields[j]) {
							columns[i].visible = false;
						}
					}
				}
			} 
	 	}
	 	
 		var event:TreeDataGridEvent = new TreeDataGridEvent(TreeDataGridEvent.ITEM_CLOSE, false, false, item, dataField, false);
		this.dispatchEvent(event);
	}
	
	public function expandAllTreeItems():void {
		if (expandToBottom) {
			this.expandAll();
		} else {
			var treeUID:String;
			var topNodeItems:Array = [];
			var i:int, j:int;
			for (i = 0; i < this.dataProvider.length; i++) {
				if (this.dataProvider[i][treeColumnField] == null) {
					topNodeItems.push(this.dataProvider[i]);
				}
			}
			for (var prop:String in treeColumnInfo) {
				treeColumnInfo[prop].count = 0;
			}
			for (i = 0; i < topNodeItems.length; i++) {
				expandTreeItem(topNodeItems[i], treeColumnField, true);
				treeUID = UIDUtil.getUID(topNodeItems[i]) + treeColumnField;
				if (treeInfo[treeUID]) treeInfo[treeUID].open = true;
			}
		}
	}
	
	
	
	public function collapseAllTreeItems():void {
		if (expandToBottom) {
			this.collapseAll();
		} else {
			var treeUID:String;
			var topNodeItems:Array = [];
			var i:int, j:int;
			for (i = 0; i < this.dataProvider.length; i++) {
				if (this.dataProvider[i][treeColumnField] == null) {
					topNodeItems.push(this.dataProvider[i]);
				}
			}
			for (i = 0; i < topNodeItems.length; i++) {
				collapseTreeItem(topNodeItems[i], treeColumnField, true);
				treeUID = UIDUtil.getUID(topNodeItems[i]) + treeColumnField;
				if (treeInfo[treeUID]) treeInfo[treeUID].open = false;
			}
			for (i = 0; i < columns.length; i++) {
				if (columns[i].dataField != treeColumnField) {
					columns[i].visible = false;
				}
			}
		}
	}
	
	private function containsItem(item:Object):Boolean {
		return ListCollectionView(this.dataProvider).contains(item);
	}
		
		/**
	 * Function that returns treeColumnField. This method is only used when treeDirection property 
	 * is set as vertical since when it is horizontal, there could be many treeFields. 
	 * 
	 * @return A column's dataField which is used as a tree column.
	 **/
	public function get treeColumnField():String {
		if (!this.columnMap.treeColumnField) {
			var len:int = this.visibleColumns.length;
			for (var i:int = 0; i < len; i++) {
				if (columns[i].itemRenderer && IFactory(columns[i].itemRenderer).newInstance() is DataGridTreeItemRenderer) {
					this.columnMap.treeColumnField = columns[i].dataField;
					break;
				}
			}
		}
		return  this.columnMap.treeColumnField;
	}
	
		/**
	 * @private
	 * 
	 * Internal function to dynamically make a GroupingCollection instance with an ArrayCollection instance
	 * and treeFields property. This method autogenerates Grouping instance by using treeFields property and
	 * a GroupingCollection instance with the given information, ie ArrayCollection dataProvider and treeFields property value.
	 **/
	protected function makeGroupingCollection():void {
		if (treeFields) {
			 var g:Grouping = new Grouping();
			 var groupFields:Array = [];
			 var groupField:GroupingField;
			 for (var i:int = 0; i <treeFields.length; i++) {
			 	groupField = new GroupingField(treeFields[i]);
			 	groupFields.push(groupField);
			 }
			 var gc:GroupingCollection = new GroupingCollection();
			 g.fields = groupFields;
			 gc.source = source;
			 gc.grouping = g;
			 gc.refresh();
			 dataProvider = gc;
			 model = gc as IHierarchicalData;
			 hierarchicalCollectionInstance = new HierarchicalCollectionView(model);
			 
		} 
	} 
	
		/**
	 * @private
	 * 
	 * Internal function used to show and hide columns based on a specific child node's
	 * status.
	 **/
	protected function updateColumns(child:Object):Array {
		var fieldsArr:Array = [];
		var i:int;
		var resize:Boolean = false;
		if (child.GroupLabel) {
			var field:String = getGroupLabelDataField(child.GroupLabel);
			for (i = 0; i < this.columns.length; i++) {
				if (this.columns[i].dataField == field) {
					if (!this.columns[i].visible) {
						this.columns[i].visible = true;
						resize = true;
					} 
					fieldsArr.push(this.columns[i]);
				}
			}
			
		} else {
			var fields:Array = ObjectUtil.cloneFields(child);
			for (i = 0; i < this.columns.length; i++) {
				for (var j:int = 0; j < fields.length; j++) {
					if (this.columns[i].dataField == fields[j]) {
						if (!this.columns[i].visible) {
							fieldsArr.push(this.columns[i]);
							this.columns[i].visible = true;
							resize = true;
							break;
						}
					}
				}
			}
		}
		
		if (resize) callLater(layoutColumns);
		return fieldsArr;
	}
	
		/**
	 * @private
	 * 
	 * Internal function used to figure out which groupLabel maps to which dataField.
	 **/
	protected function getGroupLabelDataField(groupLabel:String):String {
		var iView:ICollectionView = GroupingCollection(hierarchicalCollectionInstance.source).source as ICollectionView
		if (iView && iView.length > 0) {
			var fields:Array = org.openzet.utils.ObjectUtil.cloneFields(iView[0]);
			for (var i:int = 0; i < fields.length; i++) {
				for (var j:int = 0; j < iView.length; j++) {
					if (iView[j][fields[i]] == groupLabel) {
						return fields[i];
					}
				}
			}
		}
		return null;
	}
	
		/**
	 * @private
	 * 
	 * Internal function to distribute same width to all columns visible on the screen. 
	 **/
	protected function layoutColumns():void {
		if (visibleColumns) {
			var columnWidth:Number = this.width/visibleColumns.length;
			for (var i:int = 0; i < visibleColumns.length; i++) {
				visibleColumns[i].width = columnWidth;
			}
			this.validateNow();
		}
	}
	
	/**
	 * @private
	 * 
	 * Internal function that returns item's unique identified. An item's unique identifier is made up of
	 * its mx_internal_uid + treeColumnField. This method is also only used when treeDirection property's
	 * value is vertical.  
	 **/
	protected function getItemUID(item:Object):String {
		var uid:String = UIDUtil.getUID(item);
		return uid + treeColumnField;
	}
	
	/**
	 * @private
	 * Inserts data using source property.
	 **/
	private function insertData():void {
		var gc:GroupingCollection = new GroupingCollection();
		if (source) {
			gc.source = source;
			gc.grouping = GroupingCollection(model).grouping;
			gc.refresh();
			this.dataProvider = gc; 
		}

	}
	
	/**
	 * @private
	 * 
	 * Internal function to figure out next tree dataField that is about to be opened or closed
	 * with regard to current tree dataField. 
	 **/
	private function getNextDataField(field:String):String {
		var index:int = treeFields.indexOf(field);
		if (index != -1 && index != treeFields.length - 1) {
			return treeFields[index + 1];
		}
		return null;
	}
	
	/**
	 * @private
	 * 
	 * Internal function to save tree dataFields that are used to show tree type of data view
	 * on a TreeDataGrid. This method is only called when dataProvider's value is a GroupingCollection
	 * instance. 
	 **/
	private function getTreeFields():void {
		if (model) {
			var grouping:Grouping = Object(model).grouping;
			_treeFields = [];
			for (var i:int = 0; i < grouping.fields.length; i++) {
				_treeFields.push(GroupingField(grouping.fields[i]).name);
			}
			treeFields = _treeFields;
		}
	}
	
	/**
	 * @private
	 * 
	 * Internal function to figure out tree columns to hide on the screen. 
	 **/
	private function getTreeColumnsToDelete(dataField:String):Array {
		var result:Array;
		var flag:Boolean;
		for (var i:int = 0; i < treeFields.length; i++) {
			if (treeFields[i] == dataField) {
				flag = true;
				continue;
			}
			if (flag) {
				if (!result) result = [];
				result.push(treeFields[i]);
			}
		}
		return result;
		
	}
	

	
		/**
	 * @private
	 * 
	 * Internal function to initialize treeInfo dictionary's information. 
	 **/
	private function initTreeInfo():void {
		treeInfo = new Dictionary();
		var len:int = dataProvider.length;
		var uid:String;
		var item:Object;
		var i:int = 0;
		for (i = 0; i <len; i++) {
			item = dataProvider[i];
			saveInTreeInfo(item, treeColumnField);
		}
					
		if (!expandToBottom) {
			for (i = 1; i < this.columnCount; i++) {
				this.columns[i].visible = false;
			}
		}
	}
	
	/**
	 * @private
	 * 
	 * Internal function to save information on a specific node of a certain column in treeInfo dictionary.
	 * 
	 * @param item A row object item
	 * @param columnField Column's dataField
	 * @param depth Node's depth
	 * @param parentItem Node's parentItem  
	 **/
	private function saveInTreeInfo(item:Object,  columnField:String = "", depth:int = 0, parentItem:Object = null):void {
		var uid:String;
		if (parentItem) {
			uid = UIDUtil.getUID(parentItem);
		} else {
			uid = UIDUtil.getUID(item);
		}
		uid += columnField;
		var treeItem:TreeItem = new TreeItem();
		treeInfo[uid] = treeItem;
		treeItem.hasChildren = hierarchicalCollectionInstance.getChildren(item)?true:false;
		treeItem.open = false;
		treeItem.indent = 16*depth;
		treeItem.depth = depth;
		treeItem.parent = parentItem;
	}
	
	 /**
     *  @private
     */
    override protected function sortHandler(event:AdvancedDataGridEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        if (!sortableColumns
            || isNaN(event.columnIndex) 
            || event.columnIndex == -1 
            || !columns[event.columnIndex].sortable)
            return;

        if(columnGrouping)
        {
            var columnNumber:int  = event.columnIndex;
            //In case it is a column number, skip, we can't sort a column group
            if(isNaN(columnNumber) ||  columnNumber == -1)
                return;

            var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(columns[columnNumber]);
            //If this is a leaf column and doesn't get data directly from the data row, but through internalLabelFunction
            if(headerInfo.internalLabelFunction != null)
                event.dataField = null;
        }

        // If navigating header via keyboard, and you mouse click on some
        // other header to sort it, then move the keyboard navigation focus
        // to that column header.
        if (columnGrouping && selectedHeaderInfo != null)
            selectedHeaderInfo = getHeaderInfo(columns[event.columnIndex]);
        super.sortHandler(event);

        if (isRowSelectionMode())
            updateSelectedCells();
    }
}
}
class TreeItem {
	public var hasChildren:Boolean;
	
	public var open:Boolean;
	
	public var indent:Number;
	
	public var depth:Number;
	
	public var parent:Object;
}