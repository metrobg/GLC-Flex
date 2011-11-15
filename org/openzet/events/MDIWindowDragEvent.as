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
 *  Custom Event class for MDIWindow's dragging.
 *
 *  @see org.openzet.containers.MDIWindow
 */
public class MDIWindowDragEvent extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Static constant that represents windowDrag event.
     */
    public static const WINDOW_DRAG:String = "windowDrag";

    /**
     *  Static constant that represents windowDragStart event.
     */
    public static const WINDOW_DRAG_START:String = "windowDragStart";

    /**
     *  Static constant that represents windowDragEnd event.
     */
    public static const WINDOW_DRAG_END:String = "windowDragEnd";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDIWindowDragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
        x:Number = 0, y:Number = 0)
    {
        super(type, bubbles, cancelable);

        this.x = x;
        this.y = y;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  x
    //----------------------------------

    /**
     *  x value.
     */
    public var x:Number;

    //----------------------------------
    //  y
    //----------------------------------

    /**
     *  y value.
     */
    public var y:Number;

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
        return new MDIWindowDragEvent(type, bubbles, cancelable, x, y);
    }
}

}
