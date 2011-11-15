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

import flash.geom.Point;

/**
 * Static class that defines static methods used in relation with Math.
 **/
public class MathUtil
{
    /**
     * Returns an angle between two points as either radian value or degrees value.
     *
     * @param pt1 First point
     * @param pt2 Second point
     * @param isRadian A flag to specify whether to show result angle as radian or degrees value. Default value
     * is true, which is radian value.
     *
     * @return Returns an angle between two points.
     **/
    public static function getAngle(pt1:Point, pt2:Point, isRadian:Boolean = true):Number {
        var dx:Number = pt2.x - pt1.x;
        var dy:Number = pt2.y - pt1.y;
        var angle:Number = Math.atan2(dy, dx);
        return (isRadian)?angle:convertRadianToDegrees(angle);
    }

        /**
     * Converts radian value to degrees value.
     *
     * @param radian Radian value to convert to degrees value.
     *
     * @return Returns a degrees value corresponding to a radian value.
     **/
    public static function convertRadianToDegrees(radian:Number):Number {
        return radian*180/Math.PI;
    }


        /**
     * Converts degrees value to radian value.
     *
     * @param degrees Degrees value to convert to radian value.
     *
     * @return Returns a radian value corresponding to a degrees value.
     **/
    public static function convertDegressToRadian(degrees:Number):Number {
        return degrees*Math.PI/180;
    }

    /**
     *  Generates a random value within a range. 
     *
     *  @param min minimum value to start from. 
     *
     *  @param max maximum value to end. 
     */
    public static function randRange(min:Number, max:Number):Number
    {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    /**
     *  Returns random Boolean value. 
     */
    public static function randBoolean():Boolean
    {
        return randRange(0, 1) == 1;
    }

    /**
     *  Returns one of the passed parameters.
     */
    public static function randValueOne(...args):*
    {
        var idx:int = MathUtil.randRange(0, args.length - 1);

        return args[idx];
    }

    /**
     *  Returns some of the passed parameters.
     */
    public static function randValueRange(...args):Array
    {
        var i:int;
        var n:int = args.length;

        var dataList:Array = [];

        for (i = 0; i < n; i++)
        {
            if (MathUtil.randBoolean())
            {
                dataList.push(args[i]);
            }
        }

        return dataList;
    }
}
}
