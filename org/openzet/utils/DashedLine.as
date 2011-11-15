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
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Sprite;


/**
 * Drawing class used to draw dashed lines. 
 **/
public class DashedLine
{
	include "../core/Version.as";
	/**
	 * 
	 * A static method to draw dashed line on a specific graphics object.
	 * 
	 * @param g Graphics object used to draw dashed line. 
	 * @param startPoint Start point of the drawing. 
	 * @param endPoint End point of the drawing.
	 * @param lineColor Line color.
	 * @param thickness Line thickness.
	 * @param alpha Line's opacity.
	 * 
	 **/
	public static function drawDashedLine(g:Graphics,startPoint:Point,endPoint:Point,lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1):void {
		var g:Graphics=g;
		g.lineStyle(thickness,lineColor,alpha);
		var pt:Point =new Point(startPoint.x,startPoint.y);
		var pt2:Point = new Point(endPoint.x,endPoint.y);
		var dx:Number = pt2.x - pt.x;
		var dy:Number = pt2.y - pt.y;
		var dist:Number= Math.sqrt(dx*dx+dy*dy);
		var len:Number = Math.round(dist/10);
		var theta:Number = Math.atan2(dy,dx);
		for (var i:int=0; i<len; i++) {
			g.moveTo(pt.x,pt.y);
			var targetPoint:Point;
			if (i==len-1) {
				targetPoint = new Point(pt2.x- Math.cos(theta)*5,pt2.y-Math.sin(theta)*5);
			} else {
				targetPoint = new Point(pt.x + Math.cos(theta)*5,pt.y + Math.sin(theta)*5);
			}
			g.lineTo(targetPoint.x,targetPoint.y);
			pt = new Point(targetPoint.x + Math.cos(theta)*5,targetPoint.y + Math.sin(theta)*5);
		}
	}
	
	 /**
	 * 
	 * A static method to draw a rectanle with dashed lines on a specific graphics object.
	 * 
	 * @param g Graphics object used to draw dashed line.  
	 * @paramx x Starting x position of the rectangle to draw. 
	 * @param y Starting y position of the rectangle to draw. 
	 * @param width Width of the rectangle. 
	 * @param height Height of the rectangle.
	 * @param lineColor Line's color.
	 * @param thickness Line's thickness.
	 * @param alpha Line's opacity.
	 **/
	public static function drawDashedRect(g:Graphics,x:Number,y:Number,width:Number,height:Number,lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1):void {
		DashedLine.drawDashedLine(g,new Point(x,y),new Point(x+width,y),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x+width,y),new Point(x+width,y+height),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x+width,y+height),new Point(x,y+height),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x,y+height),new Point(x,y),lineColor,thickness);
	}
}
}