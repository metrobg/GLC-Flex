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
package org.openzet.skins
{

import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import mx.core.mx_internal;
import mx.skins.halo.HaloBorder;
import mx.utils.GraphicsUtil;

use namespace mx_internal;

/**
 *  Defines the appearance of the default border for the GroupBox.
 */
public class ZetBorder extends HaloBorder
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
	public function ZetBorder()
	{
		super();
	}

    /**
    * Rectangle around the title text field.
    */
    public var titleTextFieldRect:Rectangle;


    /**
    * Title gap
    */
    public var titleGap:Number = 0;


    /**
    * Title's alignment
    */
    public var titleAlign:String;


    /**
    * Title text
    */
    public var title:String;

     /**
    * raw area height
    */
    public var rawAreaHeight:Number;

     /**
    * Title text's width
    */
    public var textWidth:Number = 0;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
    /**
    * @private
    **/
    override protected function drawRoundRect(
							x:Number, y:Number, width:Number, height:Number,
							cornerRadius:Object = null,
							color:Object = null,
							alpha:Object = null,
							gradientMatrix:Matrix = null,
							gradientType:String = "linear",
							gradientRatios:Array /* of Number */ = null,
							hole:Object = null):void
	{

	    var borderThickness:Number = getStyle("borderThickness");
		var g:Graphics = graphics;

		// Quick exit if weight or height is zero.
		// This happens when scaling a component to a very small value,
		// which then gets rounded to 0.
		if (width == 0 || height == 0)
			return;

		// If color is an object then allow for complex fills.
		if (color !== null)
		{
			if (color is uint)
			{
				g.beginFill(uint(color), Number(alpha));
			}
			else if (color is Array)
			{
				var alphas:Array = alpha is Array ?
								   alpha as Array :
								   [ alpha, alpha ];

				if (!gradientRatios)
					gradientRatios = [ 0, 0xFF ];

				g.beginGradientFill(gradientType,
									color as Array, alphas,
									gradientRatios, gradientMatrix);
			}
		}

		var ellipseSize:Number;

        //!!!!!!!!!
        var halfBoxTextHeight:Number = titleTextFieldRect.height / 2;

		// Stroke the rectangle.
		if (!cornerRadius)
		{
			g.drawRect(x, y + halfBoxTextHeight, width, height - halfBoxTextHeight);
		}
		else if (cornerRadius is Number)
		{
			ellipseSize = Number(cornerRadius) * 2;
			g.drawRoundRect(x, y + halfBoxTextHeight, width, height - halfBoxTextHeight,
							ellipseSize, ellipseSize);
		}
		else
		{
			GraphicsUtil.drawRoundRectComplex(g,
								   x, y + halfBoxTextHeight, width, height - halfBoxTextHeight,
								   cornerRadius.tl, cornerRadius.tr,
								   cornerRadius.bl, cornerRadius.br);
		}

		// Carve a rectangular hole out of the middle of the rounded rect.
		if (hole)
		{
			var holeR:Object = hole.r;
			if (holeR is Number)
			{
				ellipseSize = Number(holeR) * 2;
				g.drawRoundRect(hole.x, hole.y + halfBoxTextHeight, hole.w, hole.h - halfBoxTextHeight,
								ellipseSize, ellipseSize);

                //!!!!!!!!!!
                if(title && title.length != 0 && textWidth > 0)
                {
                    if(titleAlign == "TL")
                    {
                        g.drawRect(getStyle("cornerRadius") + (titleGap * 1), 0 + halfBoxTextHeight, titleTextFieldRect.width + (titleGap * 2), getStyle("borderThickness"));
                    }
                    else if(titleAlign == "TR")
                    {
                        g.drawRect(titleTextFieldRect.x - (titleGap * 1), 0 + halfBoxTextHeight, titleTextFieldRect.width + (titleGap * 2), getStyle("borderThickness"));
                    }
                    else if(titleAlign == "BL")
                    {
                        g.drawRect(getStyle("cornerRadius") + (titleGap * 1), height - borderThickness, titleTextFieldRect.width + (titleGap * 2), getStyle("borderThickness"));
                    }
                    else if(titleAlign == "BR")
                    {
                        g.drawRect(titleTextFieldRect.x - (titleGap * 1), height - borderThickness, titleTextFieldRect.width + (titleGap * 2), getStyle("borderThickness"));
                    }
                }
			}
			else
			{
				GraphicsUtil.drawRoundRectComplex(g,
									   hole.x, hole.y + halfBoxTextHeight, hole.w, hole.h - halfBoxTextHeight,
									   holeR.tl, holeR.tr, holeR.bl, holeR.br);
			}
		}

		if (color !== null)
			g.endFill();
	}

    /**
	 *  @private
	 */
	override mx_internal function drawBorder(w:Number, h:Number):void
	{
		var borderStyle:String = getStyle("borderStyle");

		// Other styles that we may fetch.
		var highlightAlphas:Array = getStyle("highlightAlphas");

		var backgroundAlpha:Number;

		var borderCapColor:uint;
		var borderColor:uint;
		var borderSides:String;
		var borderThickness:Number;
		var buttonColor:uint;
		var docked:Boolean;
		var dropdownBorderColor:uint;
		var fillColors:Array;
		var footerColors:Array;
		var highlightColor:uint;
		var shadowCapColor:uint;
		var shadowColor:uint;
		var themeColor:uint;
		var translucent:Boolean;

		var hole:Object;
		var drawTopHighlight:Boolean = false;

		var borderColorDrk1:Number
		var borderColorDrk2:Number
		var borderColorLt1:Number

		var borderInnerColor:Object;

		var g:Graphics = graphics;
		g.clear();

		if (borderStyle)
		{
			switch (borderStyle)
			{
				case "none":
				{
					break;
				}

                /*
				case "inset": // used for text input & numeric stepper
				{
					borderColor = getStyle("borderColor");
					borderColorDrk1 =
						ColorUtil.adjustBrightness2(borderColor, -40);
					borderColorDrk2 =
						ColorUtil.adjustBrightness2(borderColor, +25);
					borderColorLt1 =
						ColorUtil.adjustBrightness2(borderColor, +40);

					borderInnerColor = backgroundColor;
					if (borderInnerColor === null ||
						borderInnerColor === "")
					{
						borderInnerColor = borderColor;
					}

					draw3dBorder(borderColorDrk2, borderColorDrk1, borderColorLt1,
								 Number(borderInnerColor),
								 Number(borderInnerColor),
								 Number(borderInnerColor));
					break;
				}

				case "outset":
				{
					borderColor = getStyle("borderColor");
					borderColorDrk1 =
						ColorUtil.adjustBrightness2(borderColor, -40);
					borderColorDrk2 =
						ColorUtil.adjustBrightness2(borderColor, -25);
					borderColorLt1 =
						ColorUtil.adjustBrightness2(borderColor, +40);

					borderInnerColor = backgroundColor;
					if (borderInnerColor === null ||
						borderInnerColor === "")
					{
						borderInnerColor = borderColor;
					}

					draw3dBorder(borderColorDrk2, borderColorLt1, borderColorDrk1,
								 Number(borderInnerColor),
								 Number(borderInnerColor),
								 Number(borderInnerColor));
					break;
				}

                */

                //!!!!!!!!!!!!!!!!!!!!!!!!!!!!

				default: // ((borderStyle == "solid") || (borderStyle == null))
				{
					borderColor = getStyle("borderColor");
					borderThickness = getStyle("borderThickness");
					borderSides = getStyle("borderSides");
					var bHasAllSides:Boolean = true;
					radius = getStyle("cornerRadius");

					bRoundedCorners =
						getStyle("roundedBottomCorners").toString().toLowerCase() == "true";

					var holeRadius:Number =
						Math.max(radius - borderThickness, 0);

					hole = { x: borderThickness,
							 y: borderThickness,
							 w: w - borderThickness * 2,
							 h: h - borderThickness * 2,
							 r: holeRadius };

					if (!bRoundedCorners)
					{
						radiusObj = {tl:radius, tr:radius, bl:0, br:0};
						hole.r = {tl:holeRadius, tr:holeRadius, bl:0, br:0};
					}

					if (borderSides != "left top right bottom")
					{
						// Convert the radius values from a scalar to an object
						// because we need to adjust individual radius values
						// if we are missing any sides.
						hole.r = { tl: holeRadius,
								   tr: holeRadius,
								   bl: bRoundedCorners ? holeRadius : 0,
								   br: bRoundedCorners ? holeRadius : 0 };

						radiusObj = { tl: radius,
									  tr: radius,
									  bl: bRoundedCorners ? radius : 0,
									  br: bRoundedCorners ? radius : 0};

						borderSides = borderSides.toLowerCase();

						if (borderSides.indexOf("left") == -1)
						{
							hole.x = 0;
							hole.w += borderThickness;
							hole.r.tl = 0;
							hole.r.bl = 0;
							radiusObj.tl = 0;
							radiusObj.bl = 0;
							bHasAllSides = false;
						}

						if (borderSides.indexOf("top") == -1)
						{
							hole.y = 0;
							hole.h += borderThickness;
							hole.r.tl = 0;
							hole.r.tr = 0;
							radiusObj.tl = 0;
							radiusObj.tr = 0;
							bHasAllSides = false;
						}

						if (borderSides.indexOf("right") == -1)
						{
							hole.w += borderThickness;
							hole.r.tr = 0;
							hole.r.br = 0;
							radiusObj.tr = 0;
							radiusObj.br = 0;
							bHasAllSides = false;
						}

						if (borderSides.indexOf("bottom") == -1)
						{
							hole.h += borderThickness;
							hole.r.bl = 0;
							hole.r.br = 0;
							radiusObj.bl = 0;
							radiusObj.br = 0;
							bHasAllSides = false;
						}
					}

					if (radius == 0 && bHasAllSides)
					{
						drawDropShadow(0, 0, w, h, 0, 0, 0, 0);

						g.beginFill(borderColor);

						//!!!!!!!!!


						if(titleTextFieldRect && titleGap)
						{
						    var halfBoxTextHeight:Number = titleTextFieldRect.height / 2;

						    g.drawRect(0, 0 + halfBoxTextHeight, w, h - halfBoxTextHeight);
						    g.drawRect(borderThickness, borderThickness + halfBoxTextHeight,
								   w - 2 * borderThickness,
								   h - 2 * borderThickness - halfBoxTextHeight);

                            if(title && title.length != 0 && textWidth > 0)
                            {

                                if(titleAlign == "TL")
                                {
                                    g.drawRect(titleGap, halfBoxTextHeight, titleTextFieldRect.width + (titleGap * 2), borderThickness);
                                }
                                else if(titleAlign == "TR")
                                {
                                    g.drawRect(titleTextFieldRect.x - (titleGap * 1), halfBoxTextHeight, titleTextFieldRect.width + (titleGap * 2), borderThickness);
                                }
                                else if(titleAlign == "BL")
                                {
                                    g.drawRect(titleGap, rawAreaHeight - borderThickness, titleTextFieldRect.width + (titleGap * 2), borderThickness);
                                }
                                else if(titleAlign == "BR")
                                {
                                    g.drawRect(titleTextFieldRect.x - (titleGap * 1), rawAreaHeight - borderThickness, titleTextFieldRect.width + (titleGap * 2), borderThickness);
                                }
                            }
						}

						g.endFill();
					}


					else if (radiusObj)
					{
						drawDropShadow(0, 0, w, h,
									   radiusObj.tl, radiusObj.tr,
									   radiusObj.br, radiusObj.bl);

						drawRoundRect(
							0, 0, w, h, radiusObj,
							borderColor, 1,
							null, null, null, hole);

						// Reset radius here so background drawing
						// below is correct.
						radiusObj.tl = Math.max(radius - borderThickness, 0);
						radiusObj.tr = Math.max(radius - borderThickness, 0);
						radiusObj.bl = bRoundedCorners ? Math.max(radius - borderThickness, 0) : 0;
						radiusObj.br = bRoundedCorners ? Math.max(radius - borderThickness, 0) : 0;
					}
					else
					{
						drawDropShadow(0, 0, w, h,
									   radius, radius, radius, radius);

						drawRoundRect(
							0, 0, w, h, radius,
							borderColor, 1,
							null, null, null, hole);

						// Reset radius here so background drawing
						// below is correct.
						radius = Math.max(getStyle("cornerRadius") -
								 borderThickness, 0);
					}
				}
			} // switch
		}
	}
}

}
