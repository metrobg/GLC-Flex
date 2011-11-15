// ActionScript file


import com.goodlife.BILLING;
import com.goodlife.CLIENT;
import com.metrobg.Icons.Images;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ItemClickEvent;
import mx.events.MenuEvent;
import mx.managers.CursorManager;
import mx.rpc.events.*;
import mx.styles.StyleManager;

[Bindable] public var acReferral:ArrayCollection=new ArrayCollection();
[Bindable] public var acAgent:ArrayCollection=new ArrayCollection();
[Bindable] public var acNotes:ArrayCollection=new ArrayCollection();

public var currentClient:Number = 0;

[Bindable] private var client:CLIENT;
[Bindable] private var billing:BILLING;

private var _strCurrentStyle:String="";

[Bindable] private var searchAC:ArrayCollection;
private var searchArray:Array = new Array('Search History');

private function clientLookup():void
{
//	var id:String=txtSearch.text;
	if (id.length > 2)
	{
		//service.getClientById(id);
		gateway.get(id);
	//	updateSearchHistory();
	}
	else
	{

		Alert.show("Search field requires at least 3 characters", "Error");
		return;
	}
}

[Bindable]
public var acAgents:ArrayCollection=new ArrayCollection();

public function init():void
{
	//ClientWindow.setSize(650, 525)
	//ClientWindow.showMaxButton=false;
	
	cbx_source.dataField="DATA";
	cbx_source.labelField="LABEL"
	
	searchAC = new ArrayCollection;
	searchAC.source = searchArray;
	
	service.getLeads();
	service.getAgents();
	
	 
	
	changeCSS("Styles/PlainStyles/GMSBlue.swf")
	gateway.get(1353);
	//service.getClientById(1353);
}



private function setReferrer():void {
	
	    clientSource.text = cbx_source.selectedItem.LABEL;
	   status= cbx_status.selectedItem.label + " Client: " + client.CLIENTID;
}

private function setAgent():void {		    
	    clientRep.text = cbx_agent.selectedItem.LABEL;	     
}
	
public function onServiceDataReady(event:ResultEvent):void
{
	var act:Object=event.token;
	switch (act.message.operation)
	{
		case "get":
		if(act.result.CLIENTID != "null") {
			client = new CLIENT();
			client = event.result as CLIENT;	
			currentClient = client.CLIENTID;
				clientName.text=client.FNAME + " " + client.LNAME;
				clientAddress.text=client.ADDRESS;
				clientAddress2.text=client.CITY + ", " + client.STATE + " " + client.ZIP;

				if (String(client.ADDRESS2) != "null")
				{
					clientAddress.text+="  " + client.ADDRESS2;
				}
				//trace("address 2 lenght is: " + String(client.ADDRESS2).length);

				clientPhone.text=pf.format(client.PHONE);
				clientPhone2.text=pf.format(client.PHONE2);
				clientDOB.text=df1.format(client.DOB);
				clientSSN.text=client.SSN;

				cbx_source.value=client.SOURCE;
								
				clientEmail.label=client.EMAIL;
			//	clientRep.text = client.VAGENT;
				service.getHistory(client.CLIENTID);
				callLater(setReferrer);
				gateway1.getById(client.CLIENTID); 
					
			break;
		}  else {
			Alert.show("Record Not Found", "NIF");
			return;
		}
		case "getLeads":
			acReferral=event.result as ArrayCollection;
			acReferral.addItemAt({LABEL: "Unknown", DATA: 0}, 0);
			clientSource.text = acReferral.getItemAt(0).LABEL;
			
			break;
		case "getAgents":
			acAgents=event.result as ArrayCollection;
			acAgents.addItemAt({LABEL: "Unknown", DATA: 0}, 0);
			cbx_agent.dataProvider = acAgents;
			//clientSource.text = acReferral.getItemAt(0).LABEL;
			
			break;
		case "getHistory":
		    if (event.result.length > 0) {
			    dgHistory.dataProvider=event.result as ArrayCollection;
			   }
			break;
		case "getById":
		      if(act.result.CLIENTID != null) {
		      	billing = new BILLING();
				billing = event.result as BILLING;
				callLater(setAgent);
		      	return;
		      }
		
		
			break;
		case "getClientById":
			if (event.result.length > 0)
			{
				currentClient = act.result[0].CLIENTID;
				clientName.text=act.result[0].FNAME + " " + act.result[0].LNAME;
				clientAddress.text=act.result[0].ADDRESS;
				clientAddress2.text=act.result[0].CITY + ", " + act.result[0].STATE + " " + act.result[0].ZIP;

				if (String(act.result[0].ADDRESS2) != "null")
				{
					clientAddress.text+="  " + act.result[0].ADDRESS2;
				}
				//trace("address 2 lenght is: " + String(act.result[0].ADDRESS2).length);

				clientPhone.text=act.result[0].PHONE;
				clientPhone2.text=act.result[0].PHONE2;
				clientDOB.text=act.result[0].DOB;
				clientSSN.text=act.result[0].SSN;

				cbx_source.value=act.result[0].SOURCE;

				clientSource.text=act.result[0].VSOURCE;
				status=act.result[0].VERBAGE + " Client: " + act.result[0].CLIENTID;
				clientInitial_Billing.text=act.result[0].INITIAL_BILLING;
				clientBalance.text=act.result[0].BALANCE + "  " + act.result[0].ACCOUNT_TYPE;
				clientLast_Billing.text=act.result[0].LAST_BILLING + " " + act.result[0].RPS_FLAG + " (" + act.result[0].CARD_ATTEMPTS + ")";
				clientNext_Billing.text=act.result[0].NEXT_BILLING;
				clientEmail.label=act.result[0].EMAIL;
				clientRep.text = act.result[0].VAGENT;
				service.getHistory(act.result[0].CLIENTID);
				 
			}
			else
			{
				Alert.show("Record Not Found", "NIF");
			}
			break;
		case "getClientRecord":
		    currentClient = act.result[0].CLIENTID;
			clientPhone.text=act.result[0].PHONE;
			clientPhone2.text=act.result[0].PHONE2;
			clientDOB.text=act.result[0].DOB;
			clientSSN.text=act.result[0].SSN;

			cbx_source.value=act.result[0].SOURCE;

			clientSource.text=act.result[0].VSOURCE;
			status=act.result[0].VERBAGE + " Client: " + act.result[0].CLIENTID;
			clientInitial_Billing.text=act.result[0].INITIAL_BILLING;
			clientBalance.text=act.result[0].BALANCE + "  " + act.result[0].ACCOUNT_TYPE;
			clientLast_Billing.text=act.result[0].LAST_BILLING + " " + act.result[0].RPS_FLAG + " (" + act.result[0].CARD_ATTEMPTS + ")";
			clientNext_Billing.text=act.result[0].NEXT_BILLING;
			clientEmail.label=act.result[0].EMAIL;
			clientRep.text = act.result[0].VAGENT;
			service.getHistory(act.result[0].CLIENTID);

			break;
		case "getClientNotes":
			if (event.result.length > 0)
			{
				acNotes=event.result as ArrayCollection;
				dgNotes.dataProvider=acNotes;

			}
	}


/* if(act.message.operation == "getLeads") {
   acReferral = event.result as ArrayCollection;
   acReferral.addItemAt({LABEL:"-- Select --", DATA:0},0);
   } else if {
   dgHistory.dataProvider = event.result as ArrayCollection;
 } */
}

 public function goToEmail(emailStr:String):void {
         
         //see http://livedocs.macromedia.com/flex/2/langref/flash/net/URLRequest.html
          var emailURL:URLRequest = new URLRequest("mailto:" + emailStr );
          
          //see: http://livedocs.macromedia.com/flex/2/langref/flash/net/package.html#navigateToURL()
          navigateToURL(emailURL)
  
 }        

private function onServiceFault(event:FaultEvent):void
{
	// Or clock-cursor will spin forever (:
	CursorManager.removeBusyCursor();
	var act:Object=event.token;
	// Do your own error processing with event.fault.faultstring, etc...
	Alert.show(event.fault.faultString, 'Error');
}

private function getAgentsOk(event:ResultEvent):void
{
	//agentAC = getAgents.lastResult.agents.agent;

}

private function dataGridCurrencyFormat(item:Object, column:Object):String
{
	return cf.format(item[column.dataField]);
}



private function getResultOk(r:Number, event:Event):void
{
	var kount:Number=0;
	var returnCode:Number=0;
	switch (r)
	{
		case 1:
			clientName.text="";
			clientAddress.text="";
			clientPhone.text="";
	}
}


private function getClient_fault(evt:FaultEvent):void
{
	Alert.show(evt.message.toString(),"Error");

}

private function changeCSS(strName:String):void
{
	if (_strCurrentStyle.length > 0)
	{
		StyleManager.unloadStyleDeclarations(_strCurrentStyle, false);
	}
	_strCurrentStyle=strName;
	var styleEvent:IEventDispatcher=StyleManager.loadStyleDeclarations(strName, true);
}

public function menuItemSelected(event:MenuEvent):void
{

	var action:Number=Number(event.item.@index);

	switch (action)
	{
		case 50:
			changeCSS(event.item.@value + ".swf");
			break;
		default:
			Alert.show("Unknown menu selection", "Error");
	}

/* var action:String = "styles/" + event.item.@value;
 changeCSS(event.item.@value); */
}


private function CutPasteMode():void {
	

}

private function downloadMode():void {
	 
}

/*
   [Bindable]
   public var empList:Object;
   public var employeeRO:RemoteObject;

   public function useRemoteObject(intArg:int, strArg:String):void {
   employeeRO = new RemoteObject();
   employeeRO.destination = "SalaryManager";
   employeeRO.getList.addEventListener("result", getListResultHandler);
   employeeRO.addEventListener("fault", faultHandler);
   employeeRO.getList(deptComboBox.selectedItem.data);
   }

   public function getListResultHandler(event:ResultEvent):void {
   // Do something
   empList=event.result;
   }

   public function faultHandler (event:FaultEvent):void {
   // Deal with event.fault.faultString, etc.
   Alert.show(event.fault.faultString, 'Error');
   }

 */
