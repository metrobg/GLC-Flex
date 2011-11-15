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
*  Custom Event class for ZetDateField.
*/
public class ZetDateFieldEvent extends Event
{
    include "../core/Version.as";
    
    //----------------------------------------------------------------------
    //
    //  Constructor
    //
    //----------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function ZetDateFieldEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
    }

    //----------------------------------------------------------------------
    //
    //  Class Constants
    //
    //----------------------------------------------------------------------
	 /**
     * Static constant that represents changeDate event name.
     */
    public static const CHANGE_DATE:String = "changeDate";
    
     /**
     * Static constant that represents changeDateField event name.
     */
    public static const CHANGE_DATE_FIELD:String = "changeDateField";

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
        return new ZetDateFieldEvent(type, bubbles, cancelable);
    }
}
}