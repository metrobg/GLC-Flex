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
package org.openzet.display
{
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.Event;
import flash.geom.Matrix;

import mx.managers.DragManager;


/**
 * Drawing class that draws animated dashed rectanle with an embedded swf file. 
 **/
public class DashedRectangle extends ImageLoader
{

	 //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function DashedRectangle(isDragProxy:Boolean = false)
	{
		super();
		this.isDragProxy = isDragProxy;
	}
	
	
   //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Internal BitmapData to be used for rendering animated dashed line.
	 **/
	protected var bd:BitmapData;
	
	/**
	 * @private
	 * Flag to specify whether an instance of this class is used as a drag proxy.
	 **/
	private var isDragProxy:Boolean;
	
	
   //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 **/
	private var _contentWidth:Number;
	
	
	/**
	 * @private
	 **/
	override public function set contentWidth(value:Number):void {
		_contentWidth = value;
	}
	/**
	 * Drawing width.
	 **/
	override public function get contentWidth():Number {
		if (isNaN(_contentWidth)) {
			return this.height;
		}
		return _contentWidth;
	}
	
	/**
	 * @private
	 **/
	private var _contentHeight:Number;
	
		/**
	 * @private
	 **/
	override public function set contentHeight(value:Number):void {
		_contentHeight = value;
	}
	
	/**
	 * Drawing height.
	 **/
	override public function get contentHeight():Number {
		if (isNaN(_contentHeight)) {
			return this.height;
		}
		return _contentHeight;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
	
	/**
	 * Overriden clear() method to remove enterFrame event handler. 
	 **/
	override public function clear():void {
		super.clear();
		if (this.hasEventListener(Event.ENTER_FRAME)) {
			this.removeEventListener(Event.ENTER_FRAME, enterHandler);
		}
	}
   //--------------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------------
	/**
	 * @private
	 * Overriden complete handler method. Registers enterFrame event handler. 
	 **/
	override protected function completeHandler(event:Event):void {
		child.visible = false;
		this.addEventListener(Event.ENTER_FRAME, enterHandler, false, 0, true);
	}
	
	
	
   //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
	private function enterHandler(event:Event):void {
		if (isDragProxy && !DragManager.isDragging) {
			this.removeEventListener(Event.ENTER_FRAME, enterHandler);
			if (this.parent) this.parent.removeChild(this);
			return;
		}
		bd = new BitmapData(child.width,child.height);
		bd.draw(child);
		var g:Graphics = this.graphics;
		g.clear();
		g.beginBitmapFill(bd, null, true, true);
		g.moveTo(0,0);
		g.drawRect(0,0, contentWidth, 1);
		g.drawRect(0, contentHeight-1, contentWidth , 1);
		var matrix:Matrix = new Matrix();
		matrix.rotate(Math.PI/2);
		g.beginBitmapFill(bd, matrix);
		g.drawRect(0, 0, 1, contentHeight);
		g.drawRect(contentWidth, 0, 1, contentHeight);
		g.endFill(); 
	}
	
	
}
}