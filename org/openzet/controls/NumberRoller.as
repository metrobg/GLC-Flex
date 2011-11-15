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

import mx.containers.HBox;

import org.openzet.controls.numberRollerClasses.NumberRollerInstance;

public class NumberRoller extends HBox
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function NumberRoller()
    {
        super();
        setStyle("horizontalAlign", "right");
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Keeps track of whether we need to update
     *  the value in commitProperties().
     */
    private var valueChanged:Boolean;

    /**
     *  @private
     *  Keeps track of whether we need to update
     *  the value in commitProperties().
     */
    private var easingFunctionChanged:Boolean;

    /**
     *  @private
     *  Previous Value
     */
    private var prevValue:int = 0;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _value:int = 0;

    /**
     *  @private
     */
    public function set value(value:int):void
    {
        _value = value;
        valueChanged = true;

        invalidateProperties();
    }

    [Inspectable(category="General", defaultValue="0")]
    /**
     *  Current value displayed in the text area of the NumberRoller control.
     */
    public function get value():int
    {
        return _value;
    }

    /**
     *  @private
     */
    private var _duration:Number = 1000;

    /**
     *  @private
     */
    public function set duration(value:Number):void
    {
        _duration = value;
    }

    [Inspectable(category="General", defaultValue="1000")]
    /**
     *  Duration of the animation, in milliseconds.
     */
    public function get duration():Number
    {
        return _duration;
    }

    /**
     *  @private
     */
    private var _easingFunction:Function;

    /**
     *  @private
     */
    public function set easingFunction(value:Function):void
    {
        _easingFunction = value;

    }

    /**
     *  The easing function for the animation.
     */
    public function get easingFunction():Function
    {
        return _easingFunction;
    }

    //--------------------------------------------------------------------------
    //
    //  Override Methods
    //
    //--------------------------------------------------------------------------

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
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (valueChanged)
        {
            valueChanged = false;

            var unitGap:int = _value.toString().length - prevValue.toString().length;

            if (prevValue == 0)
            {
                removeAllChildren();
                setInstance(_value.toString().length);
            }
            else if (unitGap != 0)
            {
                setInstance(unitGap);
            }
            prevValue = _value;

            setInstanceData();
        }

        if (easingFunctionChanged)
        {
            for (var i:int = 0; i < getChildren().length; i++)
            {
                NumberRollerInstance(getChildAt(i)).easingFunction = easingFunction;
            }
        }
    }

    /**
     *  @private
     *
     */
    override protected function measure():void
    {
        super.measure();
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  prevValue와 _value의 단위가 다를경우 NumberRollerInstance를 가감한다.
     */
    private function setInstance(value:int):void
    {
        var i:int;
        if (value > 0)
        {
            for (i = 0; i < value; i++)
            {
                var instance:NumberRollerInstance = new NumberRollerInstance();
                addChildAt(instance, 0);
            }
        }
        else if (value < 0)
        {
            for (i = 0; i < Math.abs(value); i++)
            {
                removeChildAt(0);
            }
        }
    }

    /**
     *  @private
     *  생성된 NumberRollerInstance Property를 변경한다.
     */
    private function setInstanceData():void
    {
        for (var i:int = 0; i < getChildren().length; i++)
        {
            NumberRollerInstance(getChildAt(i)).value = int(_value.toString().substr(i, 1));
            NumberRollerInstance(getChildAt(i)).duration = _duration;
            NumberRollerInstance(getChildAt(i)).easingFunction = easingFunction;
        }
    }
}
}