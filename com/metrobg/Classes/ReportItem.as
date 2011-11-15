package com.metrobg.Classes
{
    import mx.events.IndexChangedEvent;
    import mx.core.IUID;

    [Bindable]
    public class ReportItem implements IUID
    {
        public var id:Number;

        public var url:String;

        public var label:String;

        public var value:Number;

        public var security:Number;

        public var datefields:String;

        public var options:Boolean;

        public var options1:Boolean;

        public var options2:Boolean;

        public var options3:Boolean;

        public var xoptions:Boolean;

        public function ReportItem()
        {
        }

        public function get uid():String
        {
            return id.toString();
        }

        public function set uid(value:String):void
        {
            this.id = Number(value);
        }

        public function fill(obj:Object):void
        {
            this.id = Number(obj.VALUE)
            this.url = obj.URL;
            this.label = obj.LABEL;
            this.value = Number(obj.VALUE);
            this.security = obj.SECURITY;
            this.datefields = obj.DATEFIELDS;
            options = (obj.OPTIONS == "true" ? true : false);
            options1 = (obj.OPTIONS1 == "true" ? true : false);
            options2 = (obj.OPTIONS2 == "true" ? true : false);
            options3 = (obj.OPTIONS3 == "true" ? true : false);
            xoptions = (obj.XOPTIONS == "true" ? true : false);
        /*
           this.options =  Boolean(obj.OPTIONS);
           this.options1 =  Boolean(obj.OPTIONS1);
           this.options2 =  Boolean(obj.OPTIONS2);
           this.options3 =  Boolean(obj.OPTIONS3);
           this.xoptions =  Boolean(obj.XOPTIONS);
         */
        }
    }
}