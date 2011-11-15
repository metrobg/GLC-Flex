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
	
import mx.controls.HRule;

/**
 *  Custom class to draw dash for ZetDateField control.
 */
public class DateControlDash extends HRule
{
    include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @Constructor
     */
    public function DateControlDash()
    {
        super();
        
        name = "dash";
        percentHeight = defaultPercentHeight;
        width = defaultWidth;
        setStyle("strokeColor", defaultStrokeColor);
        setStyle("strokeWidth", defaultStrokeWidth);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var defaultPercentHeight:Number = 100;
    
    /**
     *  @private
     */
    private static var defaultWidth:Number = 8;
    
    /**
     *  @private
     */
    private static var defaultStrokeColor:uint = 0x000000;
    
    /**
     *  @private
     */
    private static var defaultStrokeWidth:int = 2;

}
}