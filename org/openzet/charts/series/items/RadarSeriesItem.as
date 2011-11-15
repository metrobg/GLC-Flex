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
package org.openzet.charts.series.items
{
import flash.geom.Point;

import mx.charts.ChartItem;
import mx.charts.chartClasses.IChartElement;
import mx.core.mx_internal;
import mx.graphics.IFill;

import org.openzet.charts.series.RadarSeries;

use namespace mx_internal;

/**
 * Custom ChartItem class to represent chart Items for RadarSeries.
 */
public class RadarSeriesItem extends ChartItem
{
    include "../../../core/Version.as";
    
    public function RadarSeriesItem(element:IChartElement = null, data:Object = null, index:uint = 0)
    {
        super(element, data, index);
    }
    
    //----------------------------------
    //  origin
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     * 
     */
    public var origin:Point;
    
    //----------------------------------
    //  radius
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     * 
     */
    public var radius:Number;
    
    //----------------------------------
    //  angle
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The angle of this item.
     */
    public var angle:Number;

    //----------------------------------
    //  value
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     * 
     */
    public var value:Object;
    
    //----------------------------------
    //  number
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     * 
     */
    public var number:Number;
    
    //----------------------------------
    //  filter
    //----------------------------------
    
    [Inspectable(environment="none")]

    /**
     *  @private
     *  You cannot change this property's name since RadialSeries' updateFilter method references the value by this property name 
     */
    public var filter:Number;

    //----------------------------------
    //  startAngle
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The startAngle of this item.
     */
    public var startAngle:Number;
        
    //----------------------------------
    //  x
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     * @private
     */
    public var x:Number;
    
    //----------------------------------
    //  y
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     * @private
     */
    public var y:Number;
    
    //----------------------------------
    //  fill
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The fill value associated with this wedge of the PieChart control.
     */
    public var fill:IFill;
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Returns a copy of this ChartItem.
     */
    override public function clone():ChartItem
    {		
    	var result:RadarSeriesItem = new RadarSeriesItem(RadarSeries(element),item,index);
    	result.itemRenderer = itemRenderer;
    	return result;
    }
}
}