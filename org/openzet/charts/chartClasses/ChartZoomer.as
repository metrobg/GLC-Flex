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
import flash.events.MouseEvent;

import mx.charts.chartClasses.CartesianChart;
import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.HDividedBox;
import mx.events.DividerEvent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;

import org.openzet.events.ChartZoomerEvent;

//-----------------------------------------------------------------------------
//
//  Events
//
//-----------------------------------------------------------------------------
/**
 *  Dispatched when the user drags the Divider.
 *
 *  @eventType control.events.ChartZoomInEvent
 */
[Event(name="dividerChange", type="org.openzet.events.ChartZoomerEvent")]

/**
 *  ChartZoomer class is used as an annotationElement for data extraction of a chart control. 
 *
 *  @includeExample ChartZoomerExample.mxml
 */
public class ChartZoomer extends HDividedBox
{
    include "../../core/Version.as";
    //-----------------------------------------------------------------------------
    //
    //  Class constants
    //
    //-----------------------------------------------------------------------------
    /**
     *  @private
     *
     *  Default percent width of each area. 
     */
    private const AREA_DEFAULT_PERCENT_WIDTH:Number = 100;
    
    /**
     *  @private
     *
     *  Default percent height of each area. 
     */
    private const AREA_DEFAULT_PERCENT_HEIHGT:Number = 100;

    /**
     *  @private
     *
     *  Default left value from which index to extract chart data 
     */
    private const DEFAULT_LEFT_VALUE:int = 0;

    /**
     *  @private
     * 
     *   Default right value to which index to extract chart data 
     */
    private const DEFAULT_RIGHT_VALUE:int = 50;
    //-----------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-----------------------------------------------------------------------------
    /**
     *  Constructor
     */
    public function ChartZoomer()
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
    private var _leftArea:Canvas;

    /**
     *  Left Area of HDividedBox
     *
     */
    public function get leftArea():Canvas
    {
        return _leftArea;
    }

    /**
     *  @private
     */
    private var _centerArea:Canvas;
    
    /**
     *  Center Area of HDividedBox
     *
     */
    public function get centerArea():Canvas
    {
        return _centerArea;
    }

    /**
     *  @private
     */
    private var _rightArea:Canvas;
    
    /**
     *  Right Area of HDividedBox
     *
     */
    public function get rightArea():Canvas
    {
        return _rightArea;
    }

    /**
     *  @private
     */
    private var _navigateChart:CartesianChart

    /**
     * @private
     */
    public function set navigateChart(value:CartesianChart):void
    {
        _navigateChart = value;
    }

    /**
     * Target chart to extract data from. 
     */
    public function get navigateChart():CartesianChart
    {
        return _navigateChart;
    }

    
    /**
     *  @private
     */
    private var _chartData:ArrayCollection
    
    /**
     *  @private 
     */
    public function set chartData(value:ArrayCollection):void
    {
        _chartData = value;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    [Bindable("dataChange")]
    /**
     *  Data provider bound with target chart control. 
     */
    public function get chartData():ArrayCollection
    {
        return _chartData;
    }

    /**
     *  @private
     */
    private var _areaPercentHeight:Number = AREA_DEFAULT_PERCENT_HEIHGT;

    /**
     *  Percent height for left, center and right.
     */
    public function get areaPercentHeight():Number
    {
        return _areaPercentHeight;
    }

    /**
     *  @private
     */
    private var _areaPercentWidth:Number = AREA_DEFAULT_PERCENT_WIDTH;

    /**
     *  Percent width for left, center and right.
     */
    public function get areaPercentWidth():Number
    {
        return _areaPercentWidth;
    }

    /**
     *  @private
     */
    private var _leftValue:int = DEFAULT_LEFT_VALUE;
    
    /**
     *  @private
     */
    public function set leftValue(value:int):void
    {
        _leftValue = value;
    }

    /**
     *  Data's extraction start index.
     */
    public function get leftValue():int
    {
        return _leftValue;
    }
    
    /**
     *  @private
     */
    private var _rightValue:int = DEFAULT_RIGHT_VALUE;

    /**
     *  @private 
     */
    public function set rightValue(value:int):void
    {
        _rightValue = value;
    }

    /**
     *  Data's extraction end index. 
     */
    public function get rightValue():int
    {
        return _rightValue;
    }

    
    /**
     *  @private
     */
    private var _isDragEnabled:Boolean = false;

    /**
     *  Flag that indicates whehter center area is clicked on.
     */
    public function get isDragEnabled():Boolean
    {
        return _isDragEnabled;
    }

    //-----------------------------------------------------------------------------
    //
    //  Variables
    //
    //-----------------------------------------------------------------------------
    /**
     *  @private
     *
     *  x position of mouse pointer when first clicked.
     */
    private var mouseXPosition:int;

    /**
     *  @private
     *
     *  Data extraction start index when users click on the center area.
     */
    private var currentLeftValue:int;

    /**
     *  @private
     *
     * Data extraction end index when users click on the center area.
     */
    private var currentRightValue:int;
    //-----------------------------------------------------------------------------
    //
    //  Override Method
    //
    //-----------------------------------------------------------------------------
    /**
     * @private
     * Calls superclass's createChildren() method.
     */
    override protected function createChildren():void
    {
        configure();

        super.createChildren();
    }

    //-----------------------------------------------------------------------------
    //
    //  Method
    //
    //-----------------------------------------------------------------------------
    /**
     *  @private
     *
     *  Configures HDividedBox's properties and styles.
     */
    private function configure():void
    {
        this.percentWidth = 100;
        this.horizontalScrollPolicy = "off";
        this.liveDragging = true;

        this.addEventListener(DividerEvent.DIVIDER_DRAG, dividerDragHandler);
        
        this.addEventListener(FlexEvent.DATA_CHANGE, chartDataChangeHandler);

        createLayout();
    }

    /**
     * 
     * Creates the layout of this control. 
     */
    protected function createLayout():void
    {
        if(!itemInvalidate()) return;

        if(!_leftArea)
        {
            _leftArea = new Canvas();
            _leftArea.setStyle("backgroundColor", 0xFFFFFF);
            _leftArea.setStyle("backgroundAlpha", 0.6);
            addChildAt(_leftArea, 0);
        }

        if(!_centerArea)
        {
            _centerArea = new Canvas();
            
            _centerArea.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDownHandler);
            _centerArea.buttonMode = true;
            _centerArea.useHandCursor = true;
            addChildAt(_centerArea, 1);
        }

        if(!_rightArea)
        {
            _rightArea = new Canvas();
            _rightArea.setStyle("backgroundColor", 0xFFFFFF);
            _rightArea.setStyle("backgroundAlpha", 0.6);
            addChildAt(_rightArea, 2);
        }
    }

    /**
     *  Updates the layout.
     */
    protected function updateLayout():void
    {
        _leftArea.percentHeight = areaPercentHeight;
        _leftArea.width = int((this.width / chartData.length) * leftValue);
        
        
        _centerArea.percentWidth = areaPercentWidth;
        _centerArea.percentHeight = areaPercentHeight;

        
        _rightArea.width = int((this.width / chartData.length) * (chartData.length - rightValue));
        _rightArea.percentHeight = areaPercentHeight;

        dispatchEvent(new ChartZoomerEvent(ChartZoomerEvent.DIVIDER_CHANGE, false,  false, leftValue, rightValue));
    }

    /** 
     *  필수 요소인 navigateChart와 chartData를 체크하여 화면을 구성하는데 있어 발생할 수 있는 문제를 방지한다.
     */
    protected function itemInvalidate():Boolean
    {
        if(!_navigateChart)
        {
            throw new Error("No target chart is specified.");
            return false
        }

        if(!_chartData)
        {
            throw new Error("No dataProvider is set.");
            return false
        }

        return true;
    }

    //-----------------------------------------------------------------------------
    //
    //  EventHandler
    //
    //-----------------------------------------------------------------------------
    
    /**
     *  @private
     *  
     *  divider's drag event handler.
     */
    private function dividerDragHandler(event:DividerEvent):void
    {
         leftValue = int(_leftArea.width / (this.width / chartData.length));
         rightValue = -(int((_rightArea.width / (this.width / chartData.length)) - chartData.length));

        updateLayout();
    }

    /**
     *  @private
     *  
     *  mouseDown event handler for center area. 
     */
    private function viewMouseDownHandler(event:MouseEvent):void
    {
        _isDragEnabled = true;
        
        mouseXPosition = this.mouseX;
        currentLeftValue = _leftValue;
        currentRightValue = _rightValue;

        this.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        this.systemManager.addEventListener(MouseEvent.MOUSE_UP, viewMouseUpHandler);
    }

    /**
     *  @private
     *  mouseUp event handler for center area. 
     */
    private function viewMouseUpHandler(event:MouseEvent):void
    {
        _isDragEnabled = false;

        this.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        this.systemManager.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUpHandler);
    }

    /**
     *  @private
     * mouseMove event handler for dividers. 
     */
    private function mouseMoveHandler(event:MouseEvent):void
    {
        var tempLeftValue:int = int(currentLeftValue - (mouseXPosition - this.mouseX) / (this.width / _chartData.length));
        var tempRightValue:int = int(currentRightValue - (mouseXPosition - this.mouseX) / (this.width / _chartData.length));

        if(tempLeftValue <= 0)
        {
            tempLeftValue = 0;
        }
        else if((chartData.length - tempRightValue) <= 0)
        {
            tempRightValue = chartData.length;
        }

        leftValue = tempLeftValue;
        rightValue = tempRightValue;

        updateLayout();
    }

    /**
     *  @private
     *  Data change event handler for chart's data provider. 
     */
    private function chartDataChangeHandler(event:FlexEvent):void
    {
        if(_chartData.length <= 0)
        {
            return;
        }

        dividerDragHandler(new DividerEvent(DividerEvent.DIVIDER_DRAG));
        
        this.addEventListener(ResizeEvent.RESIZE, resizeHandler);
    }
	
	/**
	 * @private
	 * resize event handler. 
	 **/
    private function resizeHandler(event:ResizeEvent):void
    {
        callLater(updateLayout);
    }
}
}