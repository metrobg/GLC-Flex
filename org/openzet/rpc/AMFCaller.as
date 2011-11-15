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
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.NetConnection;
import flash.net.Responder;

import mx.managers.CursorManager;

import org.openzet.events.RPCEvent;
import org.openzet.rpc.rpcClasses.IRPCAMFCaller;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when an object is intialized and ready to be used.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="initalize",        type="org.openzet.events.RPCEvent")]
/**
 *  Dispatched when data loading is complete.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="complete",         type="org.openzet.events.RPCEvent")]
/**
 *  Dispatched when an error ocurrs while loading data.
 *  @eventType org.openzet.events.RPCEvent
 */
[Event(name="error",                 type="org.openzet.events.RPCEvent")]

/**
 * Controller class for openAmf, AMFPHP use.
 */
public class AMFCaller extends EventDispatcher implements IRPCAMFCaller
{
    include "../core/Version.as";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AMFCaller(){
        netConnection = new NetConnection();
        responder = new Responder(resultHandler,faultHandler);
        netConnection.addEventListener(NetStatusEvent.NET_STATUS,netStatusErrorHandler);
    }

    /**
     * @private
     */
    private var _showBusyCursor:Boolean;

    /**
     * @private
     */
    private var responder:Responder;

    /**
     * @private
     */
    private var netConnection:NetConnection;

    /**
     * @private
     */
    private var url:String = "";

    /**
     * @private
     */
    public function set showBusyCursor(value:Boolean):void
    {
            _showBusyCursor = value;
    }

   /**
     * Flag to specify whether to show busy cursor while loading data.
     * @param value
     */
    public function get showBusyCursor():Boolean
    {
            return _showBusyCursor;
    }

    /**
     *
     * Performs an AMF call.
     * @param classPath packagepath.className.methodName
     * @param param parameter to pass
     *
     */
    public function call(classPath:String, param:Object=null):void
    {
        if(url == "")
        {
                throw new Error("Must Set URL for AMFGateway Service URL Adress");
                return;
        }
        if(showBusyCursor)
        {
                CursorManager.setBusyCursor();
        }
        param ? netConnection.call(classPath,responder,param) : netConnection.call(classPath,responder);
    }

  	/**
  	 * @private
  	 */
    public function set URL(url:String):void
    {
            netConnection.connect(url);
            this.url = url;
    }

    /**
     * GateWay url for AMF calling.
     */
    public function get URL():String
    {
            return url;
    }

    /**
     * Closes connection.
     */
    public function close():void
    {
        responder = null;
        netConnection.close();
    }

    //-----------------------------------------------------------
    //
    //  Event Handlers
    //
    //-----------------------------------------------------------

    /**
     *
     * @private
     *
     */
    private function netStatusErrorHandler(e:NetStatusEvent):void
    {
            dispatchEvent(new RPCEvent(RPCEvent.COMPLETE,e.info));
    }
    /**
     *
     * @private
     *
     */
    private function resultHandler(e:Object):void
    {
            dispatchEvent(new RPCEvent(RPCEvent.COMPLETE,e));
    }

    /**
     *
     * @private
     *
     */
    private function faultHandler(e:Object):void
    {
            dispatchEvent(new RPCEvent(RPCEvent.ERROR,null,e));
    }
}
}
