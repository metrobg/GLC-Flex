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
import flash.display.DisplayObject;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import mx.charts.LinearAxis;
import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.PolarChart;
import mx.charts.chartClasses.PolarTransform;
import mx.charts.chartClasses.Series;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
import mx.core.IUIComponent;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

import org.openzet.charts.chartClasses.IRadarAxisRenderer;
import org.openzet.charts.renderers.RadarLineRenderer;

use namespace mx_internal;

/**
 *  Custom PolarChart that implements radar series features.
 * 
 *  @includeExample RadarChartExample.mxml
 */
public class RadarChart extends PolarChart
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

		var radarChartStyle:CSSStyleDeclaration =
			HaloDefaults.createSelector("RadarChart");

		var radarChartSeriesStyles:Array = [];

		radarChartStyle.defaultFactory = function():void
		{
			this.axisColor = 0xD5DEDD;
			this.chartSeriesStyles = radarChartSeriesStyles;
			this.dataTipRenderer = DataTip;
			this.fill = new SolidColor(0xFFFFFF, 0);
			this.fontSize = 10;
			this.angularAxisStyleName = "hangingCategoryAxis";
			this.textAlign = "left";
			this.radialAxisStyleName = "blockNumericAxis";
		}

		var n:int = HaloDefaults.defaultColors.length;
	    for (var i:int = 0; i < n; i++)
		{
			var styleName:String = "haloRadarSeries" + i;
			radarChartSeriesStyles[i] = styleName;

			var o:CSSStyleDeclaration =
				HaloDefaults.createSelector("." + styleName);

			var f:Function = function(o:CSSStyleDeclaration, stroke:Stroke):void
			{
				o.defaultFactory = function():void
				{
					this.lineStroke = stroke;
					this.stroke = stroke;
					this.lineSegmentRenderer = new ClassFactory(RadarLineRenderer);
				}
			}

			f(o, new Stroke(HaloDefaults.defaultColors[i], 3, 1));
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
    public function RadarChart()
    {
        super();
        
        seriesFilters = [ new DropShadowFilter(2, 45, 0.2 * 0xFFFFFF) ];
        
		var ra:LinearAxis = new LinearAxis();
		radialAxis = ra;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    private var _computedGutters:Rectangle = new Rectangle();

    /**
     *  @private
     */
    private var _bAxisStylesDirty:Boolean = true;
            
    /**
     *  @private
     */
    private var _bAxesRenderersDirty:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  computedGutters
    //----------------------------------
    [Inspectable(environment="none")]

    /**
     *  The current computed size of the gutters of the RadarChart.
     *  The gutters represent the area between the padding
     *  and the data area of the chart, where the titles and axes render.
     *  By default, the gutters are computed dynamically.
     *  You can set explicit values through the gutter styles.
     *  The gutters are computed to match any changes to the chart
     *  when it is validated by the LayoutManager.
     */
    public function get computedGutters():Rectangle
    {
        return _computedGutters;
    }

    //----------------------------------
    //  radialAxisRenderers
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the radialAxisRenderers property.
     */
    private var _radialAxisRenderer:IRadarAxisRenderer;
    
    [Inspectable(category="Data", arrayType="org.openzet.charts.chartClasses.IRadarAxisRenderer")]

    /**
     */
    public function get radialAxisRenderer():IRadarAxisRenderer
    {
        return _radialAxisRenderer;
    }

    /**
     *  @private
     */
    public function set radialAxisRenderer(value:IRadarAxisRenderer):void
    {
        if (_radialAxisRenderer)
            if (DisplayObject(_radialAxisRenderer).parent == this)
                removeChild(DisplayObject(_radialAxisRenderer));

        _radialAxisRenderer = value;
        
        if(_radialAxisRenderer.axis)
            radialAxis = _radialAxisRenderer.axis;

        _bAxisStylesDirty = true;
        _bAxesRenderersDirty = true;
        
        invalidateChildOrder();
        invalidateProperties();
    }

    //----------------------------------
    //  angularAxisRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the angularAxisRenderer property.
     */
    private var _angularAxisRenderer:IRadarAxisRenderer;
    
    [Inspectable(category="Data", arrayType="org.openzet.charts.chartClasses.IRadarAxisRenderer")]

    /**
     */
    public function get angularAxisRenderer():IRadarAxisRenderer
    {
        return _angularAxisRenderer;
    }

    /**
     *  @private
     */
    public function set angularAxisRenderer(value:IRadarAxisRenderer):void
    {
        if (_angularAxisRenderer)
        {
            if (DisplayObject(_angularAxisRenderer).parent == this)
                removeChild(DisplayObject(_angularAxisRenderer));
        }

        _angularAxisRenderer = value;
        
        if(_angularAxisRenderer.axis)
            angularAxis = _angularAxisRenderer.axis;
            
        _bAxesRenderersDirty = true;
        _bAxisStylesDirty=true;

        invalidateChildOrder();
        invalidateProperties();
    }

    //----------------------------------
    //  startAngle
    //----------------------------------

    /**
     *  @private
     *  Storage for the startAngle property.
     */
    private var _startAngle:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the starting angle for the first slice of the RadarChart control.
     *  The default value is 0,
     */
    public function get startAngle():Number
    {
        return _startAngle * 180 / Math.PI;
    }

    /**
     *  @private
     */
    public function set startAngle(value:Number):void
    {
        _startAngle = value % 360;
        if (_startAngle < 0)
            _startAngle += 360;
        
        invalidateProperties();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     */
    override protected function commitProperties():void
    {
        var i:Number;

        if(!_radialAxisRenderer)
            radialAxisRenderer = new RadialAxisRenderer();
        if(!_angularAxisRenderer)
            angularAxisRenderer = new AngularAxisRenderer();

        if (_bAxesRenderersDirty)
        {
            var addIndex:int = dataTipLayerIndex - 1;
            
            if(_radialAxisRenderer)
                addChildAt(DisplayObject(_radialAxisRenderer), addIndex);
            
            if(_angularAxisRenderer)
                addChildAt(DisplayObject(_angularAxisRenderer), addIndex);
            
            invalidateDisplayList();

            if (_transforms)
            {
                PolarTransform(_transforms[0]).setAxis(PolarTransform.RADIAL_AXIS, radialAxis);
                PolarTransform(_transforms[0]).setAxis(PolarTransform.ANGULAR_AXIS, angularAxis);                        
            }

            if(_radialAxisRenderer)
                _radialAxisRenderer.axis = radialAxis;
            if(_angularAxisRenderer)
                _angularAxisRenderer.axis = angularAxis;

        }

        super.commitProperties();
    }

    /**
     *  @inheritDoc
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        graphics.clear();

        updateAxisLayout(unscaledWidth, unscaledHeight);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  private
     */
    protected function updateAxisLayout(unscaledWidth:Number,
                                      unscaledHeight:Number):void
    {
        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");
                                         
        var adjustable:Object = [];
    
        var rcElements:Rectangle;

        var i:int = 0;
        var n:int = 0;

        var offset:Object = {left:0, top:0, right: 0, bottom: 0};
        
        if(_radialAxisRenderer)
        {
            _radialAxisRenderer.setActualSize(unscaledWidth - paddingLeft - paddingRight, unscaledHeight - paddingTop - paddingBottom);
            _radialAxisRenderer.move(paddingLeft, paddingTop);
        }

        if(_angularAxisRenderer)
        {       
            _angularAxisRenderer.setActualSize(unscaledWidth - paddingLeft - paddingRight, unscaledHeight - paddingTop - paddingBottom);
            _angularAxisRenderer.move(paddingLeft, paddingTop);
        }
        
        _computedGutters = new Rectangle();
        adjustable.left = false;
        adjustable.right = false;
        adjustable.top = false;
        adjustable.right = false;

        _computedGutters = _angularAxisRenderer.adjustGutters(_computedGutters, adjustable);
        _computedGutters = _radialAxisRenderer.adjustGutters(_computedGutters, adjustable);
        
        rcElements = new Rectangle(_computedGutters.left + paddingLeft,
                                   _computedGutters.top + paddingTop,
                                   unscaledWidth - _computedGutters.right - paddingRight -
                                   (_computedGutters.left + paddingLeft),
                                   unscaledHeight - _computedGutters.bottom - paddingBottom -
                                   (_computedGutters.top + paddingTop));
    
        if (_transforms)
        {
            for (i = 0; i < _transforms.length; i++)
            {
                _transforms[i].setSize(rcElements.width,rcElements.height);
            }
        }
        
        n = allElements.length;
        for (i = 0; i < n; i++)
        {
            var c:DisplayObject = allElements[i];
            if (c is IUIComponent)
            {
                (c as IUIComponent).setActualSize(rcElements.width, rcElements.height);
            }
            else
            {
                c.width = rcElements.width;
                c.height = rcElements.height;
            }
            
            if (c is Series && Series(c).dataTransform)
                PolarTransform((c as Series).dataTransform).setSize(rcElements.width,rcElements.height);
            /* if (c is IDataCanvas)
            	PolarTransform((c as Object).dataTransform).setSize(rcElements.width, rcElements.height); */
        }

        if (_seriesHolder.mask)
        {
            _seriesHolder.mask.width = rcElements.width;
            _seriesHolder.mask.height = rcElements.height;
        }
        
        if (_backgroundElementHolder.mask)
        {
            _backgroundElementHolder.mask.width = rcElements.width;
            _backgroundElementHolder.mask.height = rcElements.height;
        }
        
        if (_annotationElementHolder.mask)
        {
            _annotationElementHolder.mask.width = rcElements.width;
            _annotationElementHolder.mask.height = rcElements.height;
        }
        
        _seriesHolder.move(rcElements.left, rcElements.top);
        _backgroundElementHolder.move(rcElements.left, rcElements.top);
        _annotationElementHolder.move(rcElements.left, rcElements.top);
        
    }
  
    override protected function measure():void
    {
        super.measure();
        
        if(_angularAxisRenderer)
            measuredMinHeight = _angularAxisRenderer.minHeight + 40;
        
        if(_radialAxisRenderer)
            measuredMinWidth = _radialAxisRenderer.minWidth + 40;
    }
}
}