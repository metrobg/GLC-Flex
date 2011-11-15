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
package org.openzet.utils
{
import flash.display.DisplayObject;
import flash.utils.*;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.series.AreaSeries;
import mx.charts.series.BarSeries;
import mx.charts.series.ColumnSeries;
import mx.charts.series.LineSeries;
import mx.containers.TitleWindow;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

/**
 * Static class that defines static methods used in relation with Chart controls.
 * 
 **/
public class ChartUtil
{
	include "../core/Version.as";
	/**
	 * @private
	 * 
	 * Internal instance of ColumnSeries. Since this method dynamically create series by invoking
	 * getDefinitionByName() method, we need to make at least one instance in advance of each series to use 
	 * to prevent runtime exception.
	 **/
	private var columnSer:ColumnSeries = new ColumnSeries();
	
	/**
	 * @private
	 * 
	 * Internal instance of LineSeries. Since this method dynamically create series by invoking
	 * getDefinitionByName() method, we need to make at least one instance in advance of each series to use 
	 * to prevent runtime exception.
	 **/
	private var lineSer:LineSeries = new LineSeries();
	
	
	/**
	 * @private
	 * 
	 * Internal instance of BarSeries. Since this method dynamically create series by invoking
	 * getDefinitionByName() method, we need to make at least one instance in advance of each series to use 
	 * to prevent runtime exception.
	 **/
	private var barSer:BarSeries = new BarSeries();

	/**
	 * @private
	 * 
	 * Internal instance of AreaSeries. Since this method dynamically create series by invoking
	 * getDefinitionByName() method, we need to make at least one instance in advance of each series to use
	 * to prevent runtime exception.
	 **/
	private var areaSer:AreaSeries = new AreaSeries();
	
	/**
	 * Static constant representing class name string for ColumnSeries.
	 **/
	public static const COLUMN_SERIES:String = "ColumnSeries";
	/**
	 * Static constant representing class name string for LineSeries.
	 **/
	public static const LINE_SERIES:String = "LineSeries";
	/**
	 * Static constant representing class name string for BarSeries.
	 **/
	public static const BAR_SERIES:String = "BarSeries";
	/**
	 * Static constant representing class name string for AreaSeries.
	 **/
	public static const AREA_SERIES:String ="AreaSeries";
	
	/**
	 * Shows a popUp TitleWindow to display a chart control with specified seriesType and dataProvider and xField.
	 * 
	 * @param chartType Type of series to show.
	 * @param dataProvider Data provider for a chart control.
	 * @param xField xField for series.
	 * 
	 **/
	public static function showPopUpChart(chartType:String, dataProvider:Object, xField:String = null):void {
		if (dataProvider) {
			var popup:TitleWindow = new TitleWindow();
			popup.addEventListener(CloseEvent.CLOSE, closeHandler, false, 0, true);
			popup.showCloseButton = true;
			var chart:CartesianChart = new CartesianChart();
			var fields:Array = org.openzet.utils.ObjectUtil.cloneFields(dataProvider[0]);
			var series:Array=[];
			var ser:*;
			var classRef:Class = getDefinitionByName("mx.charts.series."+chartType) as Class;
			var convertXYField:Boolean = chartType == BAR_SERIES? true: false;
			for (var i:int=0; i<fields.length;i++) {
				ser = new classRef();
				if (convertXYField) {
					ser.xField=fields[i];
					if (xField) ser.yField = xField;
				} else {
					ser.yField=fields[i];
					if (xField) ser.xField = xField;
				}
				ser.displayName = fields[i];
				series.push(ser);
			}
			chart.dataProvider = dataProvider;
			chart.series=series;
			popup.addChild(chart);
			PopUpManager.addPopUp(popup, mx.core.Application.application as DisplayObject);
			PopUpManager.centerPopUp(popup);
			
			function closeHandler(event:CloseEvent):void {
					event.currentTarget.removeEventListener(CloseEvent.CLOSE, closeHandler);
					PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
			}
		}
	}
}
}