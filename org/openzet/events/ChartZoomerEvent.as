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
package org.openzet.events
{

import flash.events.Event;

/**
 *  Event class used for ChartZoomer.
 */
public class ChartZoomerEvent extends Event
{
    include "../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    /**
     *  The <code>ZoomInChartEvent.DIVIDER_CHANGE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>dividerChange</code> event.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myZoomInChart.addEventListener()</code> to register an event listener, 
     *       myZoomIn is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>leftValue</code></td><td>Left point in CenterArea The ZoomInChart componenet
     *       <code>value</code> property.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>rightValue</code></td><td>Right point in CenterArea of The ZoomInChart component
     *       <code>value</code> property.</td></tr>
     *  </table>
     *
     *  @eventType dividerChange
     */
    public static const DIVIDER_CHANGE:String = "dividerChange";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function ChartZoomerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, leftValue:int = 0, rightValue:int = 0)
    {
        super(type, bubbles, cancelable);

        this.leftValue = leftValue;
        this.rightValue = rightValue;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    /**
     *  Target chart's dataProvider start index.
     */
    public var leftValue:int;
    
    /**
     *   Target chart's dataProvider end index.
     */
    public var rightValue:int;
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function clone():Event
    {
        return new ChartZoomerEvent(type, bubbles, cancelable, leftValue, rightValue);
    }
}

}
