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
import flash.display.Graphics;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.AxisLabel;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.ChartBase;
import mx.charts.chartClasses.ChartState;
import mx.charts.chartClasses.DualStyleObject;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.styles.HaloDefaults;
import mx.core.ContextualClassFactory;
import mx.core.IUITextField;
import mx.core.UITextField;
import mx.core.UITextFormat;
import mx.graphics.IStroke;
import mx.graphics.Stroke;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

import org.openzet.charts.chartClasses.IRadarAxisRenderer;


/**
 *  Specifies the characteristics of the line for the axis.
 *  This style must be an instance of the Stroke class.  
 */
[Style(name="axisStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Color of text in the component, including the component label.
 *
 *  @default 0x0B333C
 */
[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  Color of text in the component if it is disabled.
 *
 *  @default 0xAAB3B3
 */
[Style(name="disabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  Sets the <code>antiAliasType</code> property of internal TextFields. The possible values are 
 *  <code>"normal"</code> (<code>flash.text.AntiAliasType.NORMAL</code>) 
 *  and <code>"advanced"</code> (<code>flash.text.AntiAliasType.ADVANCED</code>). 
 *  
 *  <p>The default value is <code>"advanced"</code>, which enables the FlashType renderer if you are using an 
 *  embedded FlashType font. Set to <code>"normal"</code> to disable the FlashType renderer.</p>
 *  
 *  <p>This style has no effect for system fonts.</p>
 *  
 *  <p>This style applies to all the text in a TextField subcontrol; 
 *  you can't apply it to some characters and not others.</p>

 *  @default "advanced"
 * 
 *  @see flash.text.TextField
 *  @see flash.text.AntiAliasType
 */
[Style(name="fontAntiAliasType", type="String", enumeration="normal,advanced", inherit="yes")]

/**
 *  Name of the font to use.
 *  Unlike in a full CSS implementation,
 *  comma-separated lists are not supported.
 *  You can use any font family name.
 *  If you specify a generic font name,
 *  it is converted to an appropriate device font.
 * 
 *  @default "Verdana"
 */
[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  Height of the text, in pixels.
 *
 *  The default value is 10 for all controls except the ColorPicker control. 
 *  For the ColorPicker control, the default value is 11. 
 */
[Style(name="fontSize", type="Number", format="Length", inherit="yes")]

/**
 *  Determines whether the text is italic font.
 *  Recognized values are <code>"normal"</code> and <code>"italic"</code>.
 * 
 *  @default "normal"
 */
[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
 *  Determines whether the text is boldface.
 *  Recognized values are <code>"normal"</code> and <code>"bold"</code>.
 *  For LegendItem, the default is <code>"bold"</code>.
 * 
 *  @default "normal"
 */
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/** 
 *  Specifies the gap between the end of the tick marks
 *  and the top of the labels, in pixels. 
 *  
 *  @default 3 
 */
[Style(name="labelGap", type="Number", format="Length", inherit="no")]

/**
 *  Specifies whether labels should appear along the axis. 
 *  
 *  @default true 
 */
[Style(name="showLabels", type="Boolean", inherit="no")]

/**
 *  Specifies whether to display the axis. 
 *  
 *  @default true 
 */
[Style(name="showLine", type="Boolean", inherit="no")]

/**
 *  Specifies the length of the tick marks on the axis, in pixels. 
 *  
 *  @default 3  
 */
[Style(name="tickLength", type="Number", format="Length", inherit="no")]

/**
 *  Specifies where to draw the tick marks. Options are:
 *  <ul>
 *    <li><code>"inside"</code> -
 *    Draw tick marks inside the data area.</li>
 *
 *    <li><code>"outside"</code> -
 *    Draw tick marks in the label area.</li>
 *
 *    <li><code>"cross"</code> -
 *    Draw tick marks across the axis.</li>
 *
 *    <li><code>"none"</code> -
 *    Draw no tick marks.</li>
 *  </ul>
 *  
 *  @default "cross"  
 */
[Style(name="tickPlacement", type="String", enumeration="inside,outside,cross,none", inherit="no")]

/**
 *  Specifies the characteristics of the tick marks on the axis.
 *  This style must be an instance of the Stroke class.  
 */
[Style(name="tickStroke", type="mx.graphics.IStroke", inherit="no")]


public class RadialAxisRenderer extends DualStyleObject implements IRadarAxisRenderer
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
        
        var o:CSSStyleDeclaration;

        var axisRendererStyle:CSSStyleDeclaration =
            HaloDefaults.createSelector("RadialAxisRenderer");

        axisRendererStyle.defaultFactory = function():void
        {
            this.axisStroke = new Stroke(0xBBCCDD, 8, 1, false, "normal", "none");
            this.labelGap = 3;
            this.showLabels = true;
            this.showLine = true;
            this.tickLength = 0;
            this.tickPlacement = "cross";
            this.tickStroke = new Stroke(0, 0, 1);
        }
        
        return true;
    }

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var textFieldFactory:ContextualClassFactory;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
    public function RadialAxisRenderer()
    {
        super();

        textFieldFactory =  new ContextualClassFactory(UITextField, moduleFactory);

        _labelCache = new InstanceCache(UITextField, this);
        
       	_labelCache.discard = true;
        _labelCache.remove = true;
        
        super.showInAutomationHierarchy = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _ticks:Array /* of Number */ = [];

    /**
     *  @private
     */
    private var _bGuttersAdjusted:Boolean = false;

    /**
     *  @private
     */
    private var _axisLabelSet:AxisLabelSet;

    /**
     *  @private
     */
    private var _labels:Array /* of ARLabelData */ = [];

    /**
     *  @private
     */
    private var _maxLabelHeight:Number;

    /**
     *  @private
     */
    private var _maxLabelWidth:Number;

    /**
     *  @private
     */
    private var _forceLabelUpdate:Boolean = false;  

    /**
     *  @private
     */
    private var _labelCache:InstanceCache;

    /**
     *  @private
     */
    private var _supressInvalidations:int = 0;
    
    /**
     *  @private
     */
    private var _measuringField:DisplayObject;
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  axis
    //----------------------------------

    /**
     *  @private
     *  Storage for the axis property.
     */
    private var _axis:IAxis = null;
    
    [Inspectable(category="General")]

    /**
     *  The axis object associated with this renderer.
     *  This property is managed by the enclosing chart,
     *  and could be explicitly set if multiple axes renderers are used.
     */ 
    public function get axis():IAxis
    {
        return _axis;       
    }

    /**
     *  @private
     */ 
    public function set axis(value:IAxis):void
    {
        if (_axis)
        {
            _axis.removeEventListener("axisChange", axisChangeHandler, false);
            _axis.removeEventListener("titleChange", titleChangeHandler, false);
        }

        _axis = value;

        value.addEventListener("axisChange", axisChangeHandler, false, 0, true);
        value.addEventListener("titleChange", titleChangeHandler, false, 0, true);
    }

    //----------------------------------
    //  chart
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The base chart for this AxisRenderer.
     */
    protected function get chart():ChartBase
    {
        var p:DisplayObject = parent;
        while (!(p is ChartBase) && p)
        {
            p = p.parent;
        }           
        return p as ChartBase;
    }

    //----------------------------------
    //  gutters
    //----------------------------------

    /**
     *  @private
     *  Storage for the gutters property.
     */
    private var _gutters:Rectangle = new Rectangle();
    
    [Inspectable(category="General")]
    

    /** 
    * @inheritDoc
    */
    public function get gutters():Rectangle
    {
        return _gutters;
    }
    
    /**
     *  @private
     */ 
    public function set gutters(value:Rectangle):void
    {
        var correctedGutters:Rectangle = value;
        
        // This check will rarely succeed, because _gutters
        // have been tweaked to represent placement.
        if (_gutters && 
            _gutters.left == correctedGutters.left && 
            _gutters.right == correctedGutters.right && 
            _gutters.top == correctedGutters.top && 
            _gutters.bottom == correctedGutters.bottom)
        {
            _gutters = correctedGutters;
            return;
        }
        else
        {
            adjustGutters(value, { left: false, top: false, right: false, bottom: false });
        }       
    }
    
    //----------------------------------
    //  ticks
    //----------------------------------

    [Inspectable(environment="none")]

    /**
    *   @inheritDoc
    */
    public function get ticks():Array /* of Number */
    {
        return _ticks;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if(/* !labelRenderer && */ !_labelCache.factory)
            _labelCache.factory = textFieldFactory;
        
        //setupMouseDispatching();
    }

    /**
     *  @inheritDoc
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        var chart:ChartBase = this.chart;

        if (chart.dataProvider == null)
            return;
            
        if (chart.chartState != ChartState.PREPARING_TO_HIDE_DATA &&
            chart.chartState != ChartState.HIDING_DATA)
        {
            graphics.clear();

            var lineVisible:Boolean = getStyle("showLine");
            //var labelBottom:Number = drawLabels(lineVisible);

            drawLabels(lineVisible);
            
            drawAxis(lineVisible);

            drawTicks(lineVisible);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    *   @inheritDoc
    */
    public function adjustGutters(workingGutters:Rectangle, adjustable:Object):Rectangle
    {
        _bGuttersAdjusted = true;

        var axisStroke:IStroke = getStyle("axisStroke");

        updateCaches();

        var width:Number = unscaledWidth;
        var height:Number = unscaledHeight;
        var scale:Number = 1;
        var tmpGutter:Number;
        
        _gutters = workingGutters = workingGutters.clone();

        var calcSize:Number = 0;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        var showLineStyle:Object = getStyle("showLine");        
        var showLine:Boolean = showLineStyle != false &&
                               showLineStyle != "false";

        calcSize += tickSize(showLine);

        calcSize += getStyle("labelGap");

        calcSize += Number(showLine == true && axisStroke ?
                           axisStroke.weight :
                           0);

        // Adjust for any ticks that might be hanging over the edge.        
        var tickStroke:IStroke = getStyle("tickStroke");
        if (tickStroke)
        {
            workingGutters.left = Math.max(workingGutters.left,
                                           tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,
                                            tickStroke.weight / 2);
        }

        tickStroke = getStyle("minorTickStroke");
        if (tickStroke)
        {
            workingGutters.left = Math.max(workingGutters.left,
                                           tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,
                                            tickStroke.weight / 2);
        }

        if (showLabels)
        {
            //_labelPlacement =
            calcRotationAndSpacing(width, height, /* targetHeight,  */workingGutters, adjustable);

            var label:ARLabelData = _labels[0];
            var lcount:int = _labels.length;    
                
            calcSize += _maxLabelHeight;// * _labelPlacement.scale;
        }
        else
        {
            // For gridlines, we still need to measure out our labels.
            measureLabels(false, width);

            //_labelPlacement = { rotation: 0, left: 0, right: 0, scale: 1, staggered: false };           
        }
        
/*         var wmLeft:Number = Math.max(workingGutters.left,_labelPlacement.left);

        workingGutters = new Rectangle( wmLeft, workingGutters.top,
                                        Math.max(workingGutters.right, _labelPlacement.right) - wmLeft,
                                        Math.max(workingGutters.bottom, calcSize) - workingGutters.top); */

        /* if (_inverted)
        {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
        } */

        _gutters = workingGutters;
        invalidateDisplayList();

        return gutters;
    }

    /**
     *  @private
     */
    private function calcRotationAndSpacing(width:Number, height:Number,
                                            /* targetHeight:Number, */
                                            workingGutters:Rectangle,
                                            adjustable:Object):Object
    {
        updateCaches();

        var leftGutter:Number = workingGutters.left;
        var rightGutter:Number = workingGutters.right;
        
        // First, ask our range to estimate what our labels will be,
        // and do a measurement pass on them.
        var bEstimateIsAccurate:Boolean = measureLabels(true, 0);

        // If we have no labels, we're done.
        if (_labels.length == 0)
        {
            return { rotation: 0, left: leftGutter, right: rightGutter,
                     scale: 1, staggered: false };          
        }

        // First check and see if a rotation has been specified.
        // If it has, go with what the author requested.        
        var firstLabel:ARLabelData = _labels[0];
        var lastLabel:ARLabelData = _labels[_labels.length - 1];        
        
        // Layout vertical if:
        // 1. horizontal, and label is 90 and canRotate is true
        // 2. (vertical, and rotation is null, 90), or (canRotate is false)
/*         
        var mustLayoutVertical:Boolean =
            (_horizontal && _canRotate && labelRotation == 90) ||
            (_horizontal == false &&
             ((isNaN(labelRotation) ||
               labelRotation == 90) ||
               _canRotate == false));
    
        var canLayoutHorizontal:Boolean =
            mustLayoutVertical == false &&
            ((isNaN(labelRotation) && _horizontal == true) ||
            (labelRotation == 0) || (_canRotate == false));
        
        var horizontalScale:Number = 0;
        
        var canStaggerStyle:Object = getStyle("canStagger");
        var canStagger:Boolean =
            canStaggerStyle == null ||
            (canStaggerStyle != false &&
             canStaggerStyle != "false");

        var canLayoutStaggered:Boolean =
            mustLayoutVertical == false &&
            ((canDropLabels == false) &&
            canLayoutHorizontal &&
            (false != canStaggerStyle));
        
        var staggeredScale:Number = 0;
        
        var canLayoutAngled:Boolean =
            (mustLayoutVertical == false && 
            ((_canRotate == true) && 
             labelRotation != 0 && 
             ((canDropLabels == false) || 
              !isNaN(labelRotation)))); */

        var angledScale:Number = 0;
        var minimumAxisLength:Number = width - leftGutter - rightGutter;
        
        var verticalData:Object;
        var horizontalGutterData:Object;
        var angledGutterData:Object;
        var angledSpacingData:Object;
        var horizontalSpacingData:Object;
        var staggeredSpacingData:Object;
        
        if (bEstimateIsAccurate)
        {
            // First, determine the gutter adjustments for vertical labels.
           /*  if (mustLayoutVertical)
            {
                verticalData = calcVerticalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            }
 */
            // Now, determine the gutter and/or dropLabel adjustments
            // for horizontal labels.
            /* if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels,
                    adjustable, minimumAxisLength);
                
                horizontalScale = horizontalSpacingData.scale;
                
                if (horizontalScale != 1 && canLayoutStaggered)
                {
                    staggeredSpacingData = calcStaggeredSpacing(
                        width, horizontalGutterData, targetHeight,
                        firstLabel, lastLabel, canDropLabels, adjustable);

                    staggeredScale = staggeredSpacingData.scale;
                }
            } */

            // Now we're going to determine the optimal angle,
            // and gutter adjustments, for angled labels.
            /* if (horizontalScale != 1 && staggeredScale != 1 && canLayoutAngled)
            {
                angledGutterData = measureAngledGutters(
                    width, labelRotation, targetHeight,
                    firstLabel, leftGutter, rightGutter, adjustable);

                angledSpacingData = calcAngledSpacing(angledGutterData);

                angledScale = angledSpacingData.scale;
            }

            if (horizontalScale >= staggeredScale &&
                horizontalScale >= angledScale)
            {
                if (horizontalSpacingData != null)
                    return horizontalSpacingData;
                return angledSpacingData;
            }
            else if (staggeredScale >= angledScale)
            {
                if(staggeredSpacingData != null)
                    return staggeredSpacingData;
                return angledSpacingData;
            }
            else
            {
                return angledSpacingData;
            } */
        }
        else
        {
            // First, determine the gutter adjustments for vertical labels.
            /* if (mustLayoutVertical)
            {
                verticalData = calcVerticalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                minimumAxisLength = Math.min(minimumAxisLength,
                                             verticalData.minimumAxisLength);
            } */

            // Now, determine the gutter and/or dropLabel adjustments
            // for horizontal labels.
            /* if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                minimumAxisLength = Math.min(
                    minimumAxisLength, horizontalGutterData.minimumAxisLength);         
            } */

            // Now we're going to determine the optimal angle,
            // and gutter adjustments, for angled labels
            /* if (canLayoutAngled)
            {
                angledGutterData = measureAngledGutters(
                    width, labelRotation, targetHeight,
                    firstLabel, leftGutter, rightGutter, adjustable);

                minimumAxisLength = Math.min(
                    minimumAxisLength, angledGutterData.minimumAxisLength);         
            } */

            // We've effectively measured our maximum gutter reduction.
            // Now our range can adjust based on any gutters
            // in the range required by specific renderers.
            measureLabels(false, minimumAxisLength);

            // Now that we have an accurate set of labels, it's entirely possible we have no labels anymore.
            // if that's the case, bail out.
            if (_labels.length == 0)
            {
                return { rotation: 0, left: leftGutter, right: rightGutter,
                         scale: 1, staggered: false };          
            }
    
            // Now, determine either the scale factor or the drop factor
            // for vertical titles
           /*  if (mustLayoutVertical)
            {
                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            } */

            // Now determine the scale adjustments for horizontal labels.
           /*  if (canLayoutHorizontal)
            {
                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels,
                    adjustable, minimumAxisLength);

                horizontalScale = horizontalSpacingData.scale;
            } */

            // And the scale adjustments for staggered labels.
            /* if (canLayoutStaggered)
            {
                staggeredSpacingData = calcStaggeredSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels, adjustable);

                staggeredScale = staggeredSpacingData.scale;
            } */

            /* if (canLayoutAngled)
            {
                angledSpacingData = calcAngledSpacing(angledGutterData);
                angledScale = angledSpacingData.scale;
            } */

/*             if (horizontalScale  >= staggeredScale &&
                horizontalScale >= angledScale)
            {
                if (horizontalSpacingData != null)
                    return horizontalSpacingData;
                return angledSpacingData;
            }
            else if (staggeredScale >= angledScale)
            {
                if(staggeredSpacingData != null)
                    return staggeredSpacingData;
                return angledSpacingData;
            }
            else
            {
                return angledSpacingData;
            } */
        }
        
        return [];
    }

    /**
     *  @private
     */
    private function measureLabels(bEstimate:Boolean,
                                   minimumAxisLength:Number):Boolean
    {
        var newLabelData:AxisLabelSet;
        
        if(!_axis)
            return false;
        	//throw(new Error(resourceManager.getString("charts", "noAxisSet")));
        else if (bEstimate)
            newLabelData = _axis.getLabelEstimate();
        else
            newLabelData = _axis.getLabels(minimumAxisLength);
        
        if (newLabelData == _axisLabelSet && _forceLabelUpdate == false)
            return newLabelData.accurate;

        var bResult:Boolean = processAxisLabels(newLabelData);

        _axisLabelSet = newLabelData;

        return bResult;
    }

    /**
     *  @private
     */
    private function updateCaches():void
    {
        /* if (_cacheDirty)
        {
            _labelFormatCache = determineTextFormatFromStyles();

            var sm:ISystemManager = systemManager as ISystemManager;
            var embedFonts:Boolean = _canRotate =
                sm.isFontFaceEmbedded(_labelFormatCache);
            
            if (!_labelRenderer)
            {
                _labelCache.properties =
                    { embedFonts: embedFonts, selectable: false, styleName: this };
            }
            else
            {
                _labelCache.properties = {};
            }           

            _cacheDirty = false;
        }*/
    }


    /**
     *  @private
     */
    private function drawLabels(showLine:Boolean):Number
    {
        var axisStroke:IStroke = getStyle("axisStroke");

        var labelBottom:Number;     
        var labelY:Number;
        var xAdjustment:Number;
        var ldi:ARLabelData;
        var r:Number;
        
        renderLabels();
        
        var firstLabel:ARLabelData = _labels[0];

        var baseline:Number = _gutters.top + (unscaledHeight - _gutters.top - _gutters.bottom) / 2; 
        /* unscaledHeight - _gutters.bottom +
                                   Number(showLine == true ? axisStroke.weight : 0) +
                                   tickSize(showLine); */

        var scale:Number = 1;//_labelPlacement.scale;
        var lcount:int = _labels.length;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        if (showLabels == false)
            return baseline;
        
        // Place the labels.
        // If they have no rotation, we need to center them,
        // and potentially offset them (if they're staggered).
        var hscale:Number = scale;
        for (var i:int = 0; i < lcount; i++)
        {
            ldi = _labels[i];
            ldi.instance.scaleX = ldi.instance.scaleY = hscale;
        }
        
        var axisWidth:Number = Math.min(unscaledWidth - _gutters.left - _gutters.right, unscaledHeight - _gutters.top - _gutters.bottom) / 2;
        var labelGap:Number = getStyle("labelGap");
        var alignOffset:Number = 0.5;//this.labelAlignOffset;

        var oddLabelYOffset:Number = 0;

        /* if (_labelPlacement.staggered)
        {
            oddLabelYOffset = scale * _maxLabelHeight;// * (Number(_inverted ? -1 : 1));
        } */

        /* if (_inverted)
        {
            labelY = baseline - labelGap - _maxLabelHeight * scale;
            labelBottom = labelY - oddLabelYOffset;
        }
        else */
        {
            labelY = baseline + labelGap + (axisStroke.weight) / 2;
            labelBottom = labelY +
                          _maxLabelHeight * scale +
                          oddLabelYOffset;
        }
        
        var staggerCount:int = 0;
        for (i = 0; i < lcount; i++)
        {
            var thisLabel:ARLabelData = _labels[i];
            
            thisLabel.instance.rotation = 0;
            thisLabel.instance.x = (unscaledWidth - _gutters.left - _gutters.right) / 2 + _gutters.left + axisWidth * thisLabel.position - thisLabel.width * alignOffset;
            thisLabel.instance.y = labelY + staggerCount * oddLabelYOffset;
            
            staggerCount = 1 - staggerCount;
        }           
        
        return labelBottom;
    }

    /**
     *  @private
     */
    private function renderLabels():void
    {
        var visCount:int = 0;
        var i:int;
        var labelData:ARLabelData;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        if (showLabels == false)
        {
            _labelCache.count = 0;
        }
        else
        {
            _labelCache.count = _labels.length;
            var len:int = _labels.length;
            //if (!_labelRenderer)
            {
                _labelCache.format = determineTextFormatFromStyles();
                for (i = 0; i < len; i++)
                {
                    labelData = _labels[i];
                    labelData.instance = _labelCache.instances[visCount++];
                    
                    (labelData.instance as IUITextField).htmlText =
                        labelData.text;
                    
                    labelData.instance.width = labelData.width;
                    labelData.instance.height = labelData.height;
                }
            }
            /* else
            {
                for (i; i < len; i++)
                {
                    labelData = _labels[i];
                    labelData.instance = _labelCache.instances[visCount++];
                    
                    (labelData.instance as IDataRenderer).data = labelData.value;
                    
                    (labelData.instance as IFlexDisplayObject).setActualSize(labelData.width * _labelPlacement.scale,
                                                                             labelData.height * _labelPlacement.scale);
                }           
            } */
        }
    }

    /**
     *  @private
     */
    private function drawAxis(showLine:Boolean):void
    {
        if (showLine) {
            var pCenter:Point = new Point((unscaledWidth - _gutters.right - _gutters.left) / 2 + gutters.left,
                                          (unscaledHeight - _gutters.bottom - _gutters.top) / 2 + _gutters.top);
            var r:Number = Math.min(unscaledWidth - _gutters.right - _gutters.left, unscaledHeight - _gutters.bottom - _gutters.top) / 2;
            
            var axisStroke:IStroke = getStyle("axisStroke");
            axisStroke.apply(graphics);
            
            // startAngle 에 해당하는 축에만 그린다. startAngle 속성 현재 미구현.
            var raN:Number = 0;//(360 / 축갯수) * i * (Math.PI / 180);
            
            graphics.moveTo(pCenter.x, pCenter.y);
            graphics.lineTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
        }
    }

    /**
     *  @private
     */
    private function drawTicks(showLine:Boolean):Number
    {
        var axisStroke:IStroke = getStyle("axisStroke");

        var axisWeight:Number = Number(showLine == true ?
                                       axisStroke.weight :
                                       0);

        var baseline:Number = _gutters.top + (unscaledHeight - _gutters.top - _gutters.bottom) / 2 - (axisWeight / 2); 

        var w:Number;
        var a:Number;
        var left:Number;
        var right:Number;
        var axisStart:Number;
        var axisLength:Number;
        var tickStart:Number;
        var tickEnd:Number;
        var tickLen:Number = getStyle("tickLength");
        var tickPlacement:String = getStyle("tickPlacement");
        var oldWeight:Number;
        
        /* if (_inverted)
        {
            tickLen *= -1;
            axisWeight *= -1;
        } */

        var tickStroke:IStroke = new Stroke(0xFFFFFF, 1); //getStyle("tickStroke");
        
        switch (tickPlacement)
        {
            case "inside":
            {
                tickStart = baseline;
                tickEnd = baseline - tickLen;
                break;
            }

            case "outside": 
            default:
            {
                tickStart  = baseline + axisWeight;
                tickEnd = baseline + axisWeight + tickLen; 
                break;
            }

            case "cross":
            {
                tickStart = baseline - tickLen;
                tickEnd = baseline + axisWeight + tickLen;
                break;
            }

            case "none":
            {
                tickStart  = 0;
                tickEnd = 0;
                break;
            }
        }

        var tickCount:int = _ticks.length;

        axisStart = (unscaledWidth - _gutters.left - _gutters.right) / 2 + _gutters.left;
        axisLength = Math.min(unscaledWidth - _gutters.left - _gutters.right, unscaledHeight - _gutters.top - _gutters.bottom) / 2;

        var g:Graphics = graphics;
        
        if (tickStart != tickEnd)
        {
            oldWeight = tickStroke.weight;
            tickStroke.weight = tickStroke.weight;//_labelPlacement.scale * Number(tickStroke.weight == 0 ? 1 : tickStroke.weight);

            tickStroke.apply(g);
            tickStroke.weight = oldWeight;

            for (var i:int = 0; i < tickCount; i++)
            {
                left = axisStart + axisLength * _ticks[i];
                g.moveTo(left, tickStart);
                g.lineTo(left, tickEnd);
            }

        }   

        /* if (tickStart != tickEnd)
        {
            var minorTicks:Array = _minorTicks;
            tickCount = minorTicks ? minorTicks.length : 0;

            oldWeight = minorTickStroke.weight;
            minorTickStroke.weight = _labelPlacement.scale *
                Number(minorTickStroke.weight == 0 ? 1 : minorTickStroke.weight);

            minorTickStroke.apply(g);
            minorTickStroke.weight = oldWeight;

            for (i = 0; i < tickCount; i++)
            {
                left = axisStart + axisLength * minorTicks[i];
                g.moveTo(left, tickStart);
                g.lineTo(left, tickEnd);
            }
        } */

        return baseline + tickEnd;
    }

    /**
     *  @private
     */
    private function processAxisLabels(newLabelData:AxisLabelSet):Boolean
    {
        var len:int;
        var labelValues:Array /* of String */ = [];
        var bUseRenderer:Boolean = false;// (_labelRenderer != null);
        var i:int;
        
        _supressInvalidations++;
        len = newLabelData.labels.length;

        _labels = [];
        
        // Initialize the labelvalues with the text.
        for (i = 0; i < len; i++)
        {
            labelValues.push(newLabelData.labels[i].text);
        }

        /* if (newLabelData != _axisLabelSet)
        {
            if (_labelFunction != null)
            {
                labelValues = [];
                for (i = 0; i < len; i++)
                {
                    labelValues.push(_labelFunction(this,newLabelData.labels[i].text));
                }
            }
        } */

        var maxLabelWidth:Number = 0;
        var maxLabelHeight:Number = 0;
        var ltext:AxisLabel;
        var labelData:ARLabelData;
        
        if (!bUseRenderer)
        {       
            var systemManager:ISystemManager = systemManager as ISystemManager;
            var measuringField:IUITextField = _measuringField as IUITextField;
            if (!_measuringField)
            {
                measuringField = IUITextField(createInFontContext(UITextField));
                _measuringField = DisplayObject(measuringField);
            }
            
            var tf:UITextFormat = determineTextFormatFromStyles();
            measuringField.defaultTextFormat = tf;
            measuringField.setTextFormat(tf);
            measuringField.multiline = true;

            // this information is carried around in the UITextFormat, but not automatically applied.
            // at some future date, this code should not need to set styles directly, but rather just inherit them through the style system.
            measuringField.antiAliasType = tf.antiAliasType;
            measuringField.gridFitType = tf.gridFitType;
            measuringField.sharpness = tf.sharpness;
            measuringField.thickness = tf.thickness;
            
            measuringField.autoSize = "left";
            measuringField.embedFonts =
                systemManager && systemManager.isFontFaceEmbedded(tf);
        }
        /* else
        {
            var measuringLabel:IUIComponent = _measuringField as IUIComponent;
            if (!measuringLabel)
            {
                measuringLabel = _labelRenderer.newInstance();
                _measuringField = measuringLabel as DisplayObject;
                if (measuringLabel is ISimpleStyleClient)
                    (measuringLabel as ISimpleStyleClient).styleName = this;
                measuringLabel.visible = false;
                addChild(DisplayObject(measuringLabel));
            }

            var ilcMeasuringLabel:ILayoutManagerClient = measuringLabel as ILayoutManagerClient;

            var doMeasuringLabel:IDataRenderer = measuringLabel as IDataRenderer;
        } */
        
        for (i = 0; i < len; i++)
        {
            ltext = newLabelData.labels[i];
            labelData = new ARLabelData(ltext, ltext.position, labelValues[i]);
            
            if (!bUseRenderer)
            {
                measuringField.htmlText = labelValues[i];
                
                labelData.width = measuringField.width;
                labelData.height = measuringField.height;
            }
           /*  else
            {
                doMeasuringLabel.data = ltext;
                
                if (ilcMeasuringLabel)
                    ilcMeasuringLabel.validateSize(true);

                labelData.width = measuringLabel.measuredWidth;
                labelData.height = measuringLabel.measuredHeight;                                           
            } */

            maxLabelWidth = Math.max(maxLabelWidth, labelData.width);
            maxLabelHeight = Math.max(maxLabelHeight, labelData.height);
            
            _labels[i] = labelData;                         
        }

        _ticks = newLabelData.ticks == null ? [] : newLabelData.ticks;

        //_minorTicks = newLabelData.minorTicks == null ? [] : newLabelData.minorTicks;
        
        _maxLabelWidth = maxLabelWidth;
        _maxLabelHeight = maxLabelHeight;
        
        _forceLabelUpdate = false;

        _supressInvalidations--;

        return newLabelData.accurate == true;
    }

    /**
     *  @private
     */
    private function tickSize(showLine:Boolean):Number
    {
        var tickLength:Number = getStyle("tickLength");
        var tickPlacement:String = getStyle("tickPlacement");
        var axisStroke:IStroke = getStyle("axisStroke");
        var rv:Number = 0;
        
        switch (tickPlacement)
        {           
            case "cross":
            {
                if (showLine)
                    rv = tickLength + axisStroke.weight;
                else
                    rv = tickLength;
                break;
            }

            case "inside":
            {
                rv = 0;
                break;
            }

            case "none":
            {
                rv = 0;
                break;
            }

            default:
            case "outside": 
            {
                rv = tickLength;
                break;
            }
        }

        return rv;
    }
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    private function axisChangeHandler(event:Event):void
    {
        if (chart)
            chart.invalidateDisplayList();

        invalidateDisplayList();
    }

    /**
     *  @private
     */
    private function titleChangeHandler(event:Event):void
    {
        if (chart)
            chart.invalidateDisplayList();

        invalidateDisplayList();        
    }
}
}

////////////////////////////////////////////////////////////////////////////////

import flash.display.DisplayObject;
import mx.charts.AxisLabel;
import mx.styles.ISimpleStyleClient;

/**
 *  @private
 */
class ARLabelData
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function ARLabelData(value:AxisLabel, position:Number, text:String)
    {
        super();

        this.value = value;
        this.position = position;
        this.text = text;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var value:AxisLabel;

    /**
     *  @private
     *  Copied from value for performance.
     */
    public var position:Number;
    
    /**
     *  @private
     */
    public var width:Number;
    
    /**
     *  @private
     */
    public var height:Number;
    
    /**
     *  @private
     */
    public var instance:DisplayObject;
    
    /**
     *  @private
     *  Modified version of value.text as part of AxisRenderer's label function
     */
    public var text:String;
}
