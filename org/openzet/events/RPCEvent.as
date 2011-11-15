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
 * Custom Event class for remote procedure call.
 */
public class RPCEvent extends Event{
	
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    /**
     * Static constant that represents initialize event name.
     */
    public static const INITIALIZE:String = "initialize";
     /**
     * Static constant that represents complete event name.
     */
    public static const COMPLETE:String = "complete";
     /**
     * Static constant that represents error event name.
     */
    public static const ERROR:String = "error";


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
    * Storage for transffered data. 
    * @return Object Data transferred by a remote procedure call.
    */
    public var data:Object = {};
    
    /**
    * Storage for error.
    * @return Object Error occurred while performing remote procedure call.
    */
    public var error:Object = {};


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function RPCEvent(type:String,result:Object = null,falut:Object=null)
    {
            super(type,false,false);
            data = result;
            this.error = falut;
    }

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
            var e:RPCEvent = new RPCEvent(type,data,error);
            e.data = this.data;
            e.error = this.error;
            return e;
    }
}
}