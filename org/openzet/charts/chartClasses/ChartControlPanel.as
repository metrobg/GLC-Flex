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

import mx.charts.CategoryAxis;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.Series;
import mx.charts.series.AreaSeries;
import mx.charts.series.BarSeries;
import mx.charts.series.BubbleSeries;
import mx.charts.series.CandlestickSeries;
import mx.charts.series.ColumnSeries;
import mx.charts.series.HLOCSeries;
import mx.charts.series.LineSeries;
import mx.charts.series.PlotSeries;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.core.Container;
//----------------------------------------------------------------------------
//
//  Event
//
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//
//  Style
//
//----------------------------------------------------------------------------
/**
 * ChartControlPanel class dynamically changes series of a target chart control. Yet you need to note that
 * this class is used only for CartesianChart type.
 *
 *  @includeExample ChartControlPanelExample.mxml
 **/
public class ChartControlPanel extends Container
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
     *  TextInput's default width
     */
    private const TEXTINPUT_DEFAULT_WIDTH:Number = 140;

    /**
     *  @private
     *
     *  TextInput's default height
     */
    private const TEXTINPUT_DEFAULT_HEIGHT:Number = 22;

    /**
     *  @private
     *
     * Default gap between controls
     */
    private const DEFAULT_HORIZONTAL_GAP:Number = 3;

    /**
     *  @private
     *
     *  ComboBox's default width
     */
    private const COMBOBOX_DEFAULT_WIDTH:Number = 140;

    /**
     *  @private
     *
     *  ComboBox's default height
     */
    private const COMBOBOX_DEFAULT_HEIGHT:Number = 22;

    /**
     *  @private
     *
     *  Setting button's width
     */
    private const SETTING_BUTTON_DEFAULT_WIDTH:Number = 70;

    /**
     *  @private
     *
     *  Setting button's height
     */
    private const SETTING_BUTTON_DEFAULT_HEIGHT:Number = 22;
    //----------------------------------------------------------------------------
    //
    //  Constructor
    //
    //----------------------------------------------------------------------------
    /**
     *  constructor()
     */
    public function ChartControlPanel()
    {
        super();
    }

    //----------------------------------------------------------------------------
    //
    //  Properties
    //
    //----------------------------------------------------------------------------
    /**
     *  @private
     */
    private var _targetChart:CartesianChart;

    /**
     *  @private
     */
    public function set targetChart(value:CartesianChart):void
    {
        _targetChart = value;
        callLater(configureSereise);
    }

    /**
     *  Property to specify the target chart. Only CartesianChart is supported.
     */
    public function get targetChart():CartesianChart
    {
        return _targetChart;
    }

    /**
     *  @private
     */
    private var _selectedSeries:Series;

     /**
     *  @private
     */
    public function set selectedSeries(value:Series):void
    {
        _selectedSeries = value;
        searchSeriesKind();
    }

   /**
     *  Selected series
     */
    public function get selectedSeries():Series
    {
        return _selectedSeries;
    }

    /**
     *  @private
     */
    private var _horizontalGap:Number = DEFAULT_HORIZONTAL_GAP;

    /**
     *  @private
     */
    public function set horizontalGap(value:Number):void
    {
        _horizontalGap = value;
    }

    /**
     *  Horizontal gap
     */
    public function get horizontalGap():Number
    {
        return _horizontalGap;
    }

    /**
     *  @private
     */
    private var _seriesStatusWidth:Number = TEXTINPUT_DEFAULT_WIDTH;

    /**
     *  @private
     */
    public function set seriesStatusWidth(value:Number):void
    {
        _seriesStatusWidth = value;
    }

    /**
     *  Series status textInput's width
     */
    public function get seriesStatusWidth():Number
    {
        return _seriesStatusWidth;
    }

    /**
     *  @private
     */
    private var _seriesStatusHeight:Number = TEXTINPUT_DEFAULT_HEIGHT;

    /**
     *  @private
     */
    public function set seriesStatusHeight(value:Number):void
    {
        _seriesStatusHeight = value;
    }

    /**
     *  Series status textInput's height
     */
    public function get seriesStatusHeight():Number
    {
        return _seriesStatusHeight;
    }

    /**
     *  @private
     */
    private var _seriesKindComboWidth:Number = COMBOBOX_DEFAULT_WIDTH;

    /**
     *  @private
     */
    public function set seriesKindComboWidth(value:Number):void
    {
        _seriesKindComboWidth = value;
    }

    /**
     *  ComboBox's width
     */
    public function get seriesKindComboWidth():Number
    {
        return _seriesKindComboWidth;
    }

    /**
     *  @private
     */
    private var _seriesKindComboHeight:Number = COMBOBOX_DEFAULT_HEIGHT;

    /**
     *   @private
     */
    public function set seriesKindComboHeight(value:Number):void
    {
        _seriesKindComboHeight = value;
    }

    /**
     *  ComboBox's height
     */
    public function get seriesKindComboHeight():Number
    {
        return _seriesKindComboHeight;
    }

    /**
     *  @private
     */
    private var _settingButtonLabel:String = "";

    /**
     *   @private
     */
    public function set settingButtonLabel(value:String):void
    {
        _settingButtonLabel = value;
    }

    /**
     *  Setting button's label
     */
    public function get settingButtonLabel():String
    {
        return _settingButtonLabel;
    }

    /**
     *  @private
     */
    private var _settingButtonWidth:Number = SETTING_BUTTON_DEFAULT_WIDTH;

    /**
     *  @private
     */
    public function set settingButtonWidth(value:Number):void
    {
        _settingButtonWidth = value;
    }

    /**
     *  Setting button's width
     */
    public function get settingButtonWidth():Number
    {
        return _settingButtonWidth;
    }

    /**
     *  @private
     */
    private var _settingButtonHeight:Number = SETTING_BUTTON_DEFAULT_HEIGHT;

    /**
     *  @private
     */
    public function set settingButtonHeight(value:Number):void
    {
        _settingButtonHeight = value;
    }

    /**
     * Setting button's height
     */
    public function get settingButtonHeight():Number
    {
        return _settingButtonHeight;
    }
    //----------------------------------------------------------------------------
    //
    //  Variables
    //
    //----------------------------------------------------------------------------
    /**
     *  @private
     *
     *  List of available series to change to.
     */
    private var seriesKindAC:ArrayCollection = new ArrayCollection([{label : "AreaSeries"},
                                                                    {label : "BarSeries"},
                                                                    {label : "ColumnSeries"},
                                                                    {label : "LineSeries"},
                                                                    {label : "PlotSeries"}]);
    /**
     *  @private
     *
     *  ComboBox to display series types.
     */
    private var seriesKindCombo:ComboBox;

    /**
     *  @private
     *
     *  TextInput to display selected series.
     */
    private var selectedSeriesDisplayName:TextInput;

    /**
     *  @private
     *
     *  Setting button
     */
    private var settindBtn:Button;

    /**
     *  @private
     *
     *  Series's index
     */
    private var seriesIndex:int;

    /**
     *  @private
     *
     *  Storage for the last series that was changed to other type of series.
     */
    private var oldSeries:String;
    //----------------------------------------------------------------------------
    //
    //  Override Methods
    //
    //----------------------------------------------------------------------------
    /**
    * @private
    **/
    override protected function commitProperties():void
    {
        this.width = 10;
        this.height = 25;

        createChildElement();
        super.commitProperties();
    }

    //----------------------------------------------------------------------------
    //
    //  Methods
    //
    //----------------------------------------------------------------------------
    /**
     *  @private
     *
     *  Adds eventlisteners for target chart's series.
     */
    private function configureSereise():void
    {
        var i:int;
        var n:int = targetChart.series.length;

        for(i = 0; i < n; i++)
        {
            targetChart.series[i].addEventListener(MouseEvent.CLICK, seriesClickHandler);
        }
    }

    /**
     * @private
     * Lays out controls inside.
     */
    protected function createChildElement():void
    {
        if(!selectedSeriesDisplayName)
        {
            selectedSeriesDisplayName = new TextInput();

            selectedSeriesDisplayName.width = _seriesStatusWidth;
            selectedSeriesDisplayName.height = _seriesStatusHeight
            selectedSeriesDisplayName.editable = false;
            addChild(selectedSeriesDisplayName);

            this.width += selectedSeriesDisplayName.width;
        }

        if(!seriesKindCombo)
        {
            seriesKindCombo = new ComboBox();
            seriesKindCombo.x = selectedSeriesDisplayName.width + horizontalGap;
            seriesKindCombo.width = _seriesKindComboWidth;
            seriesKindCombo.height = _seriesKindComboHeight;
            seriesKindCombo.dataProvider = seriesKindAC;
            addChild(seriesKindCombo);

            this.width += seriesKindCombo.width;
        }

        if(!settindBtn)
        {
            settindBtn = new Button();
            settindBtn.x = seriesKindCombo.x + seriesKindCombo.width + horizontalGap;
            settindBtn.width = 80;
            settindBtn.height = 22;

            settindBtn.label = _settingButtonLabel;
            settindBtn.addEventListener(MouseEvent.CLICK, settingClickHandler);
            addChild(settindBtn);

            this.width += settindBtn.width;
        }
    }

    /**
     *  Updates currently selected series.
     */
    protected function searchSeriesKind():void
    {
        selectedSeriesDisplayName.text = _selectedSeries.displayName;
    }

    /**
     * Changes series' type.
     */
    protected function changeSeries():void
    {
        //trace("setting");
        var classType:String;

        classType = seriesKindCombo.selectedItem.label;

        var tempSeries:Array = _targetChart.series;

        var field1:String = "xField";
        var field2:String = "yField";

        if(oldSeries == "BarSeries" && classType != "BarSeries")
        {
            field1 = "yField";
            field2 = "xField";
        }
        else if(oldSeries != "BarSeries" && classType == "BarSeries")
        {
            field1 = "yField";
            field2 = "xField";
        }

        switch(classType)
        {
            case "AreaSeries" :
                var area:AreaSeries = new AreaSeries();
                area.xField = tempSeries[seriesIndex][field1];
                area.yField = tempSeries[seriesIndex][field2];
                area.displayName = tempSeries[seriesIndex].displayName;

                tempSeries.splice(seriesIndex, 1, area);
                break;

            case "BarSeries" :
                var bar:BarSeries = new BarSeries();
                bar.xField = tempSeries[seriesIndex][field1];
                bar.yField = tempSeries[seriesIndex][field2];
                bar.displayName = tempSeries[seriesIndex].displayName;

                tempSeries.splice(seriesIndex, 1, bar);
                break;

            case "ColumnSeries" :
                var column:ColumnSeries = new ColumnSeries();
                column.xField = tempSeries[seriesIndex][field1];
                column.yField = tempSeries[seriesIndex][field2];
                column.displayName = tempSeries[seriesIndex].displayName;

                tempSeries.splice(seriesIndex, 1, column);
                break;

            case "LineSeries" :
                var line:LineSeries = new LineSeries();
                line.xField = tempSeries[seriesIndex][field1];
                line.yField = tempSeries[seriesIndex][field2];
                line.displayName = tempSeries[seriesIndex].displayName;

                tempSeries.splice(seriesIndex, 1, line);
                break;

            case "PlotSeries" :
                var plot:PlotSeries = new PlotSeries();
                plot.xField = tempSeries[seriesIndex][field1];
                plot.yField = tempSeries[seriesIndex][field2];
                plot.displayName = tempSeries[seriesIndex].displayName;

                tempSeries.splice(seriesIndex, 1, plot);
                break;

            default :
                break;
        }
        oldSeries = classType;

        _targetChart.series = tempSeries;

        var data:* = _targetChart.dataProvider;

        _targetChart.dataProvider = null;

        _targetChart.validateNow();

        _targetChart.dataProvider = data;

        configureSereise();
        //trace(_targetChart.series[seriesIndex].className);

    }

    //----------------------------------------------------------------------------
    //
    //  EventHandler
    //
    //----------------------------------------------------------------------------
    /**
     *  @private
     */
    private function seriesClickHandler(event:MouseEvent):void
    {
        selectedSeries = Series(event.target);

        var i:int;
        var n:int = _targetChart.series.length;
        for (i = 0; i < n; i++)
        {
            if(event.target == _targetChart.series[i])
            {
                seriesIndex = i;
                break;
            }
        }
    }

    /**
     *  @private
     */
    private function settingClickHandler(event:MouseEvent):void
    {
        if(!_selectedSeries)
        {
            return;
        }

        changeSeries();
    }
}
}