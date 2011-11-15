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
//---------------------------------------------------------------------------
//
//  Imports
//
//---------------------------------------------------------------------------
import flash.events.Event;
import flash.display.DisplayObject;

import mx.charts.chartClasses.Series;
import mx.controls.CheckBox;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.UITextField;

/**
 *  As part of ZetCartesianChart, comprises marker and checkBox to selectively choose the visibility of
 *  each series. 
 */
public class VisibleCheckBox extends UIComponent
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
     *  CheckBox's default width.
     */
    private const CHECKBOX_DEFAULT_WIDTH:Number = 70;
    
    /**
     *  @private
     *
     *  CheckBox's default height. 
     */
    private const CHECKBOX_DEFAULT_HEIGHT:Number = 17;
    
    /**
     *  @private
     *
     *  Gap between marker and checkBox.
     */
    private const MARKER_DEFAULT_GAP:Number = 3;

    /**
     *  @private
     *
     *  marker's default width.
     */
    private const MARKER_DEFAULT_WIDTH:Number = 10;

    /**
     *  @private
     *
     *  marker's default height. 
     */
    private const MARKER_DEFAULT_HEIGHT:Number = 14;
    //---------------------------------------------------------------------------
    //
    //  Constructor
    //
    //---------------------------------------------------------------------------
    /**
     *  constructor()
     */
    public function VisibleCheckBox()
    {
        super();
    }

    //---------------------------------------------------------------------------
    //
    //  Properties
    //
    //---------------------------------------------------------------------------
    /**
     *  @private
     */
    private var _seriesData:Series;

    /**
     *  @private
     */
    public function set seriesData(value:Series):void
    {
        _seriesData = value;
        callLater(createVisibleCheckBox);
    }
    
    /**
     *  Series comprising ther current chart. 
     */
    public function get seriesData():Series
    {
        return _seriesData;
    }

    /**
     *  @private
     */
    private var _checkBoxWidth:Number = CHECKBOX_DEFAULT_WIDTH;

    /**
     *  @private 
     */
    public function set checkBoxWidth(value:Number):void
    {
        _checkBoxWidth = value;
    }

    /**
     *  CheckBox's width
     */
    public function get checkBoxWidth():Number
    {
        return _checkBoxWidth;
    }

    /**
     *  @private
     */
    private var _checkBoxHeight:Number = CHECKBOX_DEFAULT_HEIGHT;
    
    /**
     *  CheckBox's height 
     */
    public function set checkBoxHeight(value:Number):void
    {
        _checkBoxHeight = value;
    }

    /**
     *  @private
     */
    public function get checkBoxHeight():Number
    {
        return _checkBoxHeight;
    }

    /**
     *  @private
     */
    private var _markerGap:Number = MARKER_DEFAULT_GAP;

    /**
     * @private 
     */
    public function set markerGap(value:Number):void
    {
        _markerGap = value;
    }

    /**
     *   gap between marker and checkBox.
     */
    public function get markerGap():Number
    {
        return _markerGap;
    }

    /**
     *  @private
     */
    private var _markerWidth:Number = MARKER_DEFAULT_WIDTH;

    /**
     *  @private 
     */
    public function set markerWidth(value:Number):void
    {
        _markerWidth = value;
    }

    /**
     *  Marker's width. 
     */
    public function get markerWidth():Number
    {
        return _markerWidth;
    }

    /**
     *  @private
     */
    private var _markerHeight:Number = MARKER_DEFAULT_HEIGHT;

    /**
     *  @private
     */
    public function set markerHeight(value:Number):void
    {
        _markerHeight = value;
    }

    /**
     * Marker's height.
     */
    public function get markerHeight():Number
    {
        return _markerHeight;
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
     *  Visibility of checkboxes to control each series' visibility.
     */
    public function get showVisibleBox():Boolean
    {
        return _showVisibleBox;
    }

    //---------------------------------------------------------------------------
    //
    //  Methods
    //
    //---------------------------------------------------------------------------
    /**
     * @private
     * Creates visibility control checkBoxes and markers. 
     */
    protected function createVisibleCheckBox():void
    {
        var tempSeriesData:Series = _seriesData;
        
        if(_showMarker)
        {
            var marker:IFlexDisplayObject = _seriesData.legendData[0].marker;
            marker.y = 2;
            marker.width = _markerWidth;
            marker.height = _markerHeight;

            addChild(DisplayObject(marker));
        }

        if(_showVisibleBox)
        {
            var visibleBox:CheckBox = new CheckBox();

            visibleBox.addEventListener(Event.CHANGE, checkBoxChangeHandler);

            visibleBox.width = _checkBoxWidth;
            visibleBox.height = _checkBoxHeight;
            
            if(_showMarker)
            {
                visibleBox.x = marker.width + _markerGap;
            }

            visibleBox.label = tempSeriesData.displayName;
            visibleBox.selected = true;
            
            _seriesData.visible = true;

            addChild(visibleBox);
        }
        else
        {
            var labelText:UITextField = new UITextField();
            labelText.text = tempSeriesData.displayName;

            if(_showMarker)
            {
                labelText.x = marker.width + _markerGap;
            }
            
            
            addChild(labelText);

        }
    }

    //---------------------------------------------------------------------------
    //
    //  EventHandler
    //
    //---------------------------------------------------------------------------
    /**
     *  @private
     *
     *  change handler for checkBoxs.
     */
    private function checkBoxChangeHandler(event:Event):void
    {
        _seriesData.visible = event.target.selected;
    }
}
}