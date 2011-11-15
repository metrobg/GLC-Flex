////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//  All Rights Reserved.
//
//  This file is part of OpenZet.
//
//  OpenZet is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License version 3 as
//  published by the Free Software Foundation.
//
//  OpenZet is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License version 3 for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with OpenZet. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////

package org.openzet.containers
{

import mx.core.IUIComponent;

import org.openzet.containers.IMDI;

/**
 *  IMDIWindow interface defines methods and properties need for an MDI instance.  
 *  To register a control as a child object of an MDI, the control must always implement this interface.
 *  User defined windows could be instances of UIComponent or its subclasses.
 *  Yet mostly, you'd prefer to use Panel instance as a window. 
 */
public interface IMDIWindow extends IUIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  windowState
    //----------------------------------

    /**
     *  Specifies a window's minimized, maximized, normal state.
     *  You can change a window's state by using constants defined by MDIWindowState class.
     *  Valid values are <code>MDIWindowState.MINIMIZED</code>, <code>MDIWindowState.MAXIMIZED</code> and
     *  <code>MDIWindowState.NORMAL</code>.
     *
     *  @see org.openzet.containers.MDIWindowState
     */
    function get windowState():String;

    /**
     *  @private
     */
    function set windowState(value:String):void;

    //----------------------------------
    //  draggable
    //----------------------------------

    /**
     *  Specifies whether a window is draggable.
     *  Even if set to true, if <code>windowState</code> property's value is <code>maximized</code>,
     *  draggable getter method will return false. 
     */
    function get draggable():Boolean;

    /**
     *  @private
     */
    function set draggable(value:Boolean):void;

    //----------------------------------
    //  resizable
    //----------------------------------

    /**
     *  Specifies whether a window is resizable.
     *  Even if set to true, if <code>windowState</code> property's value is not<code>normal</code>
     *  resizable getter method will return false. 
     */
    function get resizable():Boolean;

    /**
     *  @private
     */
    function set resizable(value:Boolean):void;

    //----------------------------------
    //  mdi
    //----------------------------------

    /**
     *  Specifies a reference to parent container's IMDI object.
     */
    function get mdi():IMDI;

    /**
     *  @private
     */
    function set mdi(value:IMDI):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Invoked when a window gets its focus.
     */
    function focusIn():void;

    /**
     * Invoked when a window loses its focus.
     */
    function focusOut():void;

    /**
     *  Invoked when a object is removed from an MDI instance.
     *  To prevent possible memory leaking, we override this method and removes
     *  all event listeneres registered when children are removed from their parent container. 
     */
    function destroy():void;

    /**
     * Restores a window to its previous size. 
     */
    function restore():void;

    /**
     * Maximizes a window. 
     */
    function maximize():void;

    /**
     * Minimizes a window. 
     */
    function minimize():void;

    /**
     * Closes a window. 
     */
    function close():void;

    /**
     * Sets a component's position.
     */
    function setPosition(x:Number, y:Number):void;

    /**
     * Sets a component's size.
     */
    function setSize(width:Number, height:Number):void;

    /**
     *  Invoked when <code>windowState</code> property value changes. 
     *  Normally you shouldn't call this method directly, yet have this method called by changing
     *  <code>windowState</code> property value.
     *
     *  @param value <code>windowState</code> property's new value. Possible values are
     *  <code>MDIWindowState.NORMAL</code>, <code>MDIWindowState.MAXIMIZED</code> and 
     *  <code>MDIWindowState.MINIMIZED</code>.
     *
     *  @param noEvent If <code>true</code>, no event is dispatched.
     *  If <code>false</code>, when <code>windowState</code> changes, dispatches a relevant event. 
     */
    function setWindowState(value:String, noEvent:Boolean = false):void;
}

}
