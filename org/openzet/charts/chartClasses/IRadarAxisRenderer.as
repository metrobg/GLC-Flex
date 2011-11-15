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
package org.openzet.charts.chartClasses
{

import flash.geom.Rectangle;

import mx.charts.chartClasses.IAxis;
import mx.core.IUIComponent;

/**
 * Custom Interface that defines methods used for RadarChart control.
 */
public interface IRadarAxisRenderer extends IUIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  axis
    //----------------------------------

    /**
     *  The axis object associated with this renderer.
     *  This property is managed by the enclosing chart,
     *  and should not be explicitly set.
     */ 
    function get axis():IAxis;
    
    /**
     *  @private
     */
    function set axis(value:IAxis):void;

    //----------------------------------
    //  ticks
    //----------------------------------
    
    /**
     *  Contains an array that specifies where Flex
     *  draws the tick marks along the axis.
     *  Each array element contains a value between 0 and 1. 
     */
    function get ticks():Array /* of Number */;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Adjusts its layout to accomodate the gutters passed in.
     *  This method is called by the enclosing chart to determine
     *  the size of the gutters and the corresponding data area.
     *  This method provides the AxisRenderer with an opportunity
     *  to calculate layout based on the new gutters,
     *  and to adjust them if necessary.
     *  If a given gutter is adjustable, an axis renderer
     *  can optionally adjust the gutters inward (make the gutter larger)
     *  but not outward (make the gutter smaller).
     *
     *  @param workingGutters Defines the gutters to adjust.
     *
     *  @param adjustable Consists of four Boolean properties
     *  (left=true/false, top=true/false, right=true/false,
     *  and bottom=true/false) that indicate whether the axis renderer
     *  can optionally adjust each of the gutters further.
     *  
     *  @return A rectangle that defines the dimensions of the gutters, including the 
     *  adjustments.
     */
    function adjustGutters(workingGutters:Rectangle, adjustable:Object):Rectangle;

}
}