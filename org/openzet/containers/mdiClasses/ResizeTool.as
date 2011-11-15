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

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import mx.core.FlexSprite;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.core.Application;
import mx.containers.Panel;

import org.openzet.containers.IMDI;
import org.openzet.containers.IMDIWindow;
import org.openzet.containers.MDI;
import org.openzet.containers.MDIWindow;
import org.openzet.containers.MDIWindowResizeType;
import org.openzet.containers.MDIWindowMoveType;
import org.openzet.events.MDIWindowResizeEvent;
import org.openzet.events.MDIWindowDragEvent;
import org.openzet.managers.MDICursorManager;

//--------------------------------------
//  Other metadata
//--------------------------------------

[ExcludeClass]

/**
 *  Class that takes care of MDIWindow instance's resize and drag features.
 *  This instance of this class is added as the first child of MDIWindow's rawChildren.
 */
public class ResizeTool extends FlexSprite
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
    public function ResizeTool(target:IMDIWindow)
    {
        super();

        this.target = target;

        hide();

        blendMode = BlendMode.DIFFERENCE;

        // Create sprite for hit area.
        if (!hitRect)
        {
            hitRect = new Sprite();
            hitRect.mouseEnabled = false;
            addChild(hitRect);

            hitArea = hitRect;
        }

        addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
        addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
        addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
    }

    //--------------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Constant that defines mouse cursor's status.
     *  This constant represents a status when mouse is not place over one of the window corners,
     *  which will trigger resizing of a window.
     *  Normal state.
     */
    private static const SIDE_OTHER:uint = 0x0000;

    /**
     *  @private
     *  This constant represents a status when mouse pointer is place over the top border.
     */
    private static const SIDE_TOP:uint = 0x0001;

    /**
     *  @private
     *  This constant represents a status when mouse pointer is place over the bottom border.
     */
    private static const SIDE_BOTTOM:uint = 0x0002;

    /**
     *  @private
     *  This constant represents a status when mouse pointer is place over the left border.
     */
    private static const SIDE_LEFT:uint = 0x0004;

    /**
     *  @private
     *  This constant represents a status when mouse pointer is place over the right border.
     */
    private static const SIDE_RIGHT:uint = 0x0008;

    /**
     *  @private
     *  Constant that defines the corner area of the window which will trigger resizing.
     *  If a mouse is placed over the window corner, resizing cursor will be provided
     *  based on this property's value.
     **/
    private static const CORNER_OFFSET:Number = 22;

    //--------------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Flag indicating whether MDIWindow is currently resizing.
     *  This variable is static since we don't want to change mouse cursor
     *  while resizing no matter we happen to place mouse over other window's border.
     */
    private static var isResizing:Boolean = false;

    /**
     *  @private
     *  Flag indicating whether MDIWindow is currently dragging.
     *  This variable is static since we don't want to change mouse cursor
     *  while resizing no matter we happen to place mouse over other window's border.
     */
    private static var isDragging:Boolean = false;

    //--------------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     */
    private var regX:Number;
    private var regY:Number;
    private var regWidth:Number;
    private var regHeight:Number;
    private var regTop:Number;
    private var regRight:Number;
    private var regBottom:Number;
    private var regLeft:Number;
    private var regStageMouseX:Number;
    private var regStageMouseY:Number;

    /**
     *  @private
     *  Maximum width and height of a window.
     */
    private var maxWidth:Number;
    private var maxHeight:Number;

    /**
     *  @private
     *  Minimum width and height of a window.
     */
    private var minWidth:Number;
    private var minHeight:Number;

    /**
     *  @private
     *  Window's maximum top, right, bottom, left value.
     */
    private var maxTop:Number;
    private var maxRight:Number;
    private var maxBottom:Number;
    private var maxLeft:Number;

    /**
     *  @private
     *  Window's minimum top, right, bottom, left value.
     */
    private var minTop:Number;
    private var minRight:Number;
    private var minBottom:Number;
    private var minLeft:Number;

    /**
     *  @private
     */
    private var _width:Number = 0;

    /**
     *  @private
     */
    private var _height:Number = 0;

    /**
     *  @private
     */
    private var hitRect:Sprite;

    //--------------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------------

    //----------------------------------
    //  target
    //----------------------------------

    /**
     *  @private
     */
    private var target:IMDIWindow;

    //----------------------------------
    //  mdi
    //----------------------------------

    /**
     *  @private
     */
    private function get mdi():IMDI
    {
        return target.mdi;
    }

    //----------------------------------
    //  resizable
    //----------------------------------

    /**
     *  @private
     */
    private function get resizable():Boolean
    {
        return target.resizable;
    }

    //----------------------------------
    //  mouseState
    //----------------------------------

    /**
     *  @private
     *  Storage for the mouseState property.
     */
    private var _mouseState:uint = SIDE_OTHER;

    /**
     * Returns current cursor's state.
     * If this property's value is set, we change mouse cursor.
     */
    private function get mouseState():uint
    {
        return _mouseState;
    }

    /**
     *  @private
     */
    private function set mouseState(value:uint):void
    {
        if (value == _mouseState)
        {
            return;
        }

        _mouseState = value;

        switch (_mouseState)
        {
            // other
            case ResizeTool.SIDE_OTHER:
            {
                MDICursorManager.setCursor(null);
                break;
            }

            // bottom right, top left
            case SIDE_RIGHT | SIDE_BOTTOM:
            case SIDE_LEFT | SIDE_TOP:
            {
                MDICursorManager.setCursor(MDICursorManager.SIZE_NWSE);
                break;
            }

            // bottom left, top right
            case SIDE_LEFT | SIDE_BOTTOM:
            case SIDE_RIGHT | SIDE_TOP:
            {
                MDICursorManager.setCursor(MDICursorManager.SIZE_NESW);
                break;
            }

            // left, right
            case SIDE_LEFT:
            case SIDE_RIGHT:
            {
                MDICursorManager.setCursor(MDICursorManager.SIZE_WE);
                break;
            }

            // top, bottom
            case SIDE_TOP:
            case SIDE_BOTTOM:
            {
                MDICursorManager.setCursor(MDICursorManager.SIZE_NS);
                break;
            }
        }
    }

    //----------------------------------
    //  hitThickness
    //----------------------------------

    /**
     *  @private
     *  Storage for the hitThickness property.
     */
    private var _hitThickness:Number = 4;

    /**
     *  @default 4
     */
    public function get hitThickness():Number
    {
        return _hitThickness;
    }

    /**
     *  @private
     */
    public function set hitThickness(value:Number):void
    {
        value = Math.max(1, Math.min(10, value));

        _hitThickness = value;

        invalidateDisplayList();
    }

    //----------------------------------
    //  borderAlpha
    //----------------------------------

    /**
     *  @private
     *  Storage for the borderAlpha property.
     */
    private var _borderAlpha:Number = 1;

    /**
     *  @default 1
     */
    public function get borderAlpha():Number
    {
        return _borderAlpha;
    }

    /**
     *  @private
     */
    public function set borderAlpha(value:Number):void
    {
        _borderAlpha = value;

        invalidateDisplayList();
    }

    //----------------------------------
    //  borderThickness
    //----------------------------------

    /**
     *  @private
     *  Storage for the borderThickness property.
     */
    private var _borderThickness:Number = 4;

    /**
     *  @default 4
     */
    public function get borderThickness():Number
    {
        return _borderThickness;
    }

    /**
     *  @private
     */
    public function set borderThickness(value:Number):void
    {
        value = Math.max(0, value);

        _borderThickness = value;

        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Prevents background processing of method calls stored in callLater()'s queue
     *  until UIComponent.resumeBackgroundProcessing() is called.
     *  Since LayoutManager uses callLater() method, commitProperties(), measure(), updateDisplayList() methods
     *  will not be called until resumeBackgroundProcessing() is called once suspendBackgroundProcessing() has been called.
     *  This method is used for performance causes.
     */
    private static function suspendBackgroundProcessing():void
    {
        UIComponent.suspendBackgroundProcessing();
    }

    /**
     *  @private
     *  Resumes background processing of method calls stored in callLater()'s queue after
     *  UIComponent.suspendBackgroundProcessing() has been called.
     */
    private static function resumeBackgroundProcessing():void
    {
        UIComponent.resumeBackgroundProcessing();
    }

    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     */
    public function invalidateDisplayList():void
    {
        layoutChrome(_width, _height);
    }

    /**
     *  @private
     */
    public function destroy():void
    {
        removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    /**
     *  @private
     *  Shows the window border.
     */
    private function show():void
    {
        alpha = 1;
    }

    /**
     *  @private
     *  Hides window border.
     */
    private function hide():void
    {
        alpha = 0;
    }

    /**
     *  @private
     *  Sets location.
     *
     *  @param x x value.
     *
     *  @param y y value.
     */
    private function setPosition(x:Number, y:Number):void
    {
        this.x = x;
        this.y = y;
    }

    /**
     *  Sets the size
     *
     *  @param width width value.
     *
     *  @param height height value.
     */
    public function setSize(w:Number, h:Number):void
    {
        var changed:Boolean = false;

        if (_width != w)
        {
            _width = w;
            changed = true;
        }

        if (_height != h)
        {
            _height = h;
            changed = true;
        }

        if (ResizeTool.isResizing)
        {
            return;
        }

        if (changed)
        {
            layoutChrome(_width, _height);
        }
    }

    /**
     *  @private
     */
    private function layoutChrome(w:Number, h:Number):void
    {
        drawHitBorder(w, h);
        drawBorder(w, h);
    }

    /**
     *  @private
     */
    protected function drawHitBorder(width:Number, height:Number):void
    {
        hitRect.graphics.clear();

        drawSolidLine(
            hitRect.graphics, width, height, _hitThickness, 0x00FF00, 0);
    }

    /**
     */
    protected function drawBorder(width:Number, height:Number):void
    {
        graphics.clear();
        //GraphicsUtil.drawSolidLine(graphics, width, height, borderThickness, 0xFFFFFF, borderAlpha);

        drawDottedLine(graphics, width, height, borderThickness, borderAlpha);
    }

    /**
     *  Draw solid line.
     */
    private function drawSolidLine(g:Graphics, width:Number, height:Number,
        thickness:Number, color:uint, alpha:Number):void
    {
        g.beginFill(color, alpha);
        g.drawRect(0, 0, width, height);
        g.drawRect(thickness, thickness,
            width - thickness * 2, height - thickness * 2);
        g.endFill();
    }

    /**
     *  @private
     */
    protected function drawDottedLine(g:Graphics, width:Number, height:Number,
        thickness:Number, alpha:Number):void
    {
        var alpha16:uint = uint((0xFF * alpha) << 24);
        var foreColor:uint = 0x000000 | alpha16;
        var backColor:uint = 0xFFFFFF | alpha16;

        var val:Number = target.x + this.x + target.y + this.y;

        var bmd:BitmapData = new BitmapData(2, 2, true, backColor);
        bmd.setPixel32(0, 0, foreColor);
        bmd.setPixel32(1, 1, foreColor);

	    g.beginBitmapFill(bmd, null, true, false);
        g.drawRect(0, 0, width, height);
        g.drawRect(thickness, thickness,
            Math.max(0, width - thickness * 2), Math.max(0, height - thickness * 2));
        g.endFill();
    }

    /**
     *  @private
     *  x, y, width, height, top. right, bottom, left 및
     *  stageMouseX, stageMouseY 값을 저장한다.
     *  리사이즈를 하기 위한 초기 작업.
     */
    private function storePosition():void
    {
        var paddingLeft:Number = UIComponent(mdi).getStyle("paddingLeft");
        var paddingRight:Number = UIComponent(mdi).getStyle("paddingRight");
        var paddingTop:Number = UIComponent(mdi).getStyle("paddingTop");
        var paddingBottom:Number = UIComponent(mdi).getStyle("paddingBottom");

        // Stores window's x, y, width, height
        regX = target.x;
        regY = target.y;
        regWidth = target.width;
        regHeight = target.height;

        // Stores window's top, right, bottom, left
        regTop = target.y;
        regRight = target.x + this.width;
        regBottom = target.y + this.height;
        regLeft = target.x;

        regStageMouseX = stage.mouseX;
        regStageMouseY = stage.mouseY;

        // Stores window's maximum width and height
        maxWidth = mdi.width - paddingLeft - paddingRight;
        maxHeight = mdi.height - paddingTop - paddingBottom;

        // Stores window's minimum width and height
        minWidth = mdi.windowMinWidth;
        minHeight = mdi.windowMinHeight;

        // Stores window's maximum and minimum top, right, left, bottom values
        // This values altogether define a rect (bounds) of MDI's available area.
        maxTop = regBottom - minHeight;
        maxRight = mdi.width - paddingRight;
        maxLeft = regRight - minWidth;
        maxBottom = mdi.height - paddingBottom;

        minTop = paddingTop;
        minRight = regLeft + minWidth;
        minLeft = paddingLeft;
        minBottom = regTop + minHeight;
    }

    /**
     *  @private
     *  Returns headerHeight.
     *  If target is of Panel type, returns Panel's headerHeight,
     *  otherwise returns mdi.windowMinHeight value.
     */
    private function getHeaderHeight():Number
    {
        var headerHeight:Number = mdi.windowMinHeight;

        if (target is Panel)
        {
            headerHeight = Panel(target).mx_internal::getHeaderHeightProxy();
        }

        return headerHeight;
    }

    /**
     *  @private
     *  Initalizes mouse cursor.
     */
    private function removeCursor():void
    {
        mouseState = ResizeTool.SIDE_OTHER;
    }

    /**
     *  @private
     *  Initializes border position.
     */
    private function resetPosition():void
    {
        x = y = 0;
    }

    //--------------------------------------------------------------------------------
    //
    //  Methods : Dispatch Events
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Dispatches windowResizeStart event.
     *  This event contains information data about x, y coordinates and width and height information.
     *  At the starting point of resizing, since there'd be no change with x, y, width and height,
     *  this method simply returns target's values as is.
     *  After dispatching event, position is initialized.
     */
    private function dispatchResizeStartEvent():void
    {
        var e:MDIWindowResizeEvent = new MDIWindowResizeEvent(MDIWindowResizeEvent.WINDOW_RESIZE_START);
        e.x = target.x;
        e.y = target.y;
        e.width = target.width;
        e.height = target.height;

        dispatchEvent(e);

        resetPosition();
    }

    /**
     *  @private
     *  Dispatches windowResize event.
     *  Dispatched event contains data about x, y coordinates and width, height information.
     *  Values for each of these data are assigned through this method's parameter values.
     */
    private function dispatchResizeEvent(x:Number, y:Number, width:Number, height:Number):void
    {
        var e:MDIWindowResizeEvent = new MDIWindowResizeEvent(MDIWindowResizeEvent.WINDOW_RESIZE);
        e.x = x;
        e.y = y;
        e.width = width;
        e.height = height;
        dispatchEvent(e);

        resetPosition();
    }

    /**
     *  @private
     *  Disptaches windowResizeEnd event.
     *  Dispatched event contains data about x, y coordinates and width, height information.
     *  When resizeType is realTime, we use x, y width, height value of the window as is.
     *  Otherwise, we use stored values added to current x and y values, respectively.
     */
    private function dispatchResizeEndEvent():void
    {
        var e:MDIWindowResizeEvent = new MDIWindowResizeEvent(MDIWindowResizeEvent.WINDOW_RESIZE_END);

        if (MDIWindow.resizeType == MDIWindowResizeType.REALTIME)
        {
            e.x = target.x;
            e.y = target.y;
            e.width = target.width;
            e.height = target.height;
        }
        else
        {
            e.x = regX + this.x;
            e.y = regY + this.y;
            e.width = width;
            e.height = height;
        }

        dispatchEvent(e);

        resetPosition();
    }

    /**
     *  @private
     *  Dispatches windowDragStart event.
     *  Dispatched event contains x and y coordinate data.
     *  When dragging starts, since there's no change in x and y values, we simply return target's corresponding
     *  values.
     *  After dispatching an event, we initialize window's position.
     */
    private function dispatchDragStartEvent():void
    {
        var e:MDIWindowDragEvent = new MDIWindowDragEvent(MDIWindowDragEvent.WINDOW_DRAG_START);
        e.x = target.x;
        e.y = target.y;
        dispatchEvent(e);

        resetPosition();
    }

    /**
     *  @private
     *  Dispatches windowDrag event.
     *  Dispatched event contains x and y coordinate values.
     *  Values for each of these data are assigned through correspondig parameter values passed on to this method.
     */
    private function dispatchDragEvent(x:Number, y:Number):void
    {
        var e:MDIWindowDragEvent = new MDIWindowDragEvent(MDIWindowDragEvent.WINDOW_DRAG);
        e.x = x;
        e.y = y;
        dispatchEvent(e);

        resetPosition();
    }

    /**
     *  @private
     *  Dispatches windowDragEnd event.
     *  Dispatched event contains x, y coordinate information.
     *  Values for this event's data are assigned through a call to calculateDragPosition() method.
     */
    private function dispatchDragEndEvent():void
    {
        var pt:Point = calculateDragPosition();

        var e:MDIWindowDragEvent = new MDIWindowDragEvent(MDIWindowDragEvent.WINDOW_DRAG_END);
        e.x = pt.x;
        e.y = pt.y;
        dispatchEvent(e);

        resetPosition();
    }

    //------------------------------------------------------------
    //
    //  Methods : Resize
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Starts resizing.
     */
    private function startResizing():void
    {
        if (!ResizeTool.isResizing && resizable)
        {
            // Since resizing is in progress, set isResizing flat to true.
            ResizeTool.isResizing = true;

            if (MDIWindow.resizeType != MDIWindowResizeType.REALTIME)
            {
                show();
                suspendBackgroundProcessing();
            }

            // Stores current values
            storePosition();

            // dispatches resizeStart event.
            dispatchResizeStartEvent();

            // add eventlistener to stage to handle resizing.
            addStageListener();
        }
    }

    /**
     *  @private
     *  Stops resizing
     */
    private function stopResizing():void
    {
        if (!ResizeTool.isResizing)
        {
            return;
        }

        // reset resize flag
        ResizeTool.isResizing = false;

        // remove stage's event listener.
        removeStageListener();

        if (MDIWindow.resizeType != MDIWindowResizeType.REALTIME)
        {
            hide();
            resumeBackgroundProcessing();
        }

        // adjust position
        //adjustPositionAtResizingEnd();

        // dispatches windowResizeEnd event.
        dispatchResizeEndEvent();
    }

    /**
     *  @private
     *  Adds event listeners to stage for mouseMove, mouseUp, mouseLeave events.
     *  mouseMove event's event listener is for implementing resize features.
     *  mouseUp, mouseLeave events' event listeners are for implementing AS 2's onReleaseOutside event-like
     *  functionality in ActionScript 3.
     */
    private function addStageListener():void
    {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
        stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
    }

    /**
     *  @private
     *  removes event listeners for mouseMove, mouseUp, mouseLeave events from stage.
     */
    private function removeStageListener():void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
        stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
    }

    /**
     *  @private
     *  Method that implements all the resizing logic.
     *
     *  Only invoked when mdi.boundsEnabled is true.
     *  Invoked whenever stage's mouseMove event occurs.
     */
    private function doResizing():void
    {
        // Calculates the values of xOffset and yOffset, which are the value of stage's mouseX and mouseY
        // substracting regStageMouseX and regStageMouseY, which represent stage's mouse position when
        // resiziting started.
        // x, y??offset.
        // If direction is either right or bottom and the the resulting values are positive,
        // width/height increases, otherwise width/height decreases.
        // There's no change in x, y coordniates.
        // If direction is either top or left and the resulting values are positive,
        // width/height decreases while x and y increases.
        // Otherwise, width/height increases while x and y decreases.

        var xOffset:Number = stage.mouseX - regStageMouseX;
        var yOffset:Number = stage.mouseY - regStageMouseY;

        // Sets offset only when mdi.allowResizeOverflow is false
        if (!mdi.allowResizeOverflow)
        {
            //--------------------
            //  x, y offset adjustment
            //--------------------

            // left
            if (_mouseState & SIDE_LEFT)
            {
                if (regLeft + xOffset < minLeft)
                {
                    xOffset = minLeft - regLeft;
                }
            }

            // right
            if (_mouseState & SIDE_RIGHT)
            {
                if (regRight + xOffset > maxRight)
                {
                    xOffset = maxRight - regRight;
                }
            }

            // top
            if (_mouseState & SIDE_TOP)
            {
                if (regTop + yOffset < minTop)
                {
                    yOffset = minTop - regTop;
                }
            }

            // bottom
            if (_mouseState & SIDE_BOTTOM)
            {
                if (regBottom + yOffset > maxHeight)
                {
                    yOffset = maxHeight - regBottom;
                }
            }
        }

        // new x and y position
        var newX:Number = regX;
        var newY:Number = regY;

        // new width and height
        var newWidth:Number = width;
        var newHeight:Number = height;

        //--------------------
        //  calculates new x, y, width and height
        //--------------------

        // left
        if (_mouseState & SIDE_LEFT)
        {
            newX = regX + xOffset > maxLeft ? maxLeft : regX + xOffset < minLeft ? minLeft : regX + xOffset;
            newWidth = regWidth - xOffset < minWidth ? minWidth : regWidth - xOffset > maxWidth ? maxWidth : regWidth - xOffset;
        }

        // right
        if (_mouseState & SIDE_RIGHT)
        {
            // The following is to implement  mdi.allowResizeOverflow logic
            //
            // As for right, since x position never changes, we don't need to assign newX.
            // Yet when window size is smaller than that of mdi and the window is not positioned at its left-most position,
            // and users are resizing window to the end of the mdi,
            // window size should increa towards its left side.
            // In other words, window should increase its size while decreasing its x position.
            //
            // 1. when total width (regWidth + xOffset) is greater than maxWidth, x is set to minLeft value.
            // 2. when right (regRight + xOffset) value is greater than maxRight,
            //    x is set to regX + (maxRight - (regRight + xOffset)).
            //    (difference between maxRight and right value)
            // 3. Otherwise, x is set to its original regX value.
            //
            // Values for remaining four directions have the same logic.

            newX = regWidth + xOffset > maxWidth ? minLeft : regRight + xOffset > maxRight ? regX + maxRight - (regRight + xOffset) : regX;
            newWidth = regWidth + xOffset < minWidth ? minWidth : regWidth + xOffset > maxWidth ? maxWidth : regWidth + xOffset;
        }

        // top
        if (_mouseState & SIDE_TOP)
        {
            newY = regY + yOffset > maxTop ? maxTop : regY + yOffset < minTop ? minTop : regY + yOffset;
            newHeight = regHeight - yOffset < minHeight ? minHeight : regHeight - yOffset > maxHeight ? maxHeight : regHeight - yOffset;
        }

        // bottom
        if (_mouseState & SIDE_BOTTOM)
        {
            newY = regHeight + yOffset > maxHeight ? minTop : regBottom + yOffset > maxHeight ? regY + maxBottom - (regBottom + yOffset) : regY;
            newHeight = regHeight + yOffset < minHeight ? minHeight : regHeight + yOffset > maxHeight ? maxHeight : regHeight + yOffset;
        }

        // assigns values
        if (MDIWindow.resizeType == MDIWindowResizeType.REALTIME)
        {
            dispatchResizeEvent(newX, newY, newWidth, newHeight);
            layoutChrome(newWidth, newHeight);
        }
        else
        {
            setPosition(newX - regX, newY - regY);
            layoutChrome(newWidth, newHeight);
        }
    }

    /**
     *  @private
     *  Method that practically implements resizing.
     *  Invoked only when mdi.boundsEnabled is false.
     *  There's no limitation when a window is resizing towoard right or bottom direction.
     */
    private function doResizingNoBounds():void
    {
        // x, y의 offset.
        var xOffset:Number = stage.mouseX - regStageMouseX;
        var yOffset:Number = stage.mouseY - regStageMouseY;

        // Assigns offset value only when mdi.allowResizeOverflow is false
        if (!mdi.allowResizeOverflow)
        {
            //--------------------
            //  x, y offset adjustment
            //--------------------

            // left
            if (_mouseState & SIDE_LEFT)
            {
                if (regLeft + xOffset < minLeft)
                {
                    xOffset = minLeft - regLeft;
                }
            }

            // top
            if (_mouseState & SIDE_TOP)
            {
                if (regTop + yOffset < minTop)
                {
                    yOffset = minTop - regTop;
                }
            }
        }

        // new x, y position
        var newX:Number = regX;
        var newY:Number = regY;

        // new width/height
        var newWidth:Number = width;
        var newHeight:Number = height;

        //--------------------
        //  calculates new x, y, width, height values
        //--------------------

        // left
        if (_mouseState & SIDE_LEFT)
        {
            newX = regX + xOffset > maxLeft ? maxLeft : regX + xOffset < minLeft ? minLeft : regX + xOffset;
            newWidth = regWidth - xOffset < minWidth ? minWidth : regWidth - xOffset;
        }

        // right
        if (_mouseState & SIDE_RIGHT)
        {
            newWidth = regWidth + xOffset < minWidth ? minWidth : regWidth + xOffset;
        }

        // top
        if (_mouseState & SIDE_TOP)
        {
            newY = regY + yOffset > maxTop ? maxTop : regY + yOffset < minTop ? minTop : regY + yOffset;
            newHeight = regHeight - yOffset < minHeight ? minHeight : regHeight - yOffset;
        }

        // bottom
        if (_mouseState & SIDE_BOTTOM)
        {
            newHeight = regHeight + yOffset < minHeight ? minHeight : regHeight + yOffset;
        }

        // assigns values
        if (MDIWindow.resizeType == MDIWindowResizeType.REALTIME)
        {
            dispatchResizeEvent(newX, newY, newWidth, newHeight);
            layoutChrome(newWidth, newHeight);
        }
        else
        {
            setPosition(newX - regX, newY - regY);
            layoutChrome(newWidth, newHeight);
        }
    }

    //------------------------------------------------------------
    //
    //  Methods : Drag
    //
    //------------------------------------------------------------

    /**
     *  Starts dragging.
     *  Called by an MDIWindow instance in an appropriate timing.
     *  (for example - when MDIWindow's titleBar has been pressed by a mouse pointer)
     *  Actually, dragging doesn't start automatically yet starts when stage's mouseMove
     *  event is actually dispatched
     *  This is so, to show window border not when mouseDown event occurs but when
     *  mouseMove event does occur.
     *  Or you might want to show border, say, in 3 seconds after a mouseDown event.
     */
    public function startDragging():void
    {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler_forStartDragging, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler_forDragging, false, 0, true);
        stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler_forDragging, false, 0, true);
    }

    /**
     *  @private
     *  Stops dragging.
     */
    private function stopDragging():void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler_forStartDragging);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler_forDragging);
        stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler_forDragging);

        // Escapes when dragging is not in progress
        // since we don't need to dispatch dragEnd event when not dragging.
        if (!ResizeTool.isDragging)
        {
            return;
        }

        ResizeTool.isDragging = false;

        // If in dragging state, removes relevant event handler method.
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler_forDragging);

        if (MDIWindow.moveType != MDIWindowMoveType.REALTIME)
        {
            hide();
            resumeBackgroundProcessing();
        }

        //adjustPosition();

        dispatchDragEndEvent();
    }

    /**
     *  @private
     *  Returns position value needed for dragging.
     */
    private function calculateDragPosition():Point
    {
        var xOffset:Number = stage.mouseX - regStageMouseX;
        var yOffset:Number = stage.mouseY - regStageMouseY;

        // new x, y position
        var newX:Number = regX + xOffset;
        var newY:Number = regY + yOffset;

        // restricted top, left, right, bottom dragging bounds. These boudns cannot
        // surpass MDI area.
        if (mdi.boundsEnabled)
        {
            if (newX > maxRight - this.width)
            {
                newX = maxRight - this.width;
            }

            if (newX < minLeft)
            {
                newX = minLeft;
            }

            if (newY > maxBottom - this.height)
            {
                newY = maxBottom - this.height;
            }

            if (newY < minTop)
            {
                newY = minTop;
            }
        }
        else
        {
            if (newX < minLeft)
            {
                newX = minLeft;
            }

            if (newY < minTop)
            {
                newY = minTop;
            }
        }

        return new Point(newX, newY);
    }

    //------------------------------------------------------------
    //
    //  Event Handlers
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Invoked when mouseMove event occurs.
     *  When mouse cursor is placed over the border and resizing is available
     *  while currently not no resizing is occurring, this event handler sets
     *  mouseState property values and show corresponding mouse cursor.
     */
    private function mouseMoveHandler(event:MouseEvent):void
    {
        if (!ResizeTool.isResizing &&
            !ResizeTool.isDragging &&
            resizable)
        {
            var xPosition:Number = mouseX;
            var yPosition:Number = mouseY;

            // bottom right
            if (xPosition > this.width - CORNER_OFFSET && yPosition > this.height - CORNER_OFFSET)
            {
                mouseState = SIDE_RIGHT | SIDE_BOTTOM;
            }
            // top left
            else if (xPosition < CORNER_OFFSET && yPosition < CORNER_OFFSET)
            {
                mouseState = SIDE_LEFT | SIDE_TOP;
            }
            // bottom left
            else if (xPosition < CORNER_OFFSET && yPosition > this.height - CORNER_OFFSET)
            {
                mouseState = SIDE_LEFT | SIDE_BOTTOM;
            }
            // top right
            else if (xPosition > this.width - CORNER_OFFSET && yPosition < CORNER_OFFSET)
            {
                mouseState = SIDE_RIGHT | SIDE_TOP;
            }
            // right
            else if (xPosition > this.width - _hitThickness)
            {
                mouseState = SIDE_RIGHT;
            }
            // left
            else if (xPosition < _hitThickness)
            {
                mouseState = SIDE_LEFT;
            }
            // bottom
            else if (yPosition > this.height - _hitThickness)
            {
                mouseState = SIDE_BOTTOM;
            }
            // top
            else if (yPosition < _hitThickness)
            {
                mouseState = SIDE_TOP;
            }
            // OUT
            else
            {
                removeCursor();
            }
        }
    }

    /**
     *  @private
     *  Restores the cursor when mouse moves out of the border.
     */
    private function mouseOutHandler(event:MouseEvent):void
    {
        // If resizing is not in progress yet resizing is still available, removes a cursor.
        // By "resizing is in progress", we mean either current window or other object is being resized.
        // In this case, we should not change cursor.
        if (!ResizeTool.isResizing && resizable)
        {
            removeCursor();
        }
    }

    /**
     *  @private
     *  When clicked on the border,
     *  we start resizing by storing current values and registering mouseMove
     *  event listener to stage.
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        startResizing();
    }

    /**
     *  @private
     *  When user releases the mouse over the border, we stop resizing.
     */
    private function mouseUpHandler(event:MouseEvent):void
    {
        stopResizing();
    }

    /**
     *  @private
     *  Invoked when stage's mouseMove event occurs.
     *  If resize is in progress, calls a relevant resizing method.
     */
    private function stage_mouseMoveHandler(event:MouseEvent):void
    {
        // If resize is in progress, calls a resizing method.
        if (ResizeTool.isResizing)
        {
            if (mdi.boundsEnabled)
            {
                doResizing();
            }
            else
            {
                doResizingNoBounds();
            }
        }
    }

    /**
     *  @private
     *  Invoked when stage's mouseUp event occurs.
     *  If the event phase is equal to or greater than 2, we call releaseOutsideHandler() method
     *  to implement onReleaseOutside() like functionality.
     */
    private function stage_mouseUpHandler(event:MouseEvent):void
    {
        if (event.eventPhase >= EventPhase.AT_TARGET /* 2 */)
        {
            releaseOutsideHandler();
        }
    }

    /**
     *  @private
     *  Invoked when stage's mouseLeave event occurs.
     *  If the event phase is equal to or greater than 2, we call releaseOutsideHandler() method
     *  to implement onReleaseOutside() like functionality.
     */
    private function stage_mouseLeaveHandler(event:Event):void
    {
        if (event.eventPhase >= EventPhase.AT_TARGET /* 2 */)
        {
            releaseOutsideHandler();
        }
    }

    /**
     *  @private
     *  Event handler method to implement releaseOutSide like functionality.
     *  Invoked when mouse moves out of the window or when other object dispatches a mouseUp event.
     *  Implemented to emulate AS2 version of onReleaseOutside feature.
     */
    private function releaseOutsideHandler():void
    {
        stopResizing();
        removeCursor();
    }

    /**
     *  @private
     *  Starts MDIWindow's dragging.
     *  Method that practically intiates actual dragging.
     */
    private function stage_mouseMoveHandler_forStartDragging(event:MouseEvent):void
    {
        // Since drag has started, we remove the event listener.
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler_forStartDragging);

        // If dragging is already in progress, just escape the method.
        // Since dragging state is stored in a static variable,
        //dragging could be intiated by current object or others.
        if (ResizeTool.isDragging)
        {
            return;
        }

        ResizeTool.isDragging = true;

        // If windowMoveType is not realtime, show border and
        // suspends background processing.
        if (MDIWindow.moveType != MDIWindowMoveType.REALTIME)
        {
            show();
            suspendBackgroundProcessing();
        }

        // stores current values.
        storePosition();

        stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler_forDragging, false, 0, true);

        // dispatch dragStart Event
        dispatchDragStartEvent();
    }

    /**
     *  @private
     *  Implements actual dragging logic.
     *  Activates draggins whenever stage's mouseMove event occurs.
     */
    private function stage_mouseMoveHandler_forDragging(event:MouseEvent):void
    {
        var pt:Point = calculateDragPosition();

        // if real time dragging is in progress,
        // dispatches windowDrag event.
        if (MDIWindow.moveType == MDIWindowMoveType.REALTIME)
        {
            dispatchDragEvent(pt.x, pt.y);
        }
        else
        {
            setPosition(pt.x - regX, pt.y - regY);
        }
    }

    /**
     *  @private
     *  Stops dragging.
     */
    private function stage_mouseUpHandler_forDragging(event:MouseEvent):void
    {
        stopDragging();
    }

    /**
     *  @private
     *  Stops dragging.
     */
    private function stage_mouseLeaveHandler_forDragging(event:Event):void
    {
        stopDragging();
    }
}

}
