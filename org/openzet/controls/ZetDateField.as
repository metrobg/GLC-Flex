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

import flash.events.TextEvent;
import flash.geom.Point;

import mx.core.UIComponent;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.NumericStepperEvent;

import org.openzet.controls.dateControls.DateControlDash;
import org.openzet.controls.dateControls.DateField;
import org.openzet.controls.dateControls.MonthDateField;
import org.openzet.controls.dateControls.TimeStepper;
import org.openzet.events.ZetDateFieldEvent;
import org.openzet.utils.DateUtil;

/**
 * Custom component that includes controls to display dates, hours, and a range of dates, such as
 * startDate and endDate.
 */
public class ZetDateField extends UIComponent
{
    include "../core/Version.as";

    //------------------------------------------------------------
    //
    //  Constructor
    //
    //------------------------------------------------------------
    /**
     *  constructor
     */
    public function ZetDateField()
    {
        super();
        createComponents();
    }

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private const YYYY:String = "YYYY";

    /**
     *  @private
     */
    private const MM:String = "MM";

    /**
     *  @private
     */
    private const DD:String = "DD";

    /**
     *  @private
     */
    private const DAY:String = "DAY";

    /**
     *  @private
     */
    private const MONTH:String = "MONTH";

    /**
     *  @private
     */
    private const WEEK:String = "WEEK";

    /**
     *  @private
     */
    private const YEARS:String = "YEARS";

    /**
     *  @private
     */
    private const WEEK_LENGTH:uint = 7;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  DateField for start date.
     */
    protected var _startDateField:DateField;

    /**
     *  @private
     *  DateField for end date.
     */
    protected var _endDateField:DateField;

    /**
     *  @private
     *  DateField for start month.
     */
    protected var _startMonthDateField:MonthDateField;

    /**
     *  @private
     *  DateField for end month.
     */
    protected var _endMonthDateField:MonthDateField;

    /**
    *   @private
     *  TimeStepper for start time.
     */
    protected var _startTime:TimeStepper;

    /**
     *  @private
     *  TimeStepper for end time.
     */
    protected var _endTime:TimeStepper;

    /**
     *  @private
     *  Dash control between start and date date.
     */
    protected var _dash:DateControlDash;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  formatString
    //----------------------------------

    /**
     *  @private
     */
    protected var _formatString:String = "YYYYMMDD";

    /**
     *  Format string of date.
     *  @default "YYYYMMDD"
     */
    public function get formatString():String
    {
        return _formatString;
    }

    /**
     *  @private
     */
    public function set formatString(value:String):void
    {
        _formatString = value;
    }

    //----------------------------------
    //  startDate
    //----------------------------------

    /**
     *  Start date string.
     */
    public function get startDate():String
    {
        if(_startDateField.visible)
        {
            return DateUtil.dateToString(_startDateField.selectedDate, formatString);
        }
        else if(_startMonthDateField.visible)
        {
            if(formatString == YYYY)
            {
                return DateUtil.dateToString(_startDateField.selectedDate, YYYY);
            } else if(formatString == MM)
            {
                return DateUtil.dateToString(_startDateField.selectedDate, MM);
            }
            else if(formatString == DD)
            {
                return null;
            }
            return DateUtil.dateToString(_startDateField.selectedDate, "YYYYMM");
        }
        else
        {
            return null;
        }
    }

    /**
     *  @private
     */
    public function set startDate(value:String):void
    {
        if(!_startDateField.visible && !_startMonthDateField)
        {
            return;
        }
        _startDateField.selectedDate = DateUtil.stringToDate(value);
        _startMonthDateField.yearStepper.value = _startDateField.selectedDate.getFullYear();
        _startMonthDateField.monthComboBox.selectedIndex = _startDateField.selectedDate.getMonth();
        validateStartDate();
        validateStartMonthStepper();
        validateStartMonthCombo();
    }

    //----------------------------------
    //  startYear
    //----------------------------------

    /**
     *  Start year string.
     */
    public function get startYear():String
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_startDateField.selectedDate, YYYY);
    }

    /**
     *  @private
     */
    public function set startYear(value:String):void
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _startDateField.selectedDate;
        var newDate:Date = new Date(value, currentDate.getMonth(), currentDate.getDate());
        _startDateField.selectedDate = newDate;
        _startMonthDateField.yearStepper.value = Number(value);
    }

    //----------------------------------
    //  startYear
    //----------------------------------

    /**
     *  Start month string.
     */
    public function get startMonth():String
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_startDateField.selectedDate, MM);
    }

    /**
     *  @private
     */
    public function set startMonth(value:String):void
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _startDateField.selectedDate;
        var newDate:Date = new Date(currentDate.getFullYear(), Number(value) - 1, currentDate.getDate());
        _startDateField.selectedDate = newDate;
        _startMonthDateField.yearStepper.value = Number(value);
    }

    //----------------------------------
    //  startDay
    //----------------------------------

    /**
     *  start day string.
     */
    public function get startDay():String
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_startDateField.selectedDate, DD);
    }

    /**
     *  @private
     */
    public function set startDay(value:String):void
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _startDateField.selectedDate;
        var newDate:Date = new Date(currentDate.getFullYear(), currentDate.getMonth(), value);
        _startDateField.selectedDate = newDate;
    }

    //----------------------------------
    //  endDate
    //----------------------------------

    /**
     *  End date string.
     */
    public function get endDate():String
    {
        if(_endDateField.visible)
        {
            return DateUtil.dateToString(_endDateField.selectedDate, formatString);
        }
        else if(_endMonthDateField.visible)
        {
            if(formatString == YYYY)
            {
                return DateUtil.dateToString(_endDateField.selectedDate, YYYY);
            } else if(formatString == MM)
            {
                return DateUtil.dateToString(_endDateField.selectedDate, MM);
            }
            else if(formatString == DD)
            {
                return null;
            }
            return DateUtil.dateToString(_endDateField.selectedDate, "YYYYMM");
        }
        else
        {
            return null;
        }
    }

    /**
     *  @private
     */
    public function set endDate(value:String):void
    {
        _endDateField.selectedDate = DateUtil.stringToDate(value);
        _endMonthDateField.yearStepper.value = _endDateField.selectedDate.getFullYear();
        _endMonthDateField.monthComboBox.selectedIndex = _endDateField.selectedDate.getMonth();
        validateEndDate();
        validateEndMonthStepper();
        validateEndMonthCombo();
    }

    //----------------------------------
    //  endYear
    //----------------------------------

    /**
     *  End year string.
     */
    public function set endYear(value:String):void
    {
        if(!_endDateField.visible && !_endMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _endDateField.selectedDate;
        var newDate:Date = new Date(value, currentDate.getMonth(), currentDate.getDate());
        _endDateField.selectedDate = newDate;
        _endMonthDateField.yearStepper.value = Number(value);
    }

    /**
     *  @private
     */
    public function get endYear():String
    {
        if(!_endDateField.visible && !_endMonthDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_endDateField.selectedDate, YYYY);
    }

    //----------------------------------
    //  endMonth
    //----------------------------------

    /**
     *  End month string.
     **/
    public function get endMonth():String
    {
        if(!_endDateField.visible && !_endMonthDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_endDateField.selectedDate, MM);
    }

    /**
     *  @private
     */
    public function set endMonth(value:String):void
    {
        if(!_endDateField.visible && !_endMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _endDateField.selectedDate;
        var newDate:Date = new Date(currentDate.getFullYear(), Number(value) - 1, currentDate.getDate());
        _endDateField.selectedDate = newDate;
        _endMonthDateField.yearStepper.value = Number(value);
    }

    //----------------------------------
    //  endDay
    //----------------------------------

    /**
     *  End day string.
     */
    public function get endDay():String
    {
        if(!_endDateField.visible)
        {
            return null;
        }
        return DateUtil.dateToString(_endDateField.selectedDate, DD);
    }

    /**
     *  @private
     */
    public function set endDay(value:String):void
    {
        if(!_startDateField.visible && !_startMonthDateField.visible)
        {
            return;
        }
        var currentDate:Date = _endDateField.selectedDate;
        var newDate:Date = new Date(currentDate.getFullYear(), currentDate.getMonth(), value);
        _endDateField.selectedDate = newDate;
    }

    //----------------------------------
    //  startHour
    //----------------------------------

    /**
     *  start hour string.
     */
    public function get startHour():Object
    {
        if(!_startTime.visible)
        {
            return null;
        }

        var startHour:String;

        startHour = "" + _startTime.hourStepper.value;

        if (startHour.length == 1)
        {
            startHour = "0" + startHour;
        }

        return startHour;
    }

    /**
     *  @private
     */
    public function set startHour(value:Object):void
    {
       var s:String;
       if(value is String)
       {
           s = value as String;
       }
       else if(value is Number)
       {
           s = value.toString();
       }
       else
       {
           return;
       }

       if(s.length > 2 || s.length < 1 || int(s) > 23)
       {
           return;
       }

       _startTime.hourStepper.value = int(s);
    }

    //----------------------------------
    //  endHour
    //----------------------------------

    /**
     *  End hour string.
     */
    public function get endHour():Object
    {
        if(!_endTime.visible)
        {
            return null;
        }

        var endHour:String;

        endHour = "" + _endTime.hourStepper.value;

        if (endHour.length == 1)
        {
            endHour = "0" + endHour;
        }

        return endHour;
    }

    /**
     *  @private
     */
    public function set endHour(value:Object):void
    {
       var s:String;
       if(value is String)
       {
           s = value as String;
       }
       else if(value is Number)
       {
           s = value.toString();
       }
       else
       {
           return;
       }

       if(s.length > 2 || s.length < 1 || int(s) > 23)
       {
           return;
       }

       _endTime.hourStepper.value = int(s);
    }

    //----------------------------------
    //  startMinute
    //----------------------------------

    /**
     *  Start minute string.
     */
    public function get startMinute():Object
    {
        if(!_startTime.visible)
        {
            return null;
        }

        var startMinute:String;

        startMinute = "" + _startTime.minuteStepper.value;

        if (startMinute.length == 1)
        {
            startMinute = "0" + startMinute;
        }

        return startMinute;
    }

    //----------------------------------
    //  endMinute
    //----------------------------------

    /**
     *  End minute string.
     */
    public function get endMinute():Object
    {
        if(!_endTime.visible)
        {
            return null;
        }

        var endMinute:String;

        endMinute = "" + _endTime.minuteStepper.value;

        if (endMinute.length == 1)
        {
            endMinute = "0" + endMinute;
        }

        return endMinute;
    }

    //----------------------------------
    //  showMonthField
    //----------------------------------

    /**
     *  @private
     */
    private var _showMonthField:Boolean = false;

    /**
     *  @private
     */
    private var _showMonthFieldChanged:Boolean = false;

    /**
     *  @private
     */
    public function set showMonthField(value:Boolean):void
    {
        _showMonthField = value;

        _showMonthFieldChanged = true;

        invalidateProperties();
    }

    /**
     *  Flag to specify whether to show year and month only.
     *  @default false
     */
    public function get showMonthField():Boolean
    {
    	return _showMonthField;
    }

    //----------------------------------
    //  horizontalGap
    //----------------------------------

    /**
     *  @private
     */
    private var _horizontalGap:Number = 0;

    /**
     *  @private
     */
    private var _horizontalGapChanged:Boolean = false;

    /**
     *  Horizontal gap between controls.
     *  @default 0
     */
    public function get horizontalGap():Number
    {
        return _horizontalGap;
    }

    /**
     *  @private
     */
    public function set horizontalGap(value:Number):void
    {
        if(_horizontalGap == value)
        {
            return;
        }
        _horizontalGap = value;
        _horizontalGapChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  selectableRange
    //----------------------------------

    /**
     *  @private
     */
    private var _selectableRange:String;

    /**
     *  @private
     */
    private var _selectableRangeChanged:Boolean = false;

    /**
     *  Selectable range criteria.
     */
    public function get selectableRange():String
    {
        return _selectableRange;
    }

    /**
     *  @private
     */
    public function set selectableRange(value:String):void
    {
        _selectableRange = value;
        _selectableRangeChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  showStartDate
    //----------------------------------

    /**
     *  @private
     */
    private var _showStartDate:Boolean = true;

    /**
     *  @private
     */
    private var _showStartDateChanged:Boolean = false;

    /**
     *  Flag to show start date.
     *  @default true
     */
    public function get showStartDate():Boolean
    {
        return _showStartDate;
    }

    /**
     *  @private
     */
    public function set showStartDate(value:Boolean):void
    {
        _showStartDate = value;
        _showStartDateChanged = true;
        _selectableRangeChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  showEndDate
    //----------------------------------

    /**
     *  @private
     */
    private var _showEndDate:Boolean = true;

    /**
     *  @private
     */
    private var _showEndDateChanged:Boolean = false;

    /**
     *  Flag to show end date.
     *  @default true
     */
    public function get showEndDate():Boolean
    {
        return _showEndDate;
    }

    /**
     *  @private
     */
    public function set showEndDate(value:Boolean):void
    {
        _showEndDate = value;
        _showEndDateChanged = true;
        _selectableRangeChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  showTime
    //----------------------------------

    /**
     *  @private
     */
    private var _showTime:Boolean = false;

    /**
     *  @private
     */
    private var _showTimeChanged:Boolean = false;

    /**
     *  Flag to show time.
     *  @default false
     */
    public function get showTime():Boolean
    {
        return _showTime
    }

    /**
     *  @private
     */
    public function set showTime(value:Boolean):void
    {
        _showTime = value;
        _showTimeChanged = true;

        invalidateProperties();
    }

    //------------------------------------------------------------
    //
    //  Method
    //
    //------------------------------------------------------------

    /**
     *  @private
     *  Creates child controls.
     */
    protected function createComponents():void
    {
        _startDateField = new DateField();
        _startDateField.addEventListener(CalendarLayoutChangeEvent.CHANGE, startDate_changeHandler);
        _startDateField.minYear = 1900;
        _startDateField.maxYear = 2100;
        //_startDateField.editable = true;
        //_startDateField.addEventListener(TextEvent.TEXT_INPUT, startDateField_changeHandler);
        addChild(_startDateField);

        _startMonthDateField = new MonthDateField();
        _startMonthDateField.addEventListener(ZetDateFieldEvent.CHANGE_DATE, startMonthFieldChangedHandler);
        addChild(_startMonthDateField);

        _startTime = new TimeStepper();
        _startTime.addEventListener(NumericStepperEvent.CHANGE, startTime_changedHandler);
        addChild(_startTime);

        _dash = new DateControlDash();
        addChild(_dash);

        _endDateField = new DateField();
        _endDateField.minYear = 1900;
        _endDateField.maxYear = 2100;
        //_endDateField.editable = true;
        //_endDateField.addEventListener(TextEvent.TEXT_INPUT, endDateField_changeHandler);
        _endDateField.addEventListener(CalendarLayoutChangeEvent.CHANGE, endDate_changeHandler);
        addChild(_endDateField);

        _endMonthDateField = new MonthDateField();
        _endMonthDateField.addEventListener(ZetDateFieldEvent.CHANGE_DATE, endMonthFieldChangedHandler);
        addChild(_endMonthDateField);

        _endTime = new TimeStepper();
        _endTime.addEventListener(NumericStepperEvent.CHANGE, endTime_changedHandler);
        addChild(_endTime);
    }

    /**
     *  @private
     *  Event handler method for start month change.
     */
    private function startMonthFieldChangedHandler(event:ZetDateFieldEvent):void
    {
        _startDateField.selectedDate = DateUtil.stringToMonth(_startMonthDateField.getCurrentMonthDate());
        validateStartDate();
        validateStartMonthStepper();
        validateStartMonthCombo();
    }

    /**
     *  @private
     *   Event handler method for end month change.
     */
    private function endMonthFieldChangedHandler(event:ZetDateFieldEvent):void
    {
        _endDateField.selectedDate = DateUtil.stringToMonth(_endMonthDateField.getCurrentMonthDate());
        validateEndDate();
        validateEndMonthStepper();
        validateEndMonthCombo();
    }

    /**
     *  @private
     *  Checks whether start month is greater than end month.
     */
    private function validateStartMonthStepper():void
    {
        if(_endMonthDateField.yearStepper.value < _startMonthDateField.yearStepper.value)
        {
            _endMonthDateField.yearStepper.value = _startMonthDateField.yearStepper.value;
        }
    }

    /**
     *  @private
     *  Checks whether start month is greater than end month
     */
    private function validateStartMonthCombo():void
    {
        if(_endMonthDateField.yearStepper.value <= _startMonthDateField.yearStepper.value)
        {
            if(_endMonthDateField.monthComboBox.selectedIndex < _startMonthDateField.monthComboBox.selectedIndex)
            {
                _endMonthDateField.monthComboBox.selectedIndex = _startMonthDateField.monthComboBox.selectedIndex;
            }
        }
    }

    /**
     *  @private
     *  Checks whether end month is greater than end month.
     */
    private function validateEndMonthStepper():void
    {
        if(_endMonthDateField.yearStepper.value < _startMonthDateField.yearStepper.value)
        {
            _startMonthDateField.yearStepper.value = _endMonthDateField.yearStepper.value;
        }
    }

    /**
     *  @private
     *  Checks whether end month is greater than end month.
     */
    private function validateEndMonthCombo():void
    {
        if(_endMonthDateField.yearStepper.value <= _startMonthDateField.yearStepper.value)
        {
            if(_startMonthDateField.monthComboBox.selectedIndex > _endMonthDateField.monthComboBox.selectedIndex)
            {
                _startMonthDateField.monthComboBox.selectedIndex = _endMonthDateField.monthComboBox.selectedIndex;
            }
        }
    }

    /**
     *  @private
     *  Prevents from setting start month a value greater than end month.
     */
    private function setDateRange():void
    {
        _endDateField.disabledRanges = [getEndDateFieldRange()];
    }

    /**
     *  @private
     *  Sets range based on Day, Week and Month.
     */
    private function setCustomDateRange():void
    {
        _endDateField.disabledRanges = [getEndDateFieldRange(), getCustomRange()];
    }

    /**
     *  @private
     *  Retries selectable range for Day, Week and Month.
     */
    public function getCustomRange():Object
    {
        var range:Object = {};
        var customString:String = _selectableRange.toLocaleUpperCase();

        if(customString.indexOf(DAY) != -1)
        {
            range.rangeStart = getCustomDayRange(customString);
        }
        if(customString.indexOf(WEEK) != -1)
        {
            range.rangeStart = getCustomWeekRange(customString);
        }
        if(customString.indexOf(MONTH) != -1)
        {
            range.rangeStart = getCustomMonthRange(customString);
        }

        range.rangeEnd = new Date(2100, 0, 1);

        return range;
    }

    /**
     *  @private
     *  Sets day range
     */
    private function getCustomDayRange(value:String):Date
    {
        var customRange:Object = new Object();
        var customString:String = value;
        var num:Number;
        num = Number(customString.substr(0, customString.indexOf(DAY)));

        if(!isNaN(num))
        {

        var date:Date = new Date(
            _startDateField.selectedDate.getFullYear(),
            _startDateField.selectedDate.getMonth(),
            _startDateField.selectedDate.getDate() + num);

        }

        return date;
    }

    /**
     *  @private
     *  Sets week range.
     */
    private function getCustomWeekRange(value:String):Object
    {
        var customRange:Object = new Object();
        var customString:String = value;
        var num:Number = Number(customString.substr(0, customString.indexOf(WEEK)));

        if(!isNaN(num))
        {
            var date:Date = new Date(
            _startDateField.selectedDate.getFullYear(),
            _startDateField.selectedDate.getMonth(),
            _startDateField.selectedDate.getDate() + (num * WEEK_LENGTH));
        }

        return date;
    }

    /**
     *  @private
     *  Sets month range.
     */
    private function getCustomMonthRange(value:String):Object
    {
        var customRange:Object = new Object();
        var customString:String = value;
        var num:Number;
        num = Number(customString.substr(0, customString.indexOf(MONTH)));
        if(!isNaN(num))
        {
            var date:Date = new Date(
            _startDateField.selectedDate.getFullYear(),
            _startDateField.selectedDate.getMonth() + num,
            _startDateField.selectedDate.getDate());
        }
        return date;
    }

    /**
     *  @private
     *  Sets year range.
     */
    private function getCustomYearRange(value:String):Object
    {
        var customRange:Object = new Object();
        var customString:String = value;
        var num:Number;
        num = Number(customString.substr(0, customString.indexOf(YEARS)));
        if(!isNaN(num))
        {
            var date:Date = new Date(
            _startDateField.selectedDate.getFullYear() + num,
            _startDateField.selectedDate.getMonth(),
            _startDateField.selectedDate.getDate());
        }
        return date;
    }

    /**
     *  @private
     *  Prevents end month from being earlier than start month and returns a range object.
     */
    private function getEndDateFieldRange():Object
    {
        var range:Object = {};
        range.rangeStart = new Date(1900, 1, 1);
        range.rangeEnd = new Date(
        _startDateField.selectedDate.getFullYear(),
        _startDateField.selectedDate.getMonth(),
        _startDateField.selectedDate.getDate() - 1);
        return range;
    }

    /**
     *  @private
     *  Checks start date.
     */
    private function validateStartDate():void
    {
        if (_endDateField.selectedDate < _startDateField.selectedDate)
        {
            _endDateField.selectedDate = _startDateField.selectedDate;
        }
    }

    /**
     *  @private
     *  Checks whether start date is earlier than end date.
     */
    private function validateEndDate():void
    {
        if (_startDateField.selectedDate > _endDateField.selectedDate)
        {
            _startDateField.selectedDate = _endDateField.selectedDate;
        }
    }

    /**
     *  @private
     *  Calculates child controls' area.
     */
    protected function getCanvasSize():Point
    {
        var point:Point = new Point();
        var numChildrenLength:int = numChildren;
        var visibleNumChildren:int;
        var totalHorizontalGapSize:Number;
        var child:UIComponent;
        for (var i:int = 0; i<numChildrenLength; i++)
        {
            child = UIComponent(getChildAt(i)) as UIComponent;
            if(child)
            {
                if(child.visible)
                {
                    visibleNumChildren ++;
                    point.x += child.getExplicitOrMeasuredWidth();
                    if(point.y < child.getExplicitOrMeasuredHeight())
                    {
                        point.y += child.getExplicitOrMeasuredHeight();
                    }
                }

            }
        }
        totalHorizontalGapSize = getHorizontalGapSize(visibleNumChildren);
        point.x += totalHorizontalGapSize;
        return point;
    }

    /**
     *  @private
     *  Gets the total horizontalGap value.
     */
    private function getHorizontalGapSize(numChildrenLength:int):Number
    {
        return _horizontalGap * (numChildrenLength - 1);
    }

    /**
     *  @private
     *  Calculates size.
     */
    protected function setComponentsSize():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for(var i:int = 0; i < numChildrenLength; i++)
        {
            child = UIComponent(getChildAt(i)) as UIComponent;
            if(child)
            {

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
     *  Repositions child controls.
     */
    protected function moveComponents():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;

        for(var i:int = 0; i < numChildrenLength; i++)
        {
            var width:Number;
            child = UIComponent(getChildAt(i)) as UIComponent;
            if(child)
            {
                if(i != 0)
                {
                    if(!_showMonthField)
                    {
                        width = UIComponent(getChildAt(i - 1)).width + UIComponent(getChildAt(i - 1)).x;

                        if(child.visible)
                        {
                            width += _horizontalGap;
                        }
                        if(i == 1 && !_showStartDate)
                        {
                            width -= _horizontalGap;
                        }
                        child.move(width, 0);
                    }
                    else
                    {
                        width = UIComponent(getChildAt(i - 1)).width + UIComponent(getChildAt(i - 1)).x;

                        if(child.visible)
                        {
                            width += _horizontalGap;
                        }
                        if(i == 1)
                        {
                            width -= _horizontalGap;
                        }
                        child.move(width, 0);
                    }
                }
            }
        }

        //Places dash in the vertical center.
        arrangeMiddleToDash();
    }

    /**
     *  @private
     *  Validates start date based on endDateField's values.
     */
    private function checkHasStartDate():void
    {
        if(!_startDateField.selectedDate)
        {
            _startDateField.selectedDate = _endDateField.selectedDate;
        }
    }

    /**
     *  @private
     *  Places Dash in the middle.
     */
    protected function arrangeMiddleToDash():void
    {
        if(_dash.visible)
        {
            _dash.y = measuredHeight / 2;
        }
    }

    /**
     *  @private
     *  Renders dash conditionally.
     */
    protected function showOrHideDash():void
    {
        if (showStartDate && showEndDate)
        {
            _dash.visible = true;
        }
        else
        {
            _dash.visible = false;
        }
    }

    /**
     *  @private
     *  Checks start hour.
     */
    private function validateStartHour():void
    {
        if(_startTime.hourStepper.value > _endTime.hourStepper.value)
        {
            _endTime.hourStepper.value = _startTime.hourStepper.value;
        }
    }

    /**
     *  @private
     *  Checks start minute.
     */
    private function validateStartMinute():void
    {
        if(_startTime.minuteStepper.value > _endTime.minuteStepper.value)
        {
            _endTime.minuteStepper.value = _startTime.minuteStepper.value;
        }
    }

    /**
     *  @private
     *  Checks end hour.
     */
    private function validateEndHour():void
    {
        if(_startTime.hourStepper.value > _endTime.hourStepper.value)
        {
            _startTime.hourStepper.value = _endTime.hourStepper.value;
        }
    }

    /**
     *  @private
     *  Checks end minute
     */
    private function validateEndMinute():void
    {
        if(_startTime.hourStepper.value >= _endTime.hourStepper.value)
        {
            if(_startTime.minuteStepper.value > _endTime.minuteStepper.value)
            {
                _startTime.minuteStepper.value = _endTime.minuteStepper.value;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Event handler for start year and month's change.
     */
    private function startDateField_changeHandler(event:TextEvent):void {}

    /**
     *  @private
     *  Event handler for end year and month's change.
     */
    private function endDateField_changeHandler(event:TextEvent):void {}

    /**
     *  @private
     *  Event handler for start time's change.
     */
    private function startTime_changedHandler(event:NumericStepperEvent):void
    {
        validateStartHour();
        validateStartMinute();
    }
    /**
     *  @private
     *  Event handler for end time's change.
     */
    private function endTime_changedHandler(event:NumericStepperEvent):void
    {
        validateEndHour();
        validateEndMinute();
    }
    /**
     *  @private
     *  Event handler for start date's change.
     */
    private function startDate_changeHandler(event:CalendarLayoutChangeEvent):void
    {
        validateStartDate();
        validateStartMonthStepper();
        validateStartMonthCombo();
        deriveStartYearForMonthField();
        deriveStartMonthForMonthField();
        if(showStartDate && showEndDate)
        {
            setDateRange();
        }
    }

    /**
     *  @private
     *  Event handler for end date's change.
     */
    private function endDate_changeHandler(event:CalendarLayoutChangeEvent):void
    {
        validateEndDate();
        validateEndMonthStepper();
        validateEndMonthCombo();
        deriveEndYearForMonthField();
        deriveEndMonthForMonthField();
        //End year
        checkHasStartDate();

        if(showStartDate && showEndDate)
        {
            setDateRange();
        }
        if(_selectableRange && showStartDate && showEndDate)
        {
            setCustomDateRange();
        }
    }

    /**
     *  @private
     */
    private function deriveStartMonthForMonthField():void
    {
        _startMonthDateField.monthComboBox.selectedIndex = int(startMonth) - 1;
    }

    /**
     *  @private
     */
    private function deriveEndMonthForMonthField():void
    {
        _endMonthDateField.monthComboBox.selectedIndex = int(endMonth) - 1;
    }

    /**
     *  @private
     */
    private function deriveStartYearForMonthField():void
    {
          //if startDateField changes, synchronizes startMonthDateField's yearStepper value.
        _startMonthDateField.yearStepper.value = int(startYear);
    }

    /**
     *  @private
     */
    private function deriveEndYearForMonthField():void
    {
        //if endDateField changes, synchronizes endMonthDateField's yearStepper value.
        _endMonthDateField.yearStepper.value = int(endYear);
    }

    /**
     *  @private
     *  Shows or hides Timer.
     */
    private function showOrHideTimer():void
    {
        if(showTime)
        {
            _startTime.visible = showStartDate;
            _endTime.visible = showEndDate;
        }
        else
        {
            _startTime.visible = false;
            _endTime.visible = false;
        }
    }

    //------------------------------------------------------------
    //
    //  Overridden Method
    //
    //------------------------------------------------------------
    /**
     *  @private
     *  COMMITE PROPERTIES
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        showOrHideDash();

        if(_horizontalGapChanged)
        {
            _horizontalGapChanged = false;
        }

        if(_showStartDateChanged)
        {
            if(_showMonthField)
            {
                _startMonthDateField.visible = showStartDate;
                _startDateField.visible = false;
            }
            else
            {
                _startMonthDateField.visible = false;
                _startDateField.visible = showStartDate;
            }
            _showStartDateChanged = false;
        }

        if(_showEndDateChanged)
        {
            if(_showMonthField)
            {
                _endDateField.visible = false;
                _endMonthDateField.visible = showEndDate;
            }
            else
            {
                _endDateField.visible = showEndDate;
                _endMonthDateField.visible = false;
            }
            _showEndDateChanged = false;
        }

        if(_showTimeChanged)
        {
            _showTimeChanged = false;
        }

        if(_showMonthFieldChanged)
        {
            if(_showMonthField)
            {
                _startDateField.visible = false;
                _endDateField.visible = false;

                _startMonthDateField.visible = _showStartDate;
                _endMonthDateField.visible = _showEndDate;
            }
            else
            {
                _startDateField.visible = _showStartDate;
                _endDateField.visible = _showEndDate;

                _startMonthDateField.visible = false;
                _endMonthDateField.visible = false;
            }
            _showMonthFieldChanged = false;
        }

        if(_selectableRangeChanged)
        {
            if(showStartDate && showEndDate)
            {
                setCustomDateRange();
            }
            _selectableRangeChanged = false;

        }

        showOrHideDash();
        showOrHideTimer();
        invalidateSize();
        invalidateDisplayList();
    }

    /**
     *  @private
     *  UPDATE DISPLAY
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);

        setComponentsSize();
        moveComponents();
    }

    /**
     *  @private
     *  MEASURE
     */
    override protected function measure():void
    {
        super.measure();

        var point:Point = getCanvasSize();

        measuredWidth = measuredMinWidth = point.x;
        measuredHeight = measuredMinHeight = point.y;
    }
}
}