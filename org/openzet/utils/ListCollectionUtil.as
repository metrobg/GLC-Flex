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
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.utils.ObjectUtil;

/**
 * A static class that defines static methods used in relation with ListCollectionView instances.
 **/
public class ListCollectionUtil
{
	include "../core/Version.as";
	/**
	 * Static methods that extracts nodes of a ListCollectionView and returns an Array that holds
	 * all these fields.
	 * 
	 * @param value ListCollectionView instance to extract field nodes.
	 * 
	 * @return Returns an Array of fields in the given ListCollectionView.
	 * 
	 **/
	public static function cloneNodes(value:ListCollectionView):Array {
		var fields:Array;
		//since technically ListCollection object is either ArrayCollection
		// or XMLListCollection, we only take care of both of these types.
		if (value && value.length > 0) {
			if (value is ArrayCollection) {
				var item:Object = value[0];
				fields = org.openzet.utils.ObjectUtil.cloneFields(item); 
			} else if (value is XMLListCollection) {
				var xml:XML = XMLListCollection(value).source.parent() as XML;
				fields = XMLUtil.getNodeNames(xml);	
			}
		}
		return fields;
	}
		
		/**
	 * Copies an instance of ListCollectionView and returns a new instance of ICollectionView type.
	 * This method is useful when we should not refer to an ArrayCollection and yet make a simple copy of
	 * that. 
	 * 
	 * @param value Any ListCollectionView instance to make a copy of.
	 * 
	 * @return A copy of data in a type of ICollectionView.
	 **/
	public static function copy(value:ListCollectionView):ICollectionView {
	 	var iColView:ICollectionView = mx.utils.ObjectUtil.copy(value) as ICollectionView;
	 	return iColView; 
	}
}
}