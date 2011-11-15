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
import flash.events.FocusEvent;
import flash.system.IMEConversionMode;
import mx.controls.TextInput;
import mx.core.mx_internal;
import mx.controls.Alert;
import mx.managers.IFocusManagerComponent;

use namespace mx_internal;

/**
 *  This class extends mx.controls.TextInput to make it more reactive when users are typing in.
 */
public class TextInput extends mx.controls.TextInput
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Contructor
    //
    //--------------------------------------------------------------------------
    /**
     *  constructor
     */
	public function TextInput()
	{
		super();
	}
    
    //--------------------------------------------------------------------------
    //
    //  Method
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
	override protected function createChildren():void
	{
        super.createChildren();

        getTextField().alwaysShowSelection = true;

        if (restrict === null)
        {
            //imeMode = IMEConversionMode.KOREAN;
        }
	}
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        textField.y = (height - textField.textHeight) / 2 - 1;
    }
    
    //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        super.focusOutHandler(event);

        setSelection(textField.length, textField.length);
    }
}

}
