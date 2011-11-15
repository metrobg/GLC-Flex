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
package org.openzet.gantt.managers
{
public class ColorManager
{
	public function ColorManager()
	{
	}
	
	public static function getColors(description:String):Array
	{
		var result:Array = [];
		switch (description)
		{
			case "Traveling":
			result = [0x89A077, 0xFFFFFF];
			break;
			
			case "Business Trip":
			result = [0xBEAF95, 0xFFFFFF];
			break;
			
			case "Vacation":
			result = [0x89A7B6, 0xFFFFFF];
			break;
			
			case "Sickness":
			result = [0xA36868, 0xFFFFFF];
			break;
		}
		return result;
	}

}
}