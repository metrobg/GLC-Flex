package com.goodlife.Events
{
	import flash.events.Event;
    import mx.utils.ObjectUtil;
    
	public class LoginCompleteEvent extends Event
	{
		public var userData:Object;
		public static var COMPLETE:String = "loggedin";
		
		public function LoginCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
		public function setData(value:Object):void {
			userData = new Object();
			this.userData =  ObjectUtil.copy(value);
		}
	}
}
