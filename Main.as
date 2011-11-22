// ActionScript file
/*
   1.1.3  added program version tracking
   1.1.4  Added cut / paste functionality and icon to app controll bar
   1.4.5  made ACB icons all 24x24
   modified app so that the 19 list can be generated prior to download
   1.1.6  modified report parameters. seperated range validation and error message
   to seperate functions.
   1.1.7  added login panel and the first module -- AgentsMaintenance
   along with user validation and display at the bottom of cancas1 (main panel)
   1.1.8  09/17/2007 added client edit screen. allowed notes panel to be used in the editPanel.
   set phone and ssn formatter on fields as required. set restrict property
   on fields as needed.
   1.1.9  added ability to update all fields of the client record. 09/18/2007
   1.2.0  9/23/04 Now able to edit both billing and client information.
   1.2.1  9/24/07 added validation to the client billing section
   1.2.2  9/29/07 - 09/29/2007 added form validation to the client edit screen.
   added new tool bar Icon (misc adjustments) to facilitate the process of
   changing the next billing date as well as adjusting the client balance.
   1.2.3  10/02/2007 added ability to reset the card attempts from the adjustment
   popup window.
   1.2.4   10/03/2007 Added Credit Card Processing window and modified the login panel
   to show additional information as well as terms of usage message
   1.2.5   10/07/2007 Added ability for the user to change their password when logging in
   1.2.6	10/08/2007 Completed credit card processing window and added aditional functionality
   during the add record process.
   1.2.7   10/09/2007 changed the restrict values on the amount field in cc processing.
   the field did not allow the usr to to enter the decimal point.
   The email field of the client data section is no longer validated as required
   1.2.8   10/09/2007 additional checks. cc processing will now use the start amount when adding a new
   record instead of the balance.
   1.2.9   Modified the client entry process. Disabled the Process transaction button until
   new record is completely written to database. If the record is new and the client balance is
   0, we will use the start fee as the amount to bill.
   1.3.0	10/11/2007 rework menu numbering system. added documentation to the application
   accessed by clicking the help menu item.
   1.3.1	11/09/2007 Added a new module to add, change and delete users. Also created a new class
   ModuleHandlerClass to deal with the creation / destruction of application modules.
   1.3.2	11/25/2007 Modified GLCProcessingWindow and AdjustmentWindow, made top and bottom corners
   rounded and modified TitleWindow properties in the css file.
   1.3.2.1 01/11/2008 BUG fix. active flag not being sent when adding new client record.
   moved location of current user to make room for the credit report received status.
   changed base location of reports from ravaen.domanet.com/metro to raven.domanet.com/GLC
   1.3.2.2	01/14/2008 Added effective date field to adjustment panel for both credit report status
   and the balance adjustment panel. Also validaed date fields to ensure they are not empty
   when form is submitted. Limited the range of available date ranges on components too.
   1.3.2.3  01/14/2008 added combo box to tools / adjustment panel, validate that adjustment amount
   is not blank
   1.3.3	01/15/2008 Created Adjustment Codes module, so users can add/update/edit codes for the
   combo box via admin. Validated credit against database in order to see if cardnumber is
   already on file. Misc changes to module processing. Cleaned up / fixed payment type processing
   so that the correct method of payment is selected on a per user basis
   1.3.3.1 01/16/2008 addiditional checks and validation logic for billing screen, along with the ability
   to select payment type and use selective validation.
   1.3.3.2 01/18/2008 Added Lead maintenance module, and combobox component to update and set client
   referral tracking
   1.3.3.3	01/20/2008 misc change to client class. client.fill (2) had typo preventing record
   creation when in list mode.
   1.3.3.4	01/28/2008 added a report options component to facilitate  various options when running
   the client banance report. Also removed all reports that are not currently running in PDF form
   1.3.3.5	03/02/2008 added refresh button to lead combobox so that the user can update the list if
   changes are made to the table externally. removed ssn display from mainview in order to
   display the lead source as per Danielle. corrected bug in server side code that did not
   update the payment table properly when initial payment was selected from the adjustment window
   1.3.3.7	03/09/2008 reworked mainview to include ssn and lead source, also added ability to
   search for clients by address. modified the getClients.cfm on backend to handle the
   the conditions.
   1.3.3.8	03/08/2008	Modified Client class to handle  text verbage of source field.
   created new property sourceVerbage
   added class PrintWindow to allowing print of both Client and Billing records to
   hard copy device using flex printing framework.
   1.3.3.9	03/10/2008 added the ability to print a client detail report which lists all relevant
   client demographic data in PDF format. GLCClientDetailReport
   1.3.4.0  03/19/2008 added new report GLCAddressList
   1.3.4.1	04/17/2008 added ability to send a welcome packet to client. corrected problem where
   the email address not being updated properly or valildated. see the service call
   sendWelcome()
   1.3.4.2 04/24/2008 added ability to email client by clicking on the email address in screen 1
   1.3.4.3 4/25/2008 added messages to alert box after a new client is added to inform the operator
   that either the social or creditcard number is already on file.
   1.3.4.4	05/03/2008 added the ability to download client records for the id avanger
   site. once the records are downloaded the user can generate the fruad alert form letters.
   1.3.4.5	05/05/2008 Reworked the ClientBalance Report to sort by last name using lname lname for the
   name column. Also updated the report options to allow all states or florida only.
   1.3.4.6 05/19/2008 added the Initial Payment Report to the menu. and the recurring report
   1.3.4.7 5/22/2008 added option to ip report to break on sales rep
   1.3.4.8	6/26/2008 added help to admin user module
   1.3.4.9 6/30/2008 updated login.cfm to restrict access to the application for non privledged users
   to the local IP. Also updated login to return a message as well as status to the app to indicate
   the status of the transaction.
   Corrected a bug in the login service call, the call was not passing the random variable and
   caused the browser to cache the results of the last login.
   1.3.5.0	07/02/2008 corrected with the client balance report.
   1.3.5.1	07/05/2008	Added method to load report menu from xml file along with ability to
   filter the available reports by security level.
   1.3.5.3 07/27/2008 Implemented new method to run reports. All report data now
   contained in the ReportItem class. ReportItems loaded from external
   xml file
   1.3.5.4	07/28/2008 both reportSelected and runReport functions modified to
   use the reportItem object.
   1.3.5.5	8/18/2008 modified manager privledges. Same as admin but can't add users ,adj codes or ref codes.
   added ability for staff role to print the client detail page
   added ability of manager2 to run ip report with out balances
   1.3.5.6 08/23/2008 added additional option to the options2 canvas in the
   report option selector. also modified the report process to
   use the post method (runReport method)
   1.3.5.7	9/5/2008 Report combo box now loaded from database query.
   1.3.5.8 9/18/2008 fix broken report (export 19)
   1.3.5.9  9/22/2008version change only
   1.3.6.0	9/22/2008 fixed problem with the delinquent client report. The validate range was
   being called for this report which requires no date
   1.3.6.1	10/02.2008 defaulted date fields on the report generator to today's date.
   1.3.6.2	06/02/2009	fixed problem with the downloading of the 19's.
   still need to address issue of the download using a cached copy of the data.
   1.3.6.3	06/03/2009 added a unique file path to the download url to prevent browser caching
   added ascb to the project source path and imported ascb.util.NumberUtilities to the
   fileDownload.as file
   1.4.0	06/04/2010  added ability to display history records after successful client lookup, added additional fields
   to the history grid.
   1.4.8   added ability to delete client records using the backend procedure delete_client
   1.5.0	9/8/10 misc fix to alert box when deleting a record

   1.5.8	9/24/10 corrected bug with note access where notes ac was not cleared after entry and another client
   lookup done. The prev clients notes would still appear as a new clients notes.
   Changed data type of the security code field in the billing record from number to char, due to
   leading zeros being dropped. (db modification alse).
   added a date formatter to all billing date fields prior to printing the client detail report.
   1.5.9	10/6/2010 completed cc processing panel, added new cc logo to main toolbar
   1.6.0	bug fix. Manager 1 was not able to process payments. modified security controller to allow
   that role the ability to bill.
   1.6.2	10/16/2010 fixed bug where the credit card fields would display as required even if
   the payment type was Banking.
   1.6.3	10/16/2010	bug: clear notes dataProvider if the returned arraycollection has no
   elements.
   1.6.4	10/18/2010	Added ability to print the client history from the summary screen
   1.6.5	11/3/2010 enabled cc processing for security lvl 7 (manager)
   1.6.6	1/18/2011	 added additional permitted characters to the email text input
   1.6.7   1/21/2011 formatted the client ssn for use in the GLCClientDetail Report
   1.6.8	10/26/2011 modified the add client routine so that security level 7 and above have access to the function
 */
import com.ace.DBTools;
import com.ace.Input.Utilities;
import com.goodlife.BILLING;
import com.goodlife.CLIENT;
import com.goodlife.Events.LoginCompleteEvent;
import com.metrobg.Classes.ReportItem;
import com.metrobg.Classes.SecurityController;
import com.metrobg.Icons.Images;
import flash.net.navigateToURL;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ItemClickEvent;
import mx.events.MenuEvent;
import mx.managers.CursorManager;
import mx.rpc.events.*;
import mx.styles.StyleManager;
import org.openzet.containers.MDIWindow;
import org.openzet.containers.MDIWindowState;
import org.openzet.events.MDIWindowEvent;

[Bindable]
public var acReferral:ArrayCollection = new ArrayCollection();

[Bindable]
public var acAgents:ArrayCollection = new ArrayCollection();

[Bindable]
public var acNotes:ArrayCollection = new ArrayCollection();

[Bindable]
public var acGeneral:ArrayCollection = new ArrayCollection();

public var reportAC:ArrayCollection = new ArrayCollection();

public var currentClient:Number = 0;

//  WINDOW Variables  
public var loginWindow:LoginWindow;

public var notesEditor:NotesEditor;

private var calendarWindow:CalendarWindow;

private var agentEditor:AgentEditor;

private var userEditor:UserEditor;

private var leadEditor:LeadsEditor;

private var codesEditor:CodesMaintenance;

private var adjustmentWindow:AdjustmentWindow;

private var processingWindow:ProcessingWindow;

private var reportWindow:ReportRunner;

private var bolNotesOpen:Boolean = false;

private var bolCalendarOpen:Boolean = false;

private var bolAWOpen:Boolean = false;

private var bolPWOpen:Boolean = false;

private var bolRROpen:Boolean = false;

private var aryWindows:Array;

[Bindable]
private var client:CLIENT;

[Bindable]
private var billing:BILLING;

private var dbTools:DBTools;

private var acClientWrapper:ArrayCollection = new ArrayCollection();

private var acBillingWrapper:ArrayCollection = new ArrayCollection();

private var _strCurrentStyle:String = "";

[Bindable]
private var searchAC:ArrayCollection;

private var acAdjustmentCodes:ArrayCollection;

private var searchArray:Array = new Array('Search History');

public var txtUSERID:String;

public var txtROLE:String;

public var sc:SecurityController;

public var newClient:Boolean = false;

private var firstTimeInit:Boolean = false;

public var version:String = "1.6.12";

public function init():void
{
    ClientWindow.title = "Client Information Center - " + version;
    ClientWindow.setSize(650, 500)
    ClientWindow.showMaxButton = false;
    ClientWindow.showCloseButton = false;
    aryWindows = new Array();
    SOURCE.dataField = "DATA";
    SOURCE.labelField = "LABEL"
    searchAC = new ArrayCollection;
    searchAC.source = searchArray;
    // populate combo boxes
    service.getLeads();
    service.getAgents();
    service.getStates();
    service.getAdjustmentCodes();
    appMenu.dataProvider = dp2;
    appMenu.labelField = "@label"
    appMenu.addEventListener("itemClick", menuItemSelected);
    changeCSS("Styles/PlainStyles/GMSBlue.swf")
    if (!firstTimeInit)
    {
        firstTimeInit = true;
        addLoginWindow();
    }
    dbTools = new DBTools();
    ACTIVE.dataProvider = new ArrayCollection([{ DATA: "Y", LABEL: "Active" }, { DATA: "N", LABEL: "Inactive" }]);
    B_PAYTYPE.dataProvider = new ArrayCollection([{ DATA: "cc", LABEL: "Credit Card" }, { DATA: "ba", LABEL: "Banking" }]);
    sc = new SecurityController(this);
}

public function setupInit():void
{
    ClientWindow.setSize(650, 500)
    ClientWindow.showMaxButton = false;
    ClientWindow.showCloseButton = false;
    ClientWindow.visible = true;
    aryWindows = new Array();
    SOURCE.dataField = "DATA";
    SOURCE.labelField = "LABEL"
    searchAC = new ArrayCollection;
    searchAC.source = searchArray;
    // populate combo boxes
    service.getLeads();
    service.getAgents();
    service.getStates();
    service.getAdjustmentCodes();
    appMenu.dataProvider = dp2;
    appMenu.labelField = "@label"
    appMenu.addEventListener("itemClick", menuItemSelected);
    changeCSS("Styles/PlainStyles/GMSBlue.swf")
    //addLoginWindow();
    dbTools = new DBTools();
    ACTIVE.dataProvider = new ArrayCollection([{ DATA: "Y", LABEL: "Active" }, { DATA: "N", LABEL: "Inactive" }]);
    B_PAYTYPE.dataProvider = new ArrayCollection([{ DATA: "cc", LABEL: "Credit Card" }, { DATA: "ba", LABEL: "Banking" }]);
    sc = new SecurityController(this);
}

private function clientLookup():void
{
    if (txtSearch.length < 3)
    {
        Alert.show("Search field requires at least 3 characters", "Error");
        return;
    }
    else
    {
        btnPrintHistory.enabled = false;
        switch (searchGroup.selectedValue)
        {
            case "ID":
                gateway.getClientById(txtSearch.text);
                updateSearchHistory();
                break;
            case "N":
                gateway.getClientByName(txtSearch.text);
                break;
            case "SSN":
                gateway.getClientBySSN(txtSearch.text);
                break;
            case "CC":
                gateway.getClientByCC(txtSearch.text);
                break;
        }
        newClient = false;
        ClientWindow.status = "Inquiry";
    }
}

private function addLoginWindow():void
{
    loginWindow = new LoginWindow();
    mdi.addChild(loginWindow);
    loginWindow.setSize(575, 230);
    loginWindow.showMaxButton = false;
    loginWindow.resizable = false;
    loginWindow.showCloseButton = false;
    loginWindow.x = (Application.application.width - loginWindow.width) / 2;
    loginWindow.y = ((Application.application.height - 200) - loginWindow.height) / 2;
    loginWindow.showMinButton = false;
    loginWindow.addEventListener(LoginCompleteEvent.COMPLETE, loginComplete);
}

private function loginComplete(event:LoginCompleteEvent):void
{
    this.init();
    ClientWindow.visible = true;
    btn_search.enabled = true;
    appMenu.visible = true;
    appControlBar.visible = true;
    txtUSERID = event.userData.user;
    txtROLE = event.userData.role;
    sc.setSecurity(Number(txtROLE));
    lblUSERID.text = txtUSERID;
    lblROLE.text = sc.getRole(Number(txtROLE));
    service.getReports(txtROLE);
}

private function addAdjustmentWindow():void
{
    if (!bolAWOpen)
    {
        adjustmentWindow = new AdjustmentWindow();
        mdi.addChild(adjustmentWindow);
        adjustmentWindow.setSize(600, 372);
        adjustmentWindow.showMaxButton = false;
        adjustmentWindow.resizable = false;
        adjustmentWindow.showCloseButton = true;
        adjustmentWindow.doInit();
        adjustmentWindow.AdjCodesAC = acAdjustmentCodes;
        adjustmentWindow.addEventListener(MDIWindowEvent.CLOSE, AdjustmentWindowClosing);
        adjustmentWindow.name = "adjustmentWindow";
        aryWindows.push(adjustmentWindow);
    }
    else
    {
        switch (adjustmentWindow.windowState)
        {
            case MDIWindowState.NORMAL:
                {
                    adjustmentWindow.restore();
                    break;
                }
            case MDIWindowState.MAXIMIZED:
                {
                    adjustmentWindow.windowState = MDIWindowState.MAXIMIZED;
                    break;
                }
            case MDIWindowState.MINIMIZED:
                {
                    adjustmentWindow.windowState = MDIWindowState.NORMAL
                    break;
                }
        }
    }
}

private function AdjustmentWindowClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        bolAWOpen = false;
            //removeWindow("adjustmentWindow");
    }
}

private function addReportWindow():void
{
    if (!bolRROpen)
    {
        reportWindow = new ReportRunner();
        mdi.addChild(reportWindow);
        reportWindow.setSize(400, 560);
        reportWindow.showMaxButton = false;
        reportWindow.resizable = false;
        reportWindow.showCloseButton = true;
        //reportWindow.init();
        reportWindow.reportAC = this.reportAC;
        reportWindow.addEventListener(MDIWindowEvent.CLOSE, ReportWindowClosing);
        reportWindow.name = "reportWindow";
        aryWindows.push(reportWindow);
    }
    else
    {
        switch (reportWindow.windowState)
        {
            case MDIWindowState.NORMAL:
                {
                    reportWindow.restore();
                    break;
                }
            case MDIWindowState.MAXIMIZED:
                {
                    reportWindow.windowState = MDIWindowState.MAXIMIZED;
                    break;
                }
            case MDIWindowState.MINIMIZED:
                {
                    reportWindow.windowState = MDIWindowState.NORMAL
                    break;
                }
        }
    }
}

private function ReportWindowClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        bolRROpen = false;
            //removeWindow("adjustmentWindow");
    }
}

private function addCalendarWindow():void
{
    if (!bolCalendarOpen)
    {
        bolCalendarOpen = true;
        calendarWindow = new CalendarWindow();
        mdi.addChild(calendarWindow);
        calendarWindow.setSize(220, 250);
        calendarWindow.resizable = false;
        calendarWindow.showCloseButton = true;
        calendarWindow.showMaxButton = false;
        calendarWindow.x = 0;
        calendarWindow.y = 300;
        calendarWindow.addEventListener(MDIWindowEvent.CLOSE, CalendarWindowClosing);
        calendarWindow.name = "calendarWindow";
        aryWindows.push(calendarWindow);
    }
    else
    {
        switch (calendarWindow.windowState)
        {
            case MDIWindowState.NORMAL:
                {
                    calendarWindow.restore();
                    break;
                }
            case MDIWindowState.MAXIMIZED:
                {
                    calendarWindow.windowState = MDIWindowState.MAXIMIZED;
                    break;
                }
            case MDIWindowState.MINIMIZED:
                {
                    calendarWindow.windowState = MDIWindowState.NORMAL
                    break;
                }
        }
    }
}

private function CalendarWindowClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        bolCalendarOpen = false;
            //removeWindow("calendarWindow");
    }
}

private function openNotesWindow(value:Number):void
{
    notesEditor = new NotesEditor();
    bolNotesOpen = true;
    dgNotes.doubleClickEnabled = !bolNotesOpen;
    mdi.addChild(notesEditor);
    notesEditor.setSize(475, 314);
    notesEditor.showCloseButton = true;
    notesEditor.showMaxButton = false;
    notesEditor.showMinButton = false;
    notesEditor.resizable = false;
    notesEditor.x = 310;
    if (value > -1)
    {
        notesEditor.key = dgNotes.selectedItem.ID;
        notesEditor.taNotes.text = dgNotes.selectedItem.TEXT
    }
    else
    {
        notesEditor.key = 0;
    }
    if (Number(txtROLE) < 9 && notesEditor.key > 0)
    {
        notesEditor.btnSaveNote.enabled = false;
        notesEditor.taNotes.editable = false;
    }
    notesEditor.addEventListener(MDIWindowEvent.CLOSE, NotesWindowClosing);
    notesEditor.name = "notesEditor";
    aryWindows.push(notesEditor);
}

private function NotesWindowClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        bolNotesOpen = false;
        //removeWindow("notesEditor");
        if (evt.currentTarget.textChanged)
        {
            service.saveNotes(evt.currentTarget.taNotes.text, txtUSERID, client.CLIENTID, evt.currentTarget.key);
        }
        dgNotes.doubleClickEnabled = !bolNotesOpen;
    }
}

private function addAgentWindow():void
{
    agentEditor = new AgentEditor();
    mdi.addChild(agentEditor);
    agentEditor.setSize(700, 410);
    agentEditor.showMaxButton = false;
    agentEditor.resizable = true;
    agentEditor.showCloseButton = true;
    agentEditor.addEventListener(MDIWindowEvent.CLOSE, agentEditorClosing)
    agentEditor.name = "agentEditor";
    aryWindows.push(agentEditor);
}

private function agentEditorClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        //removeWindow("agaentEditor");
    }
}

private function addUserWindow():void
{
    userEditor = new UserEditor();
    mdi.addChild(userEditor);
    userEditor.setSize(700, 410);
    userEditor.showMaxButton = false;
    userEditor.resizable = true;
    userEditor.showCloseButton = true;
    userEditor.addEventListener(MDIWindowEvent.CLOSE, userEditorClosing);
    userEditor.name = "userEditor";
    aryWindows.push(userEditor);
}

private function userEditorClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        // removeWindow("userEditor");
    }
}

private function addLeadsWindow():void
{
    leadEditor = new LeadsEditor();
    mdi.addChild(leadEditor);
    leadEditor.setSize(700, 410);
    leadEditor.showMaxButton = false;
    leadEditor.resizable = false;
    leadEditor.showCloseButton = true;
    leadEditor.name = "leadEditor";
    aryWindows.push(leadEditor);
}

private function addCodesWindow():void
{
    codesEditor = new CodesMaintenance();
    mdi.addChild(codesEditor);
    codesEditor.setSize(700, 470);
    codesEditor.showMaxButton = false;
    codesEditor.resizable = false;
    codesEditor.showCloseButton = true;
    codesEditor.name = "codeEditor";
    aryWindows.push(codesEditor);
}

private function collectPayment():void
{
    if (client == null || client.CLIENTID == 0)
    {
        return;
    }
    if (bolPWOpen == false)
    {
        processingWindow = new ProcessingWindow();
        mdi.addChild(processingWindow);
        processingWindow.setSize(353, 431);
        processingWindow.showMaxButton = false;
        processingWindow.resizable = false;
        processingWindow.showCloseButton = true;
        processingWindow.doInit();
        processingWindow.fld_address.text = billing.ADDRESS;
        processingWindow.fld_cardnumber.text = billing.ECARDNUMBER;
        processingWindow.fld_amount.text = billing.BALANCE.toString();
        processingWindow.fld_clientid.text = billing.CLIENTID.toString();
        processingWindow.fld_cvv.text = billing.SECURITY_CODE.toString();
        processingWindow.fld_expiry.text = billing.EXPIRATION;
        processingWindow.fld_zipcode.text = billing.ZIP;
        processingWindow.addEventListener(MDIWindowEvent.CLOSE, ProcessingWindowClosing);
        processingWindow.name = "processingWindow";
        aryWindows.push(processingWindow);
        bolPWOpen = true;
    }
    else
    {
        switch (processingWindow.windowState)
        {
            case MDIWindowState.NORMAL:
                {
                    processingWindow.restore();
                    break;
                }
            case MDIWindowState.MAXIMIZED:
                {
                    processingWindow.windowState = MDIWindowState.MAXIMIZED;
                    break;
                }
            case MDIWindowState.MINIMIZED:
                {
                    processingWindow.windowState = MDIWindowState.NORMAL
                    break;
                }
        }
    }
}

private function ProcessingWindowClosing(evt:MDIWindowEvent):void
{
    if (evt.type == "close")
    {
        bolPWOpen = false;
            //removeWindow("processingWindow");
    }
}

private function updateSearchHistory():void
{
    if (searchArray.lastIndexOf(txtSearch.text) < 0)
    {
        searchArray[0] = txtSearch.text; // add new entry
        searchArray.unshift('Search History'); // keep this as the first item	          
        if (searchArray.length > 11)
        {
            searchArray.pop(); // keep the last 10 search items
        }
        searchAC.refresh();
    }
}

private function setReferrer():void
{
    clientSource.text = SOURCE.selectedItem.LABEL;
}

private function saveClientRecord():void
{
    if (Utilities.validateAll(cnv_demographic))
    {
        if (!newClient)
        {
            dbTools.buildUpdateRecord(acClientWrapper, 0, cnv_demographic, "");
            if (dbTools.updateFields.length > 0)
            {
                var vclient:CLIENT = new CLIENT;
                vclient = dbTools.acUpdateRecord[0] as CLIENT;
                gateway.saveClient(vclient);
            }
            else
            {
                Alert.show("Nothing to Update", "Nothing to do");
            }
        }
        else
        {
            acClientWrapper.removeAll();
            client.ACTIVE = ACTIVE.selectedItem.DATA;
            client.ADDRESS2 = ADDRESS2.text;
            client.ADDRESS = ADDRESS.text;
            client.AD_ID = 0;
            client.CALC_DATE = new Date().getTime();
            client.WELCOME_SENT = 0;
            client.FNAME = FNAME.text;
            client.LNAME = LNAME.text;
            client.CITY = CITY.text;
            client.STATE = STATE.selectedItem.DATA;
            client.ZIP = ZIP.text;
            client.PHONE = PHONE.value;
            client.PHONE2 = PHONE2.value;
            client.EMAIL = EMAIL.text;
            client.SSN = SSN.value;
            client.SOURCE = SOURCE.selectedItem.DATA;
            client.DOB = new Date(Date.parse(DOB.text));
            client.AGREEMENT = "yes";
            acClientWrapper.addItem(client);
            gateway.saveClient(client);
        }
    }
    else
    {
        Alert.show("Please correct fields outlined in Red", "Incomplete");
        return;
    }
}

private function deleteClientRecord():void
{
    gateway.deleteClient(client);
}

private function saveBillingRecord():void
{
    if (Utilities.validateAll(cnv_billing))
    {
        dbTools.buildUpdateRecord(acBillingWrapper, 0, cnv_billing, "B");
        if (dbTools.updateFields.length > 0)
        {
            var vbilling:BILLING = new BILLING();
            vbilling = dbTools.acUpdateRecord[0] as BILLING;
            gateway.saveBilling(vbilling);
        }
        else
        {
            Alert.show("Nothing to Update", "Nothing to do");
        }
    }
    else
    {
        Alert.show("Please correct fields outlined in Red", "Incomplete");
    }
}

private function setAgent():void
{
    clientRep.text = B_AGENTID.selectedItem.LABEL;
    clientSTATUS.text = String(client.CLIENTID);
    lblSTATUS.text = ACTIVE.selectedLabel;
    //ClientWindow.status = "user: " + txtUSERID;
    setReferrer();
}

private function updateSearchField():void
{
    if (searchHistory_cbx.selectedLabel != "Search History")
    {
        txtSearch.text = searchHistory_cbx.selectedLabel
        searchHistory_cbx.selectedIndex = 0;
    }
}

public function onServiceDataReady(event:ResultEvent):void
{
    var act:Object = event.token;
    switch (act.message.operation)
    {
        case "getClientById":
            if (act.result.CLIENTID != 0)
            {
                makeClientRecord(act.result);
                tn.selectedIndex = 0;
                dgHistory.visible = true;
                dgReview.visible = false;
                break;
            }
            else
            {
                Alert.show("Record Not Found", "NIF");
                return;
            }
        case "getLeads":
            acReferral = event.result as ArrayCollection;
            acReferral.addItemAt({ LABEL: "Unknown", DATA: 0 }, 0);
            break;
        case "getAgents":
            acAgents = event.result as ArrayCollection;
            acAgents.addItemAt({ LABEL: "Unknown", DATA: 0 }, 0);
            B_AGENTID.dataProvider = acAgents;
            break;
        case "getHistory":
            if (event.result.length > 0)
            {
                dgHistory.dataProvider = event.result as ArrayCollection;
                btnPrintHistory.enabled = true;
            }
            else
            {
                dgHistory.dataProvider = null;
            }
            break;
        case "getStates":
            if (event.result.length > 0)
            {
                var ac:ArrayCollection = new ArrayCollection();
                ac = event.result as ArrayCollection;
                ac.addItemAt({ LABEL: "Select", DATA: "" }, 0);
                B_STATE.dataProvider = ac;
                STATE.dataProvider = ac;
            }
            break;
        case "getBillingById":
            if (act.result.CLIENTID != 0)
            {
                makeBillingRecord(act.result);
            }
            break;
        case "saveClient":
            if (newClient)
            {
                if (act.result.CLIENTID != 0)
                {
                    makeClientRecord(act.result);
                    tn.selectedIndex = 2;
                    cnv_billing.enabled = true;
                    cnv_demographic.enabled = false;
                    gateway.getBillingById(client.CLIENTID);
                }
            }
            else
            {
                if (act.result.CLIENTID != 0)
                {
                    makeClientRecord(act.result);
                    Alert.show("Client Record Saved", "Update Success");
                }
            }
            break;
        case "saveBilling":
            if (act.result.CLIENTID != 0)
            {
                makeBillingRecord(act.result);
                Alert.show("Billing Record Saved", "Update Success");
                if (newClient)
                {
                    enableTabs();
                }
            }
            break;
        case "saveNotes":
            service.getClientNotes(currentClient);
            break;
        case "getClientNotes":
            if (event.result.length > 0)
            {
                acNotes = event.result as ArrayCollection;
                dgNotes.dataProvider = acNotes;
            }
            else
            {
                dgNotes.dataProvider = null;
                    //	acNotes.removeAll(); // remove last entry
                    //	acNotes.refresh();
            }
            break;
        case "sendWelcome":
            Alert.show(act.result.reason, "Message");
            break;
            break;
        case "getAdjustmentCodes":
            if (event.result.length > 0)
            {
                acAdjustmentCodes = event.result as ArrayCollection;
            }
            break;
        case "setCardAttempts":
            if (act.result.status == "1")
            {
                billing.CARD_ATTEMPTS = Number(act.result.value);
                clientLast_Billing.text = df1.format(billing.LAST_BILLING) + " " + billing.AUTH_MESSAGE + " (" + billing.CARD_ATTEMPTS + ")";
            }
            else
            {
                Alert.show("Problem updating Record", "Error");
            }
            break;
        case "changeBillingDate":
            if (act.result.status == "1")
            {
                billing.NEXT_BILLING = new Date(Date.parse(act.result.value));
                clientNext_Billing.text = df1.format(billing.NEXT_BILLING);
            }
            else
            {
                Alert.show("Problem updating Record", "Error");
            }
            break;
        case "crReportRcvd":
            if (act.result.status == "1")
            {
                clientCreditReport.text = "Received: " + act.result.value;
                client.CREDIT_REPORT = "Y";
                client.CRRECEIPT_DATE = new Date(Date.parse(act.result.value));
            }
            else
            {
                Alert.show("Problem updating Record", "Error");
            }
            break;
        case "getReports":
            var tmpAC:ArrayCollection = new ArrayCollection();
            if (event.result.length > 0)
            {
                tmpAC = event.result as ArrayCollection;
                for (var i:int = 0; i < tmpAC.length; i++)
                {
                    var ri:ReportItem = new ReportItem();
                    ri.fill(tmpAC.getItemAt(i));
                    reportAC.addItem(ri);
                }
            }
            break;
        case "adjBalance":
            if (act.result.status == "1")
            {
                billing.BALANCE = Number(act.result.value);
                service.getHistory(client.CLIENTID);
                clientBalance.text = cf.format(billing.BALANCE) + " / " + B_PAYTYPE.selectedLabel;
            }
            else
            {
                Alert.show("Problem updating Record", "Error");
            }
            break;
        case "deleteClient":
            var x:XML = new XML(event.result);
            if (act.result.status == "1")
            {
                Alert.show("Record Deleted", "Done");
                client = null;
                billing = null;
                clearFields();
                com.ace.Input.Utilities.clearAll(cnv_demographic);
                com.ace.Input.Utilities.clearAll(cnv_billing);
                com.ace.Input.Utilities.clearAll(cnv_notes);
                //dgNotes.dataProvider = null;
                acGeneral.removeAll();
            }
            else
            {
                Alert.show("Problem removing record", "Failed");
            }
            break;
        case "getClientByName":
        case "getClientBySSN":
        case "getClientByCC":
            if (act.result.length > 0)
            {
                acGeneral.removeAll();
                dgHistory.visible = false;
                dgReview.visible = true;
                acGeneral = new ArrayCollection(act.result);
                dgReview.dataProvider = acGeneral;
                labGrid.text = "Search Results";
            }
            if (act.result.length == 1)
            {
                tn.selectedIndex = 0;
                makeClientRecord(act.result[0]);
                dgHistory.visible = true;
                dgReview.visible = false;
            }
            if (act.result.length == 0)
            {
                Alert.show("No matches found", "No Matches");
            }
            tn.selectedIndex = 0;
            break;
    }
}

private function makeClientRecord(vclient:CLIENT):void
{
    client = new CLIENT();
    client = vclient;
    currentClient = client.CLIENTID;
    clientName.text = client.FNAME + " " + client.LNAME;
    clientAddress.text = client.ADDRESS;
    clientAddress2.text = client.CITY + ", " + client.STATE + " " + client.ZIP;
    if (String(client.ADDRESS2) != "null")
    {
        clientAddress.text += "  " + client.ADDRESS2;
    }
    clientPhone.text = pf.format(client.PHONE);
    clientPhone2.text = pf.format(client.PHONE2);
    clientDOB.text = df1.format(client.DOB);
    clientSSN.text = ssn.format(client.SSN);
    clientEmail.label = client.EMAIL;
    service.getHistory(client.CLIENTID);
    gateway.getBillingById(client.CLIENTID);
    acClientWrapper.removeAll();
    acClientWrapper.addItem(client);
    if (client.CREDIT_REPORT == "Y")
    {
        clientCreditReport.text = "Received: " + df.format(client.CRRECEIPT_DATE);
    }
    else
    {
        clientCreditReport.text = "Not Received";
    }
    clientSignup.text = df.format(client.DATE_ENTERED);
    dbTools.loadFieldData(acClientWrapper, 0, cnv_demographic, "");
    enableTabs();
}

private function makeBillingRecord(vbilling:BILLING):void
{
    billing = new BILLING();
    billing = vbilling;
    acBillingWrapper.removeAll();
    acBillingWrapper.addItem(billing);
    dbTools.loadFieldData(acBillingWrapper, 0, cnv_billing, "B");
    clientBalance.text = cf.format(billing.BALANCE) + " / " + B_PAYTYPE.selectedLabel;
    clientInitial_Billing.text = df1.format(billing.INITIAL_BILLING);
    clientLast_Billing.text = df1.format(billing.LAST_BILLING) + " " + billing.AUTH_MESSAGE + " (" + billing.CARD_ATTEMPTS + ")";
    clientNext_Billing.text = df1.format(billing.NEXT_BILLING);
    callLater(enableFields);
    callLater(setAgent);
    return;
}

public function goToEmail(emailStr:String):void
{
    //see http://livedocs.macromedia.com/flex/2/langref/flash/net/URLRequest.html
    var emailURL:URLRequest = new URLRequest("mailto:" + emailStr);
    //see: http://livedocs.macromedia.com/flex/2/langref/flash/net/package.html#navigateToURL()
    navigateToURL(emailURL)
}

private function onServiceFault(event:FaultEvent):void
{
    // Or clock-cursor will spin forever (:
    CursorManager.removeBusyCursor();
    var act:Object = event.token;
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

private function changeCSS(strName:String):void
{
    if (_strCurrentStyle.length > 0)
    {
        StyleManager.unloadStyleDeclarations(_strCurrentStyle, false);
    }
    _strCurrentStyle = strName;
    var styleEvent:IEventDispatcher = StyleManager.loadStyleDeclarations(strName, true);
}

public function menuItemSelected(event:MenuEvent):void
{
    var action:Number = Number(event.item.@index);
    switch (action)
    {
        case 50:
            changeCSS(event.item.@value + ".swf");
            break;
        case 11:
            addAgentWindow();
            break;
        case 12:
            addUserWindow();
            break;
        case 13:
            addLeadsWindow();
            break;
        case 15:
            addCodesWindow();
            break;
        case 22:
            if ((client != null) && (client.CLIENTID > 0))
            {
                service.sendWelcome(client.CLIENTID);
            }
            break;
        case -1: // logout
            clearFields();
            client = null;
            billing = null;
            dgHistory.dataProvider = null;
            dgNotes.dataProvider = null;
            dgReview.dataProvider = null;
            searchHistory_cbx.dataProvider = null; //MBG
            acClientWrapper.removeAll();
            acBillingWrapper.removeAll();
            txtROLE: String;
            sc = null;
            newClient = false;
            appControlBar.visible = false;
            appMenu.visible = false;
            closeWindows();
            addLoginWindow();
            txtSearch.text = '';
            tn.selectedIndex = 0;
            break;
        default:
            Alert.show("Unknown menu selection", "Error");
    }
}

private function closeWindows():void
{
    ClientWindow.visible = false;
    var win:MDIWindow;
    var cnt:int = 0;
    for (var i:int = aryWindows.length; i >= 0; i--)
    {
        try
        {
            win = MDIWindow(aryWindows.shift());
            trace("window name is: " + win.name + "numb " + i)
            win.close();
        }
        catch (errorObj:Object)
        {
        }
    }
}

private function downloadMode():void
{
}

private function restrictInput(event:ItemClickEvent):void
{
    if (event.currentTarget.selectedValue == 'N')
    {
        txtSearch.restrict = "A-Z0-9 &_-";
    }
    else
    {
        txtSearch.restrict = "0-9";
    }
    return
}

private function enableTabs():void
{
    newClient = false;
    cnv_summary.enabled = true;
    cnv_demographic.enabled = true;
    cnv_billing.enabled = true;
    cnv_notes.enabled = true;
    btnPrintData.enabled = true;
    sc.setSecurity(Number(txtROLE));
}

private function enableFields():void
{
    if (billing.PAYTYPE == null)
    {
        billing.PAYTYPE = "cc";
    }
    if (billing.PAYTYPE == "ba")
    {
        B_ECARDNUMBER.enabled = false;
        B_EXPIRATION.enabled = false;
        B_SECURITY_CODE.enabled = false;
        B_ECARDNUMBER.minDataChars = 0;
        B_EXPIRATION.minDataChars = 0;
        B_SECURITY_CODE.minDataChars = 0;
        B_BANK_NAME.enabled = true;
        B_ACCOUNT_NUMBER.enabled = true;
        B_ROUTING_NUMBER.enabled = true;
        B_ACCOUNT_NUMBER.minDataChars = 5;
        B_ROUTING_NUMBER.minDataChars = 9;
    }
    else
    {
        B_ECARDNUMBER.enabled = true;
        B_EXPIRATION.enabled = true;
        B_SECURITY_CODE.enabled = true;
        B_ECARDNUMBER.minDataChars = 13;
        B_EXPIRATION.minDataChars = 4;
        B_SECURITY_CODE.minDataChars = 3;
        B_ACCOUNT_NUMBER.minDataChars = 0;
        B_ROUTING_NUMBER.minDataChars = 0;
        B_BANK_NAME.enabled = false;
        B_ACCOUNT_NUMBER.enabled = false;
        B_ROUTING_NUMBER.enabled = false;
    }
}

private function payTypeChanged(evt:Event):void
{
    if (evt.target.value == "ba")
    {
        B_ECARDNUMBER.enabled = false;
        B_EXPIRATION.enabled = false;
        B_SECURITY_CODE.enabled = false;
        B_ECARDNUMBER.minDataChars = 0;
        B_EXPIRATION.minDataChars = 0;
        B_SECURITY_CODE.minDataChars = 0;
        B_BANK_NAME.enabled = true;
        B_ACCOUNT_NUMBER.enabled = true;
        B_ROUTING_NUMBER.enabled = true;
        B_ACCOUNT_NUMBER.minDataChars = 5;
        B_ROUTING_NUMBER.minDataChars = 9;
    }
    else
    {
        B_ECARDNUMBER.enabled = true;
        B_EXPIRATION.enabled = true;
        B_SECURITY_CODE.enabled = true;
        B_ECARDNUMBER.minDataChars = 13;
        B_EXPIRATION.minDataChars = 4;
        B_SECURITY_CODE.minDataChars = 3;
        B_ACCOUNT_NUMBER.minDataChars = 0;
        B_ROUTING_NUMBER.minDataChars = 0;
        B_BANK_NAME.enabled = false;
        B_ACCOUNT_NUMBER.enabled = false;
        B_ROUTING_NUMBER.enabled = false;
    }
}

private function selectRecord():void
{
    if (dgReview.selectedIndex >= 0)
    {
        makeClientRecord(dgReview.selectedItem as CLIENT);
        dgReview.visible = false;
        dgHistory.visible = true;
        acGeneral.removeAll();
        labGrid.text = "Payment History";
        enableTabs();
    }
}

private function showRecord():void
{
    if (dgReview.selectedIndex >= 0)
    {
        makeClientRecord(dgReview.selectedItem as CLIENT);
        enableTabs();
    }
}

public function PrintClientData():void
{
    var d:XML = assembleXML();
    var url:String = "http://dbase.metrobg.com/GLC/GLCClientDetailReport";
    var request:URLRequest = new URLRequest(url);
    var variables:URLVariables = new URLVariables();
    variables.data = d.toXMLString();
    request.data = variables;
    request.method = "POST";
    navigateToURL(request);
}

private function assembleXML():XML
{
    var x:XML = <client></client>;
    x.id = client.CLIENTID;
    x.name = client.FNAME + ' ' + client.LNAME;
    x.address = client.ADDRESS;
    x.csz = client.CITY + ' ' + client.STATE + ' ' + client.ZIP;
    x.address2 = client.ADDRESS2;
    x.phone = pf.format(client.PHONE);
    x.source = SOURCE.selectedLabel;
    x.dob = df1.format(client.DOB);
    x.email = client.EMAIL;
    x.phone2 = pf.format(client.PHONE2);
    x.ssn = client.SSN.substr(0, 3) + "-" + client.SSN.substr(3, 2) + "-" + client.SSN.substr(5, 4);
    x.status = ACTIVE.selectedLabel;
    x.bname = billing.NAME;
    x.baddress = billing.ADDRESS;
    x.bcsz = billing.CITY + ' ' + billing.STATE + ' ' + billing.ZIP;
    x.baddress2 = billing.ADDRESS2;
    x.agent = B_AGENTID.selectedLabel;
    x.balance = cf.format(billing.BALANCE);
    x.startfee = cf.format(billing.START_FEE);
    x.billingdate = df1.format(billing.INITIAL_BILLING);
    x.creditreport = df1.format(client.CRRECEIPT_DATE);
    x.signup = df1.format(billing.DATE_ENTERED);
    x.monthly = cf.format(billing.BILLING_AMOUNT);
    x.lastattempt = df1.format(billing.LAST_BILLING) + ' ' + billing.CARD_ATTEMPTS;
    x.nextpayment = df1.format(billing.NEXT_BILLING);
    x.card = "4111111111111111";
    x.expiry = billing.EXPIRATION;
    x.cvv = billing.SECURITY_CODE;
    x.bankname = billing.BANK_NAME;
    x.account = billing.ACCOUNT_NUMBER;
    x.routing = billing.ROUTING_NUMBER;
    x.user = txtUSERID;
    return x;
}

private function preDeleteClient():void
{
    if (Number(txtROLE) == 9)
    {
        if (client != null)
        {
            Alert.show("Delete Client: " + client.CLIENTID + " , " + billing.NAME + " ?", "Delete", Alert.OK | Alert.CANCEL, this, deleteClient, Images.deleteIcon);
        }
        else
        {
            Alert.show("Select a client for deletion", "Error");
        }
    }
}

private function deleteClient(event:CloseEvent):void
{
    if (event.detail == Alert.OK)
    {
        service.deleteClient(client.CLIENTID);
    }
    else
    {
        Alert.show("Delete Cancelled", "Cancel");
    }
}

private function preNewClient():void
{
    if (!newClient && Number(txtROLE) > 6)
    {
        clearFields();
        client = new CLIENT();
        newClient = true;
        tn.selectedIndex = 1;
        cnv_billing.enabled = false;
        cnv_notes.enabled = false;
        cnv_summary.enabled = false;
        btnPrintData.enabled = false;
        clientSTATUS.text = "";
        clientRep.text = "";
        clientSignup.text = "";
        lblSTATUS.text = "";
        ClientWindow.status = "Add New Client";
        FNAME.setFocus();
    }
}

/* private function getResultOk(r:Number,event:Event):void {
   var kount:Number = 0;
   var returnCode:Number = 0;
   switch(r)
   {
   case 1:

   break;
   }

 } */
private function loadClientNotes():void
{
    if (currentClient > 0)
        service.getClientNotes(currentClient)
}

private function clearFields():void
{
    currentClient = 0;
    clientName.text = "";
    clientAddress.text = "";
    clientAddress2.text = "";
    clientPhone.text = "";
    clientPhone2.text = "";
    clientDOB.text = "";
    clientSSN.text = "";
    clientEmail.label = "";
    clientBalance.text = "";
    clientInitial_Billing.text = "";
    clientLast_Billing.text = "";
    clientNext_Billing.text = "";
    clientCreditReport.text = "";
    clientSignup.text = "";
    com.ace.Input.Utilities.clearAll(cnv_demographic);
    com.ace.Input.Utilities.clearAll(cnv_billing);
    com.ace.Input.Utilities.clearAll(cnv_notes);
}

private function CutPasteMode():void
{
    if (client.CLIENTID > 0)
    {
        Alert.show(client.FNAME + " " + client.LNAME + "\n" + client.ADDRESS + "\n" + client.ADDRESS2 + "\n" + client.CITY + " " + client.STATE + ", " + client.ZIP, "Cut & Paste");
    }
}

private function printHistory():void
{
    if (client.CLIENTID == 0)
    {
        return;
    }
    else
    {
        var variables:URLVariables = new URLVariables();
        var request:URLRequest = new URLRequest("https://www.goodlifecredit.com/flex/reports/GLCClientHistory.cfm");
        variables.clientid = client.CLIENTID;
        request.method = "POST";
        request.data = variables;
        navigateToURL(request);
    }
} /*

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