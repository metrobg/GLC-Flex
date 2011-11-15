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
 *  Event class for MDI.
 *
 *  @see org.openzet.containers.MDI
 */
public class MDIEvent extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Static constant that represents childrenFull event name.
     */
    public static const CHILDREN_FULL:String = "childrenFull";

    /**
     * Static constant that represents minimizeAll event name.
     */
    public static const MINIMIZE_ALL:String = "minimizeAll";

    /**
     *  Static constant that represents restoreAll event name.
     */
    public static const RESTORE_ALL:String = "restoreAll";

    /**
     *  Static constant that represents alignIcon event name.
     */
    public static const ALIGN_ICON:String = "alignIcon";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
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
        return new MDIEvent(type, bubbles, cancelable);
    }
}
}
