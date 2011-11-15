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
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.ArrayCollection;
import mx.controls.Button;
import mx.controls.List;
import mx.core.SpriteAsset;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.FlexMouseEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

import org.openzet.controls.dateControls.HourNumericStepper;
import org.openzet.controls.dateControls.MinuteNumericStepper;

use namespace mx_internal;

/**
 *  Custom components that expands on the functionality of UIComponent to easily set time.
 */
public class TimeChooser extends UIComponent
{
    include "../core/Version.as";

    //------------------------------------------------------------
    //
    //  Constructor
    //
    //------------------------------------------------------------
    /**
     *  Constructor
     */
    public function TimeChooser() {}

    //------------------------------------------------------------
    //
    //  Variables
    //
    //------------------------------------------------------------

    /**
     *  @private
     */
    private var _dropButton:Button;

    /**
     *  @private
     */
    private var _hourNumericStepper:HourNumericStepper;

    /**
     *  @private
     */
    private var _minuteNumericStepper:MinuteNumericStepper;

    /**
     *  @private
     */
    private var _timeList:List;

    /**
     *  @private
     */
    private var _apm:Button;

    /**
     *  @private
     */
    private var _tween:Tween;

    /**
     *  @private
     */
    private var _isTweening:Boolean = false;

    /**
     *  @private
     */
    private var _showList:Boolean = false;

    /**
     *  @private
     */
    private var _timeListData:ArrayCollection = new ArrayCollection
    ([
        {label:"12:00 AM", data:"1200AM"},
        {label:"12:30 AM", data:"1230AM"},
        {label:"1:00 AM", data:"0100AM"},
        {label:"1:30 AM", data:"0130AM"},
        {label:"2:00 AM", data:"0200AM"},
        {label:"2:30 AM", data:"0230AM"},
        {label:"3:00 AM", data:"0300AM"},
        {label:"3:30 AM", data:"0330AM"},
        {label:"4:00 AM", data:"0400AM"},
        {label:"4:30 AM", data:"0430AM"},
        {label:"5:00 AM", data:"0500AM"},
        {label:"5:30 AM", data:"0530AM"},
        {label:"6:00 AM", data:"0600AM"},
        {label:"6:30 AM", data:"0630AM"},
        {label:"7:00 AM", data:"0700AM"},
        {label:"7:30 AM", data:"0730AM"},
        {label:"8:00 AM", data:"0800AM"},
        {label:"8:30 AM", data:"0830AM"},
        {label:"9:00 AM", data:"0900AM"},
        {label:"9:30 AM", data:"0930AM"},
        {label:"10:00 AM", data:"1000AM"},
        {label:"10:30 AM", data:"1030AM"},
        {label:"11:00 AM", data:"1100AM"},
        {label:"11:30 AM", data:"1130AM"},
        {label:"12:00 PM", data:"1200PM"},
        {label:"12:30 PM", data:"1230PM"},
        {label:"1:00 PM", data:"0100PM"},
        {label:"1:30 PM", data:"0130PM"},
        {label:"2:00 PM", data:"0200PM"},
        {label:"2:30 PM", data:"0230PM"},
        {label:"3:00 PM", data:"0300PM"},
        {label:"3:30 PM", data:"0330PM"},
        {label:"4:00 PM", data:"0400PM"},
        {label:"4:30 PM", data:"0430PM"},
        {label:"5:00 PM", data:"0500PM"},
        {label:"5:30 PM", data:"0530PM"},
        {label:"6:00 PM", data:"0600PM"},
        {label:"6:30 PM", data:"0630PM"},
        {label:"7:00 PM", data:"0700PM"},
        {label:"7:30 PM", data:"0730PM"},
        {label:"8:00 PM", data:"0800PM"},
        {label:"8:30 PM", data:"0830PM"},
        {label:"9:00 PM", data:"0900PM"},
        {label:"9:30 PM", data:"0930PM"},
        {label:"10:00 PM", data:"1000PM"},
        {label:"10:30 PM", data:"1030PM"},
        {label:"11:00 PM", data:"1100PM"},
        {label:"11:30 PM", data:"1130PM"}
    ]);

    private var _apmChecker:String;

    //------------------------------------------------------------
    //
    //  Properties
    //
    //------------------------------------------------------------

    //----------------------------------
    //  time
    //----------------------------------
    /**
     *  @private
     */
    public function set time(value:String):void
    {
        var time:String = value;
        var hour:int;
        var minute:int;
        if(time.length > 4 || time.length < 3) return;
        if(time.length == 4)
        {
            hour = int(time.substr(0, 2));
            minute = int(time.substr(2, 4));
        }
        if(time.length == 3)
        {
            hour = int(time.substr(0, 1));
            minute = int(time.substr(1, 3));
        }

        this.hour = hour.toString();
        this.minute = minute.toString();
    }

    /**
     *  TimeChooser's time.
     */
    public function get time():String
    {
        return hour.toString() + minute.toString();
    }

    //----------------------------------
    //  hour
    //----------------------------------
    /**
     *  @private
     */
    public function set hour(value:String):void
    {
        var hourString:String = value;
        var hour:int = int(value);
        if (hourString.length > 2 || hourString.length <= 0) return;

        if (hour > 24) {
            _hourNumericStepper.value = 24;
        } else if (hour < 1) {
            _hourNumericStepper.value = 1;
        }

        if(hour > 12)
        {
            _apmChecker = "PM";
            hour -= 12;
        } else {
            _apmChecker = "AM"
        }

        _hourNumericStepper.value = hour;
    }

    /**
     *  TimeChooser's hour.
     */
    public function get hour():String
    {
        var hour:int;
        hour = _hourNumericStepper.value;
        if(_apmChecker == "PM" && hour != 12) hour += 12;
        if(_apmChecker == "AM" && hour == 12) hour = 0;

        var hourString:String = hour.toString();
        if(hourString.length < 2)
        {
            hourString = "0" + hourString;
        }
        return hourString;
    }

    //----------------------------------
    //  minute
    //----------------------------------
    /**
     *  @private
     */
    public function set minute(value:String):void
    {
        var minuteString:String = value;
        if(minuteString.length > 2 || minuteString.length <= 0) return;

        var minute:int = int(value);

        if(minute >= 59)
            _minuteNumericStepper.value = 59;
        else if(minute <= 0)
            _minuteNumericStepper.value = 0;
        else
            _minuteNumericStepper.value = minute;
    }

    /**
     *  TimeChooser's minute.
     */
    public function get minute():String
    {
        var minuteString:String = _minuteNumericStepper.value.toString();

        if(minuteString.length < 2)
        {
            minuteString = "0" + minuteString;
        }
        return minuteString;
    }

    //------------------------------------------------------------
    //
    //  Method
    //
    //------------------------------------------------------------

    /**
     *  Removes event listeners registered with TimeChooser
     */
    public function destroy():void
    {
        _timeList.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, timeList_mouseDownOutsideHandler);
        _timeList.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, timeList_mouseWheelOutsideHandler);
        systemManager.removeEventListener(Event.RESIZE, stage_resizeHandler);

        _dropButton.removeEventListener(MouseEvent.CLICK, dropButtonClickHandler);
        _hourNumericStepper.removeEventListener(Event.CHANGE, hourChangeHandler);
        _minuteNumericStepper.removeEventListener(Event.CHANGE, minuteChangeHandler);
        _apm.removeEventListener(MouseEvent.CLICK, apmButtonClickHandler);
        _timeList.removeEventListener(ListEvent.CHANGE, timeListClickHandler);

        _tween = null;
        _dropButton = null;
        _hourNumericStepper = null;
        _minuteNumericStepper = null;
        _timeList = null;
        _apm = null;
    }
    //------------------------------------------------------------
    //
    //  Internal Method
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Returns "0" + Number type of string.
     */
    private function digitString(value:Number, isMinute:Boolean = false):String
    {
        var digit:String;
        if(isMinute)
        {
            var minute:Number = 0;
            if(value >= 30)
            {
                minute = 30;
                _minuteNumericStepper.value = 30;
            }
            else
            {
                minute = 0;
                _minuteNumericStepper.value = 0;
            }
            digit = minute.toString();
        }
        else
        {
            digit = value.toString();
        }


        if(digit.length == 1)
        {
            digit = "0" + digit;
        }

        return digit;
    }

    /**
     *  @private
     *  Applies dropdown animation for _timeList using Tween object.
     */
    protected function displayPopUp(show:Boolean):void
    {
        var point:Point = new Point(0, unscaledHeight);
        point = localToGlobal(point);
        var endY:Number;
        var initY:Number;

        var point2:Point = this.localToGlobal(new Point(0, height-20));
            _timeList.move(point2.x + _dropButton.width, point2.y);

        if(show)
        {
            _showList = true;
            if (_timeList.parent == null)
                PopUpManager.addPopUp(_timeList, this);
            else
                PopUpManager.bringToFront(_timeList);

            point = _timeList.parent.globalToLocal(point);

            if (point.y + _timeList.height > screen.height &&
                point.y > _timeList.height)
            {
                point.y -= (unscaledHeight + _timeList.height);
                initY = -_timeList.height;
            }
            else
            {
                initY = _timeList.height;
            }

            endY = 0;
        }
        else
        {

            if(_timeList.parent == null)
            {
                return;
            }
            point = _timeList.parent.globalToLocal(point);

            endY = (point.y + _timeList.height > screen.height
                               ? -_timeList.height
                               : _timeList.height);
            initY = 0;

            _timeList.resetDragScrolling();

            _showList = false;
        }

        _tween = new Tween(this, initY, endY, 300);
        _isTweening = true;

    }

    /**
     *  @private
     *  Calculates the size.
     */
    protected function getCanvasSize():Point
    {
        var point:Point = new Point();
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for (var i:int = 0; i<numChildrenLength; i++)
        {
            child = getChildAt(i) as UIComponent;
            if (child && child.visible) {
                point.x += child.getExplicitOrMeasuredWidth();
                if(point.y < child.getExplicitOrMeasuredHeight())
                {
                    if(child.name != "timeList")
                    {
                        point.y += child.getExplicitOrMeasuredHeight();
                    }
                }
            }
        }
        return point;
    }

    /**
     *  @private
     *  Calculates the size of child components whose visibilty is true.
     */
    protected function setComponentsSize():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for(var i:int = 0; i < numChildrenLength; i++)
        {
            child = getChildAt(i) as UIComponent;
            if (child) {
                if(child.visible)
                {
                    child.setActualSize(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());

                } else {
                    child.setActualSize(0, 0);
                }
            }
        }
    }

    /**
     *  @private
     *   Calculates the position of child components whose visibilty is true.
     */
    protected function moveComponents():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for(var i:int = 0; i < numChildrenLength; i++)
        {
            child = getChildAt(i) as UIComponent;
            if(child)
            {
                if(i != 0)
                {
                    var prevChild:UIComponent = UIComponent(getChildAt(i - 1))
                    child.move(prevChild.width + prevChild.x, 0);
                }
            }
        }
    }

    /**
     *  @private
     *  Tween update
     */
    mx_internal function onTweenUpdate(value:Number):void
    {
        if (_timeList)
        {
            _timeList.scrollRect = new Rectangle(0, value, _timeList.width, _timeList.height);
        }
    }

    /**
     *  @private
     *  Tween end
     */
    mx_internal function onTweenEnd(value:Number):void
    {
        _isTweening = false;
    }



    /**
     *  @private
     *  When resized or focused out, removes tween.
     */
    private function quickHidePopUp():void
    {
        _showList = false;
        PopUpManager.removePopUp(_timeList);
    }


    //------------------------------------------------------------
    //
    //  Overriden Method
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Calls invalidateSize() and invalidateDisplayList().
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        invalidateSize();
        invalidateDisplayList();
    }

    /**
     *  @private
     *  Creates child components.
     */
    override protected function createChildren():void
    {
        super.createChildren();

        //resize handler
        systemManager.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);

        if(!_dropButton)
        {
            _dropButton = new Button();
            _dropButton.width = 20;
            _dropButton.height = 20;
            _dropButton.addEventListener(MouseEvent.CLICK, dropButtonClickHandler);
            var iconClass:Class = TimeChooserIconFactory.getIcon("watch");
            var iconInstance:* = new iconClass();
            var wrapper:SpriteAsset = new SpriteAsset();
	        wrapper.addChild(iconInstance as DisplayObject);
            _dropButton.addChild(wrapper);
            addChild(_dropButton);
        }

        if(!_hourNumericStepper)
        {
            _hourNumericStepper = new HourNumericStepper();
            _hourNumericStepper.name = "hour"
            _hourNumericStepper.addEventListener(Event.CHANGE, hourChangeHandler);
            _hourNumericStepper.minimum = 1;
            _hourNumericStepper.value = 12;
            _hourNumericStepper.maximum = 12;
            addChild(_hourNumericStepper);
        }

        if(!_minuteNumericStepper)
        {
            _minuteNumericStepper = new MinuteNumericStepper();
            _minuteNumericStepper.name = "minute"
            _minuteNumericStepper.addEventListener(Event.CHANGE, minuteChangeHandler);
            addChild(_minuteNumericStepper);
        }

        if(!_apm)
        {
            _apm = new Button();
            _apm.width = 20;
            _apm.height = 20;
            _apm.addEventListener(MouseEvent.CLICK, apmButtonClickHandler);
            var iconClass:Class = TimeChooserIconFactory.getIcon("sun");
            var iconInstance:* = new iconClass();
            var wrapper:SpriteAsset = new SpriteAsset();
            wrapper.addChild(iconInstance as DisplayObject);
            _apm.addChild(wrapper);
            _apmChecker = "AM";
            addChild(_apm);
        }

        if(!_timeList)
        {
            _timeList = new List();
            _timeList.width = 90;
            _timeList.name = "timeList";
            _timeList.addEventListener(ListEvent.CHANGE, timeListClickHandler);
            _timeList.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, timeList_mouseDownOutsideHandler, false, 0, true);
            _timeList.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, timeList_mouseWheelOutsideHandler, false, 0, true);
            _timeList.dataProvider = _timeListData;
        }
    }

    /**
     *  @private
     *  Measures size.
     */
    override protected function measure():void
    {
        super.measure();

        var point:Point = getCanvasSize();

        measuredWidth = measuredMinWidth = point.x;
        measuredHeight = measuredMinHeight = point.y;
    }

    /**
     *  @private
     *  updateDisplayList
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);
        setComponentsSize();
        moveComponents();
    }

    //------------------------------------------------------------
    //
    //  Event Listener
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Calls displayPopUp() method based on  _showList and _isTweening's value.
     */
    private function dropButtonClickHandler(event:MouseEvent):void
    {
        var hour:String = digitString(_hourNumericStepper.value);
        var minute:String = digitString(_minuteNumericStepper.value, true);
        var timeString:String = hour + minute + _apmChecker;

        for each(var item:Object in _timeList.dataProvider)
        {
            if(item.data == timeString)
            {
                _timeList.selectedItem = item;
                break;
            }
        }

        if(!_showList && !_isTweening)
        {
            displayPopUp(true);
        }
        else if(_showList && !_isTweening)
        {
            displayPopUp(false);
        }

        _timeList.verticalScrollPosition = _timeList.selectedIndex;
    }

    /**
     *  @private
     *  Minute NumericStepper's change handler.
     */
    private function minuteChangeHandler(event:Event):void
    {
        quickHidePopUp();
    }

    /**
     *  @private
     *  Hour NumericStepper's change handler.
     */
    private function hourChangeHandler(event:Event):void
    {
        quickHidePopUp();
    }

    /**
     *  @private
     *  Browser resize handler.
     *  if <code>_showList</code> is true, removes popup.
     */
    private function stage_resizeHandler(event:Event):void
    {
        if(_showList)
        {
            quickHidePopUp();
        }
    }

    /**
     *  @private
     *  mouse downOutside handler.
     */
    private function timeList_mouseDownOutsideHandler(event:MouseEvent):void
    {
        if (event.target != _timeList)
        {
            return;
        }

        if (!hitTestPoint(event.stageX, event.stageY, true))
        {
            quickHidePopUp();
        }
    }

    /**
     *  @private
     *  Mouse wheel outside handler.
     */
    private function timeList_mouseWheelOutsideHandler(event:MouseEvent):void
    {
        timeList_mouseDownOutsideHandler(event);
    }

    /**
     *  @private
     *  Event handler that takes care of timeList's change event.
     */
    protected function timeListClickHandler(event:ListEvent):void
    {
        displayPopUp(false);

        var rowData:Object = event.target.selectedItem.data;
        var hour:int = int(rowData.substr(0, 2));
        var minute:int = int(rowData.substr(2, 2));
        var apmText:String = rowData.substr(4, 2);

        _hourNumericStepper.value = hour;
        _minuteNumericStepper.value = minute;
        _apmChecker = apmText;
    }

    /**
     *  @private
     *  _apm button's click handler
     */
    protected function apmButtonClickHandler(event:MouseEvent):void
    {
        if(_apmChecker == "AM")
    	{
    		_apmChecker = "PM";
    	}
    	else
    	{
    		_apmChecker = "AM";
    	}
        quickHidePopUp();

        var iconClass:Class
        var iconInstance:*
        var wrapper:SpriteAsset = new SpriteAsset();

        if(_apmChecker == "AM") {
            iconClass = TimeChooserIconFactory.getIcon("sun");
            iconInstance = new iconClass();
            wrapper.addChild(iconInstance as DisplayObject);
            _apm.addChild(wrapper);
        } else {
            iconClass = TimeChooserIconFactory.getIcon("moon");
            iconInstance = new iconClass();
            wrapper.addChild(iconInstance as DisplayObject);
            _apm.addChild(wrapper);
        }
    }
}
}