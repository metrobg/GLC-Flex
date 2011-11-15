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
package org.openzet.rpc
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import mx.managers.CursorManager;
import org.openzet.events.RPCEvent;
import org.openzet.rpc.rpcClasses.IRPCHTTPLoader;
//-----------------------------------------------------------------------------
//
//  Events
//
//-----------------------------------------------------------------------------

/**
 *  Dispatched when an object is initialized and ready to use.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="initalize",type="org.openzet.events.RPCEvent")]
/**
 *  Dispatched when data loading is complete.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="complete", type="org.openzet.events.RPCEvent")]
/**
 *  Dispatched when an error occurs while loading data.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="error", type="org.openzet.events.RPCEvent")]
/**
 *  Dispatched when data loading is in progress.
 *  @eventType flash.events.ProgressEvent
 */
[Event(name="progress",type="flash.events.ProgressEvent")]

/**
 *
 * Custom Helper class that loads XML, text data on the web.
 */
public class HTTPLoader extends EventDispatcher implements IRPCHTTPLoader
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
    public function HTTPLoader()
    {
        urlStream = new URLStream();
        urlStream.addEventListener(ProgressEvent.PROGRESS,progressHandler);
        urlStream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
        urlStream.addEventListener(Event.COMPLETE,loadCompleteHandler);
    }
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


    /**
     * @private
     * URLStream object
     */
    private var urlStream:URLStream;

    /**
      @private
     */
    private var _showBusyCursor:Boolean = true;

    /**
      @private
     */
    private var _encoding:String;


    /**
     * @private
     */
    public function set showBusyCursor(value:Boolean):void
    {
            _showBusyCursor = value;
    }

      /**
     * Flag to specify whether to show busy cursor.
     */
    public function get showBusyCursor():Boolean
    {
            return _showBusyCursor;
    }

    /**
     * Closes connection and destorys object.
     */
    public function close():void
    {
        urlStream.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
        urlStream.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
        urlStream.removeEventListener(Event.COMPLETE,loadCompleteHandler);
        urlStream.close();
        urlStream = null;
    }

    /**
     * loads XML or text data on the web.
     * @param urlURLRequest URLRequest object to use.
     * @param encoding Encoding type such as UTF-8.
     *
     */
    public function load(url:URLRequest, encoding:String = "UTF-8"):void
    {
        _encoding = encoding;
        if(_showBusyCursor)
        {
                CursorManager.setBusyCursor();
        }
        urlStream.load(url);
    }


    //-----------------------------------------------------------
    //
    //  Event Handlers
    //
    //-----------------------------------------------------------

    /**
     * @private
     */
    private function loadCompleteHandler(e:Event):void
    {
        CursorManager.removeBusyCursor();
        dispatchEvent(new RPCEvent(RPCEvent.COMPLETE,urlStream.readMultiByte(urlStream.bytesAvailable,_encoding)));
    }
    /**
     * @private
     */
    private function progressHandler(e:ProgressEvent):void
    {
        dispatchEvent(e.clone());
    }
    /**
     * @private
     */
    private function errorHandler(e:IOErrorEvent):void
    {
        CursorManager.removeBusyCursor();
        dispatchEvent(new RPCEvent(RPCEvent.ERROR,null,e.text));
    }
}
}
