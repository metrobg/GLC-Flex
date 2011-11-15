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

import mx.managers.CursorManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

import org.openzet.events.RPCEvent;
import org.openzet.rpc.rpcClasses.IRPCRemoteObject;

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
* Custom class to integrate with LCDS or BlazeDS's remote objects.
*/
public class RemoteObjectCaller extends EventDispatcher implements IRPCRemoteObject
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
    public function RemoteObjectCaller()
    {
        remoteObject = new RemoteObject;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


    /**
     *@private
     */
    private var remoteObject:RemoteObject;
    /**
     *@private
     */
    private var _showBusyCursor:Boolean = true;

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
     * Calls remote object's method.
     * @param classPath   Destination.MethodName format of string.
     * @param param       Object type of parameter to pass.
     *
     */
    public function call(classPath:String, param:Object = null):void
    {
        if(_showBusyCursor)
        {
                CursorManager.setBusyCursor();
        }
        var ar:Array = classPath.split(".");
        var methodName:String = ar[1];
        remoteObject.destination = ar[0];
        if(param)
        {
                remoteObject.getOperation(methodName).arguments = param
        }
        remoteObject.getOperation(methodName).addEventListener(ResultEvent.RESULT,resultHandler);
        remoteObject.getOperation(methodName).addEventListener(FaultEvent.FAULT,faultHandler);
        remoteObject.getOperation(methodName).send();
    }


    /**
     * Closes connection.
     */
    public function close():void
    {
    	remoteObject.disconnect();
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
    private function resultHandler(e:ResultEvent):void
    {
            CursorManager.removeBusyCursor();
            dispatchEvent(new RPCEvent(RPCEvent.COMPLETE,e.result));
    }

    /**
     *
     * @private
     *
     */
    private function faultHandler(e:FaultEvent):void
    {
            CursorManager.removeBusyCursor();
            dispatchEvent(new RPCEvent(RPCEvent.ERROR,e.fault.message));
    }

}
}
