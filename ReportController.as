// ActionScript file

import com.metrobg.Icons.Images;
import mx.collections.ArrayCollection;

public var defaultReportDates:String;
private var today:Date = new Date();
private var PDFBase:String = "http://dbase.metrobg.com/GLC/";
private var reportArray:Array;

[Bindable]
private var reportAC:ArrayCollection;

private function init():void {
	reportAC = new ArrayCollection;
	fromDate_df.text = ""
	toDate_df.text = ""

	defaultReportDates = fromDate_df.text;
	reportArray = new Array;




}


private function runReport(val:Number):void {

}

private function resetStates():void {

}

private function addState():void {

}

private function reportSelected(event:Event):void {

	parentDocument.stateSelector_cb.visible = false;
	parentDocument.t1.visible = false;
	reset_btn.visible = false;


	ShowHideReportDateFields(report_cb.selectedItem.datefields);

	ros.visible = report_cb.selectedItem.options;
	parentDocument.ta1.text += "sort visible :" + report_cb.selectedItem.options3 + "\n";
	ros.options2.visible = report_cb.selectedItem.options2;
	ros.options1.visible = report_cb.selectedItem.options1;
	ros.options3.visible = report_cb.selectedItem.options3;

	/* so manager 2 can't access reports with dollar totals */
	if (Number(parentDocument.txtROLE) == 5) {
		ros.DisplayAmounts.enabled = false;
	}

	ros.agentSel.setAgent = 0; // set the agent selector to all agents (code 0)
	if (report_cb.selectedItem.xoptions) {
		parentDocument.stateSelector_cb.visible = true;
		parentDocument.t1.visible = true;
		reset_btn.visible = true;
	}
	// added 09/22/2008
	if (report_cb.selectedItem.value == 3) { // delinquent client report requires no date
		fromDate_df.text = defaultReportDates;
		toDate_df.text = defaultReportDates;
	}
}

private function ShowHideReportDateFields(status:String):void {
	if (status == "H") {
		fromDate_df.visible = false;
		toDate_df.visible = false;
		label13.visible = false;
		label14.visible = false
	}
	if (status == "S") {
		fromDate_df.visible = true;
		toDate_df.visible = true;
		label13.visible = true;
		label14.visible = true
	}
}

