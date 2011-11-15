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
 *  Custom Event class for SSNTextInput.
 */
public class SSNTextInputEvent extends Event
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
    public function SSNTextInputEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * Static constant that represents validSSN event name.
     */
    public static const VALID_SSN:String = "validSSN";

    /**
     * Static constant that represents invalidSSN event name.
     */
    public static const INVALID_SSN:String = "invalidSSN";

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * SSN string
     */
    public var ssn:String;

    /**
     * First part of SSN      
     **/
    public var ssn1:String;

    /**
     * Second part of SSN
     */
    public var ssn2:String;

    /**
     *  Flag indicating whether SSN is valid
     */
    public var valid:Boolean;

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
        var e:SSNTextInputEvent = new SSNTextInputEvent(type, bubbles, cancelable);
        e.ssn = this.ssn;
        e.ssn1 = this.ssn1;
        e.ssn2 = this.ssn2;
        e.valid = this.valid;

        return e;
    }
}
}
