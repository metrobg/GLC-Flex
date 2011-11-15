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
import flash.events.TextEvent;

import mx.controls.DateField;

/**
 *  Custom DateField class to display year, month, date for ZetDateField control.
 */
public class DateField extends mx.controls.DateField
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  constructor
     */
    public function DateField()
    {
        super();
        
        this.selectedDate = new Date();
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
        textInput.restrict = "0-9";
        textInput.addEventListener(TextEvent.TEXT_INPUT, textInput_textInputHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Method
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    private function textInput_textInputHandler(event:TextEvent):void
    {
        dispatchEvent(event);
    }
}
}