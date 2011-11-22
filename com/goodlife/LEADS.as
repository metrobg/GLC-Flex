package com.goodlife
{

    [RemoteClass(alias="com.goodlife.LEADS")]
    [Bindable]
    public class LEADS
    {
        public var ID:Number = 0;

        public var DESCRIPTION:String = "";

        public var POSITION:Number = 0;

        public var TRANSACTION_KEY:String = "";

        public function LEADS()
        {
        }
    }
}