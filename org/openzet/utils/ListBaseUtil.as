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
package org.openzet.utils
{
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.listClasses.AdvancedListBase;
import mx.controls.listClasses.ListBase;

/**
 * A static class that defines static methods used in relation with ListBase controls such as List, DataGrid,
 * AdvancedDataGrid, etc.
 **/
public class ListBaseUtil
{
	include "../core/Version.as";
	/**
	 * Static method that makes any List-like control to scroll up or down to a certain index. True, List controls
	 * all have their own scrollToIndex method yet this static method internally calls callLater method so that
	 * any data refresh on the list controls should not prevent scrolling movement.
	 * 
	 * @param target List-like control to move scroll
	 * @param index Any index to which to scroll up or down.
	 * 
	 **/
	public static function scrollToIndex(target:Object, index:int):void {
		MethodUtil.call(target, "callLater", target.scrollToIndex, [index]);
		target.selectedIndex = index; 
	}
	
	/**
	 * Static method that makes any List-like control to scroll up or down to a certain item. This method uses
	 * list controls' dataProvider and its getItemIndex method to find the item's index and then calls scrollToIndex method
	 * to move the scroll to the index. 
	 * 
	 * @param target List-like control to move scroll
	 * @param item A row item object of list controls' dataProvider.
	 * 
	 **/
	public static function scrollToItem(target:Object, item:Object):void {
		var index:Number;
		if (target.dataProvider && target.dataProvider.length>0) {
			index = target.dataProvider.getItemIndex(item); 
		}
		if (!isNaN(index)) {
			scrollToIndex(target, index);
		}
	}
		/**
	 * Static method that move any list control's selectedItems one index down.
	 * 
	 * @param target List-like control to move its selected items index one step down.
	 * 
	 **/
	public static function moveItemDown(target:Object):void {
		if (target.selectedItems && target.selectedItems.length > 0) {
			var arr:ArrayCollection = target.dataProvider as ArrayCollection;
			var items:Array = target.selectedItems;
			var infoArrCol:ArrayCollection = new ArrayCollection();
			var moveFlag:Boolean = true;
			var index:int;
			for (var i:int=0; i<items.length;i++) {
				index = arr.getItemIndex(items[i]);
				moveFlag = index == arr.length - 1?false:moveFlag;
				if (!moveFlag) return;
				++index;
				infoArrCol.addItem({item:items[i],index:index});
			}
			if (moveFlag) {
				var source:Array = arr.source;
				var result:ArrayCollection = new ArrayCollection();
				for (i = 0; i < source.length; i++) {
					if (!isSelectedItem(target,source[i])) {
						result.addItem(source[i]);
					}
				}  
				var newSelectedItems:Array= [];
				
				var sort:Sort = new Sort();
				sort.fields = [new SortField("index")];
				infoArrCol.sort = sort;
				infoArrCol.refresh();
				
				for (i = 0; i < infoArrCol.length; i++) {
					newSelectedItems.push(infoArrCol[i].item);
					result.addItemAt(infoArrCol[i].item, infoArrCol[i].index);
				}
				var scrollIndex:int = target.verticalScrollPosition;
				
				target.dataProvider = result;
				target.callLater(update);
				function update():void {
					target.selectedItems = newSelectedItems;
					if (infoArrCol[0].index >= scrollIndex + 1 && infoArrCol[0].index <= scrollIndex + target.rowCount - 1) {
						if (scrollIndex != 0 || scrollIndex != target.maxVerticalScrollPosition) {
							target.verticalScrollPosition = scrollIndex; //scrollToIndex(scrollIndex);
						} 
					} else {
						target.scrollToIndex(infoArrCol[0].index);
					}
				}
			}
		}
	}
	
	/**
	 * Static method that move any list control's selectedItems one index up.
	 * 
	 * @param target List-like control to move its selected items index one step up.
	 * 
	 **/
	public static function moveItemUp(target:Object):void {
		if (target.selectedItems && target.selectedItems.length > 0) {
			var arr:ArrayCollection = target.dataProvider as ArrayCollection;
			if (!arr) return;
			
			var items:Array = target.selectedItems;
			var moveFlag:Boolean = true;
			var infoArrCol:ArrayCollection = new ArrayCollection();
			var index:int;
			
			for (var i:int=0; i < items.length; i++) {
				index = arr.getItemIndex(items[i]);
				moveFlag = index == 0? false: moveFlag;
				if (!moveFlag) return;
				--index;
				infoArrCol.addItem({item:items[i], index:index});
			}
			if (moveFlag) {
				var source:Array = arr.source;
				var newSource:Array = [];
				var result:ArrayCollection = new ArrayCollection();
				for (i = 0; i < source.length; i++) {
					if (!isSelectedItem(target,source[i])) {
						result.addItem(source[i]);
					}
				}  
				
				
				var newSelectedItems:Array= [];
				
				var sort:Sort = new Sort();
				sort.fields = [new SortField("index")];
				infoArrCol.sort = sort;
				infoArrCol.refresh();
				
				for (i = 0; i < infoArrCol.length; i++) {
					newSelectedItems.push(infoArrCol[i].item);
					result.addItemAt(infoArrCol[i].item, infoArrCol[i].index);
				}
				var scrollIndex:int = target.verticalScrollPosition;
				
				scrollIndex = target.verticalScrollPosition;
				target.dataProvider = result;
				
				target.callLater(update);
				
				function update():void {
					target.selectedItems = newSelectedItems;
					if (infoArrCol[0].index >= scrollIndex && infoArrCol[0].index <= scrollIndex + target.rowCount) {
						if (scrollIndex != 0 || scrollIndex != target.maxVerticalScrollPosition) {
							target.verticalScrollPosition = scrollIndex; 
						} 
					} else {
						var tempInd:int = infoArrCol[0].index - target.rowCount + 1;
						if (tempInd < 0 ) tempInd = 0;
						target.scrollToIndex(tempInd);
					}
				}
				
			}
		}
	}
	/**
	 * Static method that indicates whether certain item belong to a list control's selectedItems or not.
	 * 
	 * @param target List-like control.
	 * @param item List control's dataProvider row item object.
	 * 
	 * @return Returns true if item is one of selectedItems, otherwise false. 
	 * 
	 **/
	public static function isSelectedItem(list:Object,item:Object):Boolean {
		var items:Array = list.selectedItems;
		var flag:Boolean = false;
		for (var i:int=0; i < items.length;i++) {
			if (item == items[i]) return true;
		}
		return flag;
	}
	
	private static function allowScroll(target:Object, index:int):Boolean {
		var flag:Boolean = false;
		if (target is ListBase) {
			
		} else if (target is AdvancedListBase) {
			
		}
		return flag;
	}
}
}