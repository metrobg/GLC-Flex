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
import mx.utils.UIDUtil;

/**
 * Filtering Manager Class that controls each FilterHelper instance. This Class is based 
 * upon a Singleton pattern so you cannot make more than one instance of this class.
 * 
 * @see org.openzet.dataGridClasses.filter.FilterHelper
 * @see org.openzet.dataGridClasses.filter.FilterItemRenderer
 * @see org.openzet.dataGridClasses.filter.FilterPopUp
 **/
public class FilterManager
{
	 include "../../../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 * Static method to return single and unique instance of this class.
	 **/
	public static function getInstance():FilterManager {
		if (!instance) {
			instance = new FilterManager(new FilterDict(true));
		}
		return instance;
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 **/
	public function FilterManager(filter:FilterDict)
	{
		this.dict = filter;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

	/**
	 * A static property to hold reference to the unique instance of this class.  
	 **/
	private static var instance:FilterManager;
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


	/**
	 * A private property to hold reference to the FilterDict instance passed on to this class' unique instance.
	 **/
	private var dict:FilterDict;
	
	

   
 
	/**
	 * Method to return a FilterHelper instance for a given dataProvider. FilterManager class uses
	 * dataProvider's mx_internal_uid property to map dataProvider and its FilterHelper instance.
	 * 
	 * @param target Target control to retrieve its filtering data. 
	 * @return A FilterHelper instance that has been saved with target's dataProvider mx_internal_uid + target's id.
	 * 
	 **/
	public function getFilter(target:Object):FilterHelper {
		var uid:String = mx.utils.UIDUtil.getUID(target.dataProvider) + UIDUtil.getUID(target.id);
		if (getInstance().dict[uid]) {
			return getInstance().dict[uid];
		} else {
			getInstance().dict[uid] = new FilterHelper();
		}
		return getInstance().dict[uid]; 			
	}

}
}

import flash.utils.Dictionary;
/**
 * Internal Dictionary Class to implement Singleton pattern on FilterManager Class
 **/	
dynamic class FilterDict extends Dictionary {
	public function FilterDict(useWeakKeys:Boolean) {
		super(true)
	}
}