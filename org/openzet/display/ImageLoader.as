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
package org.openzet.display {	
	
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;

import mx.core.SpriteAsset;   

/**  
 * ImageLoader extends Sprite to add source as its child display object.
 *   
 */  
public class ImageLoader extends Sprite   
{    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 **/
    public function ImageLoader() {   
        super();   
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	  
    /**
    * @private 
    * Child display object
    **/
    protected var child:DisplayObject;   
    
    /**
    * @private
    * Internal Loader instance.
    **/
    private var loader:Loader;  
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    /**
    * @private
    */
    private var _source:Object;   
   
       
     /**
    * @private
    */
    public function set source(value:Object):void {   
        _source = value;   
        
        if (child && this.contains(child)) {   
            this.removeChild(child);   
        }   
        if (loader && this.contains(loader)) {   
            this.removeChild(loader);   
        }   
        if (value is Class) {   
            var img:* = new value();
 
            if (!(img is InteractiveObject))
            {
                var wrapper:SpriteAsset = new SpriteAsset();
                wrapper.addChild(img as DisplayObject);
                child = wrapper as DisplayObject;
            } else {
            	child = img;
            }
            
            child.addEventListener(Event.ADDED_TO_STAGE, completeHandler, false, 0, true);
           	addChild(child);
        } else if (value is String) {   
            var loader:Loader = new Loader();   
            loader.load(new URLRequest(value.toString()));   
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);   
            addChild(loader);   
        }    
    }    
      
    /**  
     * Target source to be added. For the value of this property, you can assign an image class or a
     * simple string value specifying the image's location.
     **/  
    public function get source():Object {   
        return _source;   
    }   
    
    /**  
     * Content of this ImageLoader whether it is a display object or something else. 
     **/  
    public function get content():* {   
        return child;   
    }   
    
    /**
    * @private
    */
    private var _contentWidth:Number;   
    
     /**
    * @private
    */
    public function set contentWidth(value:Number):void {   
        _contentWidth = value;   
        if (child) child.width = value;   
        if (loader) loader.loaderInfo.content.width = value;    
    }   
     /**
    * Width of the content. 
    */
    public function get contentWidth():Number {   
		return _contentWidth;
    } 
      
     /**
    * @private
    */
    private var _contentHeight:Number;   
    
     /**
    * @private
    */ 
    public function set contentHeight(value:Number):void {   
        _contentHeight = value;   
        if (child) child.height = value;   
        if (loader) loader.loaderInfo.content.height = value;   
    }   
    
     /**
    * Height of the content. 
    */
    public function get contentHeight():Number { 
        return _contentHeight;   
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * Clears drawing.
	 **/
	public function clear():void {
		this.graphics.clear();
	}
	
	/**
	 * Sets content's width and height.
	 **/
	protected function measure(target:Object):void {   
        if (!isNaN(contentWidth)) target.width = contentWidth;   
        if (!isNaN(contentHeight)) target.height = contentHeight;   
    }  
	//--------------------------------------------------------------------------------
    //
    //   Event Handlers
    //
    //--------------------------------------------------------------------------------
   
    /**
    * @private
    * 
    * Internal event handler to initalize added content. 
    **/
    protected function completeHandler(event:Event):void {   
        if (event.currentTarget is Loader) {
            event.currentTarget.removeEventListener(Event.COMPLETE,completeHandler);   
            measure(event.currentTarget.content);   
        } else {
        	event.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, completeHandler);
        	measure(event.currentTarget);
        }
    }   
}   
}
