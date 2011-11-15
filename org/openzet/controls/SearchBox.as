////////////////////////////////////////////////////////////////////////////////
//
//  	Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//  	All Rights Reserved. 
//
//
//    	This file is part of OpenZet.
//
//    	OpenZet is free software: you can redistribute it and/or modify
//    	it under the terms of the GNU Lesser General Public License version 3 as published by
//    	the Free Software Foundation. 
//
//    	OpenZet is distributed in the hope that it will be useful,
//    	but WITHOUT ANY WARRANTY; without even the implied warranty of
//    	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    	GNU Lesser General Public License version 3 for more details.
//
//    	You should have received a copy of the GNU Lesser General Public License
//    	along with OpenZet.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////////////
package org.openzet.controls
{

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

import mx.controls.Button;
import mx.controls.Menu;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.FlexVersion;
import mx.core.IRectangularBorder;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.DropdownEvent;
import mx.events.FlexMouseEvent;
import mx.events.InterManagerRequest;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

/**
* Displays related keywords as a dropdown List when users are typing in.<br>
* Also provides icon and dropdown button to either initalize text or reflect search condition.
*/
public class SearchBox extends SuggestInput
{
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    private var searchIconButton:Button;

    /**
     *  @private
     */
    private var downArrowButton:Button;

    /**
     *  @private
     */
    private var inTween:Boolean = false;

    /**
     *  @private
     *  Is the popUp list currently shown?
     */
    private var showingPopUp:Boolean = false;

    /**
     *  @private
     *  The tween used for showing/hiding the popUp.
     */
    private var tween:Tween = null;

    /**
     *  @private
     */
    private var popUpChanged:Boolean = false;
   
    /**
     *  @private
     *  Right arrow button's visibility
     */
    private var _showArrowButton:Boolean = false
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Right arrow button's visibility
     *  @param   value   Boolean
     */
    public function set showArrowButton(value:Boolean):void
    {
        if (value != _showArrowButton)
        {
            _showArrowButton = value;
            
            downArrowButton.visible = _showArrowButton;
            downArrowButton.includeInLayout = !_showArrowButton;
            
            invalidateDisplayList();
        }
    }
    
    //------------------------------------------------------------
    //
    //  Constructor
    //
    //------------------------------------------------------------
    /**
     *  constructor  
     */
    public function SearchBox()
    {
        super();
        addEventListener(Event.CHANGE , dataChageEventHandler);
    }
    

    //----------------------------------
    //  closeOnActivity
    //----------------------------------

    /**
     *  @private
     *  Storage for the closeOnActivity property.
     */
    private var _closeOnActivity:Boolean = true;

    /**
     *  @private
     *  Specifies popUp would close on click/enter activity.
     *  In popUps like Menu/List/TileList etc, one need not change
     *  this as they should close on activity. However for multiple
     *  selection, and other popUp, this can be set to false, to
     *  prevent the popUp from closing on activity.
     *
     *  @default true
     */
    private function get closeOnActivity():Boolean
    {
        // We are not exposing this property for now, until the need arises.
        return _closeOnActivity;
    }

    /**
     *  @private
     */
    private function set closeOnActivity(value:Boolean):void
    {
        _closeOnActivity = value;
    }

    //----------------------------------
    //  popUp
    //----------------------------------

    /**
     *  @private
     *  Storage for popUp property.
     */
    private var _popUp:IUIComponent = null;

    [Bindable(event='popUpChanged')]
    [Inspectable(category="General", defaultValue="null")]

    /**
     *  Specifies the UIComponent object, or object defined by a subclass
     *  of UIComponent, to pop up.
     *  For example, you can specify a Menu, TileList, or Tree control.
     *
     *  @default null
     */
    public function get popUp():IUIComponent
    {
        return _popUp;
    }

    /**
     *  @private
     */
    public function set popUp(value:IUIComponent):void
    {
        _popUp = value;
        popUpChanged = true;

        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!searchIconButton)
        {
            searchIconButton = new Button();
            addChild(searchIconButton);
            textField.addEventListener(MouseEvent.CLICK, MouseClickEventHandler);
        }

        if (!downArrowButton)
        {
            downArrowButton = new Button();
            downArrowButton.styleName = getStyle("buttonSkin");
            addChild(downArrowButton);

            downArrowButton.addEventListener(MouseEvent.CLICK, downArrowButton_clickHandler);
        }
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (!initialized)
        {
            toggleIcon();
            this.styleName = getStyle("searchTextInputPromptStyleName");
            this.text = prompt;
        }

        if (popUpChanged)
        {
            if (_popUp is IFocusManagerComponent)
                IFocusManagerComponent(_popUp).focusEnabled = false;

            _popUp.cacheAsBitmap = true;
            _popUp.scrollRect = new Rectangle(0, 0, 0, 0);

            if (_popUp is mx.controls.Menu)
                _popUp.addEventListener(MenuEvent.MENU_HIDE, menuHideHandler);

            if (_popUp is IListItemRenderer)
            {
                _popUp.addEventListener(
                    ListEvent.ITEM_CLICK, popUpItemClickHandler);
            }

            _popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
                                    popMouseDownOutsideHandler);

            _popUp.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,
                                    popMouseDownOutsideHandler);
            _popUp.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,
                                    popMouseDownOutsideHandler);
            _popUp.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,
                                    popMouseDownOutsideHandler);

            _popUp.owner = this;

            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0 && _popUp is ISimpleStyleClient)
                ISimpleStyleClient(_popUp).styleName = getStyle("popUpStyleName");

            popUpChanged = false;
        }

        // Close if we're disabled and we happen to still be showing our popup.
        if (showingPopUp && !enabled)
            close();
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var bm:EdgeMetrics; 
 
        if (border)
        {
            border.setActualSize(unscaledWidth -  (_showArrowButton ? downArrowButton.getExplicitOrMeasuredWidth() : 0), unscaledHeight);
            bm = border is IRectangularBorder ?
                    IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY;
        }
        else
        {
            bm = EdgeMetrics.EMPTY;
        }
        
        searchIconButton.setActualSize(searchIconButton.getExplicitOrMeasuredWidth() , searchIconButton.getExplicitOrMeasuredHeight());
        searchIconButton.move(border.width - 30, (unscaledHeight/2) - searchIconButton.height/2);
        downArrowButton.setActualSize(downArrowButton.getExplicitOrMeasuredWidth() , downArrowButton.getExplicitOrMeasuredHeight());
        downArrowButton.move(unscaledWidth - downArrowButton.getExplicitOrMeasuredWidth(), (unscaledHeight/2) - downArrowButton.height/2);

        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");
        var widthPad:Number = bm.left + bm.right;
        var heightPad:Number = bm.top + bm.bottom + 1;

        textField.x = bm.left;
        textField.y = bm.top;

        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
        {
            textField.x += paddingLeft;
            textField.y += paddingTop;
            widthPad += paddingLeft + paddingRight;
            heightPad += paddingTop + paddingBottom;
        }

        textField.width = Math.max(0, unscaledWidth - widthPad - searchIconButton.getExplicitOrMeasuredWidth());
        textField.height = Math.max(0, unscaledHeight - heightPad);
    }

    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        super.focusOutHandler(event);
        if (!_isPrompt)
        {
            searchIconButton.buttonMode = _isPrompt;
            searchIconButton.removeEventListener(MouseEvent.CLICK, searchIconButton_clickHandler);
            this.styleName = getStyle("searchTextInputPromptStyleName");
            this.text = prompt;
        }
    }

    /**
     *  @private
     */
    override protected function focusInHandler(event:FocusEvent):void
    {
        super.focusInHandler(event);
        if (!_isPrompt)
        {
            searchIconButton.buttonMode = !_isPrompt;
            searchIconButton.addEventListener(MouseEvent.CLICK, searchIconButton_clickHandler);
            this.styleName = getStyle("searchTextInputNomalStyleName");
            this.text = "";
        }
    }

    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.ENTER)
        {
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  @private
     *  Used by PopUpMenuButton
     */
    mx_internal function getPopUp():IUIComponent
    {
        return _popUp ? _popUp : null;
    }

    /**
     *  Opens the UIComponent object specified by the <code>popUp</code> property.
     */
    public function open():void
    {
        openWithEvent(null);
    }

    /**
     *  @private
     */
    private function openWithEvent(trigger:Event = null):void
    {
        if (!showingPopUp && enabled)
        {
            displayPopUp(true);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }

    /**
     *  Closes the UIComponent object opened by the PopUpButton control.
     */
    public function close():void
    {
        closeWithEvent(null);
    }

    /**
     *  @private
     */
    private function closeWithEvent(trigger:Event = null):void
    {
        if (showingPopUp)
        {
            displayPopUp(false);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }


    /**
     *  @private
     */
    private function displayPopUp(show:Boolean):void
    {
        if (!initialized || (show == showingPopUp))
            return;
        // Subclasses may extend to do pre-processing
        // before the popUp is displayed
        // or override to implement special display behavior

        var popUpGap:Number = getStyle("popUpGap");
        var point:Point = new Point(unscaledWidth, unscaledHeight + popUpGap);
        point = localToGlobal(point);

        //Show or hide the popup
        var initY:Number;
        var endY:Number;
        var easingFunction:Function;
        var duration:Number;
        var sm:ISystemManager = systemManager.topLevelSystemManager;
        var sbRoot:DisplayObject = sm.getSandboxRoot();
        var screen:Rectangle;

        if (sm != sbRoot)
        {
            var request:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,
                                    false, false,
                                    "getVisibleApplicationRect");
            sbRoot.dispatchEvent(request);
            screen = Rectangle(request.value);
        }
        else
            screen = sm.getVisibleApplicationRect();

        if (show)
        {
            if (getPopUp() == null)
                return;

            if (_popUp.parent == null)
            {
                PopUpManager.addPopUp(_popUp, this, false);
                _popUp.owner = this;
            }
            else
                PopUpManager.bringToFront(_popUp);

            if (point.y + _popUp.height > screen.bottom &&
                point.y > (screen.top + height + _popUp.height))
            {
                // PopUp will go below the bottom of the stage
                // and be clipped. Instead, have it grow up.
                point.y -= (unscaledHeight + _popUp.height + 2*popUpGap);
                initY = -_popUp.height;
            }
            else
            {
                initY = _popUp.height;
            }

            // Calculate popup width
            point.x -= popUp.getExplicitOrMeasuredWidth(); 

            point.x = Math.min(point.x, screen.right - _popUp.getExplicitOrMeasuredWidth());
            point.x = Math.max( point.x, 0);
            point = _popUp.parent.globalToLocal(point);
            if (_popUp.x != point.x || _popUp.y != point.y)
                _popUp.move(point.x, point.y);

            _popUp.scrollRect = new Rectangle(0, initY,
                    _popUp.width, _popUp.height);

            if (!_popUp.visible)
                _popUp.visible = true;

            endY = 0;
            showingPopUp = show;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
        }
        else
        {
            showingPopUp = show;

            if (_popUp.parent == null)
                return;

            point = _popUp.parent.globalToLocal(point);

            endY = (point.y + _popUp.height > screen.bottom &&
                               point.y > (screen.top + height + _popUp.height)
                               ? -_popUp.height - 2
                               : _popUp.height + 2);
            initY = 0;
            duration = getStyle("closeDuration")
            easingFunction = getStyle("closeEasingFunction") as Function;
        }

        inTween = true;
        UIComponentGlobals.layoutManager.validateNow();

        // Block all layout, responses from web service, and other background
        // processing until the tween finishes executing.
        UIComponent.suspendBackgroundProcessing();

        tween = new Tween(this, initY, endY, duration);
        if (easingFunction != null)
            tween.easingFunction = easingFunction;
    }

    private var _prompt:String = "search";
    private var _isPrompt:Boolean =true;
    /**
     *  @private
     */
    public function get prompt():String
    {
        return _prompt;
    }

    /**
     *  @private
     */
    public function set prompt(value:String):void
    {
        _prompt = value;
    }

    /**
     *  @private
     *  Search button's click event handler
     */
    private function searchIconButton_clickHandler(event:MouseEvent):void
    {
        // Checks searchIconButton's close style.
        if (searchIconButton.styleName == "searchClearIconButtonStyle")
        {
            this.text = "";
            dataChageEventHandler();
            return;
        }
        // Remains focused. 
        setFocus();
        dispatchEvent(new Event("search"));
    }

    /**
     *  @private
     *  Internal method to toggle search button icon.
     */
    private function toggleIcon(isPrompt:Boolean = false):void
    {
        searchIconButton.styleName = isPrompt ? getStyle("searchClearIconButtonStyleName") : getStyle("searchIconButtonStyleName");
        _isPrompt = isPrompt;
    }


    /**
     *  @private
     */
    mx_internal function onTweenUpdate(value:Number):void
    {
        _popUp.scrollRect =
            new Rectangle(0, value, _popUp.width, _popUp.height);
    }

    /**
     *  @private
     */
    mx_internal function onTweenEnd(value:Number):void
    {
        _popUp.scrollRect =
            new Rectangle(0, value, _popUp.width, _popUp.height);

        inTween = false;
        UIComponent.resumeBackgroundProcessing();

        if (!showingPopUp)
        {
            _popUp.visible = false;
            _popUp.scrollRect = null;
        }

    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function dataChageEventHandler(event:Event = null):void
    {
        this.toggleIcon(Boolean(this.length));
    }
    
    /**
     *  @private
     */
    private function MouseClickEventHandler(event:MouseEvent):void
    {
        this.close();
    }

    /**
     *  @private
     *  Hide is called intermittently before close gets called.
     *  Call close() in such cases to  reset variables.
     */
    private function menuHideHandler(event:MenuEvent):void
    {
        if (event.menu != mx.controls.Menu(_popUp).mx_internal::getRootMenu())
        {
            return;
        }
        showingPopUp = true;
        _popUp.visible = true;
        displayPopUp(false);
    }


    /**
     *  @private
     */
    private function popMouseDownOutsideHandler(event:Event):void
    {
        if (event is MouseEvent)
        {
            // for automated testing, since we're generating this event and
            // can only set localX and localY, transpose those coordinates
            // and use them for the test point.
            var mouseEvent:MouseEvent = MouseEvent(event);
            var p:Point = event.target.localToGlobal(new Point(mouseEvent.localX,
                                                               mouseEvent.localY));
            if (hitTestPoint(p.x, p.y, true))
            {
                // do nothing
            }
            else
            {
                close();
            }
        }
        else if (event is SandboxMouseEvent)
            close();
    }


    /**
     *  @private
     *  Close popUp for IListItemRenderer's like List/Menu.
     */
    private function popUpItemClickHandler(event:Event):void
    {
        if (_closeOnActivity)
            close();
    }

 	/**
 	 * @private
 	 * 
 	 * downArrowButton's click handler method. 
 	 **/
    private function downArrowButton_clickHandler(event:MouseEvent):void
    {
        if (showingPopUp)
            closeWithEvent(event);
        else
            openWithEvent(event);
    }
}
}