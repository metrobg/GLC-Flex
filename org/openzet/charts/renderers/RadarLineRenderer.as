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
package org.openzet.charts.renderers
{
import mx.core.IDataRenderer;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

/**
 *  A simple implementation of a radar segment renderer
 *  that is used by RadarSeries objects.
 *  This class renders a line on screen using the stroke and form defined by
 *  the owning series's <code>lineStroke</code> and <code>form</code> styles,
 *  respectively.
 */
public class RadarLineRenderer extends ProgrammaticSkin implements IDataRenderer
{
    include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
    public function RadarLineRenderer()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the data property.
     */
    private var _lineSegment:Object;
    
    [Inspectable(environment="none")]
    
    /**
     *  The chart item that this renderer represents.
     *  LineRenderers assume that this value is an instance of LineSeriesItem.
     *  This value is assigned by the owning series.
     */
    public function get data():Object
    {
    	return _lineSegment;
    }
    
    /**
     *  @private
     */
    public function set data(value:Object):void
    {
    	_lineSegment = value;
    
    	invalidateDisplayList();
    }

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
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    
    	var stroke:IStroke = getStyle("lineStroke");		
        var form:String = getStyle("form");    // segment or curve. curve 는 현재 미구현.
        
    	graphics.clear();
    	
    	// stroke 적용은 clear 아래에 있어야 한다.
        stroke.apply(graphics);
        
        graphics.moveTo(0, 0);
        var raN:Number;
        var r:Number;
    	for (var i:Number = _lineSegment.start; i != _lineSegment.end + 1; i++)
    	{
            raN = _lineSegment.items[i]["angle"] * (Math.PI / 180);
            r = _lineSegment.items[i]["radius"];
            
            if ( i == _lineSegment.start )
                graphics.moveTo(Math.cos(raN) * r + (unscaledWidth / 2), Math.sin(raN) * r + (unscaledHeight / 2));
            else 
                graphics.lineTo(Math.cos(raN) * r + (unscaledWidth / 2), Math.sin(raN) * r + (unscaledHeight / 2));
    	}
        
        // 마지막 아이템과 첫 아이템을 다시 연결.
        raN = _lineSegment.items[_lineSegment.start]["angle"] * (Math.PI / 180);
        graphics.lineTo(Math.cos(raN) * _lineSegment.items[_lineSegment.start]["radius"] + (unscaledWidth / 2), Math.sin(raN) * _lineSegment.items[_lineSegment.start]["radius"] + (unscaledHeight / 2));
    }
}
}