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
 *  Class that specifies window's resize type.
 *  Property values of this class are used for MDIWindow class's <code>resizeType</code> values.
 *
 *  @see org.openzet.containers.MDIWindow
 */
public final class MDIWindowResizeType
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Supports animation effect when mouse is released. Displays the window border
     *  as <code>none</code> does. 
     */
    public static const ANIMATED:String = "animated";

    /**
     *  Displays the window border only.
     *  If <code>resizeType</code> is set to this propety, there could be performance enhancement
     *  compared with cases when it is set to either <code>animated</code> or <code>realtime</code>.
     */
    public static const NONE:String = "none";

    /**
     *  Resizes a window on a real time basis.
     *  There could a performance problem when <code>resizeType</code> is set to this property,
     *  depending on client's cpu capabilities.
     */
    public static const REALTIME:String = "realtime";
}

}
