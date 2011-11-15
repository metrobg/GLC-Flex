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
import mx.controls.dataGridClasses.DataGridColumn;
import org.openzet.utils.ObjectUtil;
import mx.collections.ArrayCollection;

/**
 * Static class that defines static methods used in relation with DataGrid controls.
 * 
 **/
public class DataGridUtil
{
	include "../core/Version.as";
	/****
	 * Pivots a DataGrid's data. 
	 * 
	 * @param dg A DataGrid instance to apply data pivoting. This parameter is type of Object since
	 * this method could be called both on DataGrid and AdvancedDataGrid instances. 
	 **/
	public static function pivotDataGrid(dg:Object):void {
		if (dg && dg.dataProvider && dg.dataProvider.length > 0) {
			var fields:Array = org.openzet.utils.ObjectUtil.cloneFields(dg.dataProvider[0]);
			var columns:Array = [];
			var result:ArrayCollection = new ArrayCollection();
			var item:Object;
			var column:DataGridColumn;
			for (var i:int =0; i < dg.columnCount; i++) {
				item = {};
				var dataField:String = dg.columns[i].dataField;
				item[0] = dataField;
				for (var j:int = 0; j < dg.dataProvider.length; j++) {
					item[j+1] = dg.dataProvider[j][dataField];
					if (i == 0) {
						column = new DataGridColumn();
						column.dataField = String(j+1);
						columns.push(column);
					}
				}
				result.addItem(item);
			}
			dg.columns = columns;
			dg.dataProvider = result;
		}
	}
}
}