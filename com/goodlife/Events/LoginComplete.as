package com.goodlife.Events
{
	import flash.events.Event;

	public class LoginCompleteEvent extends Event
	{
		public var locationData:Object;
		public static var COMPLETE:String = "loggedin";
		
		public function LoginComplete(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
	}
}
