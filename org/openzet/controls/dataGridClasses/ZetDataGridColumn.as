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

import mx.controls.dataGridClasses.DataGridColumn;

import org.openzet.controls.dataGridClasses.IMergeable;

/**
 *  The ZetDataGridColumn class describes a column in an ZetDataGrid control.
 *  This class implements IMergeable interface to show whether a specific column is mereable or not.
 *  Also this class is used to dynamically add itemRenderers to ZetDataGrid control by specifing its property
 *  such as checked as true. 
 * 
 *  @see org.openzet.controls.ZetDataGrid
 */
public class ZetDataGridColumn extends DataGridColumn implements IMergeable
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
	public function ZetDataGridColumn()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


	/**
	 * @private
	 */
	private var _enableMerge:Boolean;
	
	
		
		/**
	 * @private
	 */
	[Inspectable(enumeration="true,false", defaultValue="false")]
	public function set enableMerge(value:Boolean):void {
		_enableMerge = value;
	}
	
		/**
	 * A property to indicate whether this column's data should be vertically merged or not.
	 * Default value is false.
	 **/
	public function get enableMerge():Boolean {
		return _enableMerge;
	}
	
	/**
	 * @private
	 */
	private var _checked:Boolean;
	
		/**
	 * @private
	 */
	[Inspectable(enumeration="true,false", defaultValue="false")]
	public function set checked(value:Boolean):void {
		_checked = value;
	}
	
	/**
	 * A property to mark this column as one with CheckBox item renderer. If set to true, 
	 * AdvancedZetDataGrid automatically applies both DataGridCheckBoxRenderer and DataGridHeaderCheckBox
	 * to row items and header of this column, respectively. Default value is false. 
	 **/
	public function get checked():Boolean {
		return _checked; 
	}
	

}
}