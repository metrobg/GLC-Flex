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
    * All static utility class that implements methods for string replacement.
    */
    public class StringUtil
    {
    include "../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    *  Constructor.
    */
    public function StringUtil()
    {
        throw new Error("You cannot instantiate this class.");
    }


    /**
    * Removes HTML or XML tags such as &lt; , &gt;
    * @param String Target string to remove HTML, XML tags from.
    * 
    * @return New string with all HTML, XML tags removed. 
    */
    public static function removeHTML(value:String):String
    {
        var r:RegExp = /<[a-zA-Z\/][^>]*>/g
        return value.replace(r,"");
    }
}
}