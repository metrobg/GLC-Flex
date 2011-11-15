package com.goodlife
{
	[RemoteClass(alias="com.goodlife.USERS")]

	[Bindable]
	public class USERS
	{

		public var ID:Number = 0;
		public var FNAME:String = "";
		public var LNAME:String = "";
		public var USERNAME:String = "";
		public var PASSWORD:String = "";
		public var SECURITY:Number = 0;
		public var ROLE:String = "";


		public function USERS()
		{
		}

	}
}