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
package org.openzet.charts
{
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.chartClasses.ChartElement;
import mx.charts.chartClasses.ChartState;
import mx.charts.styles.HaloDefaults;
import mx.core.mx_internal;
import mx.graphics.IStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

import org.openzet.charts.chartClasses.IRadarAxisRenderer;

use namespace mx_internal;


//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the line style for angular lines.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 */
[Style(name="angularStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Specifies the direction of the radar lines.
 *  Allowable values are <code>radial</code>,
 *  <code>angular</code>, or <code>both</code>. 
 *  The default value is <code>both</code>.  
 */
[Style(name="direction", type="String", enumeration="radial,angular,both", inherit="no")]

/**
 *  Specifies the line style for radial lines.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 */
[Style(name="radialStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Specifies the fill pattern for alternating radar bands
 *  not defined by the <code>fill</code> property.
 *  Use the IFill class to define the properties of the fill
 *  as a child tag in MXML, or create an IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>0xFAFAFA</code>.
 */
[Style(name="radarAlternateFill", type="uint", format="Color", inherit="no")]

/**
 *  Specifies the fill pattern for every other radar band
 *  created by the radar lines.
 *  Use the IFill class to define the  properties of the fill
 *  as a child tag in MXML, or create a IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>0xFFFFFF</code>.
 */
[Style(name="radarFill", type="uint", format="Color", inherit="no")]

/**
 * Custom ChartElement class for a RadarChart control.
 * 
 *  <pre>
 *  &lt;mx:RadarLines
 *    <strong>Styles</strong>
 *     direction="angular|radial|both"
 *     angularStroke="<i>IStroke; No default</i>"
 *     radialStroke="<i>IStroke; No default</i>"
 *  /&gt;
 *  </pre>
 * 
 */
public class RadarLines extends ChartElement
{
    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var stylesInited:Boolean = initStyles();	
    
    /**
     *  @private
     */
    private static function initStyles():Boolean
    {
        HaloDefaults.init();
        
        var radarlinesStyleName:CSSStyleDeclaration = HaloDefaults.createSelector("RadarLines");
        
        radarlinesStyleName.defaultFactory = function():void
        {
            this.direction = "both";
            this.radialStroke = new Stroke(0xEEEEEE, 0);
            this.angularStroke = new Stroke(0xEEEEEE, 0);
            this.radarFill = 0xFFFFFF;
            this.radarAlternateFill = 0xFAFAFA;
        }
        
        return true;
    }
 
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
    public function RadarLines()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (!chart || chart.chartState == ChartState.PREPARING_TO_HIDE_DATA
                   || chart.chartState == ChartState.HIDING_DATA)
        {
            return;
        }
        
        var g:Graphics = this.graphics;
        g.clear();
        
        var i:Number;
        var c:Object;
        var len:int;
        var raN:Number;
        var spacing:Array /* of Number */;
        var axisLength:Number;
        var stroke:IStroke;
        var changeCount:int;
        var colors:Array /* of IFill */;
        var rc:Rectangle;
        var addedFirstLine:Boolean;
        var addedLastLine:Boolean;
        var direction:String = getStyle("direction");

        changeCount = 1;//Math.max(1, getStyle("horizontalChangeCount"));
        if ((changeCount * 0 != 0) || changeCount <= 1)
            changeCount = 1;
        	
        var radialAxisRenderer:IRadarAxisRenderer;
        radialAxisRenderer = RadarChart(chart).radialAxisRenderer;

        var ticks:Array /* of Number */ = radialAxisRenderer.ticks;//.concat();

        spacing = ticks;

        addedFirstLine = false;
        addedLastLine = false;

        if (spacing[0] != 0)
        {
            addedFirstLine = true;
            spacing.unshift(0);
        }
        
        if (spacing[spacing.length - 1] != 1)
        {
            addedLastLine = true;
            spacing.push(1);
        }
        
        axisLength = Math.min(unscaledWidth, unscaledHeight) / 2;
        colors = [ getStyle("radarFill"), getStyle("radarAlternateFill") ];

        len = spacing.length;

        var pCenter:Point = new Point(unscaledWidth / 2, unscaledHeight /2);
        
        var tempData:Object = RadarChart(chart).dataProvider;
        if (!tempData) return;
        var lengthData:Number = tempData.length;
        
        for (i = 0; i < spacing.length; i += changeCount)
        {
            var idx:int = len - 1 - i;
            c = colors[(i / changeCount) % 2];
            var r:Number = spacing[idx] * axisLength;
            
            if (c != null)
            {
                if (direction == "both" || direction == "angular") {
                    stroke = getStyle("angularStroke");
                    stroke.apply(g);
                } else {
                    g.lineStyle(0, 0, 0);
                }
            
                g.beginFill(uint(c));
                
                for (var j:Number = 0 ; j < lengthData ; j++) {
                    raN = (360 / lengthData) * j * (Math.PI / 180);
                    if (j == 0) {
                        g.moveTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
                    } else {
                        g.lineTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
                    }
                }

                if (direction == "angular") {
                    raN = 0;
                    g.lineTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
                }
            }
        }
        
        if (direction == "both" || direction == "radial")
        {    
            stroke = getStyle("radialStroke");
            stroke.apply(g);
            for (j = 0 ; j < lengthData ; j++) {
                raN = (360 / lengthData) * j * (Math.PI / 180);
                g.moveTo(pCenter.x, pCenter.y);
                g.lineTo(Math.cos(raN) * axisLength + pCenter.x, Math.sin(raN) * axisLength + pCenter.y);
            }        
        }
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: ChartElement
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function mappingChanged():void
	{
		invalidateDisplayList();
	}
	
	/**
	 *  @private
	 */
	override public function chartStateChanged(oldState:uint,
											   newState:uint):void
	{
		invalidateDisplayList();
	}
}
}