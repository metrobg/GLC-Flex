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
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.AxisLabel;
import mx.charts.chartClasses.AxisBase;
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
import mx.core.mx_internal;
import mx.graphics.IStroke;
import mx.graphics.Stroke;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

import org.openzet.charts.chartClasses.IRadarAxisRenderer;

use namespace mx_internal;

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
 *  Specifies the characteristics of the tick marks on the axis.
 *  This style must be an instance of the Stroke class.  
 */
[Style(name="tickStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 * Custom AxisRenderer class for a RadarChart control.
 */
public class AngularAxisRenderer extends DualStyleObject implements IRadarAxisRenderer
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
            HaloDefaults.createSelector("AngularAxisRenderer");

        axisRendererStyle.defaultFactory = function():void
        {
            this.axisStroke = new Stroke(0xBBCCDD, 8, 1, false, "normal", "none");
            this.labelGap = 3;
            this.showLabels = true;
            this.showLine = true;
            this.tickLength = 3;
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
    public function AngularAxisRenderer()
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
    private var _labelPlacement:Object;

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
    //  highlightElements
    //----------------------------------

    /**
     *  @private
     *  Storage for the highlightElements.
     */
    private var _highlightElements:Boolean = false;

    [Inspectable(category="General", defaltValue = "false")]
    
    /**
     *  Specifies wheter to highlight chart elements like Series on mouse rollover.
     *  
     */
    public function get highlightElements():Boolean
    {
        return _highlightElements;
    }
    
    /**
     *  @private
     */
    public function set highlightElements(value:Boolean):void
    {
        if(value == _highlightElements)
            return;
            
        _highlightElements = value;
        invalidateProperties();
    }
    
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

        value.addEventListener("axisChange", axisChangeHandler,
                               false, 0, true);
        value.addEventListener("titleChange", titleChangeHandler,
                               false, 0, true);
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
        
        setupMouseDispatching();
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
            updateCaches();

            graphics.clear();
            
            var lineVisible:Boolean = getStyle("showLine");
            
            drawLabels(lineVisible);
            drawAxis(lineVisible);
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

        /* if (_inverted)
        {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
        } */

        var calcSize:Number = 0;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
        
        var showLineStyle:Object = getStyle("showLine");        
        var showLine:Boolean = showLineStyle != false && showLineStyle != "false";

        //calcSize += tickSize(showLine);
        calcSize += 10; //getStyle("labelGap");
        calcSize += Number(showLine == true && axisStroke ? axisStroke.weight : 0);
        
        // If we have a title, we subtract off space for it.
        //var titleHeight:Number = 0;
        //var titleScale:Number = 1;

        //var titleSize:Point = measureTitle();

        //titleHeight = titleSize.y;
        
        // First, calculate the angle for the labels.               
        var targetHeight:Number;

        // Add in the size required by the title.
        //calcSize += titleHeight * titleScale;

        if (adjustable.bottom == false)
            targetHeight = Math.max(0, workingGutters.bottom - calcSize);
        //else if (!isNaN(heightLimit))
        //    targetHeight = Math.max(0,heightLimit - calcSize);

        // Adjust for any ticks that might be hanging over the edge.        
        /* var tickStroke:IStroke = getStyle("tickStroke");
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
        } */

        if (showLabels)
        {
            calcPosition(width, height, targetHeight, workingGutters, adjustable);
            //_labelPlacement = calcRotationAndSpacing(width, height, targetHeight, workingGutters, adjustable);
                
            var label:ARLabelData = _labels[0];
            //var lcount:int = _labels.length;    
                
            //if (_labelPlacement.staggered)
            //    calcSize += 2 * label.height;// * _labelPlacement.scale;
            //else
                calcSize += _maxLabelHeight;// * _labelPlacement.scale;
        }
        else
        {
            // For gridlines, we still need to measure out our labels.
            measureLabels(false, width);

            //_labelPlacement = { rotation: 0, left: 0, right: 0, scale: 1, staggered: false };           
        }
        
        var wmLeft:Number = Math.max(workingGutters.left, 0);//_labelPlacement.left);

        //workingGutters = new Rectangle(_maxLabelWidth, _maxLabelHeight, 0, 0);
        
        //workingGutters = new Rectangle(wmLeft, workingGutters.top + _maxLabelHeight,
        //                               Math.max(workingGutters.right, _maxLabelWidth/* _labelPlacement.right */) - wmLeft,
        //                               Math.max(workingGutters.bottom, calcSize) - workingGutters.top);

        _gutters = workingGutters;
        
        invalidateDisplayList();

        return gutters;
    }

    /**
     *  @private
     */
    private function measureTitle():Point
    {
        /*
        if (!_axis || !(_axis.title) || _axis.title.length == 0)
            return new Point(0, 0);

        renderTitle();
        
        _supressInvalidations++;

        (_titleField as IDataRenderer).data = _axis ? _axis.title : "";
                
        _titleField.validateProperties();
        _titleField.validateSize(true);
        
        _supressInvalidations--;
        
        return new Point(_titleField.measuredWidth,
                         _titleField.measuredHeight);
        */
        return new Point();
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

    private function calcPosition(width:Number, height:Number, targetHeight:Number, workingGutters:Rectangle, adjustable:Object):Object {
        updateCaches();
        
        var bEstimateIsAccurate:Boolean = measureLabels(true, 0);
        
        if (_labels.length == 0) {
            return {left:workingGutters.left, right:workingGutters.right};
        }
        
        var len:Number = _labels.length;
        var pCenter:Point = new Point(width / 2, height / 2);
        var oneAngle:Number = 360 / len;
        var r:Number = Math.min(width, height) / 2;
        
        for (var i:int = 0 ; i < len ; i++) {
            var angle:Number = oneAngle * i;
            var raN:Number = angle * (Math.PI / 180);
            var thisLabel:ARLabelData = _labels[i];

            var x1:Number = Math.cos(raN) * r + pCenter.x;
            var y1:Number = Math.sin(raN) * r + pCenter.y;
            
            
            // center 기준으로 왼쪽에 있는 Label 들.
            if (angle > 90 && angle < 270)
            {
                if (x1 - thisLabel.width < 0)
                    workingGutters.left = Math.max(workingGutters.left, Math.abs(x1 - thisLabel.width));
            }
            // center 기준으로 오른쪽에 있는 Label 들.
            else if (angle < 90 || angle > 270)
            {
                if (x1 + thisLabel.width > width)
                    workingGutters.right = Math.max(workingGutters.right, x1 + thisLabel.width - width);
            }
            
            // center 기준으로 아래쪽에 있는 Label 들.
            if (angle > 0 && angle < 180)
            {
                if (y1 + thisLabel.height > height)
                    workingGutters.bottom = Math.max(workingGutters.bottom, y1 + thisLabel.height - height);
            }
            // center 기준으로 위쪽에 있는 Label 들.
            else if (angle > 180 && angle < 360)
            {
                if (y1 - thisLabel.height < 0)
                    workingGutters.top = Math.max(workingGutters.top, Math.abs(y1 - thisLabel.height));
            }
        }
        return [];
    }
    /**
     *  @private
     */
    private function calcRotationAndSpacing(width:Number, height:Number,
                                            targetHeight:Number,
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
        
        /*
        var labelRotation:Number = getStyle("labelRotation");       
        if (labelRotation > 90)
            labelRotation = 0 / 0;

        if (_horizontal == false)
        {
            if (isNaN(labelRotation))
                labelRotation = 0;
            if (labelRotation >= 0)
                labelRotation = 90 - labelRotation;
            else
                labelRotation =- (90 + labelRotation);
        }
        */
            
        // Decide if it's OK to drop labels.
        // We look for a style, and if we can't find it,
        // we check the Axis to see what the default should be.     
        /*
        var canDropLabelsStyle:Object = getStyle("canDropLabels");
        var canDropLabels:Boolean;
        if (canDropLabelsStyle == null)
        {
            // Since style cache fails with unset styles, we store
            // this off so we won't hit the style code over and over.
            canDropLabels = Boolean(_axis.preferDropLabels());
        }
        else
        {
            canDropLabels = canDropLabelsStyle != false &&
                            canDropLabelsStyle != "false";
        }
        */

        // Layout vertical if:
        // 1. horizontal, and label is 90 and canRotate is true
        // 2. (vertical, and rotation is null, 90), or (canRotate is false)
        
        var mustLayoutVertical:Boolean = false;
           /*  (_horizontal && _canRotate && labelRotation == 90) ||
            (_horizontal == false &&
             ((isNaN(labelRotation) ||
               labelRotation == 90) ||
               _canRotate == false)); */
    
        var canLayoutHorizontal:Boolean = true;
            /* mustLayoutVertical == false &&
            ((isNaN(labelRotation) && _horizontal == true) ||
            (labelRotation == 0) || (_canRotate == false)); */
        
        var horizontalScale:Number = 0;
        
        var canStaggerStyle:Object = getStyle("canStagger");
        var canStagger:Boolean =
            canStaggerStyle == null ||
            (canStaggerStyle != false &&
             canStaggerStyle != "false");

        var canLayoutStaggered:Boolean = true;
            /* mustLayoutVertical == false &&
            ((canDropLabels == false) &&
            canLayoutHorizontal &&
            (false != canStaggerStyle)); */
        
        var staggeredScale:Number = 0;
        
        var canLayoutAngled:Boolean = false;
            /* (mustLayoutVertical == false && 
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
            /* if (mustLayoutVertical)
            {
                verticalData = calcVerticalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            } */

            // Now, determine the gutter and/or dropLabel adjustments
            // for horizontal labels.
            if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, false /* canDropLabels */,
                    adjustable, minimumAxisLength);
                
                horizontalScale = horizontalSpacingData.scale;
                
                if (horizontalScale != 1 && canLayoutStaggered)
                {
                    staggeredSpacingData = calcStaggeredSpacing(
                        width, horizontalGutterData, targetHeight,
                        firstLabel, lastLabel, false /* canDropLabels */, adjustable);

                    staggeredScale = staggeredSpacingData.scale;
                }
            }

            // Now we're going to determine the optimal angle,
            // and gutter adjustments, for angled labels.
            /* if (horizontalScale != 1 && staggeredScale != 1 && canLayoutAngled)
            {
                angledGutterData = measureAngledGutters(
                    width, labelRotation, targetHeight,
                    firstLabel, leftGutter, rightGutter, adjustable);

                angledSpacingData = calcAngledSpacing(angledGutterData);

                angledScale = angledSpacingData.scale;
            } */

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
            }
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
            if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                minimumAxisLength = Math.min(
                    minimumAxisLength, horizontalGutterData.minimumAxisLength);         
            }

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
            /* if (mustLayoutVertical)
            {
                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            } */

            // Now determine the scale adjustments for horizontal labels.
            if (canLayoutHorizontal)
            {
                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, false /* canDropLabels */,
                    adjustable, minimumAxisLength);

                horizontalScale = horizontalSpacingData.scale;
            }

            // And the scale adjustments or staggered labels.
            if (canLayoutStaggered)
            {
                staggeredSpacingData = calcStaggeredSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, false /* canDropLabels */, adjustable);

                staggeredScale = staggeredSpacingData.scale;
            }

            /* if (canLayoutAngled)
            {
                angledSpacingData = calcAngledSpacing(angledGutterData);
                angledScale = angledSpacingData.scale;
            } */

            if (horizontalScale  >= staggeredScale &&
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
            }
        }
        
    }

    /**
     *  @private
     */
    private function calcHorizontalSpacing(width:Number,
                                           horizontalGutterData:Object,
                                           targetHeight:Number,
                                           firstLabel:ARLabelData,
                                           lastLabel:ARLabelData,
                                           canDropLabels:Boolean,
                                           adjustable:Object,
                                           minimumAxisLength:Number):Object
    {
        var horizontalleftGutter:Number = horizontalGutterData.horizontalleftGutter;
        var horizontalrightGutter:Number = horizontalGutterData.horizontalrightGutter;

        var horizontalScale:Number = 1;

        // Now check to see if we need to scale
        // to make up for max height violations.
        if (!isNaN(targetHeight))
            horizontalScale = Math.min(1, targetHeight / _maxLabelHeight);          

        var thisLabel:ARLabelData;
        var prevLabel:ARLabelData = firstLabel;
        
        var len:int = _labels.length;
        
        var axisLength:Number = width - horizontalleftGutter -
                                horizontalrightGutter;

        var spaceBetween:Number;
        var requiredSpace:Number;
        var scalingRequired:Boolean = true;
        
        var i:int;
        
        // If we can drop labels, do that.
        /* if (canDropLabels)
        {
            var base:int;
            var dir:int;
            var maxSkipCount:int = 0;
            var bLabelsReduced:Boolean;
            var bSkipRequired:Boolean = true;

            do
            {
                maxSkipCount = 0;
                var skipCount:int = 0;
                
                //if (_horizontal)
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[0];
                    base = 0;
                    dir = 1;                    
                }
                else
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[_labels.length - 1];
                    base = _labels.length - 1;
                    dir = -1;
                }

                var firstIntervalLabel:Object;
                var lastIntervalLabel:Object;
                            
                for (var i:int = 1; i < _labels.length; i++)
                {
                    thisLabel = _labels[base + dir * i];
                    spaceBetween =
                        Math.abs(thisLabel.position - prevLabel.position) *
                        axisLength;
                    requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                    if (requiredSpace > spaceBetween)
                    {
                        skipCount++;
                    }
                    else
                    {
                        if (skipCount > maxSkipCount)
                        {
                            maxSkipCount = skipCount;
                            firstIntervalLabel = prevLabel;
                            lastIntervalLabel = _labels[base + dir * (i - 1)];
                        }                       
                        skipCount = 0;
                        prevLabel = thisLabel;
                    }
                }
    
                if (skipCount > maxSkipCount)
                {
                    maxSkipCount = skipCount;
                    firstIntervalLabel = prevLabel;
                    lastIntervalLabel = _labels[base + dir * (i - 1)];
                }                       
                
                if (maxSkipCount)
                {
                    // Here's where we increase the interval.
                    bLabelsReduced = reduceLabels(firstIntervalLabel.value,
                                                  lastIntervalLabel.value);
                }
                else 
                {
                    bSkipRequired = false;
                    scalingRequired = false;                    
                }
            }
            while (bSkipRequired && bLabelsReduced)
        } */
        
        if (scalingRequired)
        {
            if (adjustable.left == false)
            {
                horizontalScale = Math.min(horizontalScale,
                    (horizontalleftGutter +
                     firstLabel.position * axisLength) /
                    (firstLabel.width / 2));                
            }

            if (adjustable.right == false)
            {
                horizontalScale = Math.min(horizontalScale,
                    (horizontalrightGutter +
                     (1 - lastLabel.position) * axisLength) /
                    (lastLabel.width / 2));             
            }

            // Never mind, we'll have to scale it..
            prevLabel = _labels[0];
            len = _labels.length;
            for (i = 1 ; i < len; i++)
            {
                thisLabel = _labels[i];
                spaceBetween = (thisLabel.position - prevLabel.position) *
                               axisLength;
                requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                horizontalScale = Math.min(horizontalScale,
                                           spaceBetween / requiredSpace);
                prevLabel = thisLabel;
            }
        }
        return { rotation: 0, 
                 left: horizontalleftGutter,
                 right: horizontalrightGutter,
                 scale: Math.max(0, horizontalScale), 
                 staggered: false };            
    }

    /**
     *  @private
     */
    private function calcStaggeredSpacing(width:Number,
                                          horizontalGutterData:Object,
                                          targetHeight:Number,
                                          firstLabel:ARLabelData,
                                          lastLabel:ARLabelData,
                                          canDropLabels:Boolean,
                                          adjustable:Object):Object
    {
        // We're assuming that we never can layout staggered
        // without being able to layout flat horizontal.
        var staggeredleftGutter:Number = horizontalGutterData.horizontalleftGutter;
        var staggeredrightGutter:Number = horizontalGutterData.horizontalrightGutter;
        var staggeredScale:Number;
        var axisLength:Number = width - staggeredleftGutter - staggeredrightGutter;
        
        // Check for scale to correct for max height violations.
        if (!isNaN(targetHeight))
            staggeredScale = Math.min(1, targetHeight / (2 * _maxLabelHeight));
        else
            staggeredScale = 1;

        var skipLabel:ARLabelData = firstLabel;
        lastLabel = _labels[1];

        if (adjustable.left == false)
        {
            staggeredScale = Math.min(
                staggeredScale,
                staggeredleftGutter / (firstLabel.width / 2));              
        }

        if (adjustable.right == false)
        {
            staggeredScale = Math.min(
                staggeredScale,
                staggeredrightGutter / (lastLabel.width / 2));              
        }

        // Now check for scaling due to overlap.
        // Note that we don't drop labels here...
        // if we can drop labels, then we always prefer horizontal
        // to staggered, and currently there's no way to force staggering.
        for (var i:int = 2; i <_labels.length; i++)
        {
            var thisLabel:ARLabelData = _labels[i];
            var spaceBetween:Number =
                (thisLabel.position - skipLabel.position) * axisLength;
            var requiredSpace:Number = (thisLabel.width + skipLabel.width) / 2;
            staggeredScale = Math.min(staggeredScale,
                                      spaceBetween / requiredSpace);
            skipLabel = lastLabel;
            lastLabel = thisLabel;
        }

        return { rotation: 0, 
                 left: staggeredleftGutter,
                 right:staggeredrightGutter,
                 scale: Math.max(0, staggeredScale), 
                 staggered: true };         
    }
        
    /**
     *  @private
     */
    private function measureHorizontalGutters(width:Number,
                                              leftGutter:Number,
                                              rightGutter:Number,
                                              firstLabel:ARLabelData,
                                              lastLabel:ARLabelData,
                                              adjustable:Object):Object
    {
        // With staggered labels, it's possible to have a very long
        // 2nd or 2nd-to-last label that pushes past the borders
        // before the end labels do. We should be checking those too.

        var labelAlignOffset:Number = 0.5;// this.labelAlignOffset;
        var axisLength:Number = width - leftGutter - rightGutter;

        var LS:Number = firstLabel.width * labelAlignOffset;
        var RS:Number = lastLabel.width * (1 - labelAlignOffset);
        var P1:Number = firstLabel.position;
        var P2:Number = 1 - lastLabel.position;

        var lhm:Number;
        var rhm:Number;

        // First, see if we need to push the gutters in.
        var leftOverlaps:Boolean = adjustable.left != false &&
                                   LS > leftGutter + P1 * axisLength;

        var rightOverlaps:Boolean = adjustable.right != false &&
                                    RS > rightGutter + P2 * axisLength;

        if (leftOverlaps == false && rightOverlaps == false)
        {
            lhm = leftGutter;
            rhm = rightGutter;
        }
        else if (leftOverlaps == true && rightOverlaps == false)
        {
            axisLength = (width - rightGutter - LS) / (1 - P1);
            lhm = width - rightGutter - axisLength;
            rhm = rightGutter;
            rightOverlaps = RS > rhm + P2 * axisLength;             
        }
        else if (leftOverlaps == false && rightOverlaps == true)
        {
            axisLength = (width - leftGutter - RS) / (1 - P2);
            lhm = leftGutter;
            rhm = width - leftGutter - axisLength;
            leftOverlaps = LS > lhm + P1 * axisLength;
        }
        
        if (leftOverlaps && rightOverlaps)
        {
            axisLength = (width - LS - RS) / (1 - P1 - P2);

            lhm = LS - P1 * axisLength;
            rhm = RS - P2 * axisLength;
        }

        return { horizontalleftGutter: lhm,
                 horizontalrightGutter: rhm,
                 minimumAxisLength: width - lhm - rhm };
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
        } */
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

        var baseline:Number;
        /* if (_inverted)
        {
            baseline = _gutters.top -
                       Number(showLine == true ? axisStroke.weight : 0) -
                       tickSize(showLine);
        }
        else */
        {
            baseline = unscaledHeight - _gutters.bottom + Number(showLine == true ? axisStroke.weight : 0) + 0;//tickSize(showLine);
        }

        var scale:Number = 1;//_labelPlacement.scale;
        var lcount:int = _labels.length;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
        
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
        
        var axisWidth:Number = unscaledWidth - _gutters.left - _gutters.right;
        var labelGap:Number = 5;//getStyle("labelGap");
        var alignOffset:Number = 0.5;//this.labelAlignOffset;

        //if (_labelPlacement.rotation == 0)
        {
            var oddLabelYOffset:Number = 0;

            /* if (_labelPlacement.staggered)
            {
                oddLabelYOffset = scale * _maxLabelHeight * 1;//(Number(_inverted ? -1 : 1));
            } */

            /* if (_inverted)
            {
                labelY = baseline - labelGap - _maxLabelHeight * scale;
                labelBottom = labelY - oddLabelYOffset;
            }
            else */
            {
                labelY = baseline + labelGap;
                labelBottom = labelY +
                              _maxLabelHeight * scale +
                              oddLabelYOffset;
            }
            
            var staggerCount:int = 0;
            var pCenter:Point = new Point((unscaledWidth - _gutters.right - _gutters.left) / 2 + gutters.left, (unscaledHeight - _gutters.bottom - _gutters.top) / 2 + _gutters.top);
            r = Math.min(unscaledWidth - _gutters.right - _gutters.left, unscaledHeight - _gutters.bottom - _gutters.top) / 2;
        
            for (i = 0; i < lcount; i++)
            {
                var angle:Number = (360 / lcount) * i;
                var raN:Number = angle * (Math.PI / 180);
                var thisLabel:ARLabelData = _labels[i];
                
                thisLabel.instance.rotation = 0;
                thisLabel.instance.x = Math.cos(raN) * r + pCenter.x;
                thisLabel.instance.y = Math.sin(raN) * r + pCenter.y;
                
                //thisLabel.instance.x -= IUITextField(thisLabel.instance).textWidth / 2;
                //thisLabel.instance.y -= IUITextField(thisLabel.instance).textHeight / 2;

                if (angle > 0 && angle < 180) {
                    // -_-
                }
                else if (angle > 180 && angle < 360 )
                {
                    thisLabel.instance.y -= thisLabel.height;
                }
                else
                {
                    thisLabel.instance.y -= thisLabel.height / 2;
                }
                
                if (angle < 90 || angle > 270)
                {
                    // -_-
                }
                else if (angle > 90 && angle < 270)
                {
                    thisLabel.instance.x -= thisLabel.width;
                } 
                else
                {
                    thisLabel.instance.x -= thisLabel.width / 2;
                }
                /*thisLabel.instance.x = _gutters.left +
                                       axisWidth * thisLabel.position -
                                       thisLabel.width * scale * alignOffset;
                thisLabel.instance.y = labelY + staggerCount * oddLabelYOffset;
                
                staggerCount = 1 - staggerCount; */
            }
        }
        /* else if (_labelPlacement.rotation > 0)
        {
            xAdjustment = 2 + Math.sin(_labelPlacement.rotation) *
                          firstLabel.height * scale / 2;
            
            var c:Number;
            var s:Number;
                        
            if (_inverted)
            {
                labelY = baseline - labelGap;

                if (_horizontal) // top, positive
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    alignOffset = 1 - alignOffset;
                    
                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.width * scale * c +
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY -
                                         ldi.width * scale * s -
                                         ldi.height * alignOffset * scale * c;
                    }

                    labelBottom = labelY - _maxRotatedLabelHeight;
                }
                else // right, positive
                {
                    r = -90 - (90 - ((_labelPlacement.rotation) / Math.PI * 180));
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY +
                                         ldi.height * alignOffset * scale * c;
                    }

                    labelBottom = labelY - _maxRotatedLabelHeight;
                }       
            }
            else // bottom or left, positive values
            {
                c = Math.cos(Math.abs(_labelPlacement.rotation));
                s = Math.sin(Math.abs(_labelPlacement.rotation));
                                
                r = -_labelPlacement.rotation / Math.PI * 180;
                
                labelY = baseline + labelGap;
                
                for (i = 0; i < lcount; i++)
                {
                    ldi = _labels[i];

                    ldi.instance.rotation = r;
                    
                    ldi.instance.x = _gutters.left +
                                     axisWidth * ldi.position -
                                     ldi.width * scale * c -
                                     ldi.height * alignOffset * scale * s;
                    
                    ldi.instance.y = labelY +
                                     ldi.width * scale * s -
                                     ldi.height * alignOffset * scale * c;
                }
                
                labelBottom = labelY;// + _maxRotatedLabelHeight;
            }
        }
        else // labelRotation < 0
        {
            if (_inverted)
            {
                if (_horizontal) //top, negative
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    labelY = baseline - labelGap;

                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;
                        
                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;
                        
                        ldi.instance.y = labelY -
                                         ldi.height * alignOffset * scale * c;
                    }

                    labelBottom = labelY + _maxRotatedLabelHeight;
                }
                else // right, negative
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));

                    labelY = baseline - labelGap;

                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY -
                                         ldi.height * alignOffset * scale * c;
                    }
                }
            }
            else
            {
                //if (_horizontal) // bottom, negative
                {
                    r = -_labelPlacement.rotation / Math.PI * 180;

                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));

                    labelY = baseline + labelGap;

                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x =_gutters.left +
                                        axisWidth * ldi.position +
                                        s * ldi.height * scale * alignOffset;

                        ldi.instance.y = labelY -
                                         c * ldi.height * scale * alignOffset;
                    }

                    labelBottom = labelY;// + _maxRotatedLabelHeight;
                }
                /* else // left, negative
                {
                    r = -180 - _labelPlacement.rotation / Math.PI * 180;

                    c = Math.cos(Math.abs(_labelPlacement.rotation + Math.PI/2));
                    s = Math.sin(Math.abs(_labelPlacement.rotation + Math.PI/2));

                    labelY = baseline + labelGap;

                    for (i = 0; i < lcount; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * c +
                                         ldi.width * scale * s;

                        ldi.instance.y = labelY +
                                         ldi.height * alignOffset * scale * s +
                                         ldi.width * scale * c;
                    }

                    labelBottom = labelY + _maxRotatedLabelHeight;
                }
            }
        }*/
        
        return labelBottom;
    }

    /**
     *  @private
     */
    private function drawAxis(showLine:Boolean):void {
        if (showLine)
        {
            var len:Number = chart.dataProvider.length;
            var pCenter:Point = new Point((unscaledWidth - _gutters.right - _gutters.left) / 2 + gutters.left, (unscaledHeight - _gutters.bottom - _gutters.top) / 2 + _gutters.top);
        
            var axisStroke:IStroke = getStyle("axisStroke");
            axisStroke.apply(graphics);
            
            var r:Number = Math.min(unscaledWidth - _gutters.right - _gutters.left, unscaledHeight - _gutters.bottom - _gutters.top) / 2;
            
            for (var i:Number = 0 ; i < len ; i++) {
                var raN:Number = (360 / len) * i * (Math.PI / 180);
                
                if (i == 0)
                    graphics.moveTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
                else
                    graphics.lineTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
            }
            raN = 0;
            graphics.lineTo(Math.cos(raN) * r + pCenter.x, Math.sin(raN) * r + pCenter.y);
        }
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
        var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
        
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
                    
                    (labelData.instance as IUITextField).htmlText = labelData.text;
                    
                    labelData.instance.width = labelData.width;
                    labelData.instance.height = labelData.height;
                }
            }
            /* else 
            {
                for (i = 0 ; i < len ; i++)
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
    private function processAxisLabels(newLabelData:AxisLabelSet):Boolean
    {
        var len:int;
        var labelValues:Array /* of String */ = [];
        var bUseRenderer:Boolean = false;//(_labelRenderer != null);
        var i:int;
        
        _supressInvalidations++;
        len = newLabelData.labels.length;

        _labels = [];
        
        // Initialize the labelvalues with the text.
        for (i = 0; i < len; i++)
        {
            labelValues.push(newLabelData.labels[i].text);
        }

        if (newLabelData != _axisLabelSet)
        {
            /* if (_labelFunction != null)
            {
                labelValues = [];
                for (i = 0; i < len; i++)
                {
                    labelValues.push(_labelFunction(this,newLabelData.labels[i].text));
                }
            } */
        }

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
            measuringField.embedFonts = systemManager && systemManager.isFontFaceEmbedded(tf);
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
        
        //if (_horizontal)
        {
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
                /* else
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
        }

        _maxLabelWidth = maxLabelWidth;
        _maxLabelHeight = maxLabelHeight;
        
        _forceLabelUpdate = false;

        _supressInvalidations--;

        return newLabelData.accurate == true;
    }

    /**
    *   @private
    */
    private function setupMouseDispatching():void
    {
        if(_highlightElements)
        {
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseOverHandler);
        }
        else
        {
            removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, mouseOverHandler);
        }
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

    /**
     *  @private
     */
    private function mouseOutHandler(event:MouseEvent):void
    {
        AxisBase(_axis).highlightElements(false);
    }
    
    /**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void
    {
        AxisBase(_axis).highlightElements(true);
    }

}
}


////////////////////////////////////////////////////////////////////////////////

import flash.display.DisplayObject;
import mx.charts.AxisLabel
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