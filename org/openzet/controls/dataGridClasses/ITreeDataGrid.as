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
/**
 * Interface that defines methods needed for a DataGrid showing data in a tree hierarchy.
 * 
 **/
public interface ITreeDataGrid
{
	/**
	 * Method to collapse tree Item
	 * 
	 * @param item Any node item object
	 * @param dataField The datafield of the current column
	 * @param recursive Specifies whether to recursively open tree nodes
	 **/
	function collapseTreeItem(item:Object, dataField:String = null, recursive:Boolean = false):void;
	
	/**
	 * Method to expand tree Item
	 * 
	 * @param item Any node item object
	 * @param dataField The datafield of the current column
	 * @param recursive Specifies whether to recursively close tree nodes
	 **/
	function expandTreeItem(item:Object, dataField:String = null, recursive:Boolean = false):void;	
	
	/**
	 * A getter method to return tree column's dataField when treeDirection is set as vertical.
	 **/
	function get treeColumnField():String;	
	
	/**
	 * @private 
	 **/
	function set treeDirection(value:String):void;
	
	/**
	 * Setter/getter method to define tree view direction. 
	 **/
	function get treeDirection():String;
}
}