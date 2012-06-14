// ActionScript file
// ActionScript file

// AgentMaintenance.mxml


import com.ace.DBTools;
import com.ace.Input.Utilities;
import com.goodlife.AGENT;
import com.metrobg.Icons.Images;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.events.*;

[Bindable]
public var acGeneral:ArrayCollection = new ArrayCollection;

[Bindable]
private var agent:AGENT;
private var dbTools:DBTools;

private function init():void {
	dbTools = new DBTools();
	ACTIVE.labelField = "LABEL";
	COMPANY.labelField = "LABEL";
	 
	
	COMPANY.dataProvider = parentApplication.acAgencies;
	ACTIVE.dataProvider = new ArrayCollection([{DATA: "", LABEL: "Select"}, 
											   {DATA: "Y", LABEL: "Active"}, 
											   {DATA: "N", LABEL: "Inactive"}]);
}


private function makeAgentRecord(vagent:AGENT):void {
	agent = new AGENT();
	agent = vagent;
}

private function onServiceDataReady(event:ResultEvent):void {
	var act:Object = event.token;
	switch (act.message.operation) {
		case "getAgentById":


			break;
		case "getAllAgents":
			if (act.result.length > 0) {


				acGeneral = new ArrayCollection(act.result);
				dgAgents.dataProvider = acGeneral;

			}
			if (act.result.length == 1) {
				makeAgentRecord(act.result[0]);
			}
			if (act.result.length == 0) {
				Alert.show("No matches found", "No Matches",0, this, null, Images.warningIcon2);
			}
			break;
		case "saveAgent":
			if (act.result is AGENT) {
				Alert.show("Record Saved", "Success",0, this, null, Images.okIcon);
			} else {
				Alert.show("Error", "Database Error",0, this, null, Images.stopIcon);
			}
			//gateway.getAllAgents();
			break;
		case "deleteAgentById":
			if (act.result == 0) {
				agent = null;
				acGeneral.removeItemAt(dgAgents.selectedIndex);
				acGeneral.refresh();
			} else {
				Alert.show("Problem Deleteing Record", "Database Error",0, this, null, Images.stopIcon);  
			}
			break;
	}
}

private function gridItemSelected(event:ListEvent):void {
	if (dgAgents.selectedIndex >= 0) {
		makeAgentRecord(dgAgents.selectedItem as AGENT);
		btn_delete.enabled = true;
	}
}


private function buttonHandler(event:MouseEvent):void {

	switch (event.target.label) {
		case "Save":
			if (Utilities.validateAll(form1)) {
				agent.FNAME = FNAME.text;
				agent.LNAME = LNAME.text;
				agent.COMPANY = COMPANY.selectedItem.DATA;
				agent.ACTIVE = ACTIVE.selectedItem.DATA;
				gateway.saveAgent(agent);
			} else {
				Alert.show("Please correct fields outlined in Red", "Incomplete");
			}
			break;
		case "Add":
			agent = new AGENT();
			agent.AGENTID = 0;
			FNAME.setFocus();
			break;
		case 'Delete':
			if (agent.AGENTID == 0) {
				Alert.show("This record can't be deleted", "Error", 0, this, null, Images.stopIcon);
			} else {
				Alert.show("Delete Agent " + agent.FNAME + " " + agent.LNAME, "Really Delete", 3, this, deleteAgentHandler, Images.warningIcon2);
				break;
			}
	}

}


private function deleteAgentHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		gateway.deleteAgentById(agent.AGENTID);
	} else {
		return;
	}

}


private function onServiceFault(event:FaultEvent):void {
	CursorManager.removeBusyCursor();
	var act:Object = event.token;
	Alert.show(event.fault.faultString, 'Error');
}