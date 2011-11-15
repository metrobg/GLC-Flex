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
	 *  Custom Event class for PagingLinkBar.
	 */
public class PagingEvent extends Event
{
    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function PagingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, detail:int = -1)
    {
        super(type, bubbles, cancelable);

        this.detail = detail;
    }

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
	/**
     * Static constant that represents pageClick event name.
     */
    public static const PAGE_CLICK:String = "pageClick";
    /**
     * Static constant that represents prevPage event name.
     */
    public static const PREV_PAGE:String = "prevPage";
    /**
     * Static constant that represents nextPage event name.
     */
    public static const NEXT_PAGE:String = "nextPage";

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  old page index
     */
    public var oldPage:uint;

    /**
     *  new page index
     */
    public var newPage:uint;
	
	/**
	 * previous page index
	 */
    public var prevPage:uint;
    
    /**
	 * next page index
	 */
    public var nextPage:uint;

    //----------------------------------
    //  detail
    //----------------------------------

    /**
    * detail index
    */
    public var detail:int;

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
        return new PagingEvent(type, bubbles, cancelable, detail);
    }
}
}
