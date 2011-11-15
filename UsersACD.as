// ActionScript file
// ActionScript file

// AgentMaintenance.mxml


import com.ace.DBTools;
import com.ace.Input.Utilities;
import com.goodlife.USERS;
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
private var user:USERS;
private var dbTools:DBTools;

private function init():void {
	dbTools = new DBTools();
	SECURITY.dataProvider = new ArrayCollection([
					{DATA: 0, LABEL: "Select"}, 
					{DATA: 9, LABEL: "Administrator"}, 
					{DATA: 7, LABEL: "Manager 1"}, 
					{DATA: 5, LABEL: "Manager 2"}, 
					{DATA: 3, LABEL: "Staff"}, 
					{DATA: 1, LABEL: "User"}]);

	SECURITY.dataField = "DATA";
	SECURITY.labelField = "LABEL";
}


private function makeAgentRecord(vagent:USERS):void {
	user = new USERS();
	user = vagent;
}

private function onServiceDataReady(event:ResultEvent):void {
	var act:Object = event.token;
	switch (act.message.operation) {
		case "getAllUsers":
			if (act.result.length > 0) {
				acGeneral = new ArrayCollection(act.result);
				dgUsers.dataProvider = acGeneral;
			}
			if (act.result.length == 1) {
				makeAgentRecord(act.result[0]);
			}
			if (act.result.length == 0) {
				Alert.show("No matches found", "No Matches",0, this, null, Images.warningIcon2);
			}
			break;
		case "saveUser":
			if (act.result is USERS) {
				Alert.show("Record Saved", "Success",0, this, null, Images.okIcon);
				acGeneral.addItem(user);
				sortRecords();				
				user = null;
			} else {
				Alert.show("Error", "Database Error",0, this, null, Images.stopIcon);
			}
			//gateway.getAllAgents();
			break;
		case "deleteUserById":
			if (act.result == 0) {
				user = null;
				acGeneral.removeItemAt(dgUsers.selectedIndex);
				acGeneral.refresh();
			} else {
				Alert.show("Problem Deleteing Record", "Database Error",0, this, null, Images.stopIcon);  
			}
			break;
	}
}

private function gridItemSelected(event:ListEvent):void {
	if (dgUsers.selectedIndex >= 0) {
		makeAgentRecord(dgUsers.selectedItem as USERS);
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
				user.FNAME = FNAME.text;
				user.LNAME = LNAME.text;
				user.USERNAME = USERNAME.text;
				user.PASSWORD = PASSWORD.text;
				user.SECURITY = SECURITY.selectedItem.DATA;
				user.ROLE = SECURITY.selectedLabel;
				gateway.saveUser(user);
			} else {
				Alert.show("Please correct fields outlined in Red", "Incomplete");
			}
			break;
		case "Add":
			user = new USERS();
			user.ID = 0;
			USERNAME.setFocus();
			break;
		case 'Delete':
			if (user.ID == 0) {
				Alert.show("This record can't be deleted", "Error", 0, this, null, Images.stopIcon);
			} else {
				Alert.show("Delete User " + user.FNAME + " " + user.LNAME, "Really Delete", 3, this, deleteUserHandler, Images.warningIcon2);
				break;
			}
	}

}


private function deleteUserHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		gateway.deleteUserById(user.ID);
	} else {
		return;
	}

}

private function sortRecords():void {
	var sf:SortField = new SortField();
	sf.name = "USERNAME";
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