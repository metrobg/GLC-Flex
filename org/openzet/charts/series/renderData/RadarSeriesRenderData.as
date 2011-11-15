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
package org.openzet.charts.series.renderData
{
import mx.charts.chartClasses.RenderData;

/**
 * Custom RenderData class to represent renderData for RadarSeriesSegment.
 */
public class RadarSeriesRenderData extends RenderData
{
    include "../../../core/Version.as";
    
    public function RadarSeriesRenderData(cache:Array = null,
                                           filteredCache:Array = null,
                                           segments:Array = null)
    {
        super(cache, filteredCache);
        this.segments = segments;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  segments
    //----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  An Array of RadarSeriesSegment instances representing each discontiguous segment of the radar series.
	 */
	public var segments:Array /* of RadarSeriesSegment */;
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function clone():RenderData
	{
		var newSegments:Array /* of RadarSeriesSegment */ = [];
		
		var n:int = segments.length;
		for (var i:int = 0; i < n; i++)
		{
			newSegments[i] = segments[i].clone();
		}
		
		return new RadarSeriesRenderData(cache, filteredCache, newSegments);
	}
}
}