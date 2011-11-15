////////////////////////////////////////////////////////////////////////////////
//
//      Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//      All Rights Reserved. 
//
//
//      This file is part of OpenZet.
//
//      OpenZet is free software: you can redistribute it and/or modify
//      it under the terms of the GNU Lesser General Public License version 3 as published by
//      the Free Software Foundation. 
//
//      OpenZet is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU Lesser General Public License version 3 for more details.
//
//      You should have received a copy of the GNU Lesser General Public License
//      along with OpenZet.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////////////
package org.openzet.controls
{
/**
 *  Class that defines all images for TimeChooser class.
 */
public class TimeChooserIconFactory
{
    [Embed(source="../../../../assets/images/icon_sun.png")]
    public static var SUN_ICON:Class;
    [Embed(source="../../../../assets/images/icon_moon.png")]
    public static var MOON_ICON:Class;
    [Embed(source="../../../../assets/images/icon_watch.png")]
    public static var WATCH_ICON:Class;
    
    /**
     *  Returns a class representing a sun/moon/watch.
     *
     *  @return Icon image class
     */
    public static function getIcon(value:String):Class
    {
        var icon:Class = TimeChooserIconFactory[value.toUpperCase() + "_ICON"];

        return icon;
    }
}
}