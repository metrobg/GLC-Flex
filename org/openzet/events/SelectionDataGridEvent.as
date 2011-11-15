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
 * Custom Event class that defines event status with regard to SelectionDataGrid or AdvancedSelectionDataGrid.
 * 
 * @see org.openzet.controls.SelectionDataGrid
 * @see org.openzet.controls.AdvancedSelectionDataGrid
 * 
 */	
public class SelectionDataGridEvent extends Event
{
	
	include "../core/Version.as";
	//--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * Static constant that represents dragSelectionStart event name.
     */
    public static const DRAG_SELECTION_START:String = "dragSelectionStart";

    /**
     * Static constant that represents dragSelectionEnd event name.
     */
    public static const DRAG_SELECTION_END:String = "dragSelectionEnd";

    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function SelectionDataGridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }

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
        return new SelectionDataGridEvent(type, bubbles, cancelable);
    }

}
}