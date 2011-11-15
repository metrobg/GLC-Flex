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

import flash.events.MouseEvent;

import mx.controls.Button;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.IndexChangedEvent;

use namespace mx_internal;

//----------------------------------------
//  Styles
//----------------------------------------


/**
 *  The backward button up skin.
 *
 *  @default the "backwardUpSkin" symbol in the Assets.swf file.
 */
[Style(name="backwardUpSkin", type="Class", inherit="no")]

/**
 *  The backward button over skin.
 *
 *  @default the "backwardOverSkin" symbol in the Assets.swf file.
 */
[Style(name="backwardOverSkin", type="Class", inherit="no")]

/**
 *  The backward button down skin.
 *
 *  @default the "backwardDownSkin" symbol in the Assets.swf file.
 */
[Style(name="backwardDownSkin", type="Class", inherit="no")]

/**
 *  The backward button disabled skin.
 *
 *  @default the "backwardDisabledSkin" symbol in the Assets.swf file.
 */
[Style(name="backwardDisabledSkin", type="Class", inherit="no")]

/**
 *  The forward button up skin.
 *
 *  @default the "forwardUpSkin" symbol in the Assets.swf file.
 */
[Style(name="forwardUpSkin", type="Class", inherit="no")]

/**
 *  The forward button over skin.
 *
 *  @default the "forwardOverSkin" symbol in the Assets.swf file.
 */
[Style(name="forwardOverSkin", type="Class", inherit="no")]

/**
 *  The forward button down skin.
 *
 *  @default the "forwardDownSkin" symbol in the Assets.swf file.
 */
[Style(name="forwardDownSkin", type="Class", inherit="no")]

/**
 *  The forward button disabled skin.
 *
 *  @default the "forwarddDisabledSkin" symbol in the Assets.swf file.
 */
[Style(name="forwarddDisabledSkin", type="Class", inherit="no")]

/**
 *  뒤로가기 버튼의 styleName.
 *
 *  @default "backwardButtonStyle"
 */
[Style(name="backwardButtonStyleName", type="String", inherit="no")]

/**
 *  앞으로가기 버튼의 styleName.
 *
 *  @default "backwardButtonStyle"
 */
[Style(name="forwardButtonStyleName", type="String", inherit="no")]

/**
 *  TabNavigator 또는 ViewStack의 selectedIndex 속성의 상태를 저장해
 *  앞으로가기, 뒤로가기의 컨트롤을 담당하는 버튼 컴포넌트
 */
public class HistoryButton extends UIComponent
{
    include "../core/Version.as";
    //-----------------------------------------------------------
    //
    //  Constructor
    //
    //-----------------------------------------------------------

    /**
     *  Constructor
     */
    public function HistoryButton()
	{
		super();
	}

    //-----------------------------------------------------------
    //
    //  Variable
    //
    //-----------------------------------------------------------
    private var isForOrBackwardButtonClicked:Boolean = false;

    /**
     *  @private
     *  뒤로가기 버튼
     */
    private var backwardButton:Button;

    /**
     *  @private
     *  앞으로가기 버튼
     */
    private var forwardButton:Button;

    /**
     *  @private
     *  내부에서 조작하는지의 여부를 체크.
     *  내부에서 조작하는것이면, change 이벤트에서 해당타겟의 history를 생성하지 않는다.
     */
    private var inner:Boolean = false;

    /**
     *  @private
     *  이전의 히스토리 인덱스를 관리.
     */
    private var backwardHistory:Array;

    /**
     *  @private
     *  다음의 히스토리 인덱스를 관리.
     */
    private var forwardHistory:Array;

    /**
     *  @private
     *  버튼 사이의 간격
     */
    private var BUTTONS_GAP:Number = 8;

    //-----------------------------------------------------------
    //
    //  Properties
    //
    //-----------------------------------------------------------

    //------------------------------
    //  useBackward
    //------------------------------

    /**
     *  @private
     *  뒤로 버튼 사용여부값 저장.
     */
    private var _useBackward:Boolean = false;

    /**
     *  @private
     */
    private var useBackwardChanged:Boolean = false;

    [Bindable("useBackwardChanged")]

    /**
     *  뒤로 버튼 사용여부
     */
    public function get useBackward():Boolean
    {
        return _useBackward;
    }

    /**
     *  @private
     */
    public function set useBackward(value:Boolean):void
    {
        _useBackward = value;
        useBackwardChanged = true;

        invalidateSize();
        invalidateDisplayList();
    }

    //------------------------------
    //  useForward
    //------------------------------

    /**
     *  @private
     *  앞으로 버튼 사용여부값 저장.
     */
    private var _useForward:Boolean = false;

    /**
     *  @private
     */
    private var useForwardChanged:Boolean = false;

    [Bindable("useForwardChanged")]

    /**
     *  앞으로 버튼 사용여부
     */
    public function get useForward():Boolean
    {
        return _useForward;
    }

    /**
     *  @private
     */
    public function set useForward(value:Boolean):void
    {
        _useForward = value;
        useForwardChanged = true;

        invalidateSize();
        invalidateDisplayList();
    }

    //------------------------------
    //  target
    //------------------------------

    /**
     *  @private
     *
     */
    private var _target:Object;

    /**
     *  @private
     */
    private var targetChanged:Boolean = false;

    [Bindable("targetChanged")]

    /**
     *  ViewStack 참조.
     */
    public function get target():Object
    {
        return _target;
    }

    /**
     *  @private
     */
    public function set target(value:Object):void
    {
        if (!value.hasOwnProperty("selectedIndex"))
        {
            //Do Nothing
        }
        else
        {
            if (_target)
            {
                _target.removeEventListener(IndexChangedEvent.CHANGE, target_changeHandler);
            }


            _target = value;
            _target.addEventListener(IndexChangedEvent.CHANGE, target_changeHandler);

            resetHistory();
    	}
    }

    //-----------------------------------------------------------
    //
    //  Overriden Methods
    //
    //-----------------------------------------------------------

    /**
     *  @private
	 */
    override protected function createChildren():void
    {
		super.createChildren();

        if (!backwardButton)
        {
            backwardButton = new Button();
            backwardButton.visible = false;
            backwardButton.enabled = false;
            backwardButton.toolTip = "Prev";
            var backwardButtonStyleName:String = getStyle("backwardButtonStyle");
            backwardButton.styleName = backwardButtonStyleName;

            if(backwardButtonStyleName)
            {
                backwardButton.upSkinName = "backwardUpSkin";
                backwardButton.downSkinName = "backwardDownSkin";
                backwardButton.overSkinName = "backwardOverSkin";
                backwardButton.disabledSkinName = "backwardDisabledSkin";
            }
            else
            {
                backwardButton.label = "Prev";
            }

            addChild(backwardButton);

            backwardButton.addEventListener(MouseEvent.CLICK, backwardButton_clickHandler);
        }

        if (!forwardButton)
        {
            forwardButton = new Button();
            forwardButton.visible = false;
            forwardButton.enabled = false;
            forwardButton.toolTip = "Next";
            var forwardButtonStyleName:String = getStyle("forwardButtonStyle");
            forwardButton.styleName = forwardButtonStyleName;

            if(forwardButtonStyleName)
            {
                forwardButton.upSkinName = "forwardUpSkin";
                forwardButton.downSkinName = "forwardDownSkin";
                forwardButton.overSkinName = "forwardOverSkin";
                forwardButton.disabledSkinName = "forwardDisabledSkin";
            }
            else
            {
                forwardButton.label = "Next";
            }

            addChild(forwardButton);

            forwardButton.addEventListener(MouseEvent.CLICK, forwardButton_clickHandler);
        }
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        backwardButton.visible = _useBackward;

        if (_useBackward)
        {
            backwardButton.setActualSize(
                backwardButton.getExplicitOrMeasuredWidth(),
                backwardButton.getExplicitOrMeasuredHeight());

            backwardButton.move(0, 0);
        }

        forwardButton.visible = _useForward;

        if (_useForward)
        {
            forwardButton.setActualSize(
                forwardButton.getExplicitOrMeasuredWidth(),
                forwardButton.getExplicitOrMeasuredHeight());

            forwardButton.move(unscaledWidth - forwardButton.getExplicitOrMeasuredWidth(), 0);
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        var w:Number = 0;

        if (_useBackward)
        {
            w += backwardButton.getExplicitOrMeasuredWidth();
        }

        if (_useForward)
        {
            w += forwardButton.getExplicitOrMeasuredWidth();
        }

        if (_useBackward && _useForward)
        {
            w += BUTTONS_GAP;
        }

        measuredMinWidth = measuredWidth = w;
        measuredHeight = Math.max(backwardButton.getExplicitOrMeasuredHeight(),
                                  forwardButton.getExplicitOrMeasuredHeight());
    }


    //-----------------------------------------------------------
    //
    //  Methods
    //
    //-----------------------------------------------------------

    /**
     *  뒤로가기.
     */
    public function backward():void
    {
        var idx:Number = getBackwardHistory();

        if (!isNaN(idx))
        {
        	inner = true;
            setForwardHistory(target.selectedIndex);
            target.selectedIndex = idx;
            isForOrBackwardButtonClicked = true;
            setButtonsEnabled();
        }
    }

    /**
     *  앞으로가기.
     */
    public function forward():void
    {
        var idx:Number = getForwardHistory();

        if (!isNaN(idx))
        {
        	inner = true;
            setBackwardHistory(target.selectedIndex);
            target.selectedIndex = idx;
            isForOrBackwardButtonClicked = true;
            setButtonsEnabled();
        }
    }

    /**
     *  @private
     *  이전인덱스 반환
     */
    private function getBackwardHistory():Number
    {
        return backwardHistory.pop();
    }

    /**
     *  @private
     *  이전인덱스 설정
     */
    private function setBackwardHistory(idx:Number):void
    {
        backwardHistory.push(idx);
    }

    /**
     *  @private
     *  앞으로인덱스 반환
     */
    private function getForwardHistory():Number
    {
        return forwardHistory.pop();
    }

    /**
     *  @private
     *  앞으로인덱스 설정
     */
    private function setForwardHistory(idx:Number):void
    {
        forwardHistory.push(idx);
    }

    /**
     *  history를 모두 리셋한다.
     */
    public function resetHistory():void
    {
        backwardHistory = [];
        forwardHistory = [];

        setButtonsEnabled();
    }

    /**
     *  이전 history를 모두 리셋한다.
     */
    public function resetBackwardHistory():void
    {
        backwardHistory = [];

        setButtonsEnabled();
    }

    /**
     *  앞으로 history를 모두 리셋한다.
     */
    public function resetForwardHistory():void
    {
        forwardHistory = [];

        setButtonsEnabled();
    }

    /**
     *  @private
     *  뒤로/앞으로가기 버튼의 enabled를 조정.
     */
    private function setButtonsEnabled():void
    {
        backwardButton.enabled = backwardHistory.length > 0;
        forwardButton.enabled = forwardHistory.length > 0;
        if(isForOrBackwardButtonClicked)
        {
        	inner = false;
        }
    }

    //-----------------------------------------------------------
    //
    //  Event Handlers
    //
    //-----------------------------------------------------------

    /**
     *  @private
     *  뒤로가기버튼 클릭
     */
    private function backwardButton_clickHandler(event:MouseEvent):void
    {
        backward();
    }

    /**
     *  @private
     *  앞으로가기버튼 클릭
     */
    private function forwardButton_clickHandler(event:MouseEvent):void
    {
        forward();
    }

    /**
     *  @private
     *  target이 change될 때
     */
    private function target_changeHandler(event:IndexChangedEvent):void
    {
    	if(isForOrBackwardButtonClicked)
    	{
    	   inner = true;
    	   isForOrBackwardButtonClicked = false;
    	}

        if (inner)
        {
            //Do nothing
        }
        else
        {
            setBackwardHistory(event.oldIndex);
            resetForwardHistory();
        }

        inner = false;
    }
}
}
