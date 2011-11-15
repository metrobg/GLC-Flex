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

package org.openzet.containers
{

/**
 *  Class that specifies window's status
 *  Properties of this class are used for MDIWindow class's <code>windowState</code> property values.
 *
 *  Values for the <code>windowState</code> of the MDIWindow class.
 *
 *  @see org.openzet.containers.MDIWindow
 */
public final class MDIWindowState
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Maximized state.
     *  Dragging and resizing is not possible in a maximized state.
     */
    public static const MAXIMIZED:String = "maximized";

    /**
     *  Minimized state.
     *  Only dragging is possible (no resizing) in a minimized state.
     */
    public static const MINIMIZED:String = "minimized";

    /**
     *  Normal state
     *  Both Dragging and resizing are possible in a normal state. 
     */
    public static const NORMAL:String = "normal";
}
}
