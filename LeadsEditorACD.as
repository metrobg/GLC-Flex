// ActionScript file
// ActionScript file

// AgentMaintenance.mxml


import com.ace.DBTools;
import com.ace.Input.Utilities;
import com.idavenger.LEADS;
import com.metrobg.Icons.Images;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.events.*;

[Bindable]
public var acGeneral:ArrayCollection = new ArrayCollection;
private var acRoles:ArrayCollection = new ArrayCollection();

[Bindable]
private var lead:LEADS;
private var dbTools:DBTools;

private function init():void {
	dbTools = new DBTools();
	
}


private function makeLeadRecord(vagent:LEADS):void {
	lead = new LEADS();
	lead = vagent;
}

private function onServiceDataReady(event:ResultEvent):void {
	var act:Object = event.token;
	switch (act.message.operation) {
		case "getAllLeads":
			if (act.result.length > 0) {
				acGeneral = new ArrayCollection(act.result);
				dgLeads.dataProvider = acGeneral;
			}
			if (act.result.length == 1) {
				makeLeadRecord(act.result[0]);
			}
			if (act.result.length == 0) {
				Alert.show("No matches found", "No Matches",0, this, null, Images.warningIcon2);
			}
			break;
		case "saveLead":
			if (act.result is LEADS) {
				Alert.show("Record Saved", "Success",0, this, null, Images.okIcon);
				acGeneral.addItem(lead);
				sortRecords();				
				lead = null;
			} else {
				Alert.show("Error", "Database Error",0, this, null, Images.stopIcon);
			}
			//gateway.getAllAgents();
			break;
		case "deleteLeadById":
			if (act.result == 0) {
				lead = null;
				acGeneral.removeItemAt(dgLeads.selectedIndex);
				acGeneral.refresh();
			} else {
				Alert.show("Problem Deleteing Record", "Database Error",0, this, null, Images.stopIcon);  
			}
			break;
	}
}

private function gridItemSelected(event:ListEvent):void {
	if (dgLeads.selectedIndex >= 0) {
		makeLeadRecord(dgLeads.selectedItem as LEADS);
		btn_delete.enabled = true;
	}
}

private function nameLabel(item:Object, column:DataGridColumn):String {
	return item.FNAME + " " + item.LNAME;
}
private function buttonHandler(event:MouseEvent):void {

	switch (event.target.label) {
		case "Save":
			if (Utilities.validateAll(form1)) {
				lead.DESCRIPTION = DESCRIPTION.text;
				 
				gateway.saveLead(lead);
			} else {
				Alert.show("Please correct fields outlined in Red", "Incomplete");
			}
			break;
		case "Add":
			lead = new LEADS();
			lead.ID = 0;
			DESCRIPTION.setFocus();
			break;
		case 'Delete':
			if (lead.ID == 0) {
				Alert.show("This record can't be deleted", "Error", 0, this, null, Images.stopIcon);
			} else {
				Alert.show("Delete Lead " + lead.DESCRIPTION, "Really Delete", 3, this, deleteUserHandler, Images.warningIcon2);
				break;
			}
	}

}


private function deleteUserHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		gateway.deleteLeadById(lead.ID);
	} else {
		return;
	}

}

private function sortRecords():void {
	var sf:SortField = new SortField();
	sf.name = "DESCRIPTION";
	sf.numeric = false;
	 
	
	var srt:Sort = new Sort();
	srt.fields = [sf];
	acGeneral.sort = srt;
	acGeneral.refresh();
}

private function onServiceFault(event:FaultEvent):void {
	CursorManager.removeBusyCursor();
	var act:Object = event.token;
	Alert.show(event.fault.faultString, 'Error');
}