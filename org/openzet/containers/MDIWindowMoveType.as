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
 *  Defins window's move type. 
 *  Used for MDIWindow class's<code>windowMoveType</code> property values.
 *
 *  @see org.openzet.containers.MDIWindow
 */
public final class MDIWindowMoveType
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Supports animation effect when mouse is released after dragging completes.
     *  Displays window border as <code>none</code> does. 
     */
    public static const ANIMATED:String = "animated";

    /**
     *  Displays window border only. 
     *  If <code>windowMoveType</code> is set to this value, there'll be perfermance improvement
     *  compared with when it is set to either <code>animated</code> or <code>realtime</code>.
     */
    public static const NONE:String = "none";

    /**
     *  Changes window's position on a real time basis.
     *  If <code>windowMoveType</code> is set to this value, there could be performance problem
     *  depending on client's CPU capabilities. 
     */
    public static const REALTIME:String = "realtime";
}

}
