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

import flash.utils.setInterval;
import flash.utils.clearInterval;
import flash.geom.Point;

import org.openzet.containers.IMDIWindow;
import org.openzet.containers.MDI;
import org.openzet.containers.MDIWindowState;
import org.openzet.core.openzet_internal;
import org.openzet.utils.MathUtil;

use namespace openzet_internal;

//--------------------------------------
//  Other metadata
//--------------------------------------

[ExcludeClass]

/**
 *  Layout class that takes care of MDI layout.
 */
public class MDILayout
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDILayout()
    {
        super();
    }

    //--------------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  x position of a new window.
     */
    private var nextWindowX:Number;

    /**
     *  @private
     *  y postion of a new window.
     */
    private var nextWindowY:Number;

    /**
     *  @private
     *  x position of a minimized window.
     */
    private var nextMinWindowX:Number;

    /**
     *  @private
     *  y position of a minimized window.
     */
    private var nextMinWindowY:Number;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  target
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the target property.
	 */
	private var _target:MDI;

	/**
	 *  The container associated with this layout.
	 */
	public function get target():MDI
	{
		return _target;
	}

	/**
	 *  @private
	 */
	public function set target(value:MDI):void
	{
		_target = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
     *  @private
     *  Assigns initial position of a windwow.
     *  Sets the initial position of a window using nextWindowX, nextWindowY properties.
     *
     *  @param window IMDIWindow type of instance to set its position.
     */
    public function setWindowPosition(window:IMDIWindow):void
    {
        if (isNaN(nextWindowX) || isNaN(nextWindowY))
        {
            resetWindowPosition();
        }

        if (nextWindowX + window.width > target.width)
        {
            nextWindowX = target.getStyle("paddingLeft");
        }

        if (nextWindowY + window.height > target.height)
        {
            nextWindowY = target.getStyle("paddingTop");
        }

        window.x = nextWindowX;
        window.y = nextWindowY;
        //window.setPosition(nextWindowX, nextWindowY);

        // Set next value.
        var windowGap:Number = target.getStyle("windowGap");

        nextWindowX += windowGap;
        nextWindowY += windowGap;
    }

    /**
     *  @private
     *  Assigns initial position of a new window.
     */
    private function resetWindowPosition():void
    {
        nextWindowX = target.getStyle("paddingLeft");
        nextWindowY = target.getStyle("paddingTop");
    }

    /**
     *  @private
     *  Initializes position of a minimized window.
     */
    private function resetMinWindowPosition():void
    {
        nextMinWindowX = target.getStyle("paddingLeft");
        nextMinWindowY = target.height - target.windowMinHeight - target.getStyle("paddingBottom");
    }

    /**
     *  @private
     *  Returns whether MDI has no children or not.
     */
    private function isEmpty():Boolean
    {
        return target == null || target.numChildren == 0;
    }

    /**
     *  @private
     *  Returns window list. The resulting list will be in ascending child index window
     *
     *  @param minimizedOnly If set true, returns only minimized windows' list, otherwise
     *  returns windows not minimized.
     */
    private function getWindows(minimizedOnly:Boolean):Array /* of IMDIWindow */
    {
        var children:Array = target.getChildren();

        return children.filter(isNotMinimized);

        function isNotMinimized(element:*, index:int, arr:Array):Boolean
        {
            return minimizedOnly ?
                element.windowState == MDIWindowState.MINIMIZED :
                element.windowState != MDIWindowState.MINIMIZED;
        }
    }

    /**
     *  @private
     *  Aligns minimized windows.
     *  Aligns even minimized windows when aligning windows horizontally, vertically or cascadingly.
     *  Aligns even minimized windows that have been dragged after being minimized.
     *  Aligns windows according to their childIndex.
     */
    private function alignMinimizedWindows():void
    {
        resetMinWindowPosition();

        var children:Array = getWindows(true);

        var i:int;
        var n:int = children.length;

        for (i = 0; i < n; i++)
        {
            setMinWindowPosition(children[i]);
        }
    }

    /**
     *  @private
     *  Aligns minimized window's position
     *  This method has effect only when aligning all windows.
     *  Initializes draggedMinWindow property value.
     */
    private function setMinWindowPosition(window:IMDIWindow):void
    {
        var paddingRight:Number = target.getStyle("paddingRight");
        var paddingBottom:Number = target.getStyle("paddingBottom");
        var paddingLeft:Number = target.getStyle("paddingLeft");
        var hGap:Number = target.getStyle("horizontalGap");
        var vGap:Number = target.getStyle("verticalGap");

        // Reset min properties..
        var windowData:MDIWindowData = target.findMDIWindowDataByOwner(window);
        windowData.draggedMinWindow = false;
        windowData.minX = nextMinWindowX;
        windowData.minY = nextMinWindowY;

        window.x = nextMinWindowX;
        window.y = nextMinWindowY;

        nextMinWindowX += target.windowMinWidth + hGap;

        if (nextMinWindowX + target.windowMinWidth > target.width - paddingRight)
        {
            nextMinWindowX = paddingLeft;
            nextMinWindowY -= target.windowMinHeight + vGap;
        }
    }

    /**
     *  Cascades all windows in their child index ascendingly.
     */
    public function cascade(sequenceAnimate:Boolean, sequenceInterval:Number):void
    {

		// Cascading alignment will be applied according to MDI windows' child indexes,
		// which are not necessarily equal to windowInfo's order.
		// This way, we will see active windows on the top and we wouldn't need to call
		// bringToFront() method again.

        if (isEmpty())
        {
            return;
        }

        var children:Array = getWindows(false);
        var n:int = children.length;


        // If all windows are minimized, aligns only minimized ones and escape this method.
        if (n == 0)
        {
            alignMinimizedWindows();
            return;
        }

        resetWindowPosition();

        // effect
        if (sequenceAnimate)
        {
            var count:int = 0;
            var intervalId:uint = setInterval(sequenceCascade, sequenceInterval);
            sequenceCascade();

            function sequenceCascade():void
            {
                if (count < n)
                {
                    var window:IMDIWindow = children[count++];
                    window.setWindowState(MDIWindowState.NORMAL, true);
                    setWindowPosition(window);
                    window.setSize(target.windowDefaultWidth, target.windowDefaultHeight);
                    //p.bringToFront();
                }
                else
                {
                    clearInterval(intervalId);
                    return;
                }
            }
        }

        // no effect
        else
        {
            var i:int;

            for (i = 0; i < n; i++)
            {
                var window:IMDIWindow = children[i];

                window.setWindowState(MDIWindowState.NORMAL, true);
                //p.resetSize();
                window.setSize(target.windowDefaultWidth, target.windowDefaultHeight);
                //p.bringToFront();
                setWindowPosition(window);
            }
        }

        // aligns minimized windows.
        alignMinimizedWindows();
    }

    /**
     *  Aligns all windows horizontally or vertically.
     *  The alignment will be conducted in ascending child index.
     *
     *  @param alignType Type of alignment, 'horizontal' for horizontal
     *  alignment, 'vertical' for vertical alignment.
     */
    public function alignWindows(alignType:String, sequenceAnimate:Boolean, sequenceInterval:Number):void
    {
        if (isEmpty())
        {
            return;
        }

        // Firstly, aligns all windows except for minimized ones
        // and aligns them in descending child index order.
        var children:Array = getWindows(false);
        children.reverse();

        var n:int = children.length;

        // If all windows are minimized, aligns only minimized ones and escape this method.
        if (n == 0)
        {
            alignMinimizedWindows();
            return;
        }

        // column count
        var c:int = 3;

        // row count
        var r:int;

        // number added to row. Should be lower than c's value.
        var remain:int;

        // if child count is greater than 3
        if (n > 3)
        {
            while (true)
            {
                // Increases c's value in a loop and continues to check its remainder.
                // Escapes the loop when n/c is less than c.
                if (n / c < c)
                {
                    c--;
                    r = n / c;
                    remain = n % c;
                    break;
                }

                c++;
            }
        }

        // when n is equal to or less than 3
        else
        {
            c = 1;
            r = n;
            remain = 0;
        }

        // if alignType is vertical, exchange c and r values.
        if (alignType == "vertical")
        {
            var temp:Number = c;
            c = r;
            r = temp;
        }

        var posX:Number;
        var posY:Number;
        var col:int = 0;
        var row:int = 0;

        var paddingTop:Number = target.getStyle("paddingTop");
        var paddingRight:Number = target.getStyle("paddingRight");
        var paddingBottom:Number = target.getStyle("paddingBottom");
        var paddingLeft:Number = target.getStyle("paddingLeft");
        var hGap:Number = target.getStyle("horizontalGap");
        var vGap:Number = target.getStyle("verticalGap");

        // effect
        if (sequenceAnimate)
        {
            var count:int = 0;
            var intervalId:uint = setInterval(sequenceAlign, sequenceInterval);
            sequenceAlign();

            function sequenceAlign():void
            {
                if (count < n)
                {
                    var w:Number = Math.floor((target.width - paddingLeft - paddingRight) / c);
                    var h:Number = Math.floor((target.height - paddingTop - paddingBottom) / (r + ((c - col) <= remain ? 1 : 0)));
                    posX = paddingLeft + (w * col);
                    posY = paddingTop + (h * row);

                    var window:IMDIWindow = children[count++];
                    window.setWindowState(MDIWindowState.NORMAL, true);
                    window.setPosition(posX, posY);
                    window.setSize(w, h);

                    if (++row >= (r + ((c - col) <= remain ? 1 : 0)))
                    {
                        row = 0;
                        col++;
                    }
                }
                else
                {
                    clearInterval(intervalId);
                }
            }
        }

        // no effect
        else
        {
            var i:int;

            for (i = 0; i < n; i++)
            {

                // Calculates window's width by dividing width with column's count.
                // gap will have its value by substracting 1 from column's count.
                var cc:Number = c;
                var w:Number = Math.floor((target.width - paddingLeft - paddingRight - (hGap * (cc - 1))) / cc);

                // Calculates window's height by diving height with row's count.
                // gap will have its value by substracting 1 from row's count.
                var rr:Number = r + ((c - col) <= remain ? 1 : 0);
                var h:Number = Math.floor((target.height - paddingTop - paddingBottom - (vGap * (rr - 1))) / rr);

                posX = paddingLeft + ((w + hGap) * col);
                posY = paddingTop + ((h + vGap) * row);

                var window:IMDIWindow = children[i];
                window.setWindowState(MDIWindowState.NORMAL, true);
                window.setPosition(posX, posY);
                window.setSize(w, h);

                if (++row >= rr)
                {
                    row = 0;
                    col++;
                }
            }
        }

        // Aligns minimized windows.
        alignMinimizedWindows();
    }

    /**
     *  Randomly sets position and size of all windows.
     *  Windows will be aligned in their ascending child index.
     */
    public function random(sequenceAnimate:Boolean, sequenceInterval:Number):void
    {
        if (isEmpty())
        {
            return;
        }

        // The order will be in accordance with windows' ascending child indexes.
        var children:Array = getWindows(false);

        var n:int = children.length;

        // If all windows are minimized, aligns only minimized windows and escapes this method.
        if (n == 0)
        {
            alignMinimizedWindows();
            return;
        }

        var paddingTop:Number = target.getStyle("paddingTop");
        var paddingRight:Number = target.getStyle("paddingRight");
        var paddingBottom:Number = target.getStyle("paddingBottom");
        var paddingLeft:Number = target.getStyle("paddingLeft");

        // effect
        if (sequenceAnimate)
        {
            var count:int = 0;
            var intervalId:uint = setInterval(sequenceAlign, sequenceInterval);
            sequenceAlign();

            function sequenceAlign():void
            {
                if (count < n)
                {
                    var w:Number = MathUtil.randRange(target.windowMinWidth, target.windowDefaultWidth);
                    var h:Number = MathUtil.randRange(target.windowMinHeight, target.windowDefaultHeight);
                    var posX:Number = MathUtil.randRange(paddingLeft, target.width - paddingRight - w);
                    var posY:Number = MathUtil.randRange(paddingTop, target.height - paddingBottom - h);

                    var window:IMDIWindow = children[count++];
                    window.setWindowState(MDIWindowState.NORMAL, true);
                    //p.bringToFront();
                    window.setPosition(posX, posY);
                    window.setSize(w, h);
                }
                else
                {
                    clearInterval(intervalId);
                }
            }
        }

        // no effect
        else
        {
            var i:int;

            for (i = 0; i < n; i++)
            {
                var w:Number = MathUtil.randRange(target.windowMinWidth, target.windowDefaultWidth);
                var h:Number = MathUtil.randRange(target.windowMinHeight, target.windowDefaultHeight);
                var posX:Number = MathUtil.randRange(paddingLeft, target.width - paddingRight - w);
                var posY:Number = MathUtil.randRange(paddingTop, target.height - paddingBottom - h);

                var window:IMDIWindow = children[i];
                window.setWindowState(MDIWindowState.NORMAL, true);
                //p.bringToFront();
                window.setPosition(posX, posY);
                window.setSize(w, h);
            }
        }

        // aligns minimized windows.
        alignMinimizedWindows();
    }

    /**
     *  Minimizes all windows.
     *  The order will be in accordance with windows' creation indexes.
     */
    public function minimizeAll(sequenceAnimate:Boolean, sequenceInterval:Number):void
    {
        if (isEmpty())
        {
            return;
        }

        var windowInfo:Array = target.windowInfo;
        var n:int = windowInfo.length;

        // If all windows are minimized, aligns only minimized windows.
        if (n == 0)
        {
            return;
        }

        // effect
        if (sequenceAnimate)
        {
            var count:int = 0;
            var intervalId:uint = setInterval(sequenceMinimize, sequenceInterval);
            sequenceMinimize();

            function sequenceMinimize():void
            {
                if (count < n)
                {
                    var windowData:MDIWindowData = windowInfo[count++];

                    windowData.owner.windowState = MDIWindowState.MINIMIZED;
                }
                else
                {
                    clearInterval(intervalId);
                }
            }
        }

        // no effect
        else
        {
            var i:int;

            for (i = 0; i < n; i++)
            {
                windowInfo[i].owner.windowState = MDIWindowState.MINIMIZED;
            }
        }
    }

    /**
     *  Restores all windows' to their previous state.
     *  The order will be in accordance with windows' creation indexes.
     */
    public function restoreAll(sequenceAnimate:Boolean, sequenceInterval:Number):void
    {
        if (isEmpty())
        {
            return;
        }

        var windowInfo:Array = target.windowInfo;
        var n:int = windowInfo.length;

        // If all windows are minimized, aligns only minimized windows and escapes this method.
        if (n == 0)
        {
            return;
        }

        if (sequenceAnimate)
        {
            var count:int = 0;
            var intervalId:uint = setInterval(sequenceRestore, sequenceInterval);
            sequenceRestore();

            function sequenceRestore():void
            {
                if (count < n)
                {
                    var windowData:MDIWindowData = windowInfo[count++];

                    //windowData.owner.restore();
                    windowData.owner.windowState = MDIWindowState.NORMAL;
                }
                else
                {
                    clearInterval(intervalId);
                }
            }
        }
        else
        {
            var i:int;

            for (i = 0; i < n; i++)
            {
                //windowData.owner.restore();
                windowInfo[i].owner.windowState = MDIWindowState.NORMAL;
            }
        }
    }

    /**
     *  @private
     *  Sets position and size of a minimized window.
     */
    openzet_internal function setMinimizeWindowPosition(windowData:MDIWindowData):void
    {
        var pt:Point = getMinimizeWindowPosition(windowData);

        windowData.minX = pt.x;
        windowData.minY = pt.y;

        windowData.owner.setPosition(pt.x, pt.y);
        windowData.owner.setSize(target.windowMinWidth, target.windowMinHeight);
    }

    /**
     *  @private
     *  Returns the position of a minimized window.
     *  This method is called by setMinimizeWindowPosition() method.
     *  This method puts into consideration of other windows' position and the room occupied by them.
     *  This method also takes into account of room that could be possibly occupied by currently minimized
     *  windows, when they are restored.
     *  The order will be in accordance with creation indexes of all windows.
     */
    private function getMinimizeWindowPosition(windowData:MDIWindowData):Point
    {
        // If a window has been dragged in a minimized state,
        // simply returns its default position.
        if (windowData.draggedMinWindow)
        {
            return new Point(windowData.minX, windowData.minY);
        }

        var paddingRight:Number = target.getStyle("paddingRight");
        var paddingBottom:Number = target.getStyle("paddingBottom");
        var paddingLeft:Number = target.getStyle("paddingLeft");
        var hGap:Number = target.getStyle("horizontalGap");
        var vGap:Number = target.getStyle("verticalGap");

        // x and y coordinate to be taken by a minimized window.
        var minX:Number = paddingLeft;
        var minY:Number = target.height - target.windowMinHeight - paddingBottom;

        // the order in in accordance with windows' creation indexes.
        var windowInfo:Array = target.windowInfo;

        var i:int;
        var n:int = windowInfo.length;


        // Calculates the position to place minimized windows.
        // The alignment starts from the left bottom of the screen.
        // This method checks with all windows whether they occupy that area.
        // If the area is not occupied by any window, we place a window there.
        // Otherwise, check with other areas with the some routine above.
        while (true)
        {
            // Flag to check whther certain area is empty
            var exist:Boolean = false;

            // Checks whether a window exists in a certain area
            // based on its minX, minY, minWidth and minHeight values.
            // The idea is as follows
            // 1. Avoids the position of currently minimized windows.
            // 2. Avoids the position of a previously minimized and dragged window
            // since this position has been already occupied by the window.
            for (i = 0; i < n; i++)
            {
                var wData:MDIWindowData = windowInfo[i];

                // Pass on to next iterator if the data's owner is window itself.
                if (wData.owner == windowData.owner)
                {
                    continue;
                }

                // If a window is not in minimized state, and it has not been dragged while minimized
                if (!wData.draggedMinWindow &&
                    wData.owner.windowState != MDIWindowState.MINIMIZED)
                {
                    continue;
                }


                // After going through the routine above, we now have windows like the following.
                // 1. Currently minimized windows.
                // 2. Previously dragged while minimized windows, even though they are not currently minimized.
                // Checks whehter a window exists in a ractangle area.
                // If so, that area will be marked as a place occupied by another window
                // so exist flag will be set true and we escape the loop.

                if (wData.minX >= minX - target.windowMinWidth && wData.minX < minX + target.windowMinWidth &&
                    wData.minY >= minY - target.windowMinHeight && wData.minY < minY + target.windowMinHeight)
                {
                    exist = true;
                    break;
                }
            }

            // If the area is empty, escape the loop.
            if (!exist)
            {
                break;
            }

            // If the area is not empty, increases minX value continuously in a loop.
            minX += target.windowMinWidth + hGap;

            // if x is greater than MDI's width
            // x will be utter-left position and y's value will be decreased correspondingly.
            // even if y is less than 0, we don't need to care.
            if (minX + target.windowMinWidth > target.width - paddingRight)
            {
                minX = paddingLeft;
                minY -= target.windowMinHeight + vGap;
            }
        }

        return new Point(minX, minY);
    }
}

}
