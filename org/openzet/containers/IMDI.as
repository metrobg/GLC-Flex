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

import mx.core.IContainer;

/**
 * IMDI interface defines methods and properties needed for an MDI 
 */
public interface IMDI extends IContainer
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  windowDefaultWidth
    //----------------------------------

    /**
     *  Default width of a window.
     *  When a new window is populated, its width value is set based on the resulting value of this method.
     *  Also when cascading windows, their default width will be set as the resulting value of this method.
     */
    function get windowDefaultWidth():Number;

    /**
     *  @private
     */
    function set windowDefaultWidth(value:Number):void;

    //----------------------------------
    //  windowDefaultHeight
    //----------------------------------

    /**
     *  Default height of a window. 
     *  When a new window is populated, its height value is set based on the resulting value of this method.
     *  Also when cascading windows, their default height will be set as the resulting value of this method.
     */
    function get windowDefaultHeight():Number;

    /**
     *  @private
     */
    function set windowDefaultHeight(value:Number):void;

    //----------------------------------
    //  windowMinWidth
    //----------------------------------

    /**
     *  window minimum width
     */
    function get windowMinWidth():Number;

    /**
     *  @private
     */
    function set windowMinWidth(value:Number):void;

    //----------------------------------
    //  windowMinWidth
    //----------------------------------

    /**
     *  window minimum height 
     */
    function get windowMinHeight():Number

    /**
     *  @private
     */
    function set windowMinHeight(value:Number):void;

    //----------------------------------
    //  includeMinimizedWindowForAlign
    //----------------------------------

    /**
     *  Flag specifying whether to include minimized windows when aligning windows. 
     */
    function get includeMinimizedWindowForAlign():Boolean;

    /**
     *  @private
     */
    function set includeMinimizedWindowForAlign(value:Boolean):void;

    //----------------------------------
    //  minimizedWindowAutoAlign
    //----------------------------------

    /**
     *  Flag specifying whether to auto-align minimzied windows. 
     */
    function get minimizedWindowAutoAlign():Boolean;

    /**
     *  @private
     */
    function set minimizedWindowAutoAlign(value:Boolean):void;

    //----------------------------------
    //  boundsEnabled
    //----------------------------------

    /**
     *  Flag specifying whether to set MDI's bounds.
     */
    function get boundsEnabled():Boolean;

    /**
     *  @private
     */
    function set boundsEnabled(value:Boolean):void;

    //----------------------------------
    //  allowResizeOverflow
    //----------------------------------

    /**
     *  Flag specifying whether to allow resizing of the other side of edge when one side is pushed to its limit.
     *  If true, the size of the other size increases when one side has reached its size limit.
     */
    function get allowResizeOverflow():Boolean;

    /**
     *  @private
     */
    function set allowResizeOverflow(value:Boolean):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Cascades all windows
     */
    function cascade():void;

    /**
     * Aligns all windows horizontally
     */
    function horizontalAlign():void;

    /**
     * Aligns all windows vertically
     */
    function verticalAlign():void;

    /**
     * Randomize position and size of all windows.
     */
    function random():void

    /**
     * Minimizes all windows.
     */
    function minimizeAll():void;

    /**
     * Restores all windows.
     */
    function restoreAll():void;
}

}
