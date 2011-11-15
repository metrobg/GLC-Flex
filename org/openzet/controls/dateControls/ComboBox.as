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
import mx.controls.ComboBox;

import org.openzet.utils.DateUtil;

/**
 *  Custom ComboBox to be used to display months for ZetDateField.
 */
public class ComboBox extends mx.controls.ComboBox
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
    public function ComboBox()
    {
        super();
        
        width = defaultWidth;
        rowCount = defaultRowCount;
        dataProvider = _monthData;
        selectedItem = DateUtil.getMonth();
        labelFunction = monthLabelFunction;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _monthData:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    
    /**
     *  @private
     */
    private static var defaultWidth:Number = 60;
    
    /**
     *  @private
     */
    private static var defaultRowCount:int = 6;
    
    //--------------------------------------------------------------------------
    //
    //  Method
    //
    //--------------------------------------------------------------------------
    /** 
     *  @private
     *  label function
     */
    private function monthLabelFunction(value:String):String
    {
        return value + "월";
    }
}
}