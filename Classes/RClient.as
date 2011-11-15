//package admin.client
package com.metrobg.Classes
{
  

[Bindable]
[RemoteClass(alias="flex.admin.client.Client")]

	public class RClient
	{ 

public var account_type:String;
public var active:String;
public var activeVerbage:String = '';
public var address2:String;
public var address:String;                        
public var agentID:Number;
public var agentname:String;
public var alt_contact:String;
public var attempts:String;
public var balance:Number;
public var city:String;
public var clientID:Number;
public var csz:String;
public var dob:String;
public var email:String;
public var expiryMonth:String; 
public var expiryYear:String;  
public var fname:String;
public var initial_billing:String;
public var last_billed:String;
public var lname:String;
public var name:String;
public var next_billing:String;
public var phone:String;
public var reportDate:String; 
public var reportIn:String;
public var signup:String;
public var source:Number;
public var sourceVerbage:String;
public var ssn:String;
public var state:String;
public var zip:String;
public var aid:Number;

	  public function RClient()
	    {
	    	
	    }
	 
	/*	public function RClient(obj:Object=null,type:Number=2)
		{
			if (obj != null)
			{
				fill(obj,type);
			}
		}
*/
private function setStatus(value:String):void {
	  if (value == 'Y') {
	  	   this.activeVerbage = "Active";
	         } else {
	  	       this.activeVerbage = "Inactive";
	     }
}

public function clear():void 
		{
	 this.account_type = '';
	 this.active = '';
	 this.address = '';
	 this.address2 = '';			 
	 this.agentname = '';
	 this.agentID = 0;
	 this.alt_contact = '';
	 this.attempts = '';
	 this.balance = 0;
	 this.city = '';
	 this.clientID = 0;
	 this.csz = '';
	 this.dob = '';
	 this.email = '';
	 this.expiryMonth="00"; 
	 this.expiryYear="00"; 
	 this.fname = '';
	 this.initial_billing = '';
	 this.last_billed = '';
	 this.next_billing = '';
	 this.lname = '';
	 this.name = 'No Current Client';
	 this.phone = '';
	 this.reportDate = 'Not Received Yet'; 
	 this.reportIn = 'N';
	 this.signup = '';
	 this.source = 0;		
	 this.ssn = '';
	 this.state = '';
	 this.zip = '';
		}
		
		
/* public function fill(obj:Object,type:Number):void {
	if(type == 1) {
		 this.clientID = obj.lastResult.clients.client.clientID;
		 this.name = obj.lastResult.clients.client.name;
		 this.fname = obj.lastResult.clients.client.fname;
		 this.lname = obj.lastResult.clients.client.lname;
		 this.address = obj.lastResult.clients.client.address;
		 this.address2 = obj.lastResult.clients.client.address2;
		 this.city = obj.lastResult.clients.client.city;
	     this.state = obj.lastResult.clients.client.state;
	     this.zip = obj.lastResult.clients.client.zip;		
		 this.csz = obj.lastResult.clients.client.csz;
		 this.phone = obj.lastResult.clients.client.phone;
		 this.dob = obj.lastResult.clients.client.dob;
		 this.ssn = obj.lastResult.clients.client.ssn;
		 this.active = obj.lastResult.clients.client.active;
		 this.alt_contact = obj.lastResult.clients.client.phone2;
		 this.balance = obj.lastResult.clients.client.balance; 
		 this.last_billed = obj.lastResult.clients.client.last_billing;
		 this.next_billing = obj.lastResult.clients.client.next_billing;
		 this.signup = obj.lastResult.clients.client.signup;
		 this.agentname = obj.lastResult.clients.client.agentname; 
		 this.email = obj.lastResult.clients.client.email;
		 this.balance = obj.lastResult.clients.client.balance;
		 this.account_type = obj.lastResult.clients.client.account_type;
		 this.initial_billing = obj.lastResult.clients.client.initial_billing;
		 this.attempts = obj.lastResult.clients.client.attempts;
		 this.activeVerbage = obj.lastResult.clients.client.status;
		 this.agentid = obj.lastResult.clients.client.agentid;
		 this.expiryMonth = obj.lastResult.clients.client.expirymonth; 
	     this.expiryYear = obj.lastResult.clients.client.expiryyear; 
	     this.reportDate = obj.lastResult.clients.client.crreceipt;
	     this.reportIn = obj.lastResult.clients.client.crreport;
	     this.source = obj.lastResult.clients.client.source; 
	     if (reportIn == 'N') {
	     	this.reportDate = 'Not Received Yet'; 
	     }
	}   else if (type == 2) {
		 this.account_type = obj.account_type;
		this.active = obj.active;
		this.activeVerbage = obj.activeVerbage;
		this.address = obj.address;
		this.address2 = obj.address2;                            
		this.agentid = obj.agentid;
		this.agentname = obj.agentname; 
		this.alt_contact = obj.alt_contact;
		this.attempts = obj.attempts;
		this.balance = obj.balance;
		this.balance = obj.balance; 
		this.city = obj.city;
		this.clientID = obj.clientID;
		this.csz = obj.csz;
		this.dob = obj.dob;
		this.email = obj.email;
		this.expiryMonth = obj.expiryMonth; 
		this.expiryYear = obj.expiryYear; 
		this.fname = obj.fname;
		this.initial_billing = obj.initial_billing;
		this.last_billed = obj.last_billed;
		this.lname = obj.lname;
		this.name = obj.name; 
		this.next_billing = obj.next_billing;
		this.phone = obj.phone;
		this.signup = obj.signup;
		this.ssn = obj.ssn;
		this.state = obj.state;
		this.zip = obj.zip;

	    // this.report_date = obj.crreceipt_date;
	  //   this.reportIn = obj.crreceipt_date; 
	     //this.source = obj.source; 
	}   else if(type == 3) {
		 
		 this.name = obj.lastResult.clients.client.name;
		 this.fname = obj.lastResult.clients.client.fname;
		 this.lname = obj.lastResult.clients.client.lname;
		 this.address = obj.lastResult.clients.client.address;
		 this.address2 = obj.lastResult.clients.client.address2;
		 this.city = obj.lastResult.clients.client.city;
	     this.state = obj.lastResult.clients.client.state;
	     this.zip = obj.lastResult.clients.client.zip;		
		 this.csz = obj.lastResult.clients.client.csz;
		 this.phone = obj.lastResult.clients.client.phone;
		 this.alt_contact = obj.lastResult.clients.client.phone2;
		 this.email = obj.lastResult.clients.client.email;
		 this.ssn = obj.lastResult.clients.client.ssn;
		 this.dob = obj.lastResult.clients.client.dob;
		 this.activeVerbage = obj.lastResult.clients.client.status;
		 this.active = obj.lastResult.clients.client.active;
		 this.agentid = obj.lastResult.clients.client.agentid
		 this.expiryMonth = obj.lastResult.clients.client.expirymonth; 
	     this.expiryYear = obj.lastResult.clients.client.expiryyear;  
	     this.reportDate = obj.lastResult.clients.client.crreceipt;
	     this.reportIn = obj.lastResult.clients.client.crreport; 
	     this.source = obj.lastResult.clients.client.source; 
		 
		 
	} 
	      
	     
 } */  
	} 
}