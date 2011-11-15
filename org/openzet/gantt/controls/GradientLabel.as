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
package org.openzet.gantt.controls
{
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import mx.controls.Label;

/**
*  FontWeight style to assign to internal textfield.
*
*  @default normal
*/
[Style(name="rollOverColor", type="uint", format="color", inherit="yes")]

/**
*  FontWeight style to assign to internal textfield.
*
*  @default [0xFFFFFF, 0xE6E6E6]
*/
[Style(name="headerColors", type="Array", format="Color", inherit="yes")]
public class GradientLabel extends Label
{
	public function GradientLabel()
	{
		super();
		this.mouseChildren = false;
		this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
	}
	
	private var headerColorsChanged:Boolean;
	private var headerColors:Array;
	private var rollOverColorChanged:Boolean;
	private var rollOverColor:uint;
	
	protected var drawHightLight:Boolean; 
	
	protected var hightLight:Sprite = new Sprite();
	
	
	override protected function createChildren():void {
		super.createChildren();
		addChildAt(hightLight, 0);
	}
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		if (styleProp == "headerColors") {
			headerColors = this.getStyle("headerColors");
			headerColorsChanged = true;
		} else if (styleProp == "rollOverColors") {
			rollOverColor = this.getStyle("rollOverColors");
			rollOverColorChanged = true;
		}
		this.invalidateDisplayList();
	}
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var g:Graphics = this.graphics;
		g.clear();
		if (!headerColors || headerColorsChanged) {
			headerColors = getStyle("headerColors")? getStyle("headerColors"):[0xFFFFFF, 0XE6E6E6];  
			headerColorsChanged = false;
		} 
		
		var alphas:Array = [1.0, 1.0];
		var ratios:Array = [0, 255];
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI/2);
		g.beginGradientFill(GradientType.LINEAR, headerColors, alphas, ratios, matrix);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.lineStyle(1, 0xCCCCCC);
		g.moveTo(0, 2);
		g.lineTo(0, unscaledHeight - 2);
		
		var hg:Graphics = hightLight.graphics;
		hg.clear();
		
		if (drawHightLight) 
		{
			if (!rollOverColor || rollOverColorChanged) 
			{
				rollOverColor = getStyle("rollOverColor")? getStyle("rollOverColor"):0x6378ed;  
				rollOverColorChanged = false;
			}  
			hg.beginFill(rollOverColor);
			hg.drawRect(0, 0, unscaledWidth, unscaledHeight);
		} 
	}
	
	
	protected function mouseOverHandler(event:MouseEvent):void 
	{
		drawHightLight = true;
		invalidateDisplayList();
	}
	
	protected function mouseOutHandler(event:MouseEvent):void 
	{
		drawHightLight = false;
		invalidateDisplayList();
	}
}
}