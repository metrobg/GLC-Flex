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
package org.openzet.utils
{
/**
 * Static class that defines methods used to call methods.
 * 
 **/
public class MethodUtil
{
	include "../core/Version.as";
	/**
	 * Calls target's method by assigning ...args as its parameters.
	 * 
	 * @param target Target object on which to call certain method.
	 * @param method String representation of target's method name
	 * @param ...args Optional number of parameters to be passed to the method being invoked.
	 * 
	 * @return Returns the result of the method being called through this static method.
	 **/
	public static function call(target:Object, method:String, ...args):* {
		try {
			var result:* = target[method].apply(null, args);
			return result;
		} catch (e:Error) {
		}
	}
}
}