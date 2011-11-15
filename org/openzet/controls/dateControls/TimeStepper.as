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
    
import flash.geom.Point;

import mx.controls.Label;
import mx.core.UIComponent;
import mx.events.NumericStepperEvent;

/**
 *  Custom component to display hour for ZetDateField control.
 */
public class TimeStepper extends UIComponent
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function TimeStepper()
    {
        super();
        
        visible = false;
    }

    //------------------------------------------------------------
    //
    //  Variables
    //
    //------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _hourLabel:Label;
    
    /**
     *  @private
     */
    private var _minuteLabel:Label;
    
    //------------------------------------------------------------
    //
    //  Properties
    //
    //------------------------------------------------------------
    
    /**
     *  @private
     */
    protected var _hourNumericStepper:HourNumericStepper;
    
    /**
     *  Hour NumericStepper
     */
    public function get hourStepper():HourNumericStepper
    {
        return _hourNumericStepper;
    }
    
    /**
     *  @private
     */
    protected var _minuteNumericStepper:MinuteNumericStepper;

    /**
     *  Minute NumericStepper
     */
    public function get minuteStepper():MinuteNumericStepper
    {
        return _minuteNumericStepper;
    }

    //--------------------------------------------------------------------------
    //
    //  Method
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Caculates the position of child controls.
     */
    private function getCanvasSize():Point
    {
        var point:Point = new Point();
        var numChildrenLength:int = numChildren;
        var child:UIComponent;
        for (var i:int = 0; i<numChildrenLength; i++)
        {
            child = getChildAt(i) as UIComponent;
            if (child) {
                point.x += child.getExplicitOrMeasuredWidth();
                if(point.y < child.getExplicitOrMeasuredHeight())
                {
                    point.y += child.getExplicitOrMeasuredHeight();
                }
            }
        }
        return point;
    }
    /**
     *  @private
     *  Sets ths position for each child control.
     */
    private function setComponentsSize():void
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
     *  Sets the position for each child control.
     */
    private function moveComponents():void
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
                    UIComponent(getChildAt(i)).move(UIComponent(getChildAt(i - 1)).width + UIComponent(getChildAt(i - 1)).x, 0);
                }
            }
        }
        
        //arrangeLabel();
    }
    
    /**
     *  @private 
     *  Sets the label's position. 
     */
    protected function arrangeLabel():void
    {
        _hourLabel.y = measuredHeight / 2 - _hourLabel.height / 2;
        _minuteLabel.y = measuredHeight / 2 - _minuteLabel.height / 2;
    }
    /**
     *  @private 
     *  Dispatches an event when hour changes. 
     */
    private function hourChangedHandler(event:NumericStepperEvent):void
    {
        dispatchEvent(event);
    }
    /**
     *  @private
     *  Dispatches an event when minute changes.
     */
    private function minuteChangedHandler(event:NumericStepperEvent):void
    {
        dispatchEvent(event);
    }
    /**
     *  @private 
     *  Internally manges the visibility of hour and minute numeric steppers.
     */
    private function set showChildren(value:Boolean):void
    {
        _hourNumericStepper.visible = value;
        _minuteNumericStepper.visible = value;
    }
    
    //------------------------------------------------------------
    //
    //  Overriden Method
    //
    //------------------------------------------------------------

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
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if(!_hourNumericStepper)
        {
            _hourNumericStepper = new HourNumericStepper();
            _hourNumericStepper.name = "hour"
            _hourNumericStepper.addEventListener(NumericStepperEvent.CHANGE, hourChangedHandler);
            addChild(_hourNumericStepper);
            
            //_hourLabel = new Label();
            //_hourLabel.text = "시";
            //addChild(_hourLabel);
        }
        if(!_minuteNumericStepper)
        {
            _minuteNumericStepper = new MinuteNumericStepper();
            _minuteNumericStepper.name = "minute"
            _minuteNumericStepper.addEventListener(NumericStepperEvent.CHANGE, minuteChangedHandler);
            addChild(_minuteNumericStepper);
            
            //_minuteLabel = new Label();
            //_minuteLabel.text = "분";
            //addChild(_minuteLabel);
        }
        
        showChildren = visible;
        invalidateSize();
        invalidateDisplayList();
        
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
}
}