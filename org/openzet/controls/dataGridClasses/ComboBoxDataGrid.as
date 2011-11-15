package org.openzet.controls.dataGridClasses
{
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.controls.DataGrid;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.FlexSprite;

public class ComboBoxDataGrid extends DataGrid
{
	//--------------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------------
	public function ComboBoxDataGrid()
	{
		super();
	}
	
	//--------------------------------------------------------------------------------
    //
    // Overridden Methods
    //
    //--------------------------------------------------------------------------------
	override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
	{
		var g:Graphics = indicator.graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill(); 
        indicator.x = x;
        indicator.y = y;
	}
	
	//--------------------------------------------------------------------------------
    //
    // Overridden Event Handlers
    //
    //--------------------------------------------------------------------------------
	override protected function mouseOverHandler(event:MouseEvent):void
	{
		var r:IListItemRenderer;
        var i:int;
        var j:int;
		var s:Sprite = Sprite(selectionLayer.getChildByName("itemSelection"));
		
		if(!s)
		{
			s = new FlexSprite();
            s.name = "itemSelection";
            s.mouseEnabled = false;
            selectionLayer.addChild(s);
		}
		
        //r = mouseEventToItemRenderer(event);
        var pt:Point = new Point(event.stageX, event.stageY);
        pt = globalToLocal(pt);
        if(pt.y <= header.height)
            return;
        
        for(i = 0; i < listItems.length; i++)
        {
            if(header && listItems[i][0])
            {
                if(listItems[i][0].y + listItems[i][0].height + header.height >= pt.y)
                {
                    break;
                }   
            }
        }
        
        if(i >= listItems.length)
        {
            return;
        }
        
        for(j = 0; j < listItems[i].length; j++)
        {
            if(listItems[i][j].x + listItems[i][j].width >= pt.x)
            {
                r = listItems[i][j];
                break;
            }
        }
        
        if(r)
        {
        	drawHighlightIndicator(s, r.x, r.y, r.width, r.height, getStyle("rollOverColor"), mouseEventToItemRenderer(event));
        }
	}
	
	override protected function mouseOutHandler(event:MouseEvent):void
	{
		super.mouseOutHandler(event);
		
        var s:Sprite = Sprite(selectionLayer.getChildByName("itemSelection"));
        if(s)
        {
            selectionLayer.removeChild(s);
        }		
	}
}
}