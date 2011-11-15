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
	
import mx.controls.NumericStepper;

/**
 *  Custom NumericStepper class to represent hour for ZetDateField control.
 */
public class HourNumericStepper extends NumericStepper
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
    public function HourNumericStepper()
    {
        super();
        
        maxChars = 2;
        width = defaultWidth;
        minimum = MINIMUM_HOUR;
        maximum = MAXIMUM_HOUR;
        stepSize = defaultStepSize;
    }

    //--------------------------------------------------------------------------
    //
    //  Class Constant
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var defaultWidth:Number = 45;
    
    /**
     *  @private
     */
    private static const MINIMUM_HOUR:Number = 0;
    
    /**
     *  @private
     */
    private static const MAXIMUM_HOUR:Number = 23;
    
    /**
     *  @private
     */
    private static var defaultStepSize:Number = 1;
    
}
}