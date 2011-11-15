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

package org.openzet.containers.mdiClasses
{

import org.openzet.containers.IMDIWindow;

//--------------------------------------
//  Other metadata
//--------------------------------------

[ExcludeClass]

/**
 *  Helper class that stores MDIWindow's state. Defines <code>WindowState.NORMAL</code> state's x, y, width, height,
 *  minimized state's position (minX, minY) and draggedMinWindow (flag indicating whehter a window has been dragged while minimized) properties,
 */
public class MDIWindowData
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
	 *  Constructor.
	 */
	public function MDIWindowData()
	{
        super();
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  owner
    //----------------------------------

    /**
     *  @private
     */
    private var _owner:IMDIWindow;

    /**
     *  owner.
     */
    public function get owner():IMDIWindow
    {
        return _owner;
    }

    /**
     *  @private
     */
    public function set owner(value:IMDIWindow):void
    {
        _owner = value;
    }

    //----------------------------------
    //  Other properties
    //----------------------------------

    /**
     *  owner's x value..
     *  This value represents WindowState.NORMAL state's x value.
     *  This value is used when state changes from <code>WindowState.MAXIMIZED</code> or <code>WindowState.MINIMIZED</code>
     *  to <code>WindowState.NORMAL</code> state.
     *  y, width, height are all equal.
     */
    public var x:Number = 0;

    /**
     *  owner's y value.
     */
    public var y:Number = 0;

    /**
     *  owner's width.
     */
    public var width:Number = 0;

    /**
     *  owner's height.
     */
    public var height:Number = 0;

    /**
     *  owner's x when minimized.
     */
    public var minX:Number = 0;

    /**
     *  owner's y when minimized.
     */
    public var minY:Number = 0;

    /**
     *  Flag indicating whether user has dragged a window while minimized.
     *  IF a user has dragged a window in its minimized state,
     *  this property is set to true.
     *  If true, when calculating other windows' position when their state is set to minimized,
     *  the room occupied by the owner window will be marked as unoccupiable based on owner's
     *  minX and minY values.
     *  If you call cascade() method, which aligns all windows, this property will be intialized to false.
     *
     *  @default false
     */
    public var draggedMinWindow:Boolean = false;
}

}
