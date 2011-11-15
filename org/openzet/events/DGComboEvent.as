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
 * Custom event class that defines selectionFieldChanged event for a DGComboBox control.
 **/
public class DGComboEvent extends Event
{
	include "../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
	/**
	 * Static constant that represents selectedFieldChanged event name.
	 * 
	 **/
	public static const SELECTED_FIELD_CHANGED:String ="selectedFieldChanged";
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 * Constructor
	 **/
	public function DGComboEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
    	super(type, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 * 
	 * Overriden method to cast Event type as a DGComboEvent type.
	 **/
	override public function clone():Event {
		return new DGComboEvent(type, bubbles, cancelable);
	}

}
}