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
 * Static class that defines static methods used with regard to XML objects.
 **/
public class XMLUtil
{
	include "../core/Version.as";
	/****
	 * Returns An array of xml nodes in a given XML.
	 * 
	 * @param xml XML instance from which to extract xml nodes.
	 * 
	 * @return An array of xml node fields.
	 **/
	 public static function getNodeNames(xml:XML):Array {   
	 	var names:Array;
	 	if (xml) {
             if (xml.children()=="") return [];   
            var len:int = xml.children()[0].children().length();   
            if (len==0) return [];   
            var i:int;   
            names = [];
            for (i=0; i<len;i++) {   
                names.push(XML(xml.children()[0].children()[i]).name().toString());   
            }   
	 	}
        return names;   
    }   

}
}