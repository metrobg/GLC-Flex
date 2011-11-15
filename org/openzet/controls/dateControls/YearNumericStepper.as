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

import org.openzet.utils.DateUtil;

/**
 *  Custom NumericStepper to display year for ZetDateField control.
 */
public class YearNumericStepper extends NumericStepper
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
    public function YearNumericStepper()
    {
        super();
        
        maxChars = 4;
        width = defaultWidth;
        minimum = MINIMUM_YEAR;
        maximum = MAXIMUM_YEAR;
        value = DateUtil.getFullYear();
    }

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var defaultWidth:Number = 60;
    
    /**
     *  @private
     */
    private const MINIMUM_YEAR:int = 1900;
    
    /**
     *  @private
     */
    private const MAXIMUM_YEAR:int = 2100;
    
}
}