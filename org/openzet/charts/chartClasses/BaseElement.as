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
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.charts.chartClasses.ChartElement;
import mx.events.FlexEvent;
import mx.styles.StyleManager;
//import com.hexagonstar.util.debug.Debug;

/**
 *  The color of the selected Area
 */
[Style(name="colorOfArea", type="uint", format="Color", inherit="yes")]


/**
 *  BaseElement class extracts data from a chart control.
 *
 *   @includeExample BaseElementExample.mxml
 */
public class BaseElement extends ChartElement
{
    include "../../core/Version.as";
    /**
     *  @private
     *  Constructor
     */
    public function BaseElement()
    {
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHander);
    }

    /**
     *  @private
     *  data field property
     */
    public var fieldName:String = "";

    [Bindable]
    /**
     *  Detailed data around the mouse position.
     */
    public var selectData:Array = [];

    /**
     *  Property to specify how many data to extract.
     */
    public var maxDataNum:int = 3;

    /**
     *  @private
     *  Mouse click flag
     */
    private var isPress:Boolean;

    /**
     *  @private
     *  Flag to specify whether selecteData is being set.
     */
    private var isSetSelectData:Boolean = false;

    /**
     *  @private
     *  data gap size
     */
    private var gapSize:Number;

    /**
     *  @private
     */
    private var isEvenNumber:Boolean;

    /**
     *  @private
     *  Mouse point
     */
    private var point:Point;

    /**
     *  @private
     *  creationCompleteHandler
     */
    private function creationCompleteHander(event:FlexEvent):void
    {
        chart.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
        chart.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
    }

    /**
     *  @private
     *  mouseDownHandler
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        isPress = true;
        var g:Graphics = graphics;
        g.clear();
        mouseMoveHandler(event);

        //Debug.trace("(" + d[0] + "," + Math.floor(d[1]) + ")");
    }

    /**
     *  @private
     *  mouseMoveHandler
     */
    private function mouseMoveHandler(event:MouseEvent):void
    {
        if (isPress && !isSetSelectData)
        {
            isSetSelectData = true;
            var gap:Number = chart.width / chart.dataProvider.length * gapSize;
            var startX:Number = mouseX - gap;// > 0 ? mouseX - gap : 0;
            var endX:Number = mouseX + gap;// >= width ? width : mouseX + gap;
            var g:Graphics = graphics;
            var findDataArray:Array = [];

            var pointGapX:Number = chart.width / chart.dataProvider.length;
            var color:uint = StyleManager.isValidStyleValue("colorOfArea")?getStyle("colorOfArea"):0x6378ed;

            g.clear();
            g.beginFill(color, 0.5);
            g.drawRect(startX, 0, gap * 2, height);
            g.endFill();


            for (var k:Number = 0; k < maxDataNum; k++)
            {
                point = new Point(startX + (pointGapX * k), chart.mouseY);
                //var localToData:Array = chart.localToData(point);
                var localToData:Array = chart.series[0].localToData(point);
                //Debug.trace(ObjectUtil.toString(localToData));
                if (findDataArray.length > 0)
                {
                    if (localToData[0] != findDataArray[findDataArray.length-1])
                    {
                        findDataArray.push(localToData[0]);
                    }
                }
                else
                {
                    findDataArray.push(localToData[0]);
                }
            }
            selectData = [];
            for (var i:int = 0; i < findDataArray.length; i++)
            {
                for (var j:int = 0; j < chart.dataProvider.length; j++)
                {
                    if (chart.dataProvider[j][fieldName] == findDataArray[i])
                    {
                        selectData.push(chart.dataProvider[j]);
                    }
                }
            }
            isSetSelectData = false;
        }
    }

    /**
     *  @private
     */
    /*
    override protected function createChildren():void
    {
        super.createChildren();
        var layer:Sprite = new Sprite();
        layer.name = "drawLayer";
        addChild(layer);
    }
    */

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        if (maxDataNum > chart.dataProvider.length)
        {
            maxDataNum = chart.dataProvider.length;
        }

        isEvenNumber = Boolean(maxDataNum % 2 == 0);
        gapSize = Math.floor(maxDataNum / 2);
        if (isEvenNumber)
        {
            gapSize -= 0.5;
        }
    }

    /**
     *  @private
     */
    /*
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        var s:Sprite = getChildByName("drawLayer") as Sprite;
        if (s)
        {
            //return;
            s.graphics.beginFill(0xFFFFFF,0);
            s.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
            s.graphics.endFill();
        }
    }
    */

}
}