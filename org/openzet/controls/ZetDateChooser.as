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

import mx.controls.DateChooser;
import mx.core.mx_internal;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.DateChooserEvent;

use namespace mx_internal;
[Style(name="dayColors", type="Array", arrayType="uint", format="Color", inherit="no")]

/**
 *  Custom DateChooser class that displays Saturdays and Sundays with different colors. 
 *  This class also defines styles to specify colors for weekdays.
 */
public class ZetDateChooser extends DateChooser
{
    include "../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function ZetDateChooser()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Method
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();
        
        dateGrid = new ZetCalendarLayout();

        dateGrid.styleName = this;
        
        addChild(dateGrid);

        dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE, dateGrid_changeHandler);
        dateGrid.addEventListener(DateChooserEvent.SCROLL, dateGrid_scrollHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function dateGrid_changeHandler(event:CalendarLayoutChangeEvent):void
    {
        selectedDate = ZetCalendarLayout(event.target).selectedDate;

        var e:CalendarLayoutChangeEvent = new 
            CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
        e.newDate = event.newDate;
        e.triggerEvent = event.triggerEvent;
        dispatchEvent(e);
    }

    /**
     *  @private
     */
    private function dateGrid_scrollHandler(event:DateChooserEvent):void
    {
        dispatchEvent(event);
    }
}
}