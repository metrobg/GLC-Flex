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
package org.openzet.controls.numberRollerClasses
{

import mx.containers.Canvas;
import mx.containers.VBox;
import mx.controls.Label;
import mx.effects.Move;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="horizontalLineScrollSize", kind="property")]
[Exclude(name="horizontalPageScrollSize", kind="property")]
[Exclude(name="horizontalScrollBar", kind="property")]
[Exclude(name="horizontalScrollPolicy", kind="property")]
[Exclude(name="horizontalScrollPosition", kind="property")]
[Exclude(name="maxHorizontalScrollPosition", kind="property")]
[Exclude(name="maxVerticalScrollPosition", kind="property")]
[Exclude(name="verticalLineScrollSize", kind="property")]
[Exclude(name="verticalPageScrollSize", kind="property")]
[Exclude(name="verticalScrollBar", kind="property")]
[Exclude(name="verticalScrollPolicy", kind="property")]
[Exclude(name="verticalScrollPosition", kind="property")]

public class NumberRollerInstance extends Canvas
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NumberRollerInstance()
    {
        super();
        horizontalScrollPolicy = "off";
        verticalScrollPolicy = "off";
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Previous Value
     */
    private var prevValue:int = 0;

    /**
     *  @private
     *  Keeps track of whether we need to update
     *  the value in commitProperties().
     */
    private var valueChanged:Boolean;

    /**
     *  @private
     *  Label Container
     */
    private var container:VBox;

    /**
     *  @private
     *  Move Effect Instance
     */
    private var moveTween:Move;

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
     *  Current value displayed in the text area of the NumberRollerInstance control.
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
     *  The easing function for the animation.
     */
    public var easingFunction:Function = null;

    //--------------------------------------------------------------------------
    //
    //  initialize
    //
    //--------------------------------------------------------------------------



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
        if (!container)
        {
            container = new VBox();
            container.setStyle("horizontalAlign", "center");
            container.setStyle("verticalAlign", "middle");

            var instance:Label;
            for (var i:int = 0; i < 10; i ++)
            {
                instance = new Label();
                instance.text = String(i);
                container.addChild(instance);
                container.width = instance.textWidth;
                container.height = instance.textHeight;
            }
            addChild(container);
        }
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

            callLater(showCurrentValue);
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        width = container.getExplicitOrMeasuredWidth() / 2;
        height = container.getExplicitOrMeasuredHeight() / 10;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  value에 들어온 데이터를 화면에 보여준다.
     */
    private function showCurrentValue():void
    {
        if (!initialized)
        {
            callLater(showCurrentValue);
            return;
        }

        var toLabel:Label = Label(container.getChildAt(_value));
        moveTween = new Move(container);
        moveTween.yFrom = container.y;
        moveTween.yTo = -toLabel.y;
        moveTween.duration = _duration;
        moveTween.easingFunction = easingFunction
        //Debug.trace("easingFunction : " + easingFunction);
        moveTween.play();
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------


}
}