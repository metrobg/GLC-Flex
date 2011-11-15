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
//-----------------------------------------------------------------------------
//
//  Imports
//
//-----------------------------------------------------------------------------
import flash.events.Event;
import flash.display.DisplayObject;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.Series;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.containers.HBox;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.utils.ObjectUtil;

import org.openzet.charts.chartClasses.VisibleCheckBox;

/**
 *  Custom Cartesian chart to easily control series' visibility.
 *
 *  @includeExample ZetCartesianChartExample.mxml
 */
public class ZetCartesianChart extends CartesianChart
{
    include "../../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     *
     *  default width for checkBoxes.
     */
    private const VIEW_CHECKBOX_DEFAULT_WIDTH:Number = 70;

    /**
     *  @private
     *
     *  default height for checkBoxes.
     */
    private const VIEW_CHECKBOX_DEFAULT_HEIGHT:Number = 30;

    /**
     *  @private
     *
     *  default y position of checkBoxes.
     */
    private const VIEW_CHECKBOX_DEFAULT_Y_POSITION:Number = 0;

    /**
     *  @private
     *
     *  left alignment of checkBoxes.
     */
    public const CHECKBOX_HORIZONTAL_LEFT_ALIGN:String = "left";

    /**
     *  @private
     *
     *  center alignment of checkBoxes.
     */
    public const CHECKBOX_HORIZONTAL_CENTER_ALIGN:String = "center";

    /**
     *  @private
     *
     *  right alignment of checkBoxes.
     */
    public const CHECKBOX_HORIZONTAL_RIGHT_ALIGN:String = "right";
    //-----------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-----------------------------------------------------------------------------
    public function ZetCartesianChart()
    {
        super();
    }

    //-----------------------------------------------------------------------------
    //
    //  Properties
    //
    //-----------------------------------------------------------------------------
    /**
     *  @private
     */
    private var _showSeriesBox:Boolean = false;

    /**
     *  @private
     */
    public function set showSeriesBox(value:Boolean):void
    {
        _showSeriesBox = value;
    }

    /**
     *  Flag to specify whether to show series control boxes.
     */
    public function get showSeriesBox():Boolean
    {
        return _showSeriesBox;
    }

    /**
     *  @private
     */
    private var _checkBoxHorizontalAlign:String = CHECKBOX_HORIZONTAL_LEFT_ALIGN;

    /**
     *  @private
     */
    public function set checkBoxHorizontalAlign(value:String):void
    {
        _checkBoxHorizontalAlign = value;
    }

    /**
     *  Alignment of checkBoxes.
     */
    public function get checkBoxHorizontalAlign():String
    {
        return _checkBoxHorizontalAlign;
    }

    /**
     *  @private
     */
    private var _checkBoxHorizontalGap:Number = 5;

    /**
     *  @private
     */
    public function set checkBoxHorizontalGap(value:Number):void
    {
        _checkBoxHorizontalGap = value;
    }

    /**
     *  Horizontal gap between checkBoxes.
     */
    public function get checkBoxHorizontalGap():Number
    {
        return _checkBoxHorizontalGap;
    }

    /**
     *  @private
     */
    private var _checkBoxYPoint:Number = VIEW_CHECKBOX_DEFAULT_Y_POSITION;

    /**
     *  @private
     */
    public function set checkBoxYPoint(value:Number):void
    {
        _checkBoxYPoint = value;
    }

    /**
     *  y position of checkBoxes.
     */
    public function get checkBoxYPoint():Number
    {
        return _checkBoxYPoint;
    }

    /**
     *  @private
     */
    private var _checkBoxWidth:Number = VIEW_CHECKBOX_DEFAULT_WIDTH;

    /**
     * @private
     */
    public function set checkBoxWidth(value:Number):void
    {
        _checkBoxWidth = value;
    }

    /**
     *  width of checkBoxes.
     */
    public function get checkBoxWidth():Number
    {
        return _checkBoxWidth;
    }

    /**
     *  @private
     */
    private var _checkBoxHeight:Number = VIEW_CHECKBOX_DEFAULT_HEIGHT;

    /**
     *  @private
     */
    public function set checkBoxHeight(value:Number):void
    {
        _checkBoxHeight = value;
    }

    /**
     *  height of checkBoxes.
     */
    public function get checkBoxHeight():Number
    {
        return _checkBoxHeight;
    }

    /**
     *  @private
     */
    private var _showMarker:Boolean = true;

    /**
     * @private
     */
    public function set showMarker(value:Boolean):void
    {
        _showMarker = value;
    }

    /**
     *  Visibility of markers.
     */
    public function get showMarker():Boolean
    {
        return _showMarker;
    }

    /**
     *  @private
     */
    private var _showVisibleBox:Boolean = true;

    /**
     *  @private
     */
    public function set showVisibleBox(value:Boolean):void
    {
        _showVisibleBox = value;
    }

    /**
     *  Visibility of checkBoxes.
     */
    public function get showVisibleBox():Boolean
    {
        return _showVisibleBox;
    }
    //-----------------------------------------------------------------------------
    //
    //  Variables
    //
    //-----------------------------------------------------------------------------
    /**
     *  @private
     */
    private var visibleCheckBoxArr:Array = [];
    //-----------------------------------------------------------------------------
    //
    //  Override Methods
    //
    //-----------------------------------------------------------------------------
    /**
    *  @private
    *  Overrides superclass's commitProperties() method to control series control boxes.
     */
    override protected function commitProperties():void
    {
        if(showSeriesBox)
        {
            var tempArr:Array = [createVisibleBox];
            callLater(callLater, tempArr);
        }

        super.commitProperties();
    }

    //-----------------------------------------------------------------------------
    //
    //  Methods
    //
    //-----------------------------------------------------------------------------
    /**
     *  Creates series' control boxes.
     */
    protected function createVisibleBox():void
    {
        var i:int;
        var n:int = series.length;

        for (i = 0; i < visibleCheckBoxArr.length; i++)
        {
            var tempNum:int = i;

            removeChild(visibleCheckBoxArr[i]);
        }

        visibleCheckBoxArr = [];

        for(i = 0; i < n; i++)
        {
            var checkBox:VisibleCheckBox = new VisibleCheckBox();
            checkBox.seriesData = series[i];
            checkBox.showVisibleBox = this._showVisibleBox;

            checkBox.showMarker = this._showMarker;
            checkBox.width = _checkBoxWidth;
            checkBox.height = _checkBoxHeight;

            visibleCheckBoxArr.push(checkBox);

            if(this.width == 0)
            {
                checkBox.x = i * (checkBox.width + _checkBoxHorizontalGap);
                checkBox.y = 0;
            }
            else
            {
                updateCheckBoxLayout();
            }

            addChildAt(checkBox, numChildren);
        }
    }

    /**
     *  Adjust checkBoxes' position.
     *
     */
    protected function updateCheckBoxLayout():void
    {
        var i:int;
        var n:int = visibleCheckBoxArr.length;

        if(checkBoxHorizontalAlign == CHECKBOX_HORIZONTAL_LEFT_ALIGN)
        {
            for(i = 0; i < n; i++)
            {
                visibleCheckBoxArr[i].x = i * (visibleCheckBoxArr[i].width + _checkBoxHorizontalGap);
                visibleCheckBoxArr[i].y = _checkBoxYPoint;
            }
        }
        else if(checkBoxHorizontalAlign == CHECKBOX_HORIZONTAL_CENTER_ALIGN)
        {
            var tempWidth:Number = (_checkBoxWidth + _checkBoxHorizontalGap) * n;

            var initPosition:Number = (this.width / 2) - (tempWidth / 2);

            for (i = 0; i < n; i++)
            {
                visibleCheckBoxArr[i].x = (i * (visibleCheckBoxArr[i].width + _checkBoxHorizontalGap)) + initPosition;
            }
        }
        else if(checkBoxHorizontalAlign == CHECKBOX_HORIZONTAL_RIGHT_ALIGN)
        {
            for(i = 0; i < n; i++)
            {
                visibleCheckBoxArr[i].x = this.width - ((visibleCheckBoxArr[i].width * (n - i))) + _checkBoxHorizontalGap*i;
                visibleCheckBoxArr[i].y = _checkBoxYPoint;
            }
        }
    }
}
}