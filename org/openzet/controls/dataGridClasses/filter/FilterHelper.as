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
import mx.collections.ArrayCollection;
import mx.utils.ObjectUtil;

import org.openzet.utils.*;

/**
 * A Helper class that is used to help implementing data filtering feature on a DataGrid. This class 
 * is used in conjunction with FilterItemRenderer, FilterManager and FilterPopUp classes.
 * 
 * @see org.openzet.dataGridClasses.filter.FilterManager
 * @see org.openzet.dataGridClasses.filter.FilterPopUp
 * @see org.openzet.dataGridClasses.filter.FilterItemRenderer
 **/
public class FilterHelper
{
	
	
	 include "../../../core/Version.as";
 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


	/**
	 * @private
	 * Internal dataProvider property.
	 **/
	private var _dataProvider:Object;
	
	/**
	 * @private
	 * 
	 * An internal array used to save dataFields that has its all items selected.
	 * 
	 **/
	private var allFields:Array = [];
	
	/**
	 * @private
	 * 
	 * An internal object to save original dataProvider just in case we need the original dataProvider.
	 **/
	private var _originalDataProvider:Object;
	
	/**
	 * @private
	 * 
	 * Internal array to save filter information.
	 **/
	private var _filters:Array=[];
	
	/**
	 * @private
	 * 
	 * Internal array used to save dataFields' name where data filtering has been applied. 
	 * 
	 **/
	private var fields:Array = [];
	
	/**
	 * @private
	 * 
	 **/
	public function set dataProvider(value:Object):void {
		_dataProvider = DataUtil.objectToArrayCollection(value);
		_originalDataProvider = mx.utils.ObjectUtil.copy(_dataProvider);
	}
	
	/**
	 * A property to set dataProvider. FilterHelper instance hold this dataProvider and splits this data for 
	 * each column and redistributes the data to FilterPopup instances for each column.
	 **/
	public function get dataProvider():Object {
		return _dataProvider;
	}
	

	
	/**
	 * @private
	 **/
	private function set filters(value:Array):void {
		_filters = value;
	}
	
	/**
	 * @private
	 * 
	 * Internal array that save filtering information with filtering columns dataField as key and item's value as
	 * value.
	 **/
	private function get filters():Array {
		return _filters;
	}
	
	
	//--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------
	
	/**
	 * Method to add filtering information. This method is called by FilterPopUp instance when user clicks
	 * Confirm button.
	 * 
	 * @param checkedItems An array of items that are checked.
	 * @param uncheckedItems An array of items that are unchecked.
	 * @param isAllChecked A flag indicating whether all items of a certain column are checked or not.
	 * 
	 **/
	public function addFilters(checkedItems:Array, uncheckedItems:Array, isAllChecked:Boolean):void {
		var i:int;
		if (uncheckedItems) {
			var uncheckedItemsLen:int = uncheckedItems.length;
			for (i = 0; i < uncheckedItemsLen; i++) {
				for (var j:int = 0; j <filters.length; j++) {
					if (uncheckedItems[i].field == filters[j].field && uncheckedItems[i].value == filters[j].value) {
						filters.splice(j,1);
					}
				}
			}
		}
		var chckedItemsLen:int = checkedItems.length;
		for (i = 0; i < chckedItemsLen ; i++) {
			if (i==0 && fields.indexOf(checkedItems[i].field) == -1) {
				fields.push(checkedItems[i].field);
			} 
			var flag:Boolean = false;
			for (j = 0; j < filters.length; j++) {
				if (checkedItems[i].field == filters[j].field && checkedItems[i].value == filters[j].value) {
					flag = true;
					break;
				}
			}
			if (!flag) {
				filters.push({field:checkedItems[i].field,value:checkedItems[i].value});
			} 
		}
		applyFilter();
	}
	
		/**
	 * Method to return ditinct and filtered data of a certain column.
	 * 
	 * @param dataField A column's datafield from where to extract data
	 * 
	 * @return An ArrayCollection instance with distinct data values of each column
	 * */
	public function getDataByField(dataField:String):ArrayCollection {
		var result:ArrayCollection;
		if (fields.length == 0 || fields.length > 0 && dataField != fields[fields.length-1]) {
			result = ArrayCollectionUtil.extractDistinctItemsByKey(dataProvider as ArrayCollection, dataField, true);
		} else {
			var arr:ArrayCollection = mx.utils.ObjectUtil.copy(_originalDataProvider) as ArrayCollection;
			applyInternalFilter(arr, dataField);
			result = ArrayCollectionUtil.extractDistinctItemsByKey(arr, dataField, true);
		}
		return result;
	}
	
	/**
	 * Method to return filtered data of a certain column.
	 * 
	 * @param dataField A column's datafield from where to extract data
	 * 
	 * @return An Array instance with filter information of a certain column
	 * */
	public function getFilterDataByField(dataField:String):Array {
		var result:Array;
		var len:int = filters.length;
		for (var i:int = 0; i < len; i++) {
			if (filters[i].field == dataField) {
				if (!result) result = [];
				result.push(filters[i]);
			}
		}
		return result;
	}
	
	/**
	 * Method to register a certain column as one with all of its items are checked. IF a certain column's
	 * all items are checked, then the column is excluded from the fields to be checked when performing
	 * data filtering since the field's all data should match data filtering criteria in this case. 
	 * 
	 * @param dataField A column's dataField where all items are checked. 
	 * */
	public function addAllField(dataField:String):void {
		if (allFields.indexOf(dataField) == -1) {
			allFields.push(dataField);
		}
		var index:int = fields.indexOf(dataField);
		if (index != -1) {
			fields.splice(index, 1);
			removeFilter(filters, dataField);
		}
		applyFilter();
	}
	
		/**
	 * Resets all filtering information. 
	 * */
	 public function reset():void {
	 	this.filters = [];
	 	this.fields = [];
	 	this.allFields = [];
	 }
	/**
	 *  @private
	 *  Internal method to trigger data filtering.  
	 * */
	private function applyFilter():void {
		dataProvider.filterFunction = filterFunc;
		dataProvider.refresh();	
	}
	
	/**
	 *  @private
	 *  Internal filterFunction method of a dataProvider.
	 * */
	private function filterFunc(item:Object):Boolean {
	 	var fieldsLen:int = fields.length;
	 	var len:int = this.filters.length;
	 	var field:String;
	 	var value:Object;
	 	var count:int = 0;
	 	for (var i:int = 0; i < fieldsLen; i++) {
	 		field = fields[i];
 			for (var j:int = 0; j < len; j++) {
	 			if (filters[j].field == field && item[field] == filters[j].value) {
	 				count++;
	 				break;
	 			}
		 	}
	 	}
	 	if (count == fieldsLen) {
	 		return true;
	 	}
	 	return false; 
	}
	
	/**
	 *  @private
	 * Method that is that is called to track distinct yet filtered data of a certain column. This method
	 * also has internal filterFunction method called internalFilterfunc to apply the same filtering logic
	 * of the current dataProvider shown on the DataGrid.
	 * */
	private function applyInternalFilter(arr:ArrayCollection, dataField:String):void {
		var copyFields:Array = mx.utils.ObjectUtil.copy(fields) as Array;
		var index:int = copyFields.indexOf(dataField);
		copyFields.splice(index, 1);
		var len:int = filters.length;
		arr.filterFunction = internalFilterFunc;
		arr.refresh();	
		
		function internalFilterFunc(item:Object):Boolean {
			var fieldsLen:int = copyFields.length;
		 	var field:String;
		 	var value:Object;
		 	var count:int = 0;
		 	for (var i:int = 0; i < fieldsLen; i++) {
		 		field = copyFields[i];
	 			for (var j:int = 0; j < len; j++) {
		 			if (filters[j].field == field && item[field] == filters[j].value) {
		 				count++;
		 				break;
		 			}
			 	}
		 	}
		 	if (count == fieldsLen) {
		 		return true;
		 	}
		 	return false; 
		}
		
	}
	
		
	
		/**
	 * @private
	 * 
	 * Internal method to remove data filtering condition. 
	 * */
	private function removeFilter(filterArr:Array, dataField:String):void {
		for (var i:int = 0; i < filterArr.length; i++) {
			if (filterArr[i].field == dataField) {
				filterArr.splice(i, 1);
				i--;
			}
		}
	}
}
}