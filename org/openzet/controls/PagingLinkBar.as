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
import flash.events.MouseEvent;
import mx.controls.NavBar;
import mx.controls.Button;
import mx.controls.Alert;
import mx.core.ClassFactory;
import mx.core.EdgeMetrics;
import mx.core.IFlexDisplayObject;
import mx.core.mx_internal;
import mx.controls.LinkButton;
import mx.events.ChildExistenceChangedEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.styles.ISimpleStyleClient;
import org.openzet.events.PagingEvent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when users click on a page index. 
 *
 *  @eventType org.openzet.events.PagingEvent.PAGE_CLICK
 */
[Event(name="pageClick", type="org.openzet.events.PagingEvent")]

/**
 *  Dispatched when previous page is viewed. 
 *
 *  @eventType org.openzet.events.PagingEvent.PAGE_CLICK
 */
[Event(name="prevPage", type="org.openzet.events.PagingEvent")]

/**
 *  Dispatched when next page is viewed. 
 *
 *  @eventType org.openzet.events.PagingEvent.PAGE_CLICK
 */
[Event(name="nextPage", type="org.openzet.events.PagingEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  selectedButton's styleName.
 *  @default pagingLinkBarSelectedButtonStyle
 */
[Style(name="selectedButtonStyleName", type="String", inherit="no")]

/**
 *  button's  styleName.
 *  @default pagingLinkBarButtonStyle
 */
[Style(name="buttonStyleName", type="String", inherit="no")]

/**
 *  Number of pixels between the LinkButton controls in the horizontal direction.
 *
 *  @default 8
 */
[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the bottom border and the LinkButton controls.
 *
 *  @default 2
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the top border and the LinkButton controls.
 *
 *  @default 2
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Color of links as you roll the mouse pointer over them.
 *  The default value is based on the current <code>themeColor</code>.
 *
 *  @default 0xEEFEE6 (light green)
 */
[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Background color of the LinkButton control as you press it.
 *
 *  @default 0xCDFFC1
 */
[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  Separator color used by the default separator skin.
 *
 *  @default 0xC4CCCC
 */
[Style(name="separatorColor", type="uint", format="Color", inherit="yes")]

/**
 *  Seperator symbol between LinkButton controls in the LinkBar.
 *
 *  @default mx.skins.halo.LinkSeparator
 */
[Style(name="separatorSkin", type="Class", inherit="no")]

/**
 *  Separator pixel width, in pixels.
 *
 *  @default 1
 */
[Style(name="separatorWidth", type="Number", format="Length", inherit="yes")]

/**
 *  Text color of the link as you move the mouse pointer over it.
 *
 *  @default 0x2B333C
 */
[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Text color of the link as you press it.
 *
 *  @default 0x000000
 */
[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]

/**
 *  Number of pixels between children in the vertical direction.
 *
 *  @default 8
 */
[Style(name="verticalGap", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="horizontalLineScrollSize", kind="property")]
[Exclude(name="horizontalPageScrollSize", kind="property")]
[Exclude(name="horizontalScrollBar", kind="property")]
[Exclude(name="horizontalScrollPolicy", kind="property")]
[Exclude(name="horizontalScrollPosition", kind="property")]
[Exclude(name="maxHorizontalScrollPosition", kind="property")]
[Exclude(name="maxVerticalScrollPosition", kind="property")]
[Exclude(name="verticalLineScrollSize", kind="property")]
[Exclude(name="verticalPageScrollSize", kind="property")]
[Exclude(name="verticalScrollBar", kind="property")]
[Exclude(name="verticalScrollPolicy", kind="property")]
[Exclude(name="verticalScrollPosition", kind="property")]

[Exclude(name="scroll", kind="event")]
[Exclude(name="click", kind="event")]

[Exclude(name="horizontalScrollBarStyleName", kind="style")]
[Exclude(name="verticalScrollBarStyleName", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("dataProvider")]

[MaxChildren(0)]

/**
 *  PagingLinkBar
 *
 *  @includeExample LinkBarExample.mxml
 *
 *  @see mx.controls.NavBar
 *  @see mx.containers.ViewStack
 *  @see mx.controls.LinkButton
 *  @see mx.controls.ToggleButtonBar
 *  @see mx.controls.ButtonBar
 */

/**
 *  Custom component to display multiple pages with page indexes. 
 */
public class PagingLinkBar extends NavBar
{
    include "../core/Version.as";

    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function PagingLinkBar()
    {
        super();

        navItemFactory = new ClassFactory(LinkButton);

        addEventListener(MouseEvent.CLICK, defaultClickHandler);
        addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);

        //height = 19;
    }

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const SEPARATOR_NAME:String = "_separator";

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Flag to specify whether to enable previous 10 buttons.
     */
    private var prevEnabled:Boolean;

    /**
     *  @private
     *  Flag to specify whether to enable next 20 buttons.
     */
    private var nextEnabled:Boolean;

    /**
     *  @private
     *  Flag to specify whether to enable the first button.
     */
    private var startEnabled:Boolean;

    /**
     *  @private
     *   Flag to specify whether to enable the last button.
     */
    private var endEnabled:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------
    //  totalCount
    //------------------------------

    /**
     *  @private
     *  Total count of listings.
     */
    private var _totalCount:uint = 1;

    /**
     *  @private
     */
    private var totalCountChanged:Boolean = false;

    [Bindable("totalCountChanged")]

    /**
     *   Total count of listings.
     */
    public function get totalCount():uint
    {
        return _totalCount;
    }

    /**
     *  @private
     */
    public function set totalCount(value:uint):void
    {
        if (value < 1)
        {
            value = 1;
        }

        if (_totalCount != value)
        {
            _totalCount = value;

            totalCountChanged = true;

            createPageNumbers();
        }
    }

    //------------------------------
    //  currentPage
    //------------------------------

    /**
     *  @private
     *  Property to store the current page index. 
     */
    private var _currentPage:uint = 1;

    /**
     *  @private
     */
    private var currentPageChanged:Boolean = false;

    [Bindable("currentPageChanged")]

    /**
     *  Property to store the current page index. 
     */
    public function get currentPage():uint
    {
        return _currentPage;
    }

    /**
     *  @private
     */
    public function set currentPage(value:uint):void
    {
        if (value < 1)
        {
            value = 1;
        }

        if (_currentPage != value)
        {

            _currentPage = value;

            currentPageChanged = true;

            createPageNumbers();
        }
    }

    //------------------------------
    //  oldPage
    //------------------------------

    /**
     *  @private
     *  Storage for the oldPage property.
     */
    private var oldPage:uint = 1;

    //------------------------------
    //  numPages
    //------------------------------

    /**
     *  @private
     *  Property to specify how many pages to show.
     */
    private var _numPages:uint = 10;

    /**
     *  @private
     */
    private var numPagesChanged:Boolean = false;

    [Bindable("numPagesChanged")]

    /**
     *  Property to specify how many pages to show.
     *
     *  @default 10
     */
    public function get numPages():uint
    {
        return _numPages;
    }

    /**
     *  @private
     */
    public function set numPages(value:uint):void
    {
        if (_numPages != value)
        {
            _numPages = Math.max(1, value);
            numPagesChanged = true;

            // if fetchSize changes,
            // we need to store the value of currentPage * fetchSize
            // and after calling createPageNumbers()
            // we recalculate currentPage value.
            createPageNumbers();
        }
    }

    //------------------------------
    //  fetchSize
    //------------------------------

    /**
     *  @private
     *  Row count.
     */
    private var _fetchSize:uint = 10;

    /**
     *  @private
     */
    private var fetchSizeChanged:Boolean = false;

    [Bindable("fetchSizeChanged")]

    /**
     *  Row count.
     *
     *  @default 10
     */
    public function get fetchSize():uint
    {
        return _fetchSize;
    }

    /**
     *  @private
     */
    public function set fetchSize(value:uint):void
    {
        if (_fetchSize != value)
        {
            var total:Number = _fetchSize * _currentPage;
            _currentPage = Math.ceil(total / value);
            _fetchSize = value;
            fetchSizeChanged = true;

            // if fetchSize changes,
            // we need to store the value of currentPage * fetchSize
            // and after calling createPageNumbers()
            // we recalculate currentPage value.
            createPageNumbers();
        }
    }

    //------------------------------
    //  totalPage
    //------------------------------

    /**
     *  @private
     *  Storage for the totalPage property.
     */
    private var _totalPage:uint;

    /**
     *  Number of Total Page.
     */
    public function get totalPage():uint
    {
        return _totalPage;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        totalCountChanged = true;
        createPageNumbers();
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (totalCountChanged ||
            currentPageChanged ||
            fetchSizeChanged ||
            numPagesChanged)
        {
            totalCountChanged = false;
            currentPageChanged = false;
            fetchSizeChanged = false;
            numPagesChanged = false;

            // +2 is for << an <
            //@@ 2007-09-11
            // Fixed to allow to change the number of buttons currently shown.
            var hilitedIndex:int = ((_currentPage - 1) % _numPages) + 2;

            hiliteSelectedNavItem(hilitedIndex);

            adjustNavButtons();
        }
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        // The super method will lay out the Links.
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var vm:EdgeMetrics = viewMetricsAndPadding;

        var horizontalGap:Number = getStyle("horizontalGap");
        var verticalGap:Number = getStyle("verticalGap");

        var separatorHeight:Number = unscaledHeight - (vm.top + vm.bottom);
        var separatorWidth:Number = unscaledWidth - (vm.left + vm.right);

        // Lay out the separators.
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:IFlexDisplayObject = IFlexDisplayObject(getChildAt(i));

            var separator:IFlexDisplayObject = IFlexDisplayObject(rawChildren.getChildByName(SEPARATOR_NAME + i));

            if (separator)
            {
                separator.visible = false;

                // The 0th separator is to the left of the first link.
                // It should always be invisible, and doesn't need
                // to be laid out.
                if (i == 0)
                    continue;

                if (isVertical())
                {
                    separator.move(vm.left, child.y - verticalGap);
                    separator.setActualSize(separatorWidth, verticalGap);

                    // The separators don't get clipped.
                    // (In general, chrome elements
                    // don't get automatically clipped.)
                    // So show a separator only if it is completely visible.
                    if (separator.y + separator.height <
                        unscaledHeight - vm.bottom)
                    {
                        separator.visible = true;
                    }
                }
                else
                {
                    separator.move(child.x - horizontalGap, vm.top);
                    separator.setActualSize(horizontalGap, separatorHeight);

                    if (separator.x + separator.width <
                        unscaledWidth - vm.right)
                    {
                        separator.visible = true;
                    }
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: NavBar
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createNavItem(
                                        label:String,
                                        icon:Class = null):IFlexDisplayObject
    {

        // Create the new LinkButton.

        var newLink:mx.controls.Button = mx.controls.Button(navItemFactory.newInstance());

        if (label && label.length > 0)
        {
            newLink.label = label;
        }
        else
        {
            newLink.label = " ";
        }

        if (icon)
        {
            newLink.label = "";
            newLink.setStyle("icon", icon);
        }

        newLink.styleName = getStyle("buttonStyleName");

        addChild(newLink);

        newLink.addEventListener(MouseEvent.CLICK, clickHandler);

        // Create the new separator to the left of the LinkButton.
        var separatorClass:Class = Class(getStyle("separatorSkin"));

        if (separatorClass)
        {
            var separator:DisplayObject = DisplayObject(new separatorClass());

            separator.name = SEPARATOR_NAME + (numChildren - 1);
            if (separator is ISimpleStyleClient)
                ISimpleStyleClient(separator).styleName = this;

            rawChildren.addChild(separator);
        }

        return newLink;
    }

    /**
     *  @private
     */
    override protected function hiliteSelectedNavItem(index:int):void
    {
        super.selectedIndex = index;

        var child:mx.controls.Button = mx.controls.Button(getChildAt(selectedIndex));

        // set selectedButton style
        child.styleName = getStyle("selectedButtonStyleName");
    }

    /**
     *  @private
     */
    override protected function resetNavItems():void
    {
        // Reset the index values and selection state.
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:mx.controls.Button = mx.controls.Button(getChildAt(i));
            child.enabled = !(i == selectedIndex);
        }

        invalidateDisplayList();
    }


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function adjustNavButtons():void
    {
        var link:mx.controls.Button = mx.controls.Button(getChildAt(0));
        //link.toolTip = "first";
        link.enabled = startEnabled;

        link = mx.controls.Button(getChildAt(1));
        //link.toolTip = "prev";
        link.enabled = prevEnabled;

        link = mx.controls.Button(getChildAt(numChildren - 2));
        //link.toolTip = "next";
        link.enabled = nextEnabled;

        link = mx.controls.Button(getChildAt(numChildren - 1));
        //link.toolTip = "last";
        link.enabled = endEnabled;
    }

    /**
     *  @private
     */
    private function createPageNumbers():void
    {
		_totalPage = Math.ceil(_totalCount / _fetchSize);

        if (_currentPage > _totalPage)
        {
            _currentPage = _totalPage;
        }

		
        var prev:Number = _currentPage - (((_currentPage - 1) % _numPages) + 1);

        var next:Number = prev + _numPages + 1;

        prevEnabled = prev > 0;
        nextEnabled = _totalPage >= next;
        startEnabled = currentPage != 1;
        endEnabled = currentPage != _totalPage;

        var arr:Array = new Array();

        arr.push({label:"<<", data:1, toolTip:"처음", icon:getStyle("firstIcon")});
        arr.push({label:"<", data:prev, toolTip:"이전", icon:getStyle("prevIcon")});

        for (var i:int = 1 + prev; i < next && i <= totalPage; i++)
        {
            arr.push({label:i, data:i});
        }

        arr.push({label:">", data:next, toolTip:"다음", icon:getStyle("nextIcon")});
        arr.push({label:">>", data:_totalPage, toolTip:"끝", icon:getStyle("lastIcon")});

        dataProvider = arr;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function childRemoveHandler(event:ChildExistenceChangedEvent):void
    {
        var child:DisplayObject = event.relatedObject;
        var index:int = getChildIndex(child);
        var separator:DisplayObject =
            rawChildren.getChildByName(SEPARATOR_NAME + index);
        rawChildren.removeChild(separator);

        // Shuffle the separators down.
        var n:int = numChildren - 1;
        for (var i:int = index; i < n; i++)
        {
            rawChildren.getChildByName(SEPARATOR_NAME + (i + 1)).name =
                SEPARATOR_NAME + i;
        }
    }

    /**
     *  @private
     */
    private function defaultClickHandler(event:MouseEvent):void
    {
        // We do not want to propagate a MouseEvent.CLICK event up.
        if (!(event is ItemClickEvent))
        {
            event.stopImmediatePropagation();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: NavBar
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function clickHandler(event:MouseEvent):void
    {
        item_clickHandler(event);
    }

    /**
     *  @private
     */
    private function item_clickHandler(event:MouseEvent):void
    {
        if (selectedIndex > -1)
        {
            oldPage = uint(dataProvider[selectedIndex].data);
        }

        var currentLabel:String = event.currentTarget.label;
        var newPage:uint;

        var tip:String = event.currentTarget.toolTip;

        switch (tip)
        {
            case "<":
            case "이전":
                newPage = dataProvider[1].data;
                break;

            case ">":
            case "다음":
                newPage = dataProvider[dataProvider.length - 2].data;
                break;

            case "<<":
            case "처음":
                newPage = dataProvider[0].data;//1;
                break;

            case ">>":
            case "끝":
                newPage = dataProvider[dataProvider.length - 1].data;
                break;

            default:
                newPage = uint(event.currentTarget.label);
                break;
        }

        var e:PagingEvent = new PagingEvent(PagingEvent.PAGE_CLICK);
        e.oldPage = oldPage;
        e.newPage = newPage;
        currentPage = newPage;
        dispatchEvent(e);
    }

}

}
