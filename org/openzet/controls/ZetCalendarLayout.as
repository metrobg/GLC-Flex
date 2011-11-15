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
package org.openzet.controls
{
import mx.core.mx_internal;
import mx.controls.CalendarLayout
import mx.styles.StyleManager;

use namespace mx_internal;
[Style(name="dayColors", type="Array", arrayType="uint", format="Color", inherit="no")]
 

/**
 *  CalendarLayout used or ZetDateChooser. 
 */
public class ZetCalendarLayout extends mx.controls.CalendarLayout
{
    include "../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function ZetCalendarLayout()
    {
        super();
    }

    /**
     *  @private
     */
    private var _firstDayOfWeek:int = 0; // Sunday
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Method
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(w:Number, h:Number):void
    {
        super.updateDisplayList(w, h);
        
        setDayColors();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Method
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Sets color for each day.
     */
    private function setDayColors():void
    {
        // added 2007-06-18
        var colors:Array = getStyle("dayColors");
        
        if (!colors || colors.length == 0)
        {
            return;
        }

        StyleManager.getColorNames(colors);

        var curCol:int = 0;
        var i:int = 0;

        for (var columnIndex:int = 0; columnIndex < 7; columnIndex++)
        {
            for (var rowIndex:int = 0; rowIndex < 7; rowIndex++)
            {
                var dayOfWeek:int = (columnIndex + _firstDayOfWeek) % 7;
                dayBlocksArray[columnIndex][rowIndex].setColor(colors[dayOfWeek]);
            }
        }
    }
}

    
}