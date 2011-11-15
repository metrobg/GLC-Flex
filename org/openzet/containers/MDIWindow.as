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

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.getQualifiedClassName;

import mx.automation.IAutomationObject;
import mx.containers.Panel;
import mx.containers.ControlBar;
import mx.controls.Button;
import mx.controls.Label;
import mx.core.IUIComponent;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.FlexSprite;
import mx.core.UITextField;
import mx.core.IUITextField;
import mx.core.EdgeMetrics;
import mx.core.mx_internal;
import mx.effects.Blur;
import mx.effects.Rotate;
import mx.effects.Parallel;
import mx.effects.Resize;
import mx.effects.Move;
import mx.events.FlexMouseEvent;
import mx.events.FlexEvent;
import mx.events.EffectEvent;
import mx.managers.ISystemManager;
import mx.styles.ISimpleStyleClient;

import org.openzet.containers.IMDI;
import org.openzet.containers.IMDIWindow;
import org.openzet.containers.MDIWindowResizeType;
import org.openzet.containers.MDIWindowMoveType;
import org.openzet.containers.MDIWindowState;
import org.openzet.containers.mdiClasses.ResizeTool;
import org.openzet.core.openzet_internal;
import org.openzet.events.MDIWindowEvent;
import org.openzet.events.MDIWindowResizeEvent;
import org.openzet.events.MDIWindowDragEvent;

use namespace mx_internal;
use namespace openzet_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user presses the Enter key.
 *
 *  @eventType mx.events.FlexEvent.ENTER
 */
[Event(name="enter", type="mx.events.FlexEvent")]

/**
 *  Dispatched when close() method is invoked or close button is clicked on.
 *
 *  @eventType org.openzet.events.MDIWindowEvent.CLOSE
 */
[Event(name="close", type="org.openzet.events.MDIWindowEvent")]

/**
 *  Dispatched when maximize() method is invoekd or maximize button is clicked on.
 *
 *  @eventType org.openzet.events.MDIWindowEvent.MAXIMIZE
 */
[Event(name="maximize", type="org.openzet.events.MDIWindowEvent")]

/**
 *  Dispatched when minimize() method is invoked or minimize button is clicked on.
 *
 *  @eventType org.openzet.events.MDIWindowEvent.MINIMIZE
 */
[Event(name="minimize", type="org.openzet.events.MDIWindowEvent")]

/**
 *  Dispatched when restore() method is invoked or restore button is clicked on.
 *
 *  @eventType org.openzet.events.MDIWindowEvent.RESTORE
 */
[Event(name="restore", type="org.openzet.events.MDIWindowEvent")]

/**
 *  Dispatched while dragging is in progress.
 *
 *  @eventType org.openzet.events.MDIWindowDragEvent.WINDOW_DRAG
 */
[Event(name="windowDrag", type="org.openzet.events.MDIWindowDragEvent")]

/**
 *  Dispatched when dragging starts.
 *
 *  @eventType org.openzet.events.MDIWindowDragEvent.WINDOW_DRAG_START
 */
[Event(name="windowDragStart", type="org.openzet.events.MDIWindowDragEvent")]

/**
 *  Disptached when dragging is complete. 
 *
 *  @eventType org.openzet.events.MDIWindowDragEvent.WINDOW_DRAG_END
 */
[Event(name="windowDragEnd", type="org.openzet.events.MDIWindowDragEvent")]

/**
 *  Dispatched when resizing is in progress. 
 *
 *  @eventType org.openzet.events.MDIWindowResizeEvent.WINDOW_RESIZE
 */
[Event(name="windowResize", type="org.openzet.events.MDIWindowResizeEvent")]

/**
 *  Dispatched when resizing starts. 
 *
 *  @eventType org.openzet.events.MDIWindowResizeEvent.WINDOW_RESIZE_START
 */
[Event(name="windowResizeStart", type="org.openzet.events.MDIWindowResizeEvent")]

/**
 *  Dispatched when resizing completes. 
 *
 *  @eventType org.openzet.events.MDIWindowResizeEvent.WINDOW_RESIZE_END
 */
[Event(name="windowResizeEnd", type="org.openzet.events.MDIWindowResizeEvent")]

//----------------------------------------
//  Styles
//----------------------------------------

/**
 *  Style for color opacity when suspend() is called and the background processing is halted. 
 *  <code>suspendTransparency</code> value could vary from 0.0 (trasparent) to 1.0 (intransparent). 
 *  For color, we should set <code>suspendTransparencyColor</code> style.
 *
 *  @default 0.5
 */
[Style(name="suspendTransparency", type="Number", inherit="no")]

/**
 *  Style for blur value to apply when the screen is blocked by a call to suspend() method. 
 *
 *  @see flash.filters.BlurFilter
 *
 *  @default 3
 */
[Style(name="suspendTransparencyBlur", type="Number", inherit="no")]

/**
 *  Style for the color value to paint the screen with when the screen is blocked by a call to suspend() method.
 *
 *  @default #DDDDDD
 */
[Style(name="suspendTransparencyColor", type="uint", format="Color", inherit="no")]

/**
 *  Style for duration of suspending effect in milliseconds when suspend() is called. 
 *
 *  @default 100
 */
[Style(name="suspendTransparencyDuration", type="Number", format="Time", inherit="no")]

/**
 *  Style for an icon to show when suspend() method is called. 
 *
 *  @default org.openzet.skins.halo.BusyCursor
 */
[Style(name="suspendIcon", type="Class", inherit="no")]

/**
 *  Stylename for a titleBar button.
 *
 *  @default "titleBarButtonStyle"
 */
[Style(name="titleBarButtonStyleName", type="String", inherit="no")]

/**
 *  Stylename for controlBar'ss info TextField
 *
 *  @default "mdiWindowTitleStyle"
 */
[Style(name="infoStyleName", type="String", inherit="no")]

/**
 *  minimize button style.
 *
 *  @default the "MinButtonDisabled" symbol in the Assets.swf file.
 */
[Style(name="minButtonDisabledSkin", type="Class", inherit="no")]

/**
 *  The minimize button down skin.
 *
 *  @default the "MinButtonDown" symbol in the Assets.swf file.
 */
[Style(name="minButtonDownSkin", type="Class", inherit="no")]

/**
 *  The minimize button over skin.
 *
 *  @default the "MinButtonOver" symbol in the Assets.swf file.
 */
[Style(name="minButtonOverSkin", type="Class", inherit="no")]

/**
 *  The minimize button up skin.
 *
 *  @default the "MinButtonUp" symbol in the Assets.swf file.
 */
[Style(name="minButtonUpSkin", type="Class", inherit="no")]

/**
 *  The maximize button disabled skin.
 *
 *  @default the "MaxButtonDisabled" symbol in the Assets.swf file.
 */
[Style(name="maxButtonDisabledSkin", type="Class", inherit="no")]

/**
 *  The maximize button down skin.
 *
 *  @default the "MaxButtonDown" symbol in the Assets.swf file.
 */
[Style(name="maxButtonDownSkin", type="Class", inherit="no")]

/**
 *  The maximize button over skin.
 *
 *  @default the "MaxButtonOver" symbol in the Assets.swf file.
 */
[Style(name="maxButtonOverSkin", type="Class", inherit="no")]

/**
 *  The maximize button up skin.
 *
 *  @default the "MaxButtonDisabled" symbol in the Assets.swf file.
 */
[Style(name="maxButtonUpSkin", type="Class", inherit="no")]

/**
 *  The restore button disabled skin.
 *
 *  @default the "restoreButtonDisabled" symbol in the Assets.swf file.
 */
[Style(name="restoreButtonDisabledSkin", type="Class", inherit="no")]

/**
 *  The restore button down skin.
 *
 *  @default the "restoreButtonDown" symbol in the Assets.swf file.
 */
[Style(name="restoreButtonDownSkin", type="Class", inherit="no")]

/**
 *  The restore button over skin.
 *
 *  @default the "restoreButtonOver" symbol in the Assets.swf file.
 */
[Style(name="restoreButtonOverSkin", type="Class", inherit="no")]

/**
 *  The restore button up skin.
 *
 *  @default the "restoreButtonUp" symbol in the Assets.swf file.
 */
[Style(name="restoreButtonUpSkin", type="Class", inherit="no")]

/**
 *  Border alpha for edge when resizing.
 *
 *  @default 1
 */
[Style(name="resizeBorderAlpha", type="Number", format="Number", inherit="no")]

/**
 *  Border thickness for edge when resizing.
 *
 *  @default 4
 */
[Style(name="resizeBorderThickness", type="Number", format="length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

/**
 *  @private
 *  Excludes borderStyle and borderThickness from styles
 *  borderStyle is always set to "window" and borderThickness to "2".
 */
[Exclude(name="borderThickness", kind="style")]
[Exclude(name="borderStyle", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("MDIWindow.png")]

/**
 *  MDIWindow container implements IMDIWindow interface and comprises
 *  titleBar, caption, status bar, border and child content area. 
 *  Normally, MDIWindow instances are used as children of MDI containers and provide
 *  built-in support for minimize, maximize and close buttons. 
 *
 *  @mxml
 *
 *  <p><code>&lt;zet:MDIWindow&gt;</code> tag inherits all properties of its superclass on top of following properties.</p>
 *
 *  <pre>
 *  &lt;zet:MDIWindow
 *   <strong>Properties</strong>
 *   info=""
 *   showMaxButton="false|true"
 *   showMinButton="false|true"
 *   showCloseButton="false|true"
 *   windowState="normal|maximized|minimized"
 *   resizeType
 *   moveType
 *   allowRotate
 *
 *   <strong>Styles</strong>
 *   infoStyleName="mdiWindowInfoStyle"
 *   maxButtonDisabledSkin="<i>'MaxButtonDisabled' symbol in Assets.swf</i>"
 *   maxButtonDownSkin="<i>'MaxButtonDown' symbol in Assets.swf</i>"
 *   maxButtonOverSkin="<i>'MaxButtonOver' symbol in Assets.swf</i>"
 *   maxButtonUpSkin="<i>'MaxButtonUp' symbol in Assets.swf</i>"
 *   minButtonDisabledSkin="<i>'MinButtonDisabled' symbol in Assets.swf</i>"
 *   minButtonDownSkin="<i>'MinButtonDown' symbol in Assets.swf</i>"
 *   minButtonOverSkin="<i>'MinButtonOver' symbol in Assets.swf</i>"
 *   minButtonUpSkin="<i>'MinButtonUp' symbol in Assets.swf</i>"
 *   restoreButtonDisabledSkin="<i>'RestoreButtonDisabled' symbol in Assets.swf</i>"
 *   restoreButtonDownSkin="<i>'RestoreButtonDown' symbol in Assets.swf</i>"
 *   restoreButtonOverSkin="<i>'RestoreButtonOver' symbol in Assets.swf</i>"
 *   restoreButtonUpSkin="<i>'RestoreButtonUp' symbol in Assets.swf</i>"
 *   closeButtonDisabledSkin="<i>'CloseButtonDisabled' symbol in Assets.swf</i>"
 *   closeButtonDownSkin="<i>'CloseButtonDown' symbol in Assets.swf</i>"
 *   closeButtonOverSkin="<i>'CloseButtonOver' symbol in Assets.swf</i>"
 *   closeButtonUpSkin="<i>'CloseButtonUp' symbol in Assets.swf</i>"
 *
 *   <strong>Events</strong>
 *   close="No default"
 *   minimize="No default"
 *   maximize="No default"
 *   restore="No default"
 *   &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/zet:MDIWindow&gt;
 *  </pre>
 *
 *  @includeExample MDIExample.mxml
 *
 *  @see org.openzet.containers.MDI
 *  @see mx.containers.Panel
 */
public class MDIWindow extends Panel
    implements IMDIWindow
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function MDIWindow()
    {
        super();

        // A component can use its superclass's keyDownHandler() method when it
        // implements IFocusManagerComponent interface. 
        // For this cause, we add keyDown event listener to handle enter event.
        addEventListener(KeyboardEvent.KEY_DOWN, window_keyDownHandler, false, 0, true);

        focusOut();

        windowState = MDIWindowState.NORMAL;
    }

    //--------------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------------

    //----------------------------------
    //  deafultButtonSize
    //----------------------------------

    /**
     *  @private
     *  Default size for close, maximize, minimize buttons.
     */
    openzet_internal static const DEFAULT_BUTTON_SIZE:Number = 16;

    //----------------------------------
    //  defaultButtonGap
    //----------------------------------

    /**
     *  @private
     *  Gap between buttons. This property should be declared as a style, later on. 
     */
    openzet_internal static const DEFAULT_BUTTON_GAP:Number = 0; //1;

    /**
     *  @private
     *  Default alpha. Used when restoring alpha value after dragging completes. 
     *
     *  @default 1
     */
    private static const ORIGINAL_ALPHA:Number = 1;

    //--------------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------------

    //----------------------------------
    //  moveType
    //----------------------------------

    /**
     *  Specifies move type.
     *  Possible values include <code>MDIWindowMoveType.NONE</code>, <code>MDIWindowMoveType.REALTIME</code>,
     *  <code>MDIWindowMoveType.ANIMATED</code> etc.
     *
     *  @see org.openzet.containers.MDIWindowMoveType
     *
     *  @default WindowMoveType.NONE
     */
    public static var moveType:String = MDIWindowMoveType.NONE;

    //----------------------------------
    //  resizeType
    //----------------------------------

    /**
     *  Specifie resize type.
     *  Possible values include <code>MDIWindowResizeType.NONE</code>, <code>MDIWindowResizeType.REALTIME</code>,
     *  <code>MDIWindowResizeType.ANIMATED</code> etc.
     *
     *  @see org.openzet.containers.MDIWindowResizeType
     *
     *  @default MDIWindowResizeType.NONE
     */
    public static var resizeType:String = MDIWindowResizeType.NONE;

    //----------------------------------
    //  dragAlphaEnabled
    //----------------------------------

    /**
     *  Specifies whether to apply transparency to a windw when dragging it. 
     *  If true, the widow will have its transparency value based on dragAlpha property when dragged.
     *  This property only apples when <code>MDIWindow.moveType</code> is  <code>MDIWindowMoveType.REALTIME</code>.
     *
     *  @default false
     */
    public static var dragAlphaEnabled:Boolean = false;

    //----------------------------------
    //  dragAlpha
    //----------------------------------

    /**
     *  Alpha value for a dragged window. 
     *  This value could vary from 0.0 to 1.0 
     *  Applies only when <code>dragAlphaEnabled</code> is true. 
     *
     *  @default 0.4
     */
    public static var dragAlpha:Number = 0.4;

    //--------------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  suspend count. The count of calls on suspend() and resume() method.
     */
    private var suspendCount:int = 0;

    /**
     *  @private
     *  Internal Move, Resize, Rotate effect instances
     */
    private var moveEffect:Move;
    private var resizeEffect:Resize;
    private var rotateEffect:Rotate;

    /**
     *  @private
     *  Sprite used to block user input when the container being loaded.
     */
    openzet_internal var suspendBlocker:FlexSprite;

    /**
     *  @private
     *  Blur object used when suspend() method is called. 
     */
    private var blur:Blur;

    /**
     *  @private
     *  window resize manager instance
     */
    private var resizer:ResizeTool;

    /**
     *  @private
     *  maximize button.
     */
    openzet_internal var maxButton:Button;

    /**
     *  @private
     *  minimize button.
     */
    openzet_internal var minButton:Button;

    /**
     *  @private
     *  Status textfield that show window status at the bottom
     */
    openzet_internal var infoTextField:UITextField;

    //--------------------------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //--------------------------------------------------------------------------------

    //--------------------------------------
    //  enabled
    //--------------------------------------

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        super.enabled = value;

        if (closeButton)
        {
            closeButton.enabled = value;
        }

        if (maxButton)
        {
            maxButton.enabled = value;
        }

        if (minButton)
        {
            minButton.enabled = value;
        }
    }

    //--------------------------------------
    //  title
    //--------------------------------------

    /**
     *  @private
     */
    override public function set title(value:String):void
    {
        super.title = value;
        label = value;
    }

    //--------------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------------

    //----------------------------------
    //  mdi
    //----------------------------------

    /**
     *  @private
     *  Storage for the mdi property.
     */
    private var _mdi:IMDI;

    /**
     *  Reference to the parent container of IMDI type. 
     */
    public function get mdi():IMDI
    {
        return _mdi;
    }

    /**
     *  @private
     */
    public function set mdi(value:IMDI):void
    {
        _mdi = value;
    }

    //----------------------------------
    //  draggable
    //----------------------------------

    /**
     *  @private
     */
    private var _draggable:Boolean = true;

    /**
     *  Flag to specify whether dragging is enabled.
     *  Even if set to true, if <code>windowState</code> is <code>maximized</code>,
     *  this getter method will return false. 
     */
    public function get draggable():Boolean
    {
        return _draggable && _windowState != MDIWindowState.MAXIMIZED;
    }

    /**
     *  @private
     */
    public function set draggable(value:Boolean):void
    {
        _draggable = value;
    }

    //----------------------------------
    //  resizable
    //----------------------------------

    /**
     *  @private
     */
    private var _resizable:Boolean = true;

    /**
     *  Flag to specify whether resizing is enabled. 
     *  Even if set to true, if <code>windowState</code> is not normal, 
     *  this getter method will return false. 
     */
    public function get resizable():Boolean
    {
        return _resizable && _windowState == MDIWindowState.NORMAL;
    }

    /**
     *  @private
     */
    public function set resizable(value:Boolean):void
    {
        _resizable = value;

        if (_resizable)
        {
            resizer.borderThickness = 4;
        }
        else
        {
            resizer.borderThickness = 1;
        }
    }

    //----------------------------------
    //  contentEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the contentEnabled property.
     */
    private var _contentEnabled:Boolean = true;

    [Bindable("contentEnabledChanged")]

    /**
     *  @private
     *  Flag to specify whether contentPane is enabled or not. 
     *  This property is set when suspend() or resume() method is called.
     *  If set to true, you can access child content area, otherwise a blocking Sprite instance will be instantiated and 
     *  show an icon indicating suspended status.
     */
    private function get contentEnabled():Boolean
    {
        return _contentEnabled;
    }

    /**
     *  @private
     */
    private function set contentEnabled(value:Boolean):void
    {
        if (_contentEnabled != value)
        {
            _contentEnabled = value;

            tabChildren = value;

            if (contentPane)
            {
                contentPane.tabChildren = value;
                contentPane.mouseEnabled = value;
                contentPane.mouseChildren = value;
            }

            invalidateProperties();
            invalidateDisplayList();
        }
    }

    //----------------------------------
    //  showCloseButton
    //----------------------------------

    /**
     *  @private
     */
    private var _showCloseButton:Boolean = true;

    /**
     * Flag to specify whether to show close button.
     *
     *  @default true
     */
    public function get showCloseButton():Boolean
    {
        return _showCloseButton;
    }

    /**
     *  @private
     */
    public function set showCloseButton(value:Boolean):void
    {
        if (value != _showCloseButton)
        {
            _showCloseButton = value;

            invalidateDisplayList();
        }
    }

    //----------------------------------
    //  showMaxButton
    //----------------------------------

    /**
     *  @private
     */
    private var _showMaxButton:Boolean = true;

    /**
     *  Flag to specify whether to show maximize button.
     *
     *  @default true
     */
    public function get showMaxButton():Boolean
    {
        return _showMaxButton;
    }

    /**
     *  @private
     */
    public function set showMaxButton(value:Boolean):void
    {
        if (value != _showMaxButton)
        {
            _showMaxButton = value;

            invalidateDisplayList();
        }
    }

    //----------------------------------
    //  showMinButton
    //----------------------------------

    /**
     *  @private
     */
    private var _showMinButton:Boolean = true;

    /**
     *  Flag to specify whether to show minimize button.
     *
     *  @default true
     */
    public function get showMinButton():Boolean
    {
        return _showMinButton;
    }

    /**
     *  @private
     */
    public function set showMinButton(value:Boolean):void
    {
        if (value != _showMinButton)
        {
            _showMinButton = value;

            invalidateDisplayList();
        }
    }

    //----------------------------------
    //  windowState
    //----------------------------------

    /**
     *  @private
     *  Stores previous windowState value.
     */
    private var _oldWindowState:String;

    /**
     *  @private
     *  Storage for the windowState property.
     */
    private var _windowState:String;

    /**
     *  @private
     *  Flag set when windowState changes.
     */
    private var windowStateChanged:Boolean = false;

    [Inspectable(enumeration="normal,maximized,minimized", defaultValue="normal")]

    /**
     *  Specifies a window's maximized, minimized, normal state.
     *  You can change a window's state by using constants defined in MDIWindowState class.
     *  Valid values are <code>MDIWindowState.MINIMIZED</code>, <code>MDIWindowState.MAXIMIZED</code> and
     *  <code>MDIWindowState.NORMAL</code>.
     *
     *  @see org.openzet.containers.MDIWindowState
     *
     *  @default "normal"
     */
    public function get windowState():String
    {
        return _windowState;
    }

    /**
     *  @private
     */
    public function set windowState(value:String):void
    {
        setWindowState(value);
    }

    //--------------------------------------
    //  useInfo
    //--------------------------------------

    /**
     *  @private
     *  Storage for the useInfo property.
     */
    private var _useInfo:Boolean = true;

    /**
     *  Flag to specify whehter to use info property.
     */
    public function get useInfo():Boolean
    {
        return _useInfo;
    }

    /**
     *  @private
     */
    public function set useInfo(value:Boolean):void
    {
        _useInfo = value;

        // invalidateProperties();
        // invalidateDisplayList();
    }

    //--------------------------------------
    //  info
    //--------------------------------------

    /**
     *  @private
     *  Storage for the info property.
     */
    private var _info:String = "";

    /**
     *  @private
     */
    private var infoChanged:Boolean = false;

    [Bindable("infoChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Text property to show at the bottom of a window. 
     *
     *  @default ""
     */
    public function get info():String
    {
        return _info;
    }

    /**
     *  @private
     */
    public function set info(value:String):void
    {
        _info = value;

        infoChanged = true;
        invalidateProperties();
        //invalidateSize();
        //invalidateViewMetricsAndPadding();

        dispatchEvent(new Event("infoChanged"));
    }

    //--------------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        // creates closeButton before calling superclass's createChildren() method.
        if (!closeButton)
        {
            closeButton = new Button();
            closeButton.styleName = getStyle("titleBarButtonStyleName");
            closeButton.upSkinName = "closeButtonUpSkin";
            closeButton.overSkinName = "closeButtonOverSkin";
            closeButton.downSkinName = "closeButtonDownSkin";
            closeButton.disabledSkinName = "closeButtonDisabledSkin";
            closeButton.explicitWidth = closeButton.explicitHeight = DEFAULT_BUTTON_SIZE;
            closeButton.focusEnabled = false;
            closeButton.visible = false;
            closeButton.enabled = enabled;
            closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler, false, 0, true);
            //titleBar.addChild(closeButton);
            closeButton.owner = this;
        }

        super.createChildren();

        // add doubleClick event listener on titleBar.
        titleBar.doubleClickEnabled = true;
        titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, titleBar_doubleClickHandler, false, 0, true);

        // For drag feature, add mouseDown event listener on titleBar
        titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBar_mouseDownHandler, false, 0, true);

        // add closeButton as a child of the titleBar.
        titleBar.addChild(closeButton);

        // create  maxButton as a child of the titleBar.
        if (!maxButton)
        {
            maxButton = new Button();
            //maxButton.styleName = this;
            maxButton.styleName = getStyle("titleBarButtonStyleName");

            maxButton.upSkinName = "maxButtonUpSkin";
            maxButton.overSkinName = "maxButtonOverSkin";
            maxButton.downSkinName = "maxButtonDownSkin";
            maxButton.disabledSkinName = "maxButtonDisabledSkin";
            maxButton.explicitWidth = maxButton.explicitHeight = DEFAULT_BUTTON_SIZE;

            maxButton.focusEnabled = false;
            maxButton.visible = false;
            maxButton.enabled = enabled;

            maxButton.addEventListener(MouseEvent.CLICK, maxButton_clickHandler, false, 0, true);

            // Add the max button on top of the title/status.
            titleBar.addChild(maxButton);
            maxButton.owner = this;
        }

        // Create the minButton as a child of the titleBar.
        if (!minButton)
        {
            minButton = new Button();
            //minButton.styleName = this;
            minButton.styleName = getStyle("titleBarButtonStyleName");

            minButton.upSkinName = "minButtonUpSkin";
            minButton.overSkinName = "minButtonOverSkin";
            minButton.downSkinName = "minButtonDownSkin";
            minButton.disabledSkinName = "minButtonDisabledSkin";
            minButton.explicitWidth = minButton.explicitHeight = DEFAULT_BUTTON_SIZE;

            minButton.focusEnabled = false;
            minButton.visible = false;
            minButton.enabled = enabled;
            minButton.addEventListener(MouseEvent.CLICK, minButton_clickHandler, false, 0, true);

            // Add the min button on top of the title/status.
            titleBar.addChild(minButton);
            minButton.owner = this;
        }

        // Creates ResizeTool instance to handle resizing
        if (!resizer)
        {
            resizer = new ResizeTool(this);
            rawChildren.addChild(resizer);

            resizer.addEventListener(MDIWindowResizeEvent.WINDOW_RESIZE_START, window_resizeStartHandler, false, 0, true);
            resizer.addEventListener(MDIWindowResizeEvent.WINDOW_RESIZE, window_resizeHandler, false, 0, true);
            resizer.addEventListener(MDIWindowResizeEvent.WINDOW_RESIZE_END, window_resizeEndHandler, false, 0, true);
            resizer.addEventListener(MDIWindowDragEvent.WINDOW_DRAG_START, window_dragStartHandler, false, 0, true);
            resizer.addEventListener(MDIWindowDragEvent.WINDOW_DRAG, window_dragHandler, false, 0, true);
            resizer.addEventListener(MDIWindowDragEvent.WINDOW_DRAG_END, window_dragEndHandler, false, 0, true);
        }
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (windowStateChanged)
        {
            windowStateChanged = false;

            updateControlButtons();
        }

        if (infoChanged)
        {
            infoChanged = false;

            if (infoTextField)
            {
                infoTextField.text = _info;
            }

            // Don't call layoutChrome() if we  haven't initialized,
            // because it causes commit/measure/layout ordering problems
            // for children of the control bar.
            if (initialized)
            {
                layoutChrome(unscaledWidth, unscaledHeight);
            }
        }

        createOrDestroySuspendBlocker();
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        var allStyles:Boolean = !styleProp || styleProp == "styleName";

        super.styleChanged(styleProp);

        if (allStyles || styleProp == "infoStyleName")
        {
            if (infoTextField)
            {
                var infoStyleName:String = getStyle("infoStyleName");
                infoTextField.styleName = infoStyleName;
            }
        }

        if (allStyles || styleProp == "resizeBorderAlpha")
        {
            if (resizer)
            {
                resizer.borderAlpha = getStyle("resizeBorderAlpha");
            }
        }

        if (allStyles || styleProp == "resizeBorderThickness")
        {
            if (resizer)
            {
                resizer.borderThickness = getStyle("resizeBorderThickness");
            }
        }
    }

    /**
     *  @private
     *  order : commitProperties → layoutChrome → updateDisplayList → validateDisplayList
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (resizer)
        {
            resizer.setSize(unscaledWidth, unscaledHeight);
        }

        // when minimized, resizing a window leaves background traces.
        // For this cause, we always set contentPane's opaqueBackground to null
        // Also sets cacheAsBitmap to false. 
        if (contentPane && contentPane.scrollRect)
        {
            contentPane.opaqueBackground = null;
            contentPane.cacheAsBitmap = false;
        }
    }

    /**
     *  @private
     */
    override public function validateDisplayList():void
    {
        super.validateDisplayList();

        // that blocks UI input as well as draws an alpha overlay.
        // Make sure the blocker is correctly positioned and sized here.
        if (suspendBlocker)
        {
            var vm:EdgeMetrics = viewMetrics;
            var bgColor:uint = getStyle("suspendTransparencyColor");
            var blockerAlpha:Number = getStyle("suspendTransparency");

            suspendBlocker.x = vm.left;
            suspendBlocker.y = vm.top;

            var widthToBlocker:Number = Math.max(0, unscaledWidth - (vm.left + vm.right));
            var heightToBlocker:Number = Math.max(0, unscaledHeight - (vm.top + vm.bottom));

            suspendBlocker.graphics.clear();

            if (widthToBlocker > 0 &&
                heightToBlocker > 0)
            {
                suspendBlocker.graphics.beginFill(bgColor, blockerAlpha);
                suspendBlocker.graphics.drawRect(0, 0, widthToBlocker, heightToBlocker);
                suspendBlocker.graphics.endFill();
            }

            // adjusts position of suspend icon.
            var suspendIcon:IFlexDisplayObject = suspendBlocker.getChildByName("suspendIcon") as IFlexDisplayObject;

            if (suspendIcon)
            {
                var iconX:Number = Math.floor((widthToBlocker - suspendIcon.width) / 2);
                var iconY:Number = Math.floor((heightToBlocker - suspendIcon.height) / 2);

                if (iconX > 0 &&
                    iconY > 0)
                {
                    suspendIcon.move(iconX, iconY);
                    suspendIcon.visible = true;
                }
                else
                {
                    suspendIcon.visible = false;
                }
            }

            // suspendBlocker must be in front of everything else
            rawChildren.setChildIndex(suspendBlocker, rawChildren.numChildren - 1);
        }

        // resizer must be in front of everything else
        if (resizer)
        {
            rawChildren.setChildIndex(resizer, rawChildren.numChildren - 1);
        }

        // Scrollbars must be enabled/disabled when this container is.
        if (horizontalScrollBar)
        {
            horizontalScrollBar.enabled = enabled && _contentEnabled;
        }

        if (verticalScrollBar)
        {
            verticalScrollBar.enabled = enabled && _contentEnabled;
        }
    }

    /**
     *  @private
     */
    private function createOrDestroySuspendBlocker():void
    {
        var needBlur:Boolean = false;

        // If this container is being enabled and a blocker exists, remove it.
        // If this container is being disabled and a blocker doesn't exist, create it.
        if (contentEnabled)
        {
            if (suspendBlocker)
            {
                rawChildren.removeChild(suspendBlocker);
                suspendBlocker.removeEventListener(MouseEvent.CLICK, suspendBlocker_clickHandler);
                suspendBlocker.removeEventListener(MouseEvent.MOUSE_WHEEL, suspendBlocker_mouseWheelHandler);
                suspendBlocker = null;

                needBlur = true;
            }
        }
        else
        {
            if (!suspendBlocker)
            {
                suspendBlocker = new FlexSprite();
                suspendBlocker.name = "suspendBlocker";
                suspendBlocker.mouseEnabled = true;
                //suspendBlocker.tabEnabled = false;

                rawChildren.addChild(suspendBlocker);

                // Create suspend icon.
                var suspendIconClass:Class = getStyle("suspendIcon");

                if (suspendIconClass)
                {
                    var suspendIcon:IFlexDisplayObject = new suspendIconClass();
                    suspendIcon.name = "suspendIcon";
                    suspendBlocker.addChild(DisplayObject(suspendIcon));
                }

                suspendBlocker.addEventListener(MouseEvent.CLICK, suspendBlocker_clickHandler, false, 0, true);
                suspendBlocker.addEventListener(MouseEvent.MOUSE_WHEEL, suspendBlocker_mouseWheelHandler, false, 0, true);

                // If the focus is a child of ours, we clear it here.
                var o:DisplayObject =
                    focusManager ?
                    DisplayObject(focusManager.getFocus()) :
                    null;

                while (o)
                {
                    if (o == this)
                    {
                        var sm:ISystemManager = systemManager;
                        if (sm && sm.stage)
                            sm.stage.focus = null;
                        break;
                    }
                    o = o.parent;
                }

                needBlur = true;
            }
        }

        // Apply blur.
        if (needBlur)
        {
            var duration:Number = getStyle("suspendTransparencyDuration");
            var blurAmount:Number = getStyle("suspendTransparencyBlur");

            if (blurAmount)
            {
                if (blur)
                {
                    blur.end();
                    blur = null;
                }

                blur = new Blur(contentPane);

                if (contentEnabled)
                {
                    blur.blurXFrom = blur.blurYFrom = blurAmount;
                    blur.blurXTo = blur.blurYTo = 0;
                }
                else
                {
                    blur.blurXFrom = blur.blurYFrom = 0;
                    blur.blurXTo = blur.blurYTo = blurAmount;
                }

                blur.duration = duration;
                blur.addEventListener(EffectEvent.EFFECT_END, blur_effectEndHandler, false, 0, true);

                blur.play();
            }
        }
    }

    //------------------------------------------------------------
    //
    //  Overridden methods: Container
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutChrome(unscaledWidth, unscaledHeight);

        // Special case for the default borderSkin to inset the chrome content
        // by the borderThickness when borderStyle is "solid", "inset" or "outset".
        // We use getQualifiedClassName to avoid bringing in a dependency on
        // mx.skins.halo.PanelSkin.
        var em:EdgeMetrics = EdgeMetrics.EMPTY;
        var bt:Number = getStyle("borderThickness");
        if (getQualifiedClassName(border) == "mx.skins.halo::PanelSkin" &&
        	getStyle("borderStyle") != "default" && bt)
        {
        	em = new EdgeMetrics(bt, bt, bt, bt);
        }

        // Remove the borderThickness from the border metrics,
        // since the header and control bar overlap any solid border.
        var bm:EdgeMetrics =
        	FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ?
        	borderMetrics :
        	em;

        var headerHeight:Number = getHeaderHeight();

        if (headerHeight > 0 && height >= headerHeight)
        {
            var xOffset:int = 10;

            // Adjust close button position.
            closeButton.visible = _showCloseButton;

            if (_showCloseButton)
            {
                closeButton.setActualSize(
                    closeButton.getExplicitOrMeasuredWidth(),
                    closeButton.getExplicitOrMeasuredHeight());

                closeButton.move(
                    Math.ceil(unscaledWidth - bm.left - bm.right - xOffset - closeButton.getExplicitOrMeasuredWidth()),
                    Math.ceil((headerHeight - closeButton.getExplicitOrMeasuredHeight()) / 2));

                xOffset += closeButton.getExplicitOrMeasuredWidth() + DEFAULT_BUTTON_GAP;
            }

            // Adjust maximize button position.
            maxButton.visible = _showMaxButton;

            if (_showMaxButton)
            {
                maxButton.setActualSize(
                    maxButton.getExplicitOrMeasuredWidth(),
                    maxButton.getExplicitOrMeasuredHeight());

                maxButton.move(
                    Math.ceil(unscaledWidth - bm.left - bm.right - xOffset - maxButton.getExplicitOrMeasuredWidth()),
                    Math.ceil((headerHeight - maxButton.getExplicitOrMeasuredHeight()) / 2));

                xOffset += maxButton.getExplicitOrMeasuredWidth() + DEFAULT_BUTTON_GAP;
            }

            // Adjust minimize button position.
            minButton.visible = _showMinButton;

            if (_showMinButton)
            {
                minButton.setActualSize(
                    minButton.getExplicitOrMeasuredWidth(),
                    minButton.getExplicitOrMeasuredHeight());

                minButton.move(
                    Math.ceil(unscaledWidth - bm.left - bm.right - xOffset - minButton.getExplicitOrMeasuredWidth()),
                    Math.ceil((headerHeight - minButton.getExplicitOrMeasuredHeight()) / 2));

                xOffset += minButton.getExplicitOrMeasuredWidth() + DEFAULT_BUTTON_GAP;
            }

            var leftOffset:Number = 10;
            var rightOffset:Number = 4 + xOffset;
            var h:Number;
            var offset:Number;

            // Set the position of the title icon.
            if (titleIconObject)
            {
                h = titleIconObject.height;
                offset = (headerHeight - h) / 2;
                titleIconObject.move(leftOffset, offset);
                leftOffset += titleIconObject.width + 4;
            }

            // Set the position of the title text.
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            	h = titleTextField.nonZeroTextHeight;
            else
            	h = titleTextField.getUITextFormat().measureText(titleTextField.text).height;
            offset = (headerHeight - h) / 2;

            var borderWidth:Number = bm.left + bm.right;
            titleTextField.move(leftOffset, offset - 1);
            titleTextField.setActualSize(
                Math.max(0, unscaledWidth - leftOffset - rightOffset - borderWidth),
                h + UITextField.TEXT_HEIGHT_PADDING);

            // Substrct title if it is too long.
            titleTextField.text = title;
            var truncated:Boolean = titleTextField.truncateToFit();
            titleTextField.toolTip = truncated ? title : null;

            // Set the position of the status text.
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            	h = statusTextField.textHeight;
            else
            	h = statusTextField.text != "" ? statusTextField.getUITextFormat().measureText(statusTextField.text).height : 0;
            offset = (headerHeight - h) / 2;

            var statusX:Number = unscaledWidth - rightOffset - 4 - borderWidth - statusTextField.textWidth;

            statusTextField.move(statusX, offset - 1);
            statusTextField.setActualSize(
                statusTextField.textWidth + 8,
                statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING);

            // To make sure the status text isn't too long.
            // We do simple clipping here.
            var minX:Number = titleTextField.x + titleTextField.textWidth + 8;
            if (statusTextField.x < minX)
            {
                // Show as much as we can.
                statusTextField.width = Math.max(statusTextField.width - (minX - statusTextField.x), 0);
                statusTextField.x = minX;
            }
        }
        else
        {
            //
        }

        if (controlBar)
        {
            var cx:Number = controlBar.x;
            var cy:Number = controlBar.y;
            var cw:Number = controlBar.width;
            var ch:Number = controlBar.height;

            controlBar.setActualSize(
                unscaledWidth - (bm.left + bm.right),
                controlBar.getExplicitOrMeasuredHeight());

            controlBar.move(
                bm.left,
                unscaledHeight - bm.bottom - controlBar.getExplicitOrMeasuredHeight());

            if (controlBar.includeInLayout)
            {
                // Hide the control bar if it is spilling out.
                controlBar.visible = controlBar.y >= bm.top + headerHeight;
            }

            // If the control bar's position or size changed, redraw.  This
            // fixes a refresh bug (when the control bar vacates some space,
            // the new space appears blank).
            if (cx != controlBar.x ||
                cy != controlBar.y ||
                cw != controlBar.width ||
                ch != controlBar.height)
            {
                invalidateDisplayList();
            }
        }
    }

    /**
     *  @private
     *  Creates an instance based on properties and styles set in mxml tags.
     *  Here, we create a ControlBar no matter what.
     */
    override public function createComponentsFromDescriptors(recurse:Boolean = true):void
    {
        super.createComponentsFromDescriptors();

        if (useInfo)
        {
        	// For Now, we simply create a ControlBar
			// Yet later this logic could be changed to create on by calling a method like setControlBar().
			// ControlBar's margin and padding values are defined in a CSS sheet.
			// As for its height, it is automatically assigned in relation to the inner controls,
			// so we wouldn't need to specify it manually. 
            var cb:ControlBar = new ControlBar();
            rawChildren.addChild(cb);
            setControlBar(cb);

            // Create a textField to add in ControlBar
            if (!infoTextField)
            {
                infoTextField = new UITextField();
                var infoStyleName:String = getStyle("infoStyleName");
                infoTextField.styleName = infoStyleName;
                cb.addChild(infoTextField);
            }
        }
    }

    //------------------------------------------------------------
    //
    //  Methods : ControlBar
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    private var checkedForAutoSetRoundedCorners:Boolean;

    /**
     *  @private
     */
    private var autoSetRoundedCorners:Boolean;

    /**
     *  @private
     */
    private function setControlBar(newControlBar:IUIComponent):void
    {
        if (newControlBar == controlBar)
            return;

        controlBar = newControlBar;

        // If roundedBottomCorners is set locally, don't auto-set
        // it when the controlbar is added/removed.
        if (!checkedForAutoSetRoundedCorners)
        {
            checkedForAutoSetRoundedCorners = true;
            autoSetRoundedCorners = styleDeclaration ?
                    styleDeclaration.getStyle("roundedBottomCorners") === undefined :
                    true;
        }

        if (autoSetRoundedCorners)
            setStyle("roundedBottomCorners", controlBar != null);

        var controlBarStyleName:String = getStyle("controlBarStyleName");

        if (controlBarStyleName && controlBar is ISimpleStyleClient)
            ISimpleStyleClient(controlBar).styleName = controlBarStyleName;

        if (controlBar)
            controlBar.enabled = enabled;
        if (controlBar is IAutomationObject)
            IAutomationObject(controlBar).showInAutomationHierarchy = false;

        invalidateViewMetricsAndPadding();
        invalidateSize();
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

    /**
     *  Moves the component to a specified position within its parent.
     *
     *  @param x x Left position of the component within its parent.
     *
     *  @param y Top position of the component within its parent.
     */
    public function setPosition(x:Number, y:Number /*, isSystem:Boolean = false */):void
    {
        this.x = x;
        this.y = y;
    }

    /**
     *  Sizes the object.
     *
     *  @param w Width of the object.
     *
     *  @param h Height of the object.
     */
    public function setSize(w:Number, h:Number /*, isSystem:Boolean */):void
    {
        this.width = w;
        this.height = h;
    }

    /**
     *  @private
     *  Invoked when windowState value changes. Dispatches one of the following events based on the
     *  value of windowState property:
     *  <code>MDIWindowEvent.MAXIMIZE</code>, <code>MDIWindowEvent.MINIMIZE</code> and
     *  <code>MDIWindowEvent.RESTORE</code> 
     */
    private function dispatchMDIWindowEvent():void
    {
        switch (_windowState)
        {
            case MDIWindowState.NORMAL:
            {
                restoreWindow();
                break;
            }

            case MDIWindowState.MAXIMIZED:
            {
                maximizeWindow();
                break;
            }

            case MDIWindowState.MINIMIZED:
            {
                minimizeWindow();
                break;
            }
        }
    }

    /**
     *  Invoked whenever <code>windowState</code> property changes. 
     *  Normally you shouldn't call this method directly but simply change <code>windowState</code> property
     *  value to change a window's state.
     *
     *  @param value <code>windowState</code> property's new value.
     *  Possible values are <code>MDIWindowState.NORMAL</code>, <code>MDIWindowState.MAXIMIZED</code> and
     *  <code>MDIWindowState.MINIMIZED</code>.
     *
     *  @param noEvent If <code>true</code>, no event is dispatched.
     *  If <code>false</code> and if <code>windowState</code> changes, 
     *  dispatches a correspding event. 
     */
    public function setWindowState(value:String, noEvent:Boolean = false):void
    {
        if (value == _windowState)
        {
            return;
        }

        _oldWindowState = _windowState;
        _windowState = value;

        windowStateChanged = true;
        invalidateProperties();

        /*
        if (!initialized)
        {
            return;
        }
        */

        if (!noEvent)
        {
            // Dispatch windowStateChange event..
            dispatchMDIWindowEvent();
        }
    }

    //--------------------------------------------------------------------------------
    //
    //  Methods : Window handling
    //
    //--------------------------------------------------------------------------------

    /**
     *  Maximizes a windwow
     */
    public function maximize():void
    {
        windowState = MDIWindowState.MAXIMIZED;
    }

    /**
     *  Minimizes a window
     */
    public function minimize():void
    {
        windowState = MDIWindowState.MINIMIZED;
    }

    /**
     *  Restores a window
     */
    public function restore():void
    {
        if (windowState == MDIWindowState.MINIMIZED ||
            windowState == MDIWindowState.MAXIMIZED)
        {
            if (_oldWindowState == MDIWindowState.MAXIMIZED)
            {
                windowState = MDIWindowState.MAXIMIZED;
            }
            else
            {
                windowState = MDIWindowState.NORMAL;
            }
        }
    }

    /**
     *  Closes a window
     */
    public function close():void
    {
        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE));
    }

    /**
     *  Prevents user interaction within a window's content area.
     *  This method is usually called in cases when data is loaded from the server,
     *  when user interaction should be blocked for some reason, or when a suspended screen
     *  should be provided.
     *  After calling this method, you must always call resume() method to resume user interaction.
     *  The number of method calls on suspend() and resume() methods are counted by an internal counter.
     *  For example, if you call suspend() method twice for a data load from server, you should
     *  also call resume() method twice to resume the user interaction.
     */
    public function suspend():void
    {
        if (suspendCount == 0)
        {
            contentEnabled = false;
        }

        suspendCount++;
    }

    /**
     *  Resumes user interaction within the content area suspended by a call on suspend() method.
     *  You must call resume() method after calling suspend() method to resume
     *  the user interaction. 
     *
     *  @param compulsion If set to true, resumes the user interaction regardless of the method call counts of
     *  suspend() method.
     */
    public function resume(compulsion:Boolean = false):void
    {
        if (suspendCount > 0)
        {
            if (compulsion)
            {
                suspendCount = 0;
                contentEnabled = true;
            }
            else
            {
                suspendCount--;

                if (suspendCount == 0)
                {
                    contentEnabled = true;
                }
            }
        }
    }

    /**
     *  Invoked by an MDI instance when a window gets its focus.
     */
    public function focusIn():void
    {
        alpha = 1;

        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.WINDOW_FOCUS_IN));
    }

    /**
     *  Invoked by an MDI instance when a window loses its focus.
     */
    public function focusOut():void
    {
        alpha = .7;

        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.WINDOW_FOCUS_OUT));
    }

    /**
     *  @private
     *  Update control buttons when windowState property changes. 
     */
    private function updateControlButtons():void
    {
        switch (windowState)
        {
            case MDIWindowState.NORMAL:
            {
                maxButton.upSkinName = "maxButtonUpSkin";
                maxButton.overSkinName = "maxButtonOverSkin";
                maxButton.downSkinName = "maxButtonDownSkin";
                maxButton.disabledSkinName = "maxButtonDisabledSkin";

                minButton.upSkinName = "minButtonUpSkin";
                minButton.overSkinName = "minButtonOverSkin";
                minButton.downSkinName = "minButtonDownSkin";
                minButton.disabledSkinName = "minButtonDisabledSkin";

                break;
            }

            case MDIWindowState.MAXIMIZED:
            {
                maxButton.disabledSkinName = "restoreButtonDisabledSkin";
                maxButton.downSkinName = "restoreButtonDownSkin";
                maxButton.overSkinName = "restoreButtonOverSkin";
                maxButton.upSkinName = "restoreButtonUpSkin";

                minButton.upSkinName = "minButtonUpSkin";
                minButton.overSkinName = "minButtonOverSkin";
                minButton.downSkinName = "minButtonDownSkin";
                minButton.disabledSkinName = "minButtonDisabledSkin";

                break;
            }

            case MDIWindowState.MINIMIZED:
            {
                maxButton.upSkinName = "maxButtonUpSkin";
                maxButton.overSkinName = "maxButtonOverSkin";
                maxButton.downSkinName = "maxButtonDownSkin";
                maxButton.disabledSkinName = "maxButtonDisabledSkin";

                minButton.disabledSkinName = "restoreButtonDisabledSkin";
                minButton.downSkinName = "restoreButtonDownSkin";
                minButton.overSkinName = "restoreButtonOverSkin";
                minButton.upSkinName = "restoreButtonUpSkin";

                break;
            }
        }

        //maxButton.invalidateSize();
        //minButton.invalidateSize();
        maxButton.invalidateDisplayList();
        minButton.invalidateDisplayList();
    }

    /**
     *  @private
     *  Restores a window to its previous size. 
     */
    protected function restoreWindow():void
    {
        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, false, false, _oldWindowState, _windowState));
    }

    /**
     *  @private
     *  Minimizes a window. 
     */
    protected function minimizeWindow():void
    {
        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MINIMIZE, false, false, _oldWindowState, _windowState));
    }

    /**
     *  @private
     *  Maximizes a window. 
     */
    protected function maximizeWindow():void
    {
        dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, false, false, _oldWindowState, _windowState));
    }

    /**
     *  You should call this method after removing objects from an MDI instance.
     *  Override this method to prevent possible memory leak when removing windows by 
     *  removing event listeners registered. 
     */
    public function destroy():void
    {
        // titleBar.
        if (titleBar)
        {
            titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, titleBar_mouseDownHandler);
            titleBar.removeEventListener(MouseEvent.DOUBLE_CLICK, titleBar_doubleClickHandler);
        }

        // Control buttons.
        if (closeButton)
        {
            closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
        }

        if (maxButton)
        {
            maxButton.removeEventListener(MouseEvent.CLICK, maxButton_clickHandler);
        }

        if (minButton)
        {
            minButton.removeEventListener(MouseEvent.CLICK, minButton_clickHandler);
        }

        // ResizeTool
        if (resizer)
        {
            resizer.removeEventListener(MDIWindowResizeEvent.WINDOW_RESIZE_START, window_resizeStartHandler);
            resizer.removeEventListener(MDIWindowResizeEvent.WINDOW_RESIZE, window_resizeHandler);
            resizer.removeEventListener(MDIWindowResizeEvent.WINDOW_RESIZE_END, window_resizeEndHandler);
            resizer.removeEventListener(MDIWindowDragEvent.WINDOW_DRAG_START, window_dragStartHandler);
            resizer.removeEventListener(MDIWindowDragEvent.WINDOW_DRAG, window_dragHandler);
            resizer.removeEventListener(MDIWindowDragEvent.WINDOW_DRAG_END, window_dragEndHandler);
            resizer.destroy();
        }

        // Keyboard events.
        removeEventListener(KeyboardEvent.KEY_DOWN, window_keyDownHandler);

        // Blocker.
        if (suspendBlocker)
        {
            suspendBlocker.removeEventListener(MouseEvent.CLICK, suspendBlocker_clickHandler);
            suspendBlocker.removeEventListener(MouseEvent.MOUSE_WHEEL, suspendBlocker_mouseWheelHandler);
        }

        // Remove all children..
        removeAllChildren();
    }

    //--------------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------------

    /**
     *  @private
     *  Event handler for a titleBar's mouseDown event.
     *  Invokes ResizeTool's startDragging() method.
     *
     *  @param event MouseEvent
     */
    private function titleBar_mouseDownHandler(event:MouseEvent):void
    {
        // If dragging is not enabled or event target is a Button
        if (!draggable ||
            event.target == closeButton ||
            event.target == maxButton ||
            event.target == minButton)
        {
            return;
        }

        if (resizer)
        {
            resizer.startDragging();
        }
    }

    /**
     *  @private
     *  Event handler for titleBar's doubleClick event.
     *  Sets windowState appropriately.
     *
     *  @param event MouseEvent
     */
    private function titleBar_doubleClickHandler(event:MouseEvent):void
    {
        // normal state
        if (windowState == MDIWindowState.NORMAL)
        {
            // maximized state
            windowState = MDIWindowState.MAXIMIZED;
        }

        // maximized state
        else if (windowState == MDIWindowState.MAXIMIZED)
        {
            // normal state 
            windowState = MDIWindowState.NORMAL;
        }

        // minimized state
        else //if (windowState == MDIWindowState.MINIMIZED)
        {
            // if the window was maximized in the previous state
            if (_oldWindowState == MDIWindowState.MAXIMIZED)
            {
                // maximize it 
                windowState = MDIWindowState.MAXIMIZED;
            }
            // otherwise 
            else
            {
                // just apply normal state
                windowState = MDIWindowState.NORMAL;
            }
        }
    }

    /**
     *  @private
     */
    private function closeButton_clickHandler(event:MouseEvent):void
    {
        close();
    }

    /**
     *  @private
     *  Event handler for minimize Button's click event. 
     *  If windowState is minimized, restore it, otherwise minimize it. 
     *
     *  @param event MouseEvent
     */
    private function minButton_clickHandler(event:MouseEvent):void
    {
        if (windowState == MDIWindowState.MINIMIZED)
        {
            if (_oldWindowState == MDIWindowState.MAXIMIZED)
            {
                windowState = MDIWindowState.MAXIMIZED;
            }
            else
            {
                windowState = MDIWindowState.NORMAL;
            }
        }
        else
        {
            windowState = MDIWindowState.MINIMIZED;
        }
    }

    /**
     *  @private
     *  Event handler for maximized Button's click event.
     *  If windowState is maximized, apply normal state. Otherwise, maximize it.
     *
     *  @param event MouseEvent
     */
    private function maxButton_clickHandler(event:MouseEvent):void
    {
        if (windowState == MDIWindowState.MAXIMIZED)
        {
            windowState = MDIWindowState.NORMAL;
        }
        else
        {
            windowState = MDIWindowState.MAXIMIZED;
        }
    }

    /**
     *  @private
     *  Event handler for resizeStart event.
     *
     *  @param event MDIWindowResizeEvent
     */
    private function window_resizeStartHandler(event:MDIWindowResizeEvent):void
    {
        dispatchEvent(event.clone());
    }

    /**
     *  @private
     *  Event handler for resize event.
     *  Sets x, y, width and height values.
     *
     *  @param event MDIWindowResizeEvent
     */
    private function window_resizeHandler(event:MDIWindowResizeEvent):void
    {
        setPosition(event.x, event.y);
        setSize(event.width, event.height);

        dispatchEvent(event.clone());
    }

    /**
     *  @private
     *  Event handler for resizeEnd event.
     *  Sets x, y, width, height values.
     *
     *  @param event MDIWindowResizeEvent
     */
    private function window_resizeEndHandler(event:MDIWindowResizeEvent):void
    {
        setPosition(event.x, event.y);
        setSize(event.width, event.height);

        dispatchEvent(event.clone());
    }

    /**
     *  @private
     *  Event handler for dragStart event.
     *  If dragAlphaEnabled is true, changes the alpha value.
     *
     *  @param event MDIWindowDragEvent
     */
    private function window_dragStartHandler(event:MDIWindowDragEvent):void
    {
        if (MDIWindow.dragAlphaEnabled &&
            MDIWindow.moveType == MDIWindowMoveType.REALTIME)
        {
            alpha = MDIWindow.dragAlpha;
        }

        dispatchEvent(event.clone());
    }

    /**
     *  @private
     *  Event handler for dragStart event.
     *  Sets x and y values.
     *
     *  @param event MDIWindowDragEvent
     */
    private function window_dragHandler(event:MDIWindowDragEvent):void
    {
        setPosition(event.x, event.y);

        dispatchEvent(event.clone());
    }

    /**
     *  @private
     *  Event handler for dragEnd event.
     *  Sets x and y values.
     *  If MDIWindow.dragAlphaEnabled is true, restores the original alpha value. 
     *
     *  @param event MDIWindowDragEvent
     */
    private function window_dragEndHandler(event:MDIWindowDragEvent):void
    {
        if (MDIWindow.dragAlphaEnabled)
        {
            alpha = MDIWindow.ORIGINAL_ALPHA;
        }

        setPosition(event.x, event.y);

        dispatchEvent(event.clone());
    }

    /**
     *  @private
     */
    private function blur_effectEndHandler(event:EffectEvent):void
    {
        blur.removeEventListener(EffectEvent.EFFECT_END, blur_effectEndHandler);
        blur = null;
    }

    /**
     *  @private
     */
    private function suspendBlocker_clickHandler(event:Event):void
    {
        // Swallow click events from suspendBlocker.
        event.stopPropagation();
    }

    /**
     *  @private
     */
    private function suspendBlocker_mouseWheelHandler(event:MouseEvent):void
    {
        // Swallow mouse wheel events from suspendBlocker.
        event.stopPropagation();
    }

    /**
     *  @private
     */
    private function effectStartHandler(event:EffectEvent):void
    {
        verticalScrollPolicy = horizontalScrollPolicy = "off";
    }

    /**
     *  @private
     */
    private function effectEndHandler(event:EffectEvent):void
    {
        if (windowState != MDIWindowState.MINIMIZED)
        {
            //verticalScrollPolicy = horizontalScrollPolicy = "auto";
            callLater(setScrollPolicy, ["auto"]);
        }
    }

    /**
     *  @private
     */
    private function setScrollPolicy(value:String):void
    {
        verticalScrollPolicy = horizontalScrollPolicy = value;
    }

    //--------------------------------------------------------------------------------
    //
    //  Event Handlers : Keyboard Event
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  Event handler for keyDown event.
     */
    private function window_keyDownHandler(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            // Dispatch enter event.
            case Keyboard.ENTER:
            {
                dispatchEvent(new FlexEvent(FlexEvent.ENTER));
                break;
            }
        }
    }

} // end class

} // end package
