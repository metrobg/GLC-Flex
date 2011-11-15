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

import flash.utils.getQualifiedClassName;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.core.UIComponent;
import mx.core.EventPriority;
import mx.core.mx_internal;
import mx.containers.Canvas;
import mx.events.IndexChangedEvent;

import org.openzet.containers.IMDI;
import org.openzet.containers.IMDIWindow;
import org.openzet.containers.MDIWindowState;
import org.openzet.containers.MDIWindowMoveType;
import org.openzet.containers.MDIWindowResizeType;
import org.openzet.containers.mdiClasses.MDILayout;
import org.openzet.containers.mdiClasses.MDIWindowData;
import org.openzet.core.openzet_internal;
import org.openzet.events.MDIEvent;
import org.openzet.events.MDIWindowEvent;
import org.openzet.events.MDIWindowDragEvent;
import org.openzet.events.MDIWindowResizeEvent;

use namespace mx_internal;
use namespace openzet_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	Dispatched when children's count surpasses maxChildren value. This event is usually triggered
 *  by the invccation of addChild() method. 
 *  @eventType org.openzet.events.MDIEvent.CHILDREN_FULL
 */
[Event(name="childrenFull", type="org.openzet.events.MDIEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the gap between windows when populating a new window.
 *
 *  @default 20
 */
[Style(name="windowGap", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's bottom border
 *  and the bottom of its content area.
 *
 *  @default 0
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border
 *  and the top of its content area.
 *
 *  @default 0
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the component's left border
 *  and the left edge of its content area.
 *
 *  @default 0
 */
[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the component's right border
 *  and the right edge of its content area.
 *
 *  @default 0
 */
[Style(name="paddingRight", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("MDI.png")]

/**
 *  MDI, short for Multiple Document Interface, provides features defined by a normal 
 *  MDI class, which are naturally supported by Flex framework. 
 *  Class groups for providing MDI features include MDI and MDIWindow classes and
 *  you can register children for these containers only the instances of classes 
 *  implementing IMDIWindow interface. 
 *  MDI provides features of aligning horizontally, vertically and cascadingly.
 *  MDIWindow provides features of maximizing, minimizing, restoring windows. 
 *
 *  @mxml
 *
 *  <p><code>&lt;zet:MDI&gt;</code> tag inherits all properties of its superclass and adds following properties.</p>
 *
 *  <pre>
 *  &lt;zet:MDI
 *   <strong>Properties</strong>
 *   maxChildren="10"
 *   sequenceAnimate="false|true"
 *   sequenceInterval="1"
 *   <strong>Styles</strong>
 *   windowGap="0"
 *   paddingTop="0"
 *   paddingRight="0"
 *   paddingBottom="0"
 *   paddingLeft="0"
 *   <strong>Events</strong>
 *   childrenFull="No default"
 *   minimizeAll="No default"
 *   resizeAll="No default"
 *   &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/zet:MDI&gt;
 *  </pre>
 *
 *  @includeExample MDIExample.mxml
 *
 *  @see org.openzet.containers.IMDI
 *  @see org.openzet.containers.MDIWindow
 */
public class MDI extends Canvas
    implements IMDI
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDI()
    {
        super();

        layoutObject = new MDILayout();
        layoutObject.target = this;

        _windowInfo = [];

        /*
        if (this is Container)
        {
            verticalScrollPolicy = horizontalScrollPolicy = "off";
            clipContent = true;
            autoLayout = false;
        }
        */

        addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
        addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE, childIndexChangeHandler);
    }

    /**
     *  @private
     */
    private function childIndexChangeHandler(event:IndexChangedEvent):void
    {
        // childIndexChange event is dispatched
        // whenever numChildren is greater than 1
        // Therefore, we don't need to check whether numChildren > 1 or not.

        // If new index is the top index, 
        if (event.newIndex == numChildren - 1)
        {
            setTopWindow(IMDIWindow(event.relatedObject));
        }
        // If previous index is the top index,
        else if (event.oldIndex == numChildren - 1)
        {
            // finds the top window and activates its focus
            highlightTopWindow();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
	 *  @private
	 */
	private var layoutObject:MDILayout;

    /**
     *  @private
     *  (feature to be implemented)
     *  Stores the last windowState value.
     *  Newly populated window's state is set based on the state of last window. 
     *  Possible values are <code>MDIWindowState.MAXIMIZED</code> and <code>MDIWindowState.NORMAL</code>.
     *
     *  @default "normal"
     */
    private var lastWindowState:String = MDIWindowState.NORMAL;

    /**
     *  @private
     *  Window at the top level.
     */
    private var _topWindow:IMDIWindow;

    //--------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  numChildren
    //----------------------------------

    [Bindable("childrenChanged")]

    /**
     *  @private
     *  To allow numChildren as a source for data binding,
     *  declaes childrenChanged event. 
     */
    override public function get numChildren():int
    {
        return super.numChildren;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  windowDefaultWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the windowDefaultWidth property.
     */
    private var _windowDefaultWidth:Number = 300;

    /**
     *  Window's default width.
     *  When a new window is instantiated, its width will be set
     *  based on this value. Also when windows are cascaded,
     *  all windows' width will be set using this value. 
     *
     *  @default 300
     */
    public function get windowDefaultWidth():Number
    {
        return _windowDefaultWidth;
    }

    /**
     *  @private
     */
    public function set windowDefaultWidth(value:Number):void
    {
        _windowDefaultWidth = value;
    }

    //----------------------------------
    //  windowDefaultHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the windowDefaultHeight property.
     */
    private var _windowDefaultHeight:Number = 200;

    /**
     *  Window's default height. 
     *  When a new window is instantiated, its height will be set
     *  using this value. Also when windows are cascaded,
     *  all windows' height will be set usting this value. 
     *
     *  @default 200
     */
    public function get windowDefaultHeight():Number
    {
        return _windowDefaultHeight;
    }

    /**
     *  @private
     */
    public function set windowDefaultHeight(value:Number):void
    {
        _windowDefaultHeight = value;
    }

    //----------------------------------
    //  windowMinWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the windowMinWidth property.
     */
    private var _windowMinWidth:Number = 140;

    /**
     *  window minimum width
     *
     *  @default 140
     */
    public function get windowMinWidth():Number
    {
        return _windowMinWidth;
    }

    /**
     *  @private
     */
    public function set windowMinWidth(value:Number):void
    {
        _windowMinWidth = value;
    }

    //----------------------------------
    //  windowMinHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the windowMinHeight property.
     */
    private var _windowMinHeight:Number = 28;

    /**
     *  window minimum height 
     *
     *  @default 28
     */
    public function get windowMinHeight():Number
    {
        return _windowMinHeight;
    }

    /**
     *  @private
     */
    public function set windowMinHeight(value:Number):void
    {
        _windowMinHeight = value;
    }

    //----------------------------------
    //  includeMinimizedWindowForAlign
    //----------------------------------

    /**
     *  @private
     *  Storage for the includeMinimizedWindowForAlign property.
     */
    private var _includeMinimizedWindowForAlign:Boolean = false;

    /**
     *  Flag that specifies whether to include minimzed windows when aligning windows.
     *  If set to true, when horizontalAlign(), verticalAlign(), cascade() methods are called, 
     *  minimized windows will also be aligned. Otherwise, minimized windows will not be aligned. 
     *
     *  @default false
     */
    public function get includeMinimizedWindowForAlign():Boolean
    {
        return _includeMinimizedWindowForAlign;
    }

    /**
     *  @private
     */
    public function set includeMinimizedWindowForAlign(value:Boolean):void
    {
        _includeMinimizedWindowForAlign = value;
    }

    //----------------------------------
    //  minimizedWindowAutoAlign
    //----------------------------------

    /**
     *  @private
     *  Storage for the minimizedWindowAutoAlign property.
     */
    private var _minimizedWindowAutoAlign:Boolean = false;

    /**
     *  Flag that specifies whether to auto-layout minimized windows. 
     *
     *  @default false
     */
    public function get minimizedWindowAutoAlign():Boolean
    {
        return _minimizedWindowAutoAlign;
    }

    /**
     *  @private
     */
    public function set minimizedWindowAutoAlign(value:Boolean):void
    {
        _minimizedWindowAutoAlign = value;
    }

    //----------------------------------
    //  boundsEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the boundsEnabled property.
     */
    private var _boundsEnabled:Boolean = true;

    /**
     *  Flag that specifies whether to set border when MDI instance's child is moving. 
     *  If set to true, a border is set, which defines the restricting bounds area.
     *
     *  @default true
     */
    public function get boundsEnabled():Boolean
    {
        return _boundsEnabled;
    }

    /**
     *  @private
     */
    public function set boundsEnabled(value:Boolean):void
    {
        if (value != _boundsEnabled)
        {
            _boundsEnabled = value;
        }
    }

    //----------------------------------
    //  allowResizeOverflow
    //----------------------------------

    /**
     *  @private
     *  Storage for the allowResizeOverflow property.
     */
    private var _allowResizeOverflow:Boolean = false;

    /**
     *  Flag that specifies whehter the other side increases its size when the opposite side reaches its limit 
     *  If true, the other side's size will increase when the opposite side cannot increase its size
     *  when it reached its bounds. 
     *
     *  @default true
     */
    public function get allowResizeOverflow():Boolean
    {
        return _allowResizeOverflow;
    }

    /**
     *  @private
     */
    public function set allowResizeOverflow(value:Boolean):void
    {
        _allowResizeOverflow = value;
    }

    //@@ As of Fri, 30th Jan, 2009 
    // Will be defined as styles 

    //--------------------------------------
    //  sequenceAnimate
    //--------------------------------------

    /**
     *  @private
     */
    private var _sequenceAnimate:Boolean = false;

    /**
     *  Flag that specifies whether to squentially animate windows, when aligning them. 
     */
    public function get sequenceAnimate():Boolean
    {
        return _sequenceAnimate;
    }

    /**
     *  @private
     */
    public function set sequenceAnimate(value:Boolean):void
    {
        _sequenceAnimate = value;
    }

    //@@ As of 20th, Jan 2009, 
    // Will be defined as styles. 

    //--------------------------------------
    //  sequenceInterval
    //--------------------------------------

    /**
     *  @private
     */
    public var _sequenceInterval:Number = 50;

    /**
     *  Effect interval when animating windows sequentially.
     */
    public function get sequenceInterval():Number
    {
        return _sequenceInterval;
    }

    /**
     *  @private
     */
    public function set sequenceInterval(value:Number):void
    {
        _sequenceInterval = value;
    }

    //----------------------------------
    //  maxChildren
    //----------------------------------

    /**
     *  @private
     */
    private var _maxChildren:int = 10;

    [Bindable("maxChildrenChanged")]
    [Inspectable(category="General", type="Number", defaultValue="10")]

    /**
     *  maximum number of children windows.
     *  If zero, unlimited number of children could be added. 
     *  @default 10
     */
    public function get maxChildren():int
    {
        return _maxChildren;
    }

    /**
     *  @private
     */
    public function set maxChildren(value:int):void
    {
        _maxChildren = value;
        dispatchEvent(new Event("maxChildrenChanged"));
    }

    //----------------------------------
    //  windowInfo
    //----------------------------------

    /**
     *  @private
     *  An array that holds reference to currently populated popups. 
     */
    private var _windowInfo:Array;

    /**
     *  @private
     *  windowInfo.
     */
    openzet_internal function get windowInfo():Array /* of MDIWindowData */
    {
        return _windowInfo;
    }

    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Overrides UIComponent's addChildAt() method. 
     *  If child is of IMDIWindow type, throws a runtime exception.
     */
    override public function addChildAt(child:DisplayObject, index:int):DisplayObject
    {
        var window:IMDIWindow = child as IMDIWindow;

        if (window)
        {
            // Checks the maximum children count that can be added.
            if (!checkNumChildren())
            {
                return null;
            }

            initWindow(window);

            super.addChildAt(child, index);

            // when setting a window at the top 
            if (index == numChildren - 1)
            {
                // sets focus in a new window
                setTopWindow(window);
            }

            return child;
        }
        else
        {
            throw new Error("MDI can only add children that implement IMDIWindow interface.");
        }
    }

    /**
     *  @private
     */
    override mx_internal function childRemoved(child:DisplayObject):void
    {
        super.childRemoved(child);

        destroyWindow(IMDIWindow(child));

        highlightTopWindow();
    }

    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Set a window at the top.
     *  The method simply manages reference to the top window and calls focusIn() and focusOut() method.
     *  As for setting child index, you need to implement your own logic. 
     *
     *  @param window child instance to put at the top level.
     */
    private function setTopWindow(window:IMDIWindow):void
    {
        if (_topWindow == window)
        {
            return;
        }

        if (_topWindow)
        {
            _topWindow.focusOut();
            //_topWindow.tabChildren = false;
            _topWindow = null;
        }

        if (window)
        {
            _topWindow = window;
            _topWindow.focusIn();
            //_topWindow.tabChildren = true;
            //setChildIndex(DisplayObject(_topWindow), numChildren - 1);
        }
    }

    /**
     *  @private
     *  Sets a window at the bottom level.
     */
    public function sendToBack(window:IMDIWindow):void
    {
        setChildIndex(DisplayObject(window), 0);
    }

    /**
     *  Activated windows should always have grater level than other objects stored in childList. 
     *  This method sets a window at the top level.
     *  If you click on any window, this method will be invoked automatically. Yet in other cases,
     *  you should manually call this method to dynamically adjust a window level. 
     *
     *  @param target MDIWindow to set at the top level
     *
     *  @param restore Flag to specify whehter to restore a window's size to its previous state
     */
    public function bringToFront(window:IMDIWindow, restore:Boolean = false):void
    {
        // When a window's state changes from minimized to normal or maximized
        // we put the window at the top level through the event handlers registered with corresponding events.
        // Therefore, when restoring to the previous state
        // (In this case, when users click on the taskbar or createWindow() method is invoked
        // with duplicate option set to false) 
        // we don't need to change child's index when changing a state from minimized to other state. 
        // Hence, we have needTop flag to check whether we really need to change child's index or not
        var needTop:Boolean = true;

        if (restore)
        {
            // When restoring a window
            // we call restore() method only when a window is in minimized state.
            if (window.windowState == MDIWindowState.MINIMIZED)
            {
                window.restore();
                needTop = false;
            }
        }

        if (needTop)
        {
            // If a window is already at the top, simply highlight the window
            if (getChildIndex(DisplayObject(window)) == numChildren - 1)
            {
                setTopWindow(window);
            }
            else
            {
                setChildIndex(DisplayObject(window), numChildren - 1);
            }
        }
    }

    /**
     *  @private
     *  Chckes the count of windows and verifies whether we can add more windows
     */
    openzet_internal function checkNumChildren():Boolean
    {
        if (isFull())
        {
            dispatchEvent(new MDIEvent(MDIEvent.CHILDREN_FULL));
            return false;
        }

        return true;
    }

    /**
     *  @private
     *  Returns the count of windows has already reached its limit or not
     */
    openzet_internal function isFull():Boolean
    {
        return _maxChildren != 0 && numChildren >= _maxChildren;
    }

    /**
     *  Initializes MDIWindow instance
     *  This method is invoked before addChild() method is called.
     *
     *  @param window IMDIWindow instance to add as a child
     */
    protected function initWindow(window:IMDIWindow):void
    {
        // Set mdi reference.
        window.mdi = this;
        window.width = windowDefaultWidth;
        window.height = windowDefaultHeight;

        if (initialized)
        {
            layoutObject.setWindowPosition(window);
        }

        window.addEventListener(MDIWindowEvent.CLOSE, window_closeHandler, false, EventPriority.DEFAULT_HANDLER, true);
        window.addEventListener(MDIWindowEvent.MAXIMIZE, window_maximizeHandler, false, EventPriority.DEFAULT_HANDLER, true);
        window.addEventListener(MDIWindowEvent.MINIMIZE, window_minimizeHandler, false, EventPriority.DEFAULT_HANDLER, true);
        window.addEventListener(MDIWindowEvent.RESTORE, window_restoreHandler, false, EventPriority.DEFAULT_HANDLER, true);
        window.addEventListener(MDIWindowDragEvent.WINDOW_DRAG_END, window_dragEndHandler, false, EventPriority.DEFAULT_HANDLER, true);
        window.addEventListener(MouseEvent.MOUSE_DOWN, window_mouseDownHandler, false, EventPriority.DEFAULT_HANDLER, true);

        // Add MDIWindowData.
        var windowData:MDIWindowData = new MDIWindowData();
        windowData.owner = window;
        windowData.x = 0;
        windowData.y = 0;
        windowData.width = window.getExplicitOrMeasuredWidth();
        windowData.height = window.getExplicitOrMeasuredHeight();

        _windowInfo.push(windowData);
    }

    /**
     *  @private
     *  Stores window information.
     */
    private function storeWindowPositionAndSize(window:IMDIWindow):void
    {
        var windowData:MDIWindowData = findMDIWindowDataByOwner(window);

        windowData.x = window.x;
        windowData.y = window.y;
        windowData.width = window.width;
        windowData.height = window.height;
    }

    /**
     *  Populates a new window in MDI 
     *
     *  <p><b>Example</b></p>
     *
     *  <pre>var window:IMDIWindow = mdi.createPopUp(Window);
     *    window.title = "My Title";</pre>
     *
     *  @param className Class name of a window to populate
     *
     *  @param duplicate Flag to specify whether to allow duplication of newly created windows. If false,
     *  when attempting to create a duplicate window, new instance will by replaced by a previously instanced one. 
     *  Otherwise, every time a new instance will be created.
     *
     *  @param initObject Object parameter that holds initial values for a new window instance. You store
     *  whatever values to pass on to a newly created window in this parameter. 
     */
    public function createWindow(className:Class,
                                 duplicate:Boolean = true,
                                 initObject:Object = null):IMDIWindow
    {
        var window:IMDIWindow;
        var exist:Boolean = false;

        // If no duplicate windows are allowed, checks whehter there exists a instance with same class type.
        if (!duplicate)
        {
            var windowData:MDIWindowData = findMDIWindowDataByClass(className);

            if (windowData)
            {
                window = windowData.owner;
                exist = true;
            }
        }

        // If no instance of that class exists
        if (!window)
        {
            // Checks maximum number of children to be added 
            if (!checkNumChildren())
            {
                return null;
            }

            window = new className();
        }

        // If initial object exists, we assign its values to a new window.
        if (initObject)
        {
            for (var propName:String in initObject)
            {
                window[propName] = initObject[propName];
            }
        }

        if (exist)
        {
            bringToFront(window, true);
        }
        else
        {
            addChild(DisplayObject(window));
        }

        return window;
    }

    /**
     *  @private
     *  When removing windows added by addChild() method.
     *  Removes references to the window instance. 
     *
     *  @param window Child to remove
     */
    private function destroyWindow(window:IMDIWindow):void
    {
        window.destroy();

        window.removeEventListener(MDIWindowEvent.CLOSE, window_closeHandler);
        window.removeEventListener(MDIWindowEvent.MAXIMIZE, window_maximizeHandler);
        window.removeEventListener(MDIWindowEvent.MINIMIZE, window_minimizeHandler);
        window.removeEventListener(MDIWindowEvent.RESTORE, window_restoreHandler);
        window.removeEventListener(MDIWindowDragEvent.WINDOW_DRAG_END, window_dragEndHandler);
        window.removeEventListener(MouseEvent.MOUSE_DOWN, window_mouseDownHandler);

        // Delete MDIWindowData element from windowInfo.
        var windowData:MDIWindowData = findMDIWindowDataByOwner(window);

        if (windowData)
        {
            _windowInfo.splice(_windowInfo.indexOf(windowData), 1);
            windowData = null;
        }

        window = null;
    }

    /**
     *  @private
     *  Retrieves MIDWindowData and returns it using owner property. 
     *  If the corresponding data exists, returns it. Otherwise, returns null.
     *
     *  @param owner IMDIWindow instance to retrieve 
     */
    openzet_internal function findMDIWindowDataByOwner(owner:IMDIWindow):MDIWindowData
    {
        var i:int;
        var n:int = _windowInfo.length;

        for (i = 0; i < n; i++)
        {
            var windowData:MDIWindowData = _windowInfo[i];

            if (windowData.owner == owner)
            {
                return windowData;
            }
        }

        return null;
    }

    /**
     *  @private
     *  Retrieves MDIWindowData using Class's type.
     *  Returns the correponding data if exits. Otherwise, returns null.
     *
     *  @param clazz Class to refer to.
     */
    private function findMDIWindowDataByClass(clazz:Class):MDIWindowData
    {
        var className:String = getQualifiedClassName(clazz);

        var i:int;
        var n:int = _windowInfo.length;

        for (i = 0; i < n; i++)
        {
            var windowData:MDIWindowData = _windowInfo[i];

            if (getQualifiedClassName(windowData.owner) == className)
            {
                return windowData;
            }
        }

        return null;
    }

    /**
     *  @private
     *  Maximizes a window
     *
     *  @param window IMDIWindow instance to maximize 
     */
    private function maximizeWindow(window:IMDIWindow):void
    {
        var paddingTop:Number = getStyle("paddingTop");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingBottom:Number = getStyle("paddingBottom");
        var paddingLeft:Number = getStyle("paddingLeft");

        window.setPosition(paddingLeft, paddingTop);
        window.setSize(width - paddingLeft - paddingRight,
                       height - paddingTop - paddingBottom);
    }

    /**
     *  @private
     *  Hightlight the window at the top.
     *  Highlight windows that are not mimized. 
     *  In case all windows are in minimized state, simply dispatches MDIEvent.MINIMIZE_ALL event.
     */
    private function highlightTopWindow():void
    {
        var topWindow:IMDIWindow = findTopWindowNotMinimized();

        if (topWindow)
        {
            setTopWindow(topWindow);
        }
        else
        {
            setTopWindow(null);
            dispatchEvent(new MDIEvent(MDIEvent.MINIMIZE_ALL));
        }
    }

    /**
     *  @private
     *  Returns the window at the top, that is not minimized. 
     */
    private function findTopWindowNotMinimized():IMDIWindow
    {
        var topWindow:IMDIWindow;
        var children:Array = getChildren();

        // Checkes with every window in the reverse child index order.
        var i:int;
        var n:int = children.length - 1;

        for (i = n; i >= 0; i--)
        {
            var child:IMDIWindow = IMDIWindow(children[i]);

            if (child.windowState != MDIWindowState.MINIMIZED)
            {
                topWindow = child;
                break;
            }
        }

        return topWindow;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods : Child Layout
    //
    //--------------------------------------------------------------------------

    /**
     *  Cascades all windows. 
     *  Uses windows' childIndexes in an ascending order.
     */
    public function cascade():void
    {
        layoutObject.cascade(sequenceAnimate, sequenceInterval);
    }

    /**
     *  Aligns all windows horizontally.
     *  Uses windows' child indexes in a descending order.
     */
    public function horizontalAlign():void
    {
        layoutObject.alignWindows("horizontal", sequenceAnimate, sequenceInterval);
    }

    /**
     *  Aligns all windows vertically.
     *  Uses windows' child indexes in a descending order.
     */
    public function verticalAlign():void
    {
        layoutObject.alignWindows("vertical", sequenceAnimate, sequenceInterval);
    }

    /**
     *  Randomizes all windows' position and size.
     *  Uses windows' child indexes in an ascending order.
     */
    public function random():void
    {
        layoutObject.random(sequenceAnimate, sequenceInterval);
    }

    /**
     *  Minimizes all windows. 
     *  Uses windows' created order.
     */
    public function minimizeAll():void
    {
        layoutObject.minimizeAll(sequenceAnimate, sequenceInterval);
        dispatchEvent(new MDIEvent(MDIEvent.MINIMIZE_ALL));
    }

    /**
     *  Restores all windows to their previous size.
     *  Uses windows' created order.
     */
    public function restoreAll():void
    {
        layoutObject.restoreAll(sequenceAnimate, sequenceInterval);
        dispatchEvent(new MDIEvent(MDIEvent.RESTORE_ALL));
    }

    //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  When a window is clicked on, it is sent to the top level in the display list.
     */
    private function window_mouseDownHandler(event:MouseEvent):void
    {
        bringToFront(IMDIWindow(event.currentTarget));
    }

    /**
     *  @private
     *  Closes a window when close event is dispatched. 
     */
    protected function window_closeHandler(event:MDIWindowEvent):void
    {
        removeChild(DisplayObject(event.currentTarget));
    }

    /**
     *  @private
     *  Stores current state and changes size when maximize event is dispatched.
     */
    protected function window_maximizeHandler(event:MDIWindowEvent):void
    {
        lastWindowState = MDIWindowState.MAXIMIZED;

        var window:IMDIWindow = IMDIWindow(event.target);

        if (event.oldWindowState == MDIWindowState.NORMAL)
        {
            storeWindowPositionAndSize(window);
        }

        maximizeWindow(window);

        // maximize() method doesn't bring a window to the top.
        //bringToFront(window);
    }

    /**
     *  @private
     *  Restores a window to its previous position and size when restore event is dispatched. 
     */
    protected function window_restoreHandler(event:MDIWindowEvent):void
    {
        lastWindowState = MDIWindowState.NORMAL;

        var window:IMDIWindow = IMDIWindow(event.target);

        //if (UIComponent(window).initialized)
        {
            var windowData:MDIWindowData = findMDIWindowDataByOwner(window);

            window.setPosition(windowData.x, windowData.y);
            window.setSize(windowData.width, windowData.height);

            // Brings a window to the top when restore event is disptached.
            bringToFront(window);
        }
    }

    /**
     *  @private
     *  Stores current window's state and changes its size when minimize event is dispatched.
     */
    protected function window_minimizeHandler(event:MDIWindowEvent):void
    {
        var window:IMDIWindow = IMDIWindow(event.target);

        if (event.oldWindowState == MDIWindowState.NORMAL)
        {
            storeWindowPositionAndSize(window);
        }

        var windowData:MDIWindowData = findMDIWindowDataByOwner(window);

        layoutObject.setMinimizeWindowPosition(windowData);

        // If childIndex changes due to this method
    	// and if the child is not at the top level,
    	// we don't need to hight the window with greated depth.    
    	// So here we don't call highlightTopWindow() method.
    	// childIndexChangeHandler() event handler will take care of this higlighting.
        //
        // If child count is equal to or greater than 2 and current window is at the top,
        // if the window moves down to the bottom, childIndexChange will be dispatched and
        // trigger setTopWindow() method automatically.
        // Yet when there's only one child, since childIndexChange event wouldn't occur,
        // we need to manually call setTopWindow(null) method.
        if (numChildren > 1)
        {
            sendToBack(window);
        }
        else
        {
            setTopWindow(null);
        }
    }

    /**
     *  @private
     *  Stores window's state when dragEnd event is dispatched in its minimized state.
     */
    private function window_dragEndHandler(event:MDIWindowDragEvent):void
    {
        var window:IMDIWindow = IMDIWindow(event.target);

        if (window.windowState == MDIWindowState.MINIMIZED)
        {
            var windowData:MDIWindowData = findMDIWindowDataByOwner(window);
            windowData.draggedMinWindow = true;
            windowData.minX = window.x;
            windowData.minY = window.y;
        }
    }

    /**
     *  @private
     *  When a MDI instance is resized, other instance in maximized state should also change its size correspondingly.
     */
    protected function resizeHandler(event:Event):void
    {
        var windowData:MDIWindowData;

        var i:int;
        var n:int = _windowInfo.length;

        for (i = 0; i < n; i++)
        {
            windowData = _windowInfo[i];

            if (windowData.owner.windowState == MDIWindowState.MAXIMIZED)
            {
                maximizeWindow(windowData.owner);
            }
        }
    }

    /**
     *  @private
     *  When an MDI is clicked on, we remove hightlight from an already highlighted MDI instance. 
     *  Checks whehter the target is this or not.
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        if (event.target == this)
        {
            setTopWindow(null);
        }
    }
}   // end class

}   // end package
