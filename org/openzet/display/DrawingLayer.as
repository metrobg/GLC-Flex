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
import flash.display.Sprite;
/**
 * Drawing class that has a separate Sprite object for line drawing.
 **/
public class DrawingLayer extends Sprite
{
	 //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
	public function DrawingLayer(fillColor:uint = 0x6378ed, fillAlpha:Number = 0.5, lineThickness:uint = 1, lineColor:uint = 0x000000)
	{
		super();
		_fillColor = fillColor;
		_fillAlpha = fillAlpha;
		_lineThickness = lineThickness;
		_lineColor = lineColor;
		lineLayer.name = "lineLayer";
		this.addChild(lineLayer);
	}
	 //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	
	/**
	 * @private
	 * line thickness
	 */
	private var _lineThickness:uint;
	/**
	 * @private
	 * line color
	 */
	private var _lineColor:uint;
	/**
	 * @private
	 * fill color of the content area
	 */
	private var _fillColor:uint;
	/**
	 * @private
	 * fill alpha of the content area
	 */
	private var _fillAlpha:Number;
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	/**
	 * @private
	 */
	protected var _lineLayer:Sprite = new Sprite();
	
	/**
	 * @private
	 * Sprite used for drawing lines only. 
	 */
	public function get lineLayer():Sprite {
		return _lineLayer;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * Draws a rectangle with specified x, y, width, height values.
	 * 
	 * @param x x position
	 * @param y y position
	 * @param width width of the rectangle
	 * @param height height of the rectangle
	 **/
	public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
		clear();
		this.graphics.lineStyle(0, 0, 0);
		this.graphics.beginFill(_fillColor, _fillAlpha);
		this.graphics.drawRect(x, y, width, height);
		this.graphics.endFill();
		
		this.lineLayer.graphics.lineStyle(_lineThickness, _lineColor);
		this.lineLayer.graphics.moveTo(x, y);
		this.lineLayer.graphics.lineTo(x, y + height);
		this.lineLayer.graphics.lineTo(x + width, y + height);
		this.lineLayer.graphics.lineTo(x + width, y);
		this.lineLayer.graphics.lineTo(x, y); 
	}
	
	/**
	 * Clears all drawing. Clears line drawing also.  
	 **/
	public function clear():void {
		this.graphics.clear();
		this.lineLayer.graphics.clear();	
	}
}
}