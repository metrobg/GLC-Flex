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

import flash.events.Event;
import flash.events.EventPhase;
import flash.events.TextEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.events.FocusEvent;
import flash.display.DisplayObject;
import flash.display.Graphics;
import mx.controls.Alert;
import mx.controls.HRule;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;
import mx.managers.IFocusManagerComponent;
import org.openzet.controls.TextInput;
import org.openzet.events.SSNTextInputEvent;
import org.openzet.validators.SSNValidator;

import mx.events.ValidationResultEvent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when SSN is valid.
 *
 *  @eventType org.openzet.events.SSNTextInputEvent.VALID_SSN
 */
[Event(name="validSSN", type="org.openzet.events.SSNTextInputEvent")]

/**
 *  Dispatched when SSN is invalid.
 *
 *  @eventType org.openzet.events.SSNTextInputEvent.INVALID_SSN
 */
[Event(name="invalidSSN", type="org.openzet.events.SSNTextInputEvent")]

/**
 *  Dispatched when text in the TextInput control changes
 *  through user input.
 *  This event does not occur if you use data binding or
 *  ActionScript code to change the text.
 *
 *  @eventType flash.events.Event.CHANGE
 */
[Event(name="change", type="flash.events.Event")]

/**
 *  Dispatched when the user presses the Enter key.
 *
 *  @eventType mx.events.FlexEvent.ENTER
 */
[Event(name="enter", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Custom Control to validte SSN, short for Social Security Number.
 *  This control also provides visual icon to show valid status.
 */
public class SSNTextInput extends UIComponent
{
    include "../core/Version.as";

    /**
     *  Constructor
     */
    public function SSNTextInput()
    {
        super();

        validCheck();

        setStyle("horizontalGap", 2);
        setStyle("verticalAlign", "middle");
    }

    //------------------------------------------------------------
    //
    //  Variables
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Focus status for the first part of SSN.
     */
    private var textInput1_focusIn:Boolean;

    /**
     *  @private
     *  Focus status for the second part of SSN.
     */
    private var textInput2_focusIn:Boolean;

    /**
     *  @private
     *  Previous focus status for the first part of SSN.
     */
    private var oldTextInput1_focusIn:Boolean;
    /**
     *  @private
     *  Previous focus status for the second part of SSN.
     */
    private var oldTextInput2_focusIn:Boolean;
    /**
     *  @private
     *  Focus change state
     */
    private var focusChanged:Boolean = false;
    /**
     *  TextInput to display the first part of SSN.
     */
    public var textInput1:TextInput;

    /**
     *  TextInput to display the second part of SSN.
     */
    public var textInput2:TextInput;

    /**
     *  @private
     *  Icon display object to show invalid status of SSN.
     */
    private var invalidIcon:DisplayObject;
    /**
     *  @private
     *  Icon display object to show valid status of SSN.
     */
    private var validIcon:DisplayObject;

    /**
     *  @private
     *  SSN validator instance.
     */
    private var ssnValidator:SSNValidator;


    //------------------------------------------------------------
    //
    //  Overriden Properties
    //
    //------------------------------------------------------------

    //--------------------------------------
    //  tabIndex
    //--------------------------------------

    /**
     *  @private
     */
    private var _tabIndex:int;

    /**
     *  @private
     */
    private var tabIndexChanged:Boolean = false;

    /**
     *  @private
     */
    override public function set tabIndex(value:int):void
    {
        _tabIndex = value;
        tabIndexChanged = true;

        invalidateProperties();
    }

    //------------------------------------------------------------
    //
    //  Properties
    //
    //------------------------------------------------------------

    /**
     *  Flag to specify whether to display latter part of SSN as *******
     *
     *  @default false
     */
    public var block:Boolean = false;

    //--------------------------------------
    //  ssn
    //--------------------------------------

    /**
     *  SSN string value.
     */
    public function get ssn():String
    {
        return textInput1.text + textInput2.text;
    }

    /**
     *  @private
     */
    public function set ssn(value:String):void
    {

        value = value.split('-').join('');
        ssn1 = value.substr(0, 6);
        ssn2 = value.substr(6, 7);

        textInput1.text = ssn1;
        textInput2.text = ssn2;
        //callLater(isValid);
    }

    //--------------------------------------
    //  ssn1
    //--------------------------------------

    /**
     *  @private
     */
    private var ssn1Changed:Boolean = false;

    [Bindable("ssn1Changed")]

    /**
     *  First part of SSN.
     */
    public function get ssn1():String
    {
        return textInput1.text;
    }

    /**
     *  @private
     */
    public function set ssn1(value:String):void
    {
        textInput1.text = value;
        ssn1Changed = true;

        invalidateProperties();

        //callLater(isValid);
    }

    //--------------------------------------
    //  ssn2
    //--------------------------------------

    /**
     *  @private
     */
    private var ssn2Changed:Boolean = false;

    [Bindable("ssn2Changed")]

    /**
     *  Second part of SSN.
     */
    public function get ssn2():String
    {
        return textInput2.text;
    }

    /**
     *  @private
     */
    public function set ssn2(value:String):void
    {
        textInput2.text = value;
        ssn2Changed = true;

        invalidateProperties();

        //callLater(isValid);
    }

    //------------------------------
    //  validCheckEnabled
    //------------------------------

    /**
     *  @private
     *  Property to specify whether to show icon.
     */
    private var _showIcon:Boolean = false;

    /**
     *  @private
     */
    private var showIconOptionChanged:Boolean = false;

    [Bindable("showIconOptionChanged")]
    [Inspectable(defaultValue="false")]

    //------------------------------
    //  showIcon
    //------------------------------

    /**
     *  Property to specify whether to show icon.
     *
     *  @default false
     */
    public function get showIcon():Boolean
    {
        return _showIcon;
    }

    /**
     *  @private
     */
    public function set showIcon(value:Boolean):void
    {
        _showIcon = value;
        showIconOptionChanged = true;

        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
    }

    //------------------------------
    //  isValid
    //------------------------------

    /**
     *  @private
     */
    private var _isValid:Boolean = false;


    /**
     *  Property that returns whether to SSN is valid.
     */
    public function get isValid():Boolean
    {
        return _isValid;
    }

    //------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!textInput1)
        {
            textInput1 = new TextInput();
            textInput1.focusEnabled = true;
            textInput1.restrict = "0-9";
            textInput1.maxChars = 6;
            textInput1.setStyle("textAlign", "center");

            textInput1.addEventListener(Event.CHANGE, textInput1_changeHandler);
            textInput1.addEventListener(KeyboardEvent.KEY_DOWN, textInput1_keyDownHandler);
            textInput1.addEventListener(FocusEvent.FOCUS_IN, textInput1_focusInHandler, false);
            textInput1.addEventListener(FocusEvent.FOCUS_OUT, textInput1_focusOutHandler, false);

            addChild(textInput1);
        }

        if (!textInput2)
        {
            textInput2 = new TextInput();
            textInput2.focusEnabled = true;
            textInput2.restrict = "0-9";
            textInput2.maxChars = 7;
            textInput2.setStyle("textAlign", "center");
            textInput2.displayAsPassword = block;
            textInput2.addEventListener(Event.CHANGE, textInput2_changeHandler);
            textInput2.addEventListener(KeyboardEvent.KEY_DOWN, textInput2_keyDownHandler);
            textInput2.addEventListener(FocusEvent.FOCUS_IN, textInput2_focusInHandler, false);
            textInput2.addEventListener(FocusEvent.FOCUS_OUT, textInput2_focusOutHandler, false);

            addChild(textInput2);
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();
        var iconSpace:Number = 0;
        if(invalidIcon && validIcon)
        {
            iconSpace = validIcon.width;
        }

        measuredMinWidth = measuredWidth = 60 + 70 + 10 + iconSpace;
        measuredMinHeight = measuredHeight = 22;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);

        textInput1.setActualSize(60, 22);
        textInput2.move(textInput1.x + textInput1.width + 12, 0);
        textInput2.setActualSize(70, 22);
        if(invalidIcon && validIcon)
        {
            invalidIcon.x = textInput2.x + textInput2.width + 2;
            invalidIcon.y = textInput2.height / 2 - invalidIcon.height / 2;
            validIcon.x = invalidIcon.x;
            validIcon.y = invalidIcon.y;
        }

        var g:Graphics = this.graphics;
        g.clear();
        g.lineStyle(2, 0x323232, 1);
        g.moveTo(textInput1.x + textInput1.width + 4, textInput1.height / 2);
        g.lineTo(textInput2.x - 4, textInput2.height / 2);
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        viewIcon(true);
    }

    /**
     *  @private
     */
    private function viewIcon(changedStyle:Boolean = false):void
    {
        if (_showIcon)
        {
            if (!invalidIcon)
            {
                var invalidIconClass:Class = getStyle("invalidIcon");

                invalidIcon = new invalidIconClass();
                addChild(invalidIcon);
            }

            if (!validIcon)
            {
                var validIconClass:Class = getStyle("validIcon");

                validIcon = new validIconClass();
                addChild(validIcon);
            }
        }

        else
        {
            if (invalidIcon)
            {
                removeChild(invalidIcon);
                invalidIcon = null;
            }

            if (validIcon)
            {
                removeChild(validIcon);
                validIcon = null;
            }
        }
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (showIconOptionChanged)
        {
            showIconOptionChanged = false;
            viewIcon(false);
            dispatchEvent(new Event("showIconOptionChanged"));
        }

        if (ssn1Changed && ssn2Changed)
        {
            ssn1Changed = false;
            ssn2Changed = false;
            dispatchEvent(new Event("ssnChanged"));
        }

        if (ssn1Changed)
        {
            ssn1Changed = false;
            dispatchEvent(new Event("ssn1Changed"));
        }

        if (ssn2Changed)
        {
            ssn2Changed = false;
            dispatchEvent(new Event("ssn2Changed"));
        }

        if (focusChanged)
        {
            focusChanged = false;

            // focus in
            if (!oldTextInput1_focusIn && !oldTextInput2_focusIn)
            {
                dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
            }
            // focus out
            else if (!textInput1_focusIn && !textInput2_focusIn)
            {
                // reset
                textInput1_focusIn = false;
                textInput2_focusIn = false;
                oldTextInput1_focusIn = false;
                oldTextInput2_focusIn = false;

                dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
            }
        }

        if (tabIndexChanged)
        {
            tabIndexChanged = false;

            textInput1.tabIndex = textInput2.tabIndex = _tabIndex;
        }
    }

    /**
     *  @private
     */
    override public function setFocus():void
    {
        textInput1.setFocus();
    }

    //------------------------------------------------------------
    //
    //  Methods
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    private function textInput1_focusInHandler(event:FocusEvent):void
    {
        event.stopImmediatePropagation();

        oldTextInput1_focusIn = textInput1_focusIn;
        textInput1_focusIn = true;

        focusChanged = true;
        invalidateProperties();
    }

    /**
     *  @private
     */
    private function textInput1_focusOutHandler(event:FocusEvent):void
    {
        event.stopImmediatePropagation();

        oldTextInput1_focusIn = textInput1_focusIn;
        textInput1_focusIn = false;

        focusChanged = true;
        invalidateProperties();
    }

    /**
     *  @private
     */
    private function textInput2_focusInHandler(event:FocusEvent):void
    {
        event.stopImmediatePropagation();
        //event.stopPropagation();

        oldTextInput2_focusIn = textInput2_focusIn;
        textInput2_focusIn = true;

        focusChanged = true;
        invalidateProperties();
    }

    /**
     *  @private
     */
    private function textInput2_focusOutHandler(event:FocusEvent):void
    {
        event.stopImmediatePropagation();

        oldTextInput2_focusIn = textInput2_focusIn;
        textInput2_focusIn = false;

        focusChanged = true;
        invalidateProperties();
    }

    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        switch (event.keyCode)
        {
            case Keyboard.ENTER:
            {
                dispatchEvent(new FlexEvent(FlexEvent.ENTER));
                break;
            }
        }
    }

    //------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //------------------------------------------------------------

    /**
     *  private
     */
    private function validHanlder(event:ValidationResultEvent):void
    {
        changeIconState(event.type);
    }

    /**
     *  private
     */
    private function invalidHandler(event:ValidationResultEvent):void
    {
        changeIconState(event.type);
    }

    /**
     *  private
     */
    private function changeIconState(type:String):void
    {
        var e:SSNTextInputEvent;
        if(type == "invalid")
        {
            _isValid = false;
            e = new SSNTextInputEvent(SSNTextInputEvent.INVALID_SSN);
        }
        else
        {
            _isValid = true;
            e = new SSNTextInputEvent(SSNTextInputEvent.VALID_SSN);
        }

        if(validIcon && invalidIcon != null)
        {
            validIcon.visible = _isValid;
            invalidIcon.visible = !_isValid;
        }
        e.ssn = ssn;
        e.ssn1 = ssn1;
        e.ssn2 = ssn2;
        e.valid = _isValid;
        dispatchEvent(e);
    }

    /**
     *  @private
     */
    public function validCheck():void
    {
        if(!ssnValidator)
        {
            ssnValidator = new SSNValidator();
        }

        ssnValidator.source = this;
        ssnValidator.property = "ssn";
        ssnValidator.trigger = this;
        ssnValidator.triggerEvent = "change";
        ssnValidator.addEventListener(ValidationResultEvent.VALID, validHanlder);
        ssnValidator.addEventListener(ValidationResultEvent.INVALID, invalidHandler);
    }

    //------------------------------------------------------------
    //
    //  Event Handlers
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    private function textInput1_changeHandler(event:Event):void
    {
        event.stopImmediatePropagation();
        dispatchEvent(new Event(Event.CHANGE));

        if (textInput1.text.length > 5
            && textInput1.selectionBeginIndex == textInput1.text.length
            && textInput1.selectionEndIndex == textInput1.text.length)
        {
            textInput2.setFocus();
        }
    }

    /**
     *  @private
     */
    private function textInput2_changeHandler(event:Event):void
    {
        event.stopImmediatePropagation();
        dispatchEvent(new Event(Event.CHANGE));
    }

    /**
     *  @private
     */
    private function textInput1_keyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.RIGHT
            && textInput1.selectionBeginIndex == textInput1.length
            && textInput1.selectionEndIndex == textInput1.length)
        {
            textInput2.setFocus();
            textInput2.setSelection(0, 0);
        }
    }

    /**
     *  @private
     */
    private function textInput2_keyDownHandler(event:KeyboardEvent):void
    {
        //callLater(textInput1_keyDownHandler2, [event]);
        if (textInput2.selectionBeginIndex == 0
            && textInput2.selectionEndIndex == 0)
        {
            if (event.keyCode == Keyboard.LEFT)
            {
                textInput1.setFocus();
                textInput1.setSelection(textInput1.text.length, textInput1.text.length);
            }
            else if (event.keyCode == Keyboard.BACKSPACE)
            {
                callLater(deleteTextInput1Text);
            }
        }
    }

    /**
     *  @private
     */
    private function deleteTextInput1Text():void
    {
        textInput1.setFocus();
        textInput1.text = textInput1.text.substr(0, textInput1.text.length - 1);
        textInput1.setSelection(textInput1.text.length, textInput1.text.length);
    }
}
}