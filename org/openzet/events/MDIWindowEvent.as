////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//  All Rights Reserved.
//
//  This file is part of OpenZet.
//
//  OpenZet is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License version 3 as
//  published by the Free Software Foundation.
//
//  OpenZet is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License version 3 for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with OpenZet. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////

package org.openzet.events
{

import flash.events.Event;

/**
 *  Custom Event class for IMDIWindow's state.
 *  Child controls for MDI should implement IMDIWindow interface as well as event dispatchment of the
 *  following events. 
 * 
 *  @see org.openzet.containers.MDIWindow
 *  @see org.openzet.containers.IMDIWindow
 */
public class MDIWindowEvent extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Static constant that represents close event name. Normally dispatched when users click on close button. 
     */
    public static const CLOSE:String = "close";

    /**
     *  Static constant that represents maximize event name. Normally dispatched when users click on maximize button.
     */
    public static const MAXIMIZE:String = "maximize";

    /**
     *  Static constant that represents minimize event name. Normally dispatched when users click on minimize button.
     */
    public static const MINIMIZE:String = "minimize";

    /**
     * Static constant that represents restore event name. Normally dispatched when users click on restore button.
     */
    public static const RESTORE:String = "restore";

    /**
     *  @private
     *  
     */
    public static const WINDOW_STATE_CHANGE:String = "windowStateChange";

    /**
     *  Static constant that represents windowFocusIn event.
     *  Dispatched after a display object gains focus.
     */
    public static const WINDOW_FOCUS_IN:String = "windowFocusIn";

    /**
     *  Static constant that represents windowFocusOut event.
     *  Dispatched after a display object loses focus.
     */
    public static const WINDOW_FOCUS_OUT:String = "windowFocusOut";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDIWindowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
        oldWindowState:String = null, newWindowState:String = null)
    {
        super(type, bubbles, cancelable);

        this.oldWindowState = oldWindowState;
        this.newWindowState = newWindowState;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  oldWindowState
    //----------------------------------

    /**
     *  Property representing the previous window state. 
     */
    public var oldWindowState:String;

    //----------------------------------
    //  newWindowState
    //----------------------------------

    /**
     *  Property representing new window state. 
     */
    public var newWindowState:String;

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
        return new MDIWindowEvent(type, bubbles, cancelable, oldWindowState, newWindowState);
    }
}
}
