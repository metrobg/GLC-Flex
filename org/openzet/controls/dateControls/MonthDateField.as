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
package org.openzet.controls.dateControls
{
import flash.events.Event;
import flash.geom.Point;

import mx.core.UIComponent;
import mx.events.NumericStepperEvent;

import org.openzet.events.ZetDateFieldEvent;

/**
 *  Custom component to display only year and month for ZetDateField control.
 */
public class MonthDateField extends UIComponent
{   
    include "../../core/Version.as";

    //----------------------------------------------------------------------
    //
    //  Constructor
    //  
    //----------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function MonthDateField()
    {
        super();
        
        visible = false;
    }
    
    //----------------------------------------------------------------------
    //
    //  Variables
    //
    //----------------------------------------------------------------------
    
    
    
    
    //----------------------------------------------------------------------
    //
    //  Properties
    //
    //----------------------------------------------------------------------
    
    /**
     *  @private
     */
    protected var _yearStepper:YearNumericStepper;
    
    /**
     *  @private
     */
    public function set yearStepper(value:YearNumericStepper):void
    {
        _yearStepper = value;
    }
    
    /**
     * NumberricStepper to use for year.
     */
    public function get yearStepper():YearNumericStepper
    {
        return _yearStepper;
    }
    
    /**
     *  @private
     */
    protected var _monthComboBox:ComboBox;
    
    /**
     *  @private
     */
    public function set monthComboBox(value:ComboBox):void
    {
        _monthComboBox = value;
    }
    
    /**
     *  ComboBox to display month.
     */
    public function get monthComboBox():ComboBox
    {
        return _monthComboBox;
    }
    
    //----------------------------------------------------------------------
    //
    //  Overridden Method
    //  
    //----------------------------------------------------------------------

    /** 
     *  @private
     */
    override public function set visible(value:Boolean):void
    {
        super.visible = value;
        invalidateProperties();
    }
    
    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();
    } 
    
    /**
     *  @private
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
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);
        setComponentsSize();
        moveComponents();
    } 
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        if(!_yearStepper)
        {
            _yearStepper = new YearNumericStepper();
            _yearStepper.addEventListener(NumericStepperEvent.CHANGE, valueChangeHandler);
            addChild(_yearStepper);
        }
        if(!_monthComboBox)
        {
            _monthComboBox = new ComboBox();
            _monthComboBox.addEventListener(Event.CHANGE, valueChangeHandler);
            addChild(_monthComboBox);
        }
        invalidateSize();
        invalidateDisplayList();
    }
    
    //----------------------------------------------------------------------
    //
    //  Method
    //  
    //----------------------------------------------------------------------
    
    /**
     *  @private
     *  Sets the layout of child controls.
     */
    private function getCanvasSize():Point
    {
        var point:Point = new Point();
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for (var i:int = 0; i<numChildrenLength; i++)
        {
            if(getChildAt(i) is UIComponent)
            {
                child = UIComponent(getChildAt(i)) as UIComponent;
                if(child)
                {
                    point.x += UIComponent(getChildAt(i)).getExplicitOrMeasuredWidth();
                    if(point.y < UIComponent(getChildAt(i)).getExplicitOrMeasuredHeight())
                    {
                        point.y += UIComponent(getChildAt(i)).getExplicitOrMeasuredHeight();
                    }
                }
            }
        }
        
        return point;
    }
    /**
     *  @private
     *  Sets the size for each child control.
     */
    private function setComponentsSize():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for(var i:int = 0; i < numChildrenLength; i++)
        {
            if(getChildAt(i) is UIComponent)
            {
                child = UIComponent(getChildAt(i)) as UIComponent;
                if(child)
                {
                    if(UIComponent(getChildAt(i)).visible)
                    {
                        UIComponent(getChildAt(i)).setActualSize(UIComponent(getChildAt(i)).getExplicitOrMeasuredWidth(), 
                                                                 UIComponent(getChildAt(i)).getExplicitOrMeasuredHeight());
                    
                    } else {
                        UIComponent(getChildAt(i)).setActualSize(0, 0);
                    }
                }
            }
        }
    }
    /**
     *  @private
     *  Sets the position of each child control.
     */
    private function moveComponents():void
    {
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for(var i:int = 0; i < numChildrenLength; i++)
        {
            if(getChildAt(i) is UIComponent)
            {
                child = UIComponent(getChildAt(i)) as UIComponent;
                if(child)
                {
                    
                    if(i != 0)
                    {
                        UIComponent(getChildAt(i)).move(UIComponent(getChildAt(i - 1)).width + UIComponent(getChildAt(i - 1)).x, 0);
                    }
                }
            }
        }
    }
    
    /**
     *  @private
     */
    private function valueChangeHandler(event:Event):void
    {
        var e:ZetDateFieldEvent = new ZetDateFieldEvent(ZetDateFieldEvent.CHANGE_DATE);
        dispatchEvent(e);
    }
    
    /**
     * Returns current year and month as String.
     */
    public function getCurrentMonthDate():String
    {
        var year:String = String(_yearStepper.value); 
        var month:String = String(_monthComboBox.selectedItem);
        if(month.length == 1)
        {
            month = "0" + String(_monthComboBox.selectedItem);
        }
        return year + month;
    }
}
}