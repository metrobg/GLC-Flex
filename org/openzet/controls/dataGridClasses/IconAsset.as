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
package org.openzet.controls.dataGridClasses
{
/**
 *  Class that defines all images for each file extension.
 */
public class IconAsset
{
    include "../../core/Version.as";

	[Embed(source="../../../../../assets/images/icon_zip.png")]
	public static var ZIP_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_doc.png")]
	public static var DOC_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_etc.png")]
	public static var ETC_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_exe.png")]
	public static var EXE_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_gif.png")]
	public static var GIF_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_jpg.png")]
	public static var JPG_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_pdf.png")]
	public static var PDF_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_ppt.png")]
	public static var PPT_ICON:Class;
	[Embed(source="../../../../../assets/images/icon_xls.png")]
	public static var XLS_ICON:Class;

    /**
     *  Returns a class representing a file extension.
     *  If no icon matches the specified file extension, returns predefined ETC icon class.
     *
     *  @param File extension name.
     *  @return Icon image class
     */
    public static function getIcon(value:String):Class
    {
        var icon:Class = IconAsset[value.toUpperCase() + "_ICON"];

        if (icon == null)
        {
            return ETC_ICON;
        }

        return icon;
    }
}
}