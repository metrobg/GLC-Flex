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
import flash.external.ExternalInterface;

import mx.utils.StringUtil;

/**
 *  All static utility class to use as a proxy between Flex and Javascript in HTML.
 *  Note that this class could cause a runtime error when used without a browser.
 **/
public class JSControlUtil
{
    include "../core/Version.as";
	/**
	 * You cannot make an instance of this class.
	 */
    public function JSControlUtil()
    {
        throw new Error("Cannot instantiate this class.");
    }

    /**
     * Sets cookie in a browser.
     * @param key       key to specify
     * @param value     value for key
     * @param expires   cookie expiration time
     * @param path      cookie path
     * @param domain    cookie domain
     * @param secure    cookie security level.
     *
     */
    public static function setCookie(key:String, value:String, expires:Number = -1, path:String = null, domain:String = null, secure:Boolean = false):String
    {
        var cookie:String = "";
        cookie += key+"="+escape(value);
        cookie += expires == -1 ? "" : ";expires="+expires;
        cookie += path == null ? "" : ";path="+path;
        cookie += domain == null ? "" : ";domain="+domain;
        cookie += secure == false ? "" : ";secure";
        ExternalInterface.call("eval","document.cookie='"+cookie+"'");
        return cookie;
    }

    /**
     * Retrieves all cookie information.
     * @return Returns current page's all cookie information.
     *
     */
    public static function getCookieAll():String
    {
        return ExternalInterface.call("eval","document.cookie");
    }

    /**
     * Retrieves cookie by a specific key.
     * @param key   key to retrieve.
     * @return      Returns cookie result retrieved by the key. null, if no result is found.
     *
     */
    public static function getCookie(key:String):String
    {
        var cookie:String = getCookieAll();
        var keyValue:Array = cookie.split(";");
        for(var i:Number = 0; i < keyValue.length ; i++)
        {
            var t:Array = keyValue[i].split("=");
            if(mx.utils.StringUtil.trim(t[0]) == key)
            {
                return unescape(t[1]);
            }
        }
        return null;
    }

    /**
     * Deletes a selected cookie
     * @param key	cookie to delete
     *
     */
    public static function deleteCookie(key:String):void
    {
        setCookie(key,null,-1);
    }

    /**
     * Closes Javascript function to close window.
     */
    public static function close():void
    {
        ExternalInterface.call("window.close");
    }

    /**
     * Retrieves user information.
     *
     * @return Returns string representation of user agent.
     */
    public static function getUserAgent():String
    {
        return ExternalInterface.call("eval","navigator.userAgent");
    }

    /**
     * Pops up a JavaScript window.
     * @param URL   URL where to pop up a new window.
     * @param id    popup's id
     * @param param Array type of parameters. Optional values for a new window.
     */
    public static function openPopup(URL:String,id:String,param:String = "scrollbars=no,toolbar=no,resizable=no,width=100,height=80,left=0,top=0"):void
    {
        ExternalInterface.call("window.open",URL,id,param);
    }

    /**
     * Retrieves the current location.
     *
     * @return Returns the current page's location.
     */
    public static function getSelfAddress():String
    {
        return ExternalInterface.call("eval","location.href");
    }

    /**
     * Verifies whether the current browser is Internet Explorer.
     * @return true, if current browser is IE, otherwise, false.
     */
    public static function isIE():Boolean
    {
        return new RegExp(/MSIE/).test(getUserAgent());
    }

      /**
     * Verifies whether the current browser is FireFox.
     * @return true, if current browser is FireFox, otherwise, false.
     */
    public static function isFireFox():Boolean
    {
        return new RegExp(/FireFox/).test(getUserAgent());
    }

      /**
     * Verifies whether the current browser is Chrome.
     * @return true, if current browser is Chrome, otherwise, false.
     */
    public static function isGoogleCrome():Boolean
    {
        return new RegExp(/Crome/).test(getUserAgent());
    }

      /**
     * Verifies whether the current browser is Opera.
     * @return true, if current browser is Opera, otherwise, false.
     */
    public static function isOpera():Boolean
    {
        return new RegExp(/Opera/).test(getUserAgent());
    }

    /**
     * Sets style for a DIV.
     * @param id        id of a div
     * @param value     <pre>{width:"500px",height:"300px",background:"#4a4"}</pre> type of value.
     * @return          Returns the specified style.
     *
     */
    public static function setStyle(id:String, value:Object):String
    {
        var css:String = "";
        for (var v:String in value)
        {
            css += v +":";
            css += value[v]+";";
        }
        ExternalInterface.call("eval","document.getElementById('"+id+"').style.cssText+=';"+css+"'");
        return getStyle(id);
    }

    /**
     * Retrieves specified div's style.
     * @param id    div's ID
     * @return      div's style value.
     *
     */
    public static function getStyle(id:String):String
    {
        return ExternalInterface.call("eval","document.getElementById('"+id+"').style.cssText");
    }

    /**
     * Retrieves inner HTML in a div.
     * @param id    div's ID
     * @return      inner HTML of a div
     *
     */
    public static function getInnerHTML(id:String):String
    {
        return ExternalInterface.call("eval","document.getElementById('"+id+"').innerHTML");
    }

    /**
     * Specifies innerHTML in a div.
     * @param id    div's ID
     * @param HTML  inner HTML for a div.
     *
     */
    public static function setInnerHTML(id:String, HTML:String):void
    {
        ExternalInterface.call("eval","document.getElementById('"+id+"').innerHTML = '"+HTML+"'");
    }

    /**
     * Retrieves string from a div.
     * @param id    div's id
     * @return      inner text of a div
     *
     */
    public static function getInnerText(id:String):String
    {
        return ExternalInterface.call("eval","document.getElementById('"+id+"').innerText");
    }

    /**
     * Extracts all form data from an HTML documents as JSON format.
     * @return All form data in JSON format, with name:value pairs.
     *
     */
    public static function getFormData():String
    {
        const src:String = 'function getData()' +
                '{ ' +
                    'var json = "{"; ' +
                    'for(var i =0; i < document.forms.length;i++) { ' +
                        'var f = document.forms[i].childNodes; ' +
                        'for (var j=0;j<f.length ; j++) { ' +
                            'if(f[j].nodeName == "INPUT") { ' +
                                'json += f[j].name + ":"; ' +
                                'json += f[j].value + (j == f.length ? "" : ","); ' +
                            '} ' +
                        '} ' +
                    '} ' +
                    'json = json.substring(0,json.lastIndexOf(",")); ' +
                    'json += "}"; ' +
                    'return json; ' +
                '} ' +
                'getData();';
        return ExternalInterface.call("eval",src);
    }
}
}