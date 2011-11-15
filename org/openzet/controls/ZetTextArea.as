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
package org.openzet.controls
{
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import mx.controls.TextArea;
import mx.core.UITextField;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.events.ScrollEvent;

[Style(name="underLineThickness", type="Number", format="Length", inherit="no")]

/**
 *  ZetTextArea extends TextArea to provide note like features.
 *
 *  @mxml
 *
 *  <p><code>&lt;zet:ZetTextArea&gt;</code>inherits superclass's all properties in addition to following properties.</p>
 *
 *  <pre>
 *  &lt;zet:ZetTextArea
 *   <strong>Properties</strong>
 *   drawUnderLines="false|true"
 *   stepByStep="false|true"
 *   &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/zet:ZetTextArea&gt;
 *  </pre>
 *
 *  @includeExample ZetTextAreaExample.mxml
 */
public class ZetTextArea extends TextArea
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------------
    //
    //	Constructor
    //
    //--------------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function ZetTextArea()
    {
        super();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
        this.addEventListener(ScrollEvent.SCROLL, textChangedHandler, false, 0, true);
        this.addEventListener(ResizeEvent.RESIZE, textChangedHandler, false, 0, true);
        this.addEventListener(Event.CHANGE, textChangedHandler, false, 0, true);
    }

    //--------------------------------------------------------------------------------
    //
    //	Variables
    //
    //--------------------------------------------------------------------------------

    private var underLineBox:Shape;
    private var totalLines:int;
    private var lengthOfLineNumber:int
	private var lineNumberField:UITextField;
	private var numberOfLines:int;
    private var _heightOfOneLine:Number;
    private var _lineNumberFieldWidth:Number;
    private var _oneNumberWidth:Number = -1;

    //--------------------------------------------------------------------------------
    //
    //	Properties
    //
    //--------------------------------------------------------------------------------

    /**
     * @private
     */
    private var _stepByStep:Boolean = false;

      /**
     * @private
     */
    public function set stepByStep(value:Boolean):void
    {
        _stepByStep = value;
    }

    /**
     * Flag to specify whether to show lines gradually.
     *
     * @default false
     */
    public function get stepByStep():Boolean
    {
        return _stepByStep;
    }

    /**
     * @private
     */
    private var _drawUnderLines:Boolean = true;

	/**
     * @private
     */
    public function set drawUnderLines(value:Boolean):void
    {
        _drawUnderLines = value;
        if(!value)
        {
            if(underLineBox)
            {
                underLineBox.graphics.clear();
            }
        }
    }

    /**
     * Flag to specify whether to draw lines.
     * @default true
     */
    public function get drawUnderLines():Boolean
    {
        return _drawUnderLines;
    }

    //--------------------------------------------------------------------------------
    //
    //	Overridden methods
    //
    //--------------------------------------------------------------------------------

    /**
     * @override
     *
     */
    override protected function createChildren():void
    {
        createLineNumberField(-1);
        super.createChildren();
        underLineBox = new Shape();
        this.addChild(underLineBox);
    }

    //--------------------------------------------------------------------------------
    //
    //	Methods
    //
    //--------------------------------------------------------------------------------

    /**
     * @private
     *
     * Draws line.
     */
    private function drawUnderLine():void
    {
        if (lineNumberField)
        {
            if(this.textField.numLines < totalLines)
            {
                lengthOfLineNumber = int(String(this.verticalScrollPosition+this.lineNumberField.numLines).length);
            }
            else
            {
                if(lengthOfLineNumber<int(String(this.verticalScrollPosition+this.lineNumberField.numLines).length))
                {
                    lengthOfLineNumber = int(String(this.verticalScrollPosition+this.lineNumberField.numLines).length);
                }
            }

            totalLines = this.textField.numLines;
            if(_oneNumberWidth <= 0)
            {
        		_oneNumberWidth =  this.lineNumberField.textWidth / lengthOfLineNumber;
        	    _lineNumberFieldWidth = this.lineNumberField.textWidth + 7;
            }
            else
            {
                _lineNumberFieldWidth = (_oneNumberWidth*lengthOfLineNumber) + 7;
            }

        	lineNumberField.width = _lineNumberFieldWidth;
        	lineNumberField.validateNow();
        	setStyle("paddingLeft", _lineNumberFieldWidth);
        	var i:Number;
        	// starts line drawing.
        	if(_drawUnderLines)
        	{
            	var lineThickness:Number = getStyle("underLineThickness");
                if(!lineThickness)
                {
                    lineThickness = 1;
                }
            	underLineBox.graphics.clear();
                underLineBox.graphics.lineStyle(lineThickness, 1, 0.5);
                if(_stepByStep)
                {
                    if((this.height/_heightOfOneLine)>this.textField.numLines)
                    {
                        for(i = 1 ; i<=this.textField.numLines ; i++)
                        {
                            underLineBox.graphics.moveTo(_lineNumberFieldWidth, i*_heightOfOneLine);
                            underLineBox.graphics.lineTo(unscaledWidth-18, i*_heightOfOneLine);
                        }
                    }
                    else
                    {
                        for(i = _heightOfOneLine ; i < this.height ; i += _heightOfOneLine)
                        {
                            underLineBox.graphics.moveTo(_lineNumberFieldWidth, i);
                            underLineBox.graphics.lineTo(unscaledWidth-18, i);
                        }
                    }
                }
                else
                {
                    for(i = _heightOfOneLine ; i < this.height ; i += _heightOfOneLine)
                    {
                        underLineBox.graphics.moveTo(_lineNumberFieldWidth, i);
                        underLineBox.graphics.lineTo(unscaledWidth-18, i);
                    }
                }
            }
            else
            {
                //do nothing.
            }
        }
    }

    /**
     * @private
     *
     * Shows line number.
     */
    private function createLineNumber():void
    {
        numberOfLines = (this.verticalScrollPosition<1)?1:int(this.verticalScrollPosition+1);
        var lineNumber:String = "";
        var i:Number;
        if(_stepByStep)
        {
            if((this.height/_heightOfOneLine)>this.textField.numLines)
            {
                for(i = 0 ; i<this.textField.numLines ; i++)
                {
                    if(i != 0)
                    {
                        lineNumber += "\n";
                    }
                    lineNumber += numberOfLines+"";
                    numberOfLines++;
                }
            }
            else
            {
                for(i = _heightOfOneLine ; i<this.height ; i += _heightOfOneLine)
                {
                    if(i != _heightOfOneLine)
                    {
                        lineNumber += "\n";
                    }
                    lineNumber += numberOfLines+"";
                    numberOfLines++;
                }
            }
        }
        else
        {
            for(i = _heightOfOneLine ; i<this.height ; i += _heightOfOneLine)
            {
                if(i != _heightOfOneLine)
                {
                    lineNumber += "\n";
                }
                lineNumber += numberOfLines+"";
                numberOfLines++;
            }
        }
        lineNumberField.text = lineNumber;
        drawUnderLine();
    }

    /**
     *  @private
     *  Adds UITextField as a child.
     *
     *  @param childIndex The index of where to add the child.
     *  If -1, the text field is appended to the end of the list.
     */
    private function createLineNumberField(childIndex:int):void
    {

        if (!lineNumberField)
        {
            lineNumberField = new UITextField();
            lineNumberField.autoSize ="left";
            lineNumberField.enabled = enabled;
            lineNumberField.ignorePadding = false;
            lineNumberField.multiline = true;
            lineNumberField.selectable = false;
            lineNumberField.tabEnabled = false;
            lineNumberField.type = TextFieldType.DYNAMIC;
            lineNumberField.width = _lineNumberFieldWidth;
            var tf:TextFormat = new TextFormat();
            tf.align = TextFormatAlign.LEFT;
            lineNumberField.setTextFormat(tf);

            if (childIndex == -1)
                addChild(DisplayObject(lineNumberField));
            else
                addChildAt(DisplayObject(lineNumberField), childIndex);
        }
    }

    //--------------------------------------------------------------------------------
    //
    //	Event handlers
    //
    //--------------------------------------------------------------------------------

    /**
     * @private
     *
     */
    private function creationCompleteHandler(event:FlexEvent):void
    {
        _heightOfOneLine = this.textHeight;
        createLineNumber();
    }

    /**
     * @private
     *
     * TextArea's change event.
     */
    private function textChangedHandler(event:Event):void
    {
        createLineNumber();
    }
}
}