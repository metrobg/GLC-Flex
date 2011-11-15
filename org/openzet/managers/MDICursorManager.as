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

package org.openzet.managers
{

import mx.managers.CursorManager;
import mx.managers.CursorManagerPriority;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

//----------------------------------------
//  Styles
//----------------------------------------

/**
 *  Cursor style for all 4 directions's cursor (north, south, east and west).
 *
 *  @default the "SizeAllCursor" symbol in the Assets.swf file.
 */
[Style(name="sizeAllCursor", type="Class", inherit="no")]

/**
 *  Cursor style for north/east and south/west direction's cursor.
 *
 *  @default the "SizeNESWCursor" symbol in the Assets.swf file.
 */
[Style(name="sizeNESWCursor", type="Class", inherit="no")]

/**
 *  Cursor style for north and south direction's cursor.
 *
 *  @default the "SizeNSCursor" symbol in the Assets.swf file.
 */
[Style(name="sizeNSCursor", type="Class", inherit="no")]

/**
 *  Cursor style for north/west and sout/east direction's cursor.
 *
 *  @default the "SizeNWSECursor" symbol in the Assets.swf file.
 */
[Style(name="sizeNWSECursor", type="Class", inherit="no")]

/**
 *  Cursor style for east and west direction's cursor.
 *
 *  @default the "SizeWECursor" symbol in the Assets.swf file.
 */
[Style(name="sizeWECursor", type="Class", inherit="no")]

/**
 *  The x offset of the sizeAllCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeAllCursorXOffset", type="Number", inherit="no")]

/**
 *  The y offset of the sizeAllCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeAllCursorYOffset", type="Number", inherit="no")]

/**
 *  The x offset of the sizeNESWCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -7.
 */
[Style(name="sizeNESWCursorXOffset", type="Number", inherit="no")]

/**
 *  The y offset of the sizeNESWCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -7.
 */
[Style(name="sizeNESWCursorYOffset", type="Number", inherit="no")]

/**
 *  The x offset of the sizeNSCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeNSCursorXOffset", type="Number", inherit="no")]

/**
 *  The y offset of the sizeNSCursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeNSCursorYOffset", type="Number", inherit="no")]

/**
 *  The x offset of the sizeNWSECursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -7.
 */
[Style(name="sizeNWSECursorXOffset", type="Number", inherit="no")]

/**
 *  The y offset of the sizeNWSECursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -7.
 */
[Style(name="sizeNWSECursorYOffset", type="Number", inherit="no")]

/**
 *  The x offset of the sizeWECursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeWECursorXOffset", type="Number", inherit="no")]

/**
 *  The y offset of the sizeWECursor, in pixels, relative to the mouse pointer.
 *
 *  The default value is -10.
 */
[Style(name="sizeWECursorYOffset", type="Number", inherit="no")]

/**
 *  MDICursorManager class manages cursors for MDI.
 *  For each case, you can specify styles for each cursor.
 *  Types of these cursors are defined by this class's static constants.
 */
public class MDICursorManager
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Static constant represnting size cursor for all directions.
     */
    public static const SIZE_ALL:String = "sizeAll";

    /**
     *  Static constant represnting size cursor for north/east and south/west directions.
     */
    public static const SIZE_NESW:String = "sizeNESW";

    /**
     *  Static constant represnting size cursor for north and south directions.
     */
    public static const SIZE_NS:String = "sizeNS";

    /**
     *  Static constant represnting size cursor for north/west and south/east directions.
     */
    public static const SIZE_NWSE:String = "sizeNWSE";

    /**
     * Static constant represnting size cursor for east and west directions.
     */
    public static const SIZE_WE:String = "sizeWE";

    //--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  current cursor
     */
    private static var currentCursorType:String = null;

    /**
     *  @private
     *  current cursor's id.
     */
    private static var currentCursorID:int = -1;

    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Sets the current cursor.
     *  Types of available cursors are defined by this class's constants.
     *
     *  @param cursorType cursor type
     */
    public static function setCursor(cursorType:String):void
    {
        // if new cursor type is the same with the current one
        if (cursorType == currentCursorType)
        {
            return;
        }

        // if cursor type is set to null
        if (cursorType == null)
        {
            CursorManager.removeAllCursors();
            currentCursorType = null;
            currentCursorID = -1;
            return;
        }

        // Retrieves cursor and its offset from styles.
        var styleDeclaration:CSSStyleDeclaration =
            StyleManager.getStyleDeclaration("MDICursorManager");

        var cursorClass:Class;
        var cursorXOffset:Number;
        var cursorYOffset:Number;

        switch (cursorType)
        {
            case MDICursorManager.SIZE_ALL:
            {
                cursorClass = styleDeclaration.getStyle("sizeAllCursor");
                cursorXOffset = styleDeclaration.getStyle("sizeAllCursorXOffset");
                cursorYOffset = styleDeclaration.getStyle("sizeAllCursorYOffset");
                break;
            }

            case MDICursorManager.SIZE_NESW:
            {
                cursorClass = styleDeclaration.getStyle("sizeNESWCursor");
                cursorXOffset = styleDeclaration.getStyle("sizeNESWCursorXOffset");
                cursorYOffset = styleDeclaration.getStyle("sizeNESWCursorYOffset");
                break;
            }

            case MDICursorManager.SIZE_NS:
            {
                cursorClass = styleDeclaration.getStyle("sizeNSCursor");
                cursorXOffset = styleDeclaration.getStyle("sizeNSCursorXOffset");
                cursorYOffset = styleDeclaration.getStyle("sizeNSCursorYOffset");
                break;
            }

            case MDICursorManager.SIZE_NWSE:
            {
                cursorClass = styleDeclaration.getStyle("sizeNWSECursor");
                cursorXOffset = styleDeclaration.getStyle("sizeNWSECursorXOffset");
                cursorYOffset = styleDeclaration.getStyle("sizeNWSECursorYOffset");
                break;
            }

            case MDICursorManager.SIZE_WE:
            {
                cursorClass = styleDeclaration.getStyle("sizeWECursor");
                cursorXOffset = styleDeclaration.getStyle("sizeWECursorXOffset");
                cursorYOffset = styleDeclaration.getStyle("sizeWECursorYOffset");
                break;
            }
        }

        currentCursorType = cursorType;

        if (currentCursorID != -1)
        {
            CursorManager.removeCursor(currentCursorID);
            currentCursorID = -1;
        }

        if (cursorClass !== null)
        {
            currentCursorID = CursorManager.setCursor(cursorClass,
                CursorManagerPriority.LOW, cursorXOffset, cursorYOffset);
        }
    }
}

}
