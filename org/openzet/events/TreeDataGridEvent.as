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
package org.openzet.events
{
import flash.events.Event;
/**
 *  Custom Event class for TreeDataGrid.
 */	
public class TreeDataGridEvent extends Event
{
	include "../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
	
	  /**
     * Static constant that represents itemOpen event name.
     */
    public static const ITEM_OPEN:String = "itemOpen";

	   /**
     * Static constant that represents itemClose event name.
     */
    public static const ITEM_CLOSE:String = "itemClose";


	    /**
     * Static constant that represents directionChanged event name.
     */
    public static const DIRECTION_CHANGE:String = "directionChanged";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
	   /**
	 *  Constructor.
	 */
	public function TreeDataGridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, item:Object = null, dataField:String = null, isOpen:Boolean = false)
	{
	    super(type, bubbles, cancelable);
	    this.item = item;
	    this.dataField = dataField;
	    this.isOpen = isOpen;
	}
	
	/**
	 * Node Item Object
	 **/
	public var item:Object;
	
	/**
	 * Node Item's dataField
	 **/
	public var dataField:String;
	
	/**
	 * Flag to specify whether a node item has been expanded or collapsed.
	 **/
	public var isOpen:Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	override public function clone():Event
	{
	    return new TreeDataGridEvent(type, bubbles, cancelable, item, dataField, isOpen);
	}

}
}