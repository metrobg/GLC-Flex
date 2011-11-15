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
package org.openzet.charts.series.items
{
import org.openzet.charts.series.RadarSeries;

/**
 *  Represents the information required
 *  to render a segment in a RadarSeries.
 *  The RadarSeries class passes a RadarSeriesSegment
 *  to its lineRenderer when rendering.
 */
public class RadarSeriesSegment
{
    include "../../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *	@param element The owning series.
     *
     *	@param index The index of the segment in the Array of segments
     *  representing the radar series.
     *
     *	@param items The Array of RadarSeriesItems
     *  representing the full radar series.
     *
     *	@param start The index in the items Array
     *  of the first item in this segment.
     *
     *	@param end The index in the items Array
     *  of the last item in this segment, inclusive.
     */
    public function RadarSeriesSegment(element:RadarSeries,
                                       index:uint,
                                       items:Array /* of RadarSeriesItem */,
                                       start:uint,
                                       end:uint)
    {
        super();

        this.element = element;
        this.items = items;
        this.index = index;
        this.start = start;
        this.end = end;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  element
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     *  The series or element that owns this segment.
     */
    public var element:RadarSeries;
    
    //----------------------------------
    //  items
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The array of chartItems representing the full line series
     *  that owns this segment.
     */
    public var items:Array /* of RadarSeriesItem */;
    
    //----------------------------------
    //  index
    //----------------------------------
    
    [Inspectable(environment="none")]
    
    /**
     *  The index of this segment in the array of segments
     *  representing the line series.
     */
    public var index:uint;

    //----------------------------------
    //  start
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     *  The index into the items array of the first item in this segment.
     */
    public var start:uint;

    //----------------------------------
    //  end
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     *  The index into the items array of the last item
     *  in this segment, inclusive.
     */
    public var end:uint;
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Returns a copy of this segment.
     */
    public function clone():RadarSeriesSegment
    {
    	return new RadarSeriesSegment(element, index, items, start, end);		
    }
}
}