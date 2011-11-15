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
import flash.events.Event;
import flash.events.EventDispatcher;

/**
* Sets hightlight on TextArea or TextInput controls around search string.
* @includeExample Example_TextHighlight.mxml
*/
public class TextHighlighter extends EventDispatcher
{

    include "../core/Version.as";

    private var _searchStr:String = "";
    private var _target:Object = {};
    private var position:Number = -1;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    *  Constructor.
    */
    public function TextHighlighter(){}


    //----------------------------------
    //  searchStr
    //----------------------------------

   /**
   * @private
   **/
    public function set searchStr(value:String):void
    {
            _searchStr = value;
            dispatchEvent(new Event("searchStrChanged"));
    }


	 /**
     * Property to specify the search string.
     * @param value searh string.
     */
    [Bindable("searchStrChanged")]
    public function get searchStr():String
    {
            return _searchStr;
    }


    //--------------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------------

    /**
    * @private
    **/
    public function set target(value:Object):void
    {
            if(!value.hasOwnProperty("text") || !value.hasOwnProperty("setFocus") || !value.hasOwnProperty("setSelection"))
            {
                    throw new Error("Not Support Target");
                    return;
            }
            _target = value;
    }
    
   /**
    * Property to specify the target control.
    * You can only assign controls like TextInput or TextArea for the <code>value</code> of this property.
    * 
    **/
    public function get target():Object
    {
            return _target;
    }

    /**
     * Highlights the previous match of the same search string based on the current seelction index. 
     * If no matches are found, hightlights are initialized and search starts from the end.
     *
     */
    public function prev():void
    {
            var n:Number = target.text.lastIndexOf(searchStr,position-searchStr.length-1);
            if(n < 0)
            {
                    position = target.text.length;
                    return;
            }
                    position = n != -1 ? n+searchStr.length : 0-searchStr.length;
                    target.setFocus();
                    target.setSelection(n,n+searchStr.length);
    }

      /**
     * Highlights the next match of the same search string based on the current seelction index. 
     * If no matches are found, hightlights are initialized and search starts from the beginning.
     *
     */
    public function next():void
    {
            var n:Number = target.text.indexOf(searchStr,position);
            if(n == -1)
            {
                    position = n;
            }
            else
            {
                    position = n != -1 ? n+searchStr.length : 0-searchStr.length;
                    target.setFocus();
                    target.setSelection(n,n+searchStr.length);
                    dispatchEvent(new Event("find"));
            }
    }
}
}