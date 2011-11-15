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
 *  Custom Event class for MDI window's resizing.
 *
 *  @see org.openzet.containers.MDIWindow
 */
public class MDIWindowResizeEvent extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Static constant that represents windowResize event name.
     */
    public static const WINDOW_RESIZE:String = "windowResize";

    /**
     *  Static constant that represents windowResizeStart event name.
     */
    public static const WINDOW_RESIZE_START:String = "windowResizeStart";

    /**
     * Static constant that represents windowResizeEnd event name.
     */
    public static const WINDOW_RESIZE_END:String = "windowResizeEnd";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDIWindowResizeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
        x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
    {
        super(type, bubbles, cancelable);

        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
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

    //----------------------------------
    //  width
    //----------------------------------

    /**
     *  width value.
     */
    public var width:Number;

    //----------------------------------
    //  height
    //----------------------------------

    /**
     *  height value.
     */
    public var height:Number;

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
        return new MDIWindowResizeEvent(type, bubbles, cancelable, x, y, width, height);
    }
}

}
