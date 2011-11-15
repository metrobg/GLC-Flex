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
package org.openzet.charts.series
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;

import mx.charts.HitData;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.PolarChart;
import mx.charts.chartClasses.PolarTransform;
import mx.charts.chartClasses.Series;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
import mx.core.ContextualClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

import org.openzet.charts.renderers.RadarLineRenderer;
import org.openzet.charts.series.items.RadarSeriesItem;
import org.openzet.charts.series.items.RadarSeriesSegment;
import org.openzet.charts.series.renderData.RadarSeriesRenderData;

use namespace mx_internal;

/**
 *  Sets the fill for this data series. You can specify either an object implementing the IFill interface, 
 *  or a number representing a solid color value. You can also specify a solid fill using CSS. 
 */
[Style(name="fill", type=" mx.graphics.IFill", format="Color", inherit="no")]

[Style(name="form", type="String", enumeration="segment,curve", inherit="no")]
  
/**
 *  A factory that represents the class the series will use to represent individual items on the chart. This class is instantiated once for each element in the chart.
 *	Classes used as an itemRenderer should implement the IFlexDisplayObject, ISimpleStyleClient, and IDataRenderer interfaces. The <code>data</code> property is assigned the 
 *	chartItem that the skin instance renders.
 */
[Style(name="itemRenderer", type="mx.core.IFactory", inherit="no")]

[Style(name="lineSegmentRenderer", type="mx.core.IFactory", inherit="no")]

[Style(name="lineStroke", type="mx.graphics.IStroke", inherit="no")]

[Style(name="radius", type="Number", format="Length", inherit="no")]

/**
 *  Defines a data series for a RadialChart control.
 *  By default, this class uses the RadialLineRenderer class. 
 *  Optionally, you can define an itemRenderer for the data series.
 *  The itemRenderer must implement the ILineRenderer interface.
 * 
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LineSeries&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:RadialSeries
 *    <strong>Properties</strong>
 *    radialField="null"
 * 
 *    <strong>Styles</strong>
 *    fill="0xFFFFFF" 
 *    itemRenderer="<i>itemRenderer</i>"
 *    lineSegmentRenderer="<i>RadialLineRenderer</i>"
 *    lineStroke="Stroke(0xE47801,3)"
 *    radius="4"
 *  /&gt;
 *  </pre>
 *  
 */
public class RadarSeries extends Series
{
    include "../../core/Version.as";
    
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

        var seriesStyle:CSSStyleDeclaration =
            HaloDefaults.createSelector("RadarSeries");   
            
        seriesStyle.defaultFactory = function():void
        {
            this.fill = new SolidColor(0xFFFFFF);
            this.lineStroke = new Stroke(0, 3);
            this.lineSegmentRenderer = new ClassFactory(RadarLineRenderer);
            this.radius = 4;
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
    public function RadarSeries()
    {
        super();
        
        _pointInstanceCache = new InstanceCache(null, this, 1000);
        _pointInstanceCache.creationCallback = applyItemRendererProperties;
        
        _segmentInstanceCache = new InstanceCache(null, this, 0);
        _segmentInstanceCache.properties = { styleName: this };
        
        _labelLayer = new UIComponent();
        _labelLayer.styleName = this;
        
        _labelCache = new InstanceCache(UITextField,_labelLayer);
        _labelCache.properties =
        {
            autoSize: TextFieldAutoSize.LEFT,
            selectable: false,
            styleName: this
        };
        _labelCache.discard = true;
        
        dataTransform = new PolarTransform();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _pointInstanceCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _segmentInstanceCache:InstanceCache;

    /**
     *  @private
     */
    private var _labelCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _labelLayer:UIComponent;
    
    /**
     *  @private
     */
    private var _renderData:RadarSeriesRenderData;

    /**
     *  @private
     */
    private var _origin:Point;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  legendData
    //----------------------------------

    /**
     *  @private
     */
    override public function get legendData():Array /* of LegendData */
    {
        //if(fillFunction!=defaultFillFunction || _fillCount!=0)
        //{
         //  var keyItems:Array /* of LegendData */ = [];
        //    return keyItems;
        //}
        //
        var radius:Number = getStyle("radius")
        var itemRenderer:IFactory = getStyle("itemRenderer");

        var markerAspectRatio:Number;
        var color:int = 0;
        var marker:IFlexDisplayObject;
        
        var ld:LegendData = new LegendData();
        ld.element = this;
        ld.label = displayName; 
        
        var markerFactory:IFactory = getStyle("legendMarkerRenderer");
        if (markerFactory)
        {
            marker = markerFactory.newInstance();
            if (marker is ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
            ld.aspectRatio = 1;
        }
        else if (!itemRenderer || radius == 0 || isNaN(radius))
        {
            marker = new RadialSeriesLegendMarker(this);          
        }
        else
        {
            markerFactory = getStyle("itemRenderer");
            marker = markerFactory.newInstance();
            ld.aspectRatio = 1;
            if (marker as ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
        }

        ld.marker = marker;
        
        return [ld];
    }

    //----------------------------------
    //  renderData
    //----------------------------------

    /**
     *  @private
     */
    override protected function get renderData():Object
    {
        if (!_renderData||
            !(_renderData.cache) ||
            _renderData.cache.length == 0)
        {
            var renderDataType:Class = this.renderDataType;
            var ld:RadarSeriesRenderData = new RadarSeriesRenderData();
            ld.cache = ld.filteredCache = [];
            ld.segments = [];
            return ld;
        }
        return _renderData;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  radialField
    //----------------------------------
    /**
     *  @private
     *  Storage for the radialField property.
     */
    private var _field:String = "";
    
    [Inspectable(category="General")]

    /**
     *  
     *  @default null
     */
    public function get field():String
    {
        return _field;
    }

    /**
     *  @private
     */
    public function set field(value:String):void
    {
        _field = value;
        dataChanged();
    }
    
    //----------------------------------
    //  angularField
    //----------------------------------
     /*
     *  @private
     *  Storage for the angularField property.
     */
   /*  private var _angularField:String = "";
    
    [Inspectable(category="General")]
 */
    /*
     *  
     *  @default null
     */
   /*  public function get angularField():String
    {
        return _angularField;
    } */

    /*
     *  @private
     */
    /* public function set angularField(value:String):void
    {
        _angularField = value;
        dataChanged();
    }  */

    //----------------------------------
    //  itemType
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The subtype of ChartItem used by this series
     *  to represent individual items.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information in the items.
     */
    protected function get itemType():Class
    {
        return RadarSeriesItem;
    }

    //----------------------------------
    //  lineSegmentType
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The class used by this series to store all data
     *  necessary to represent a line segment.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information for rendering.
     */
    protected function get radialSegmentType():Class
    {
        return RadarSeriesSegment;
    }
    
    //----------------------------------
    //  renderDataType
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The subtype of ChartRenderData used by this series
     *  to store all data necessary to render.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information for rendering.
     */
    protected function get renderDataType():Class
    {
        return RadarSeriesRenderData;
    }

    private var _bAxesDirty:Boolean = false;

 	//----------------------------------
    //  radialAxis
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the radialAxis property.
     */
    private var _radialAxis:IAxis;

    [Inspectable(category="Data")]
    
    /**
     */
    public function get radialAxis():IAxis
    {
        return _radialAxis;
    }   
    
    /**
     *  @private
     */
    public function set radialAxis(value:IAxis):void
    {
        _radialAxis = value;
        _bAxesDirty = true;

        invalidateData();
        invalidateProperties();
    }   

 	//----------------------------------
    //  angularAxis
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the angularAxis property.
     */
    private var _angularAxis:IAxis;

    [Inspectable(category="Data")]
    
    /**
     *  The axis object used to map data values to an angle
     *  between 0 and 2 * PI.
     *  By default, this is a linear axis with the <code>autoAdjust</code>
     *  property set to <code>false</code>.
     *  So, data values are mapped uniformly around the chart.
     */
    public function get angularAxis():IAxis
    {
        return _angularAxis;
    }   
    
    /**
     *  @private
     */
    public function set angularAxis(value:IAxis):void
    {
        _angularAxis = value;
        _bAxesDirty = true;

        invalidateData();
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
        super.commitProperties();
        _labelCache.factory = new ContextualClassFactory(UITextField, moduleFactory);
        
        if (_bAxesDirty)
        {
            if (dataTransform)
            {
                if(_radialAxis) {
                    _radialAxis.chartDataProvider = dataProvider;
                    PolarTransform(dataTransform).setAxis(PolarTransform.RADIAL_AXIS, _radialAxis);
                }
                if(_angularAxis) {
                    _angularAxis.chartDataProvider = dataProvider;
                    PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS, _angularAxis);
                }
            }
            _bAxesDirty = false; 
        }
        
        var c:PolarChart = PolarChart(chart);
        if(c)
        {
            if(!_radialAxis && dataTransform.axes[PolarTransform.RADIAL_AXIS] != c.radialAxis)
                PolarTransform(dataTransform).setAxis(PolarTransform.RADIAL_AXIS, c.radialAxis);
            if(!_angularAxis && dataTransform.axes[PolarTransform.ANGULAR_AXIS] != c.angularAxis)
                PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS, c.angularAxis);
        }
        
        dataTransform.elements = [this];
    }

    /**
     * @private
     */
    private function defaultFillFunction(element:RadarSeriesItem,i:Number):IFill
    {
        return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }

    /**
     *  @inheritDoc
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (!dataProvider)
        {
            //_labelCache.count = 0;
            return;
        }

        var renderData:RadarSeriesRenderData = (transitionRenderData)? RadarSeriesRenderData(transitionRenderData) : _renderData;
        if (!renderData || !(renderData.filteredCache))
            return;

        var g:Graphics = graphics;
        g.clear();
        //g.lineStyle(2, 0x00FF00);
        //g.drawRect(0, 0, unscaledWidth, unscaledHeight);
        
        var i:int;
        var renderCache:Array /* of RadialSeriesItem */ = renderData.filteredCache;
        var len:int = renderCache.length;
        var item:RadarSeriesItem;       
        var segCount:int = renderData.segments.length;
        var activeRenderCache:Array /* of RadialSeriesItem */;
    
        // SeriesSlide, SeriesZoom
        if (renderData == transitionRenderData && transitionRenderData.elementBounds)
        {
            
            var elementBounds:Array /* of Rectangle */ = renderData.elementBounds;
            len = elementBounds.length;
            activeRenderCache = renderData.filteredCache;

            for (i = 0; i < len; i++)
            {
                var rcBounds:Object = elementBounds[i];
                var localData:RadarSeriesItem = activeRenderCache[i];
                //localData.angle = (rcBounds.left + rcBounds.right)/2;
                //localData.radius = rcBounds.bottom;
            }
        }
        // SeriesInterpolate, no Effect
        else
        {
            activeRenderCache = renderData.filteredCache;
        }
        
        // now position each segment
        _segmentInstanceCache.factory = getStyle("lineSegmentRenderer");
        _segmentInstanceCache.count = segCount;
        var instances:Array = _segmentInstanceCache.instances;
        
        for (i = 0 ; i < segCount ; i++) {
            var segment:IFlexDisplayObject = instances[i];
            if (segment is IDataRenderer)
                IDataRenderer(segment).data = renderData.segments[i];
            segment.setActualSize(unscaledWidth, unscaledHeight);
        }
        
        // if the user has asked for markers at each datapoint, position those as well
        var radius:Number = getStyle("radius");
        if (radius > 0)
        {
            _pointInstanceCache.factory = getStyle("itemRenderer");
            _pointInstanceCache.count = renderData.filteredCache.length;         

            instances = _pointInstanceCache.instances;
            var nextInstanceIdx:int = 0;

            var bSetData:Boolean = (len > 0 && (instances[0] is IDataRenderer))

            var rc:Rectangle;
            var inst:IFlexDisplayObject;
            var raN:Number;
            
            if (renderData == transitionRenderData && renderData.elementBounds)
            {
                for (i = 0; i < len; i++)
                {
                    item  = activeRenderCache[i];
                    inst = instances[nextInstanceIdx++];
                    item.itemRenderer = inst;
                    
                    if(!(item.fill))
                        item.fill = defaultFillFunction(item, i);

                    if(item.itemRenderer && (item.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (item.itemRenderer as Object).invalidateDisplayList();
                    
                    if (inst)
                    {
                        if (bSetData)
                            IDataRenderer(inst).data = item;

                        raN = item.angle * (Math.PI / 180);         
                        inst.move(Math.cos(raN) * (item.radius) + (_origin.x - radius), Math.sin(raN) * (item.radius) + (_origin.y - radius));
                        inst.setActualSize(2 * radius, 2 * radius);
                    }
                }
            }
            else
            {
                for (i = 0; i < len; i++)
                {
                    item  = activeRenderCache[i];
                    var e:Object = renderData.filteredCache[i];
                    if (filterData && (isNaN(e.angle) || isNaN(e.radius)))
                        continue;

                    inst = instances[nextInstanceIdx++];
                    item.itemRenderer = inst;
                    
                    if(!(item.fill))
                        item.fill = defaultFillFunction(item, i);

                    if(item.itemRenderer && (item.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (item.itemRenderer as Object).invalidateDisplayList();
                    
                    if (inst)
                    {
                        if (bSetData)
                            IDataRenderer(inst).data = item;

                        raN = item.angle * (Math.PI / 180);
                        inst.move(Math.cos(raN) * (item.radius) + (_origin.x - radius), Math.sin(raN) * (item.radius) + (_origin.y - radius));
                        inst.setActualSize(2 * radius, 2 * radius);
                    }
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Series
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    override protected function updateData():void
    {
        var renderDataType:Class = this.renderDataType;
        _renderData = new renderDataType();

        _renderData.cache = [];

        if (dataProvider)
        {
            cursor.seek(CursorBookmark.FIRST);
            var i:int = 0;
            var itemClass:Class = itemType;
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = new itemClass(this, cursor.current,i);
                i++;
                cursor.moveNext();
            }

            //cacheIndexValues(_angularField, _renderData.cache, "angularValue");
            cacheDefaultValues(_field, _renderData.cache, "value");
        }

        super.updateData();
    }

    /**
     *  @private
     */
    override protected function updateMapping():void {
        dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(_renderData.cache, "value", "number");

        super.updateMapping();
    }

    /**
     *  @private
     */
    override protected function updateFilter():void
    {
        _renderData.segments = [];
        var radialSegmentType:Class = this.radialSegmentType;
        
        if (filterData)
        {
            _renderData.filteredCache = _renderData.cache.concat();
            
            dataTransform.getAxis(PolarTransform.RADIAL_AXIS).filterCache(_renderData.filteredCache, "number", "filter");

            stripNaNs(_renderData.filteredCache, "filter");
            
            var start:int;
            var end:int = -1;
            /*
            
            var len:int = _renderData.filteredCache.length;
            var i:int;
            var v:RadialSeriesItem;

            while (end < len)
            {
                for (i = end + 1 ; i < len ; i++)
                {
                    v = RadialSeriesItem(_renderData.filteredCache[i]);
                    if (!isNaN(v.radialFilter))
                        break;
                    //_renderData.validPoints--;
                }
                if (i == len)
                    break;              

                start = i;

                for (i = start + 1; i < len; i++)
                {
                    v = RadialSeriesItem(_renderData.filteredCache[i]);
                    if (isNaN(v.radialFilter))
                        break;                  
                }
                end = i - 1;
                if (end != start)
                {
                    _renderData.segments.push(new radialSegmentType(this, _renderData.segments.length, _renderData.filteredCache, start, end));
                }
            } */

            if (_renderData.filteredCache.length > 1)
                _renderData.segments.push(new radialSegmentType(this, 0, _renderData.filteredCache, start, _renderData.filteredCache.length - 1));            
        }
        else
        {
            _renderData.filteredCache = _renderData.cache;
            _renderData.segments.push(new radialSegmentType(this, 0, _renderData.filteredCache, start, _renderData.filteredCache.length - 1));
        }

        //legendDataChanged();

        super.updateFilter();
    }

    /**
     *  @private
     */
    override protected function updateTransform():void
    {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);

        dataTransform.transformCache(_renderData.filteredCache, null, null, "filter", "radius");

        _origin = dataTransform.origin;
        
        var len:int = _renderData.filteredCache.length;
        var i:int;

        for (i = 0; i < len; i++)
        {
            
            var v:RadarSeriesItem = _renderData.filteredCache[i];
            v.angle = 360 / len * i;
            //v.x = Math.cos(v.angle * (Math.PI / 180)) * v.radius + v.origin.x;
            //v.y = Math.sin(v.angle * (Math.PI / 180)) * v.radius + v.origin.y;
        }
        
        super.updateTransform();
    }

    /**
     *  @private
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array
    {
        validateData();

        if (_renderData.cache.length == 0)
            return [];

        var description:DataDescription = new DataDescription();
        description.boundedValues = null;

        var dataMargin:Number;
        var stroke:IStroke;
        var radius:Number;
        var renderer:Object;
        
        if (dimension == PolarTransform.RADIAL_AXIS)
        {
            extractMinMax(_renderData.cache, "number", description);
            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0) {
                dataMargin = 0;
                
                stroke = getStyle("lineStroke");
                if (stroke)
                    dataMargin = stroke.weight/2;
                
                radius = getStyle("radius");
                renderer = getStyle("itemRenderer");
                if (radius > 0 && renderer)
                {
                    stroke = getStyle("stroke");
                    if (stroke)
                        radius += stroke.weight/2;
                        
                    dataMargin = Math.max(radius, dataMargin);
                }

                if (dataMargin > 0)
                {
                    description.boundedValues= [];
                    description.boundedValues.push(new BoundedValue(description.max, 0, dataMargin));
                    description.boundedValues.push(new BoundedValue(description.min, dataMargin, 0));
                }
            }
        }
        else if (dimension == PolarTransform.ANGULAR_AXIS)
        {
            return [];
        }
        else
        {
            return [];
        }
        
        return [ description ];
    }


    /**
     *  @private
     */
    override public function findDataPoints(x:Number, y:Number, sensitivity:Number):Array /* of HitData */
    {
        if (interactive == false || !_renderData)
            return [];

        var pr:Number = getStyle("radius");
        var minDist2:Number  = pr + sensitivity;
        minDist2 *= minDist2;
        var minItem:RadarSeriesItem = null;     
        var pr2:Number = pr * pr;
        
        var v:RadarSeriesItem;
        var dist:Number;
        
        var len:int = _renderData.filteredCache.length;

        if (len == 0)
            return [];

        var i:uint;
        for (i = 0 ; i < len ; i++)
        {
            v = _renderData.filteredCache[i];
            if (!isNaN(v.filter))
            {
                var tmpX:Number = Math.cos(v.angle * (Math.PI / 180)) * v.radius + _origin.x;
                var tmpY:Number = Math.sin(v.angle * (Math.PI / 180)) * v.radius + _origin.y;
                
                dist = (tmpX - x)*(tmpX  - x) + (tmpY - y)*(tmpY -y);
                if (dist <= minDist2)
                {
                    minDist2 = dist;
                    minItem = v;               
                }
            }
        }
        
        if (minItem)
        {
            tmpX = Math.cos(minItem.angle * (Math.PI / 180)) * minItem.radius + _origin.x;
            tmpY = Math.sin(minItem.angle * (Math.PI / 180)) * minItem.radius + _origin.y;
            
            var hd:HitData = new HitData(createDataID(minItem.index), Math.sqrt(minDist2), tmpX, tmpY, minItem);

            var istroke:IStroke = getStyle("lineStroke");
            if (istroke is Stroke)
                hd.contextColor = Stroke(istroke).color;
            /* else if (istroke is LinearGradientStroke)
            {
                var gb:LinearGradientStroke = LinearGradientStroke(istroke);
                if (gb.entries.length > 0)
                    hd.contextColor = gb.entries[0].color;
            } */
            hd.dataTipFunction = formatDataTip;
            return [ hd ];
        }
        
        return [];
    }
    
    /**
     *  @private
     */
    override public function getElementBounds(renderData:Object):void
    {
        
        var cache :Array /* of RadarSeriesItem */ = renderData.cache;
        var segments:Array /* of RadarSeriesSegment */ = renderData.segments;
        
        var rb :Array /* of Rectangle */ = [];
        var sampleCount:int = cache.length;     
        var maxBounds:Rectangle;
        
        if (sampleCount == 0)
            maxBounds = new Rectangle();
        else
        {
            var segCount:int = segments.length;
            if(segCount)
            {
                var v:Object = cache[renderData.segments[0].start];
                
                var tmpX:Number = Math.cos(v.angle * (Math.PI / 180)) * v.radius;// + v.origin.x;
                var tmpY:Number = Math.sin(v.angle * (Math.PI / 180)) * v.radius;// + v.origin.y;
                maxBounds = new Rectangle(tmpX, tmpY, 0, 0);
            }

            for (var j:int = 0; j < segCount; j++)
            {           
                var seg:Object = renderData.segments[j];
                for (var i:int = seg.start; i <= seg.end; i++)
                {
                    v = cache[i];
                    tmpX = Math.cos(v.angle * (Math.PI / 180)) * v.radius;// + v.origin.x;
                    tmpY = Math.sin(v.angle * (Math.PI / 180)) * v.radius;// + v.origin.y;
                    
                    var b:Rectangle = new Rectangle(tmpX, tmpY, 0, 0);

                    maxBounds.left = Math.min(maxBounds.left, b.left);
                    maxBounds.top = Math.min(maxBounds.top, b.top);
                    maxBounds.right = Math.max(maxBounds.right, b.right);
                    maxBounds.bottom = Math.max(maxBounds.bottom, b.bottom);
                    rb[i] = b;
                }
            }
        }
        

        renderData.elementBounds = rb;
        renderData.bounds =  maxBounds;

    }

    /**
     *  @private
     */
    override public function beginInterpolation(sourceRenderData:Object,destRenderData:Object):Object
    {
        var idata:Object = initializeInterpolationData(sourceRenderData.cache,
                                                       destRenderData.cache,
                                                       { radius: true, angle: true },
                                                       itemType,
                                                       { sourceRenderData: sourceRenderData, destRenderData: destRenderData });

        var interpolationRenderData:RadarSeriesRenderData = RadarSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        /* the segments in the renderdata have pointers back to the filetered cache.  since we just replaced the filtered cache, we need to iterate through and 
        /  update those */
        var segs:Array /* of RadarSeriesSegment */ = interpolationRenderData.segments;
        var len:int = segs.length;
        for (var i:int = 0; i < len; i++)
        {
            segs[i].items = idata.cache;
        }
        
        transitionRenderData = interpolationRenderData;
        return idata;
    }
    
    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array,
                                    destProps:Object, destCache:Array,
                                    index:Number, customData:Object):void
    {
        var cache:Array /* of RadarSeriesItem */ = customData.sourceRenderData.cache;
        var dstCache:Array /* of RadarSeriesItem */ = customData.destRenderData.cache;
        
        for (var propName:String in sourceProps)
        {
            var src:Number = sourceProps[propName];
            var dst:Number = destProps[propName];

            var lastValidIndex:int = index;
            if (isNaN(src))
            {
                if (cache.length == 0)
                {
                    src = (propName == "radius")? dstCache[index].radius : 0;
                    src = (propName == "angle")? dstCache[index].angle : 0;
                }
                else
                {
                    if (lastValidIndex >= cache.length)
                        lastValidIndex = cache.length - 1;
                    while (lastValidIndex >= 0 && isNaN(cache[lastValidIndex][propName]))
                    {
                        lastValidIndex--;
                    }
                    if (lastValidIndex >= 0)
                        src = cache[lastValidIndex][propName] + .01 * (lastValidIndex - index);
                    if (isNaN(src))
                    {
                        lastValidIndex = index + 1;
                        var cachelen:int = cache.length;
                        while (lastValidIndex < cachelen && isNaN(cache[lastValidIndex][propName]))
                        {
                            lastValidIndex++;
                        }
                        if (lastValidIndex < cachelen)
                        {
                            src = cache[lastValidIndex][propName] + .01 * (lastValidIndex - index);
                        }
                    }           
                }
            }
            
            sourceProps[propName] = src;
            destProps[propName] = dst;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Customizes the item renderer instances that are used to represent the chart. This method is called automatically
     *  whenever a new item renderer is needed while the chart is being rendered. You can override this method to add your own customization as necessary.
     *  @param instance The new item renderer instance that is being created.
     *  @param cache The InstanceCache that is used to manage the item renderer instances.
     */
    protected function applyItemRendererProperties(instance:DisplayObject,
                                                   cache:InstanceCache):void
    {
        if (instance is ISimpleStyleClient)
            ISimpleStyleClient(instance).styleName = this;
    }
    
    /**
     *  @private
     */
    private function formatDataTip(hd:HitData):String
    {
        var dt:String = "";
        
        var n:String = displayName;
        if (n && n != "")
            dt += "<b>" + n + "</b><BR/>";

       /*  var xName:String = dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).displayName;
        if (xName != "")
            dt += "<i>" + xName+ ":</i> ";
        dt += dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).formatForScreen(
            RadarSeriesItem(hd.chartItem).angle) + "\n"; */
        
        var yName:String = dataTransform.getAxis(PolarTransform.RADIAL_AXIS).displayName;
        if (yName != "")
            dt += "<i>" + yName + ":</i> ";
        dt += dataTransform.getAxis(PolarTransform.RADIAL_AXIS).formatForScreen(
            RadarSeriesItem(hd.chartItem).value) + "\n";
        
        return dt;
    }  
}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: RadialSeriesLegendMarker
//
////////////////////////////////////////////////////////////////////////////////

import flash.display.Graphics;
import mx.charts.series.LineSeries;
import mx.graphics.IStroke;
import mx.graphics.Stroke;
import mx.graphics.LinearGradientStroke;
import mx.skins.ProgrammaticSkin;
import org.openzet.charts.series.RadarSeries;

/**
 *  @private
 */
class RadialSeriesLegendMarker extends ProgrammaticSkin
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Constructor.
     */
    public function RadialSeriesLegendMarker(element:RadarSeries)
    {
        super();

        _element = element;
        styleName = _element;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _element:RadarSeries;
    

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth,unscaledHeight);

        var fillStroke:IStroke = getStyle("lineStroke");
        var color:Number;

        if (fillStroke is Stroke)
        {
            color = Stroke(fillStroke).color;
        }
        /* else if (fillStroke is LinearGradientStroke)
        {
            var gb:LinearGradientStroke = LinearGradientStroke(fillStroke);
            if (gb.entries.length > 0)
                color = gb.entries[0].color;
        } */

        var g:Graphics = graphics;
        g.clear();
        g.moveTo(0, 0);
        g.lineStyle(0, 0, 0);
        g.beginFill(color);
        g.lineTo(width, 0);
        g.lineTo(width, height);
        g.lineTo(0, height);
        g.lineTo(0, 0);
        g.endFill();
    }
}