package com.goodlife
{
	[RemoteClass(alias="com.goodlife.BILLING")]

	[Bindable]
	public class BILLING
	{

		public var CLIENTID:Number = 0;
		public var NAME:String = "";
		public var ADDRESS:String = "";
		public var ADDRESS2:String = "";
		public var CITY:String = "";
		public var STATE:String = "";
		public var ZIP:String = "";
		public var CARDNUMBER:String = "";
		public var EXPIRATION:String = "";
		public var BANK_NAME:String = "";
		public var ACCOUNT_NUMBER:String = "";
		public var ROUTING_NUMBER:String = "";
		public var NOTES:String = "";
		public var INITIAL_BILLING:Date = null;
		public var NEXT_BILLING:Date = null;
		public var LAST_BILLING:Date = null;
		public var AUTH_STATUS:String = "";
		public var AUTH_SEQUENCE:String = "";
		public var AUTH_MESSAGE:String = "";
		public var AUTH_BATCH:String = "";
		public var BILLING_AMOUNT:Number = 0;
		public var RPS_FLAG:String = "";
		public var IPR_FLAG:String = "";
		public var AUTH_CODE:String = "";
		public var CARD_ATTEMPTS:Number = 0;
		public var DATE_ENTERED:Date = null;
		public var PAYTYPE:String = "";
		public var ACCOUNT_TYPE:String = "";
		public var AGENTID:Number = 0;
		public var INITIAL_FLAG:String = "";
		public var PROGRAM_TYPE:String = "";
		public var SECURITY_CODE:String = "";
		public var START_FEE:Number = 0;
		public var BDOM:Number = 0;
		public var ECARDNUMBER:String = "";
		public var BALANCE:Number = 0;


		public function BILLING()
		{
		}

	}
}