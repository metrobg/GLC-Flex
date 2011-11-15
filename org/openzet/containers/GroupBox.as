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
package org.openzet.containers
{
import flash.display.DisplayObject;
import flash.geom.Rectangle;

import mx.core.IUITextField;
import mx.core.LayoutContainer;
import mx.core.UITextField;
import mx.core.mx_internal;

import org.openzet.skins.ZetBorder;

use namespace mx_internal;

/**
 *  title's position TL, TR
 *  @default TL
 */
[Style(name="titleAlign", type="String", enumeration="TL,TR,BL,BR", inherit="no")]

/**
 *  GroupBox component lays out child controls at absolute positions or vertically and horizontally.
 *  Also you can specify a title for this control, by which you can categorize child controls in a grouping label.
 */
public class GroupBox extends LayoutContainer
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
    /**
     *	Constructor
     */
    public function GroupBox()
    {

    }

	/**
	 *  @private
	 */
    private var _titleTextField:UITextField;

    /**
     *  @private
     */
    private var _overflowTitle:Boolean = false;

    //---------------------------------
    //  title
    //---------------------------------

    /**
     *  @private
     */
    private var _title:String;

    /**
     *  @private
     */
    private var _titleChanged:Boolean = false;

    /**
     *  GroupBox's title
     *
     */
    public function get title():String
    {
        return _title;
    }

    /**
     *  @private
     */
    public function set title(value:String):void
    {
        _title = value;
        _titleChanged = true;

        invalidateProperties();
    }

    //---------------------------------
    //  titleGap
    //---------------------------------
    /**
     *  @private
     */
    private var _titleGap:Number = 5;

    /**
     *  @private
     */
    private var _titleGapChanged:Boolean = false;

    /**
     * gap between border and title.
     */
    /*
    public function get titleGap():Number
    {
        return _titleGap;
    }
    */
    /**
     *  @private
     */
    /*
    public function set titleGap(value:Number):void
    {
        _titleGap = value;
    }
    */

    //--------------------------------------------------------------------------
    //
    //  Overridden Method
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     *	If _title is already set when commitProperties() is invoked,
     *  calls invalidateDisplayList(). invalidateSize() method will be called by
     *  layoutChrome() method.
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if(_titleChanged)
        {
            _titleChanged = false;

            invalidateDisplayList();
        }
    }

    /**
    * @private
    */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if(styleProp == "titleAlign")
        {
            invalidateDisplayList();
        }
    }

    /**
     *	@private
     *  creates _titleTextField and adds it as a raw child.
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if(!_titleTextField)
        {
            _titleTextField = new UITextField();
            rawChildren.addChild(_titleTextField);
        }
    }

    /**
     *	@private
     *  Displays selectively ... with regard to title;s length and sets _titleTextField's width.
     *  If _titleTextField's value is set, we call invalidateSize() method again to set its size.
     *  If border style exists, we cast it as ZetBorder type and stores _title inforation therein.
     *  Lastly, call super.layoutChrome() method to pass on superclass for layout logic.
     */
    override protected function layoutChrome(w:Number, h:Number):void
    {
    	var minusValues:Number = getStyle("cornerRadius") * 2 + getStyle("titleGap") * 2 + UITextField.TEXT_WIDTH_PADDING * 2;
        var outOfLength:Number = w - minusValues;

        _titleTextField.x = 0;

        _titleTextField.text = _title;



        var textWidth:Number = Math.min((_titleTextField.textWidth + UITextField.TEXT_WIDTH_PADDING), outOfLength);

        if(textWidth <= 0)
        {
        	textWidth = 0;
        }

        _titleTextField.width = textWidth;
        _titleTextField.height = _titleTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING;

        var titleAlign:String = String(getStyle("titleAlign")).toUpperCase();

        if(titleAlign == "TL" )
        {
            _titleTextField.x = _titleTextField.x + getStyle("cornerRadius") + (_titleGap * 2);
        }
        else if(titleAlign == "TR")
        {
            _titleTextField.x = w - (_titleTextField.width + getStyle("cornerRadius") + (_titleGap * 2));
        }
        else if(titleAlign == "BL")
        {
            _titleTextField.x = _titleTextField.x + getStyle("cornerRadius") + (_titleGap * 2);
            _titleTextField.y = h - _titleTextField.height/2;
        }
        else if(titleAlign == "BR")
        {
            _titleTextField.x = w - (_titleTextField.width + getStyle("cornerRadius") + (_titleGap * 2));
            _titleTextField.y = h - _titleTextField.height/2;
        }

        /*
        else if(String(getStyle("titleAlign")).toUpperCase() == "BL")
        {
            _titleTextField.x = _titleTextField.x + getStyle("cornerRadius") + (_titleGap * 2);
            _titleTextField.y = h - _titleTextField.height / 2;
        }
        */

        if (_titleTextField.height > h)
        {
            _titleTextField.visible = false;
        }
        else
        {
            _titleTextField.visible = true;

            var b:Boolean = _titleTextField.truncateToFit();
            _titleTextField.toolTip = b ? _title : null;
        }

        if(border)
        {
            ZetBorder(border).titleTextFieldRect = new Rectangle(_titleTextField.x,
                                                        _titleTextField.y,
                                                        _titleTextField.width,
                                                        _titleTextField.textHeight);
            ZetBorder(border).titleGap = _titleGap;
            ZetBorder(border).title = _title;
            ZetBorder(border).textWidth = textWidth;
            ZetBorder(border).titleAlign = String(getStyle("titleAlign")).toUpperCase();
            ZetBorder(border).rawAreaHeight = h;
        }

        // calls invalidateSize() method again.
        invalidateSize();
        // After size is set, call super class's layoutChrome() method.
        super.layoutChrome(w, h);
    }

    /**
     *  @private
     *  Sets contentPane's position as lower as half the value of _titleTextField's height.
     */
    override public function validateDisplayList():void
    {
    	super.validateDisplayList();

    	if(contentPane)
        {
            contentPane.y += _titleTextField.textHeight / 2;
        }
    }

    /**
     *  @private
     *	Adds half the height of _titleTextField to measuredHeight.
     */
    override protected function measure():void
    {
        super.measure();


        measuredHeight = measuredHeight + _titleTextField.textHeight / 2;
        measuredMinHeight = measuredMinHeight + _titleTextField.textHeight / 2;
    }
}
}