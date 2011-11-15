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
package org.openzet.controls.dateControls
{
import flash.events.Event;

import mx.controls.NumericStepper;

/**
 *  Custom NumericStepper class to represent minute for ZetDateField control.
 */
public class MinuteNumericStepper extends NumericStepper
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function MinuteNumericStepper()
    {
        super();
        
        maxChars = 2;
        width = defaultWidth;
        minimum = MINIMUM_MINUTE;
        maximum = MAXIMUM_MINUTE;
        //stepSize = defaultStepSize;
        
        addEventListener(Event.CHANGE, minuteChangeHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var defaultWidth:Number = 45;
    
    /**
     *  @private
     */
    private static const MINIMUM_MINUTE:Number = -1;
    
    /**
     *  @private
     */
    private static const MAXIMUM_MINUTE:Number = 60;
    
    /**
     *  @private
     */
    private static var defaultStepSize:Number = 10;
    
    /**
     *  @private
     */
    private function minuteChangeHandler(event:Event):void
    {
        if(value > 59) {
            value = 0;
        } else if(value < 0) {
            value = 59;
        }
    }
}
}