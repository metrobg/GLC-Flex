package com.metrobg.Classes
{
    import mx.core.Application;

    public class SecurityController
    {
        private var _application:Application;

        public function SecurityController(currentApp:Application):void
        {
            this._application = currentApp;
        }

        public function getRole(level:Number):String
        {
            var role:String;
            switch (level)
            {
                case 1:
                    role = "user";
                    break;
                case 3:
                    role = "staff";
                    break;
                case 5:
                    role = "managerII";
                    break;
                case 7:
                    role = "managerI";
                    break;
                case 9:
                    role = "administrator";
                    break;
                default:
                    role = "unk";
                    break;
            }
            return role;
        }

        public function setSecurity(level:Number):void
        {
            switch (level)
            {
                case 0:
                    _application["btnClientSave"].enabled = false;
                    _application["btnBillingSave"].enabled = false;
                    _application["btnAddNote"].enabled = false;
                    _application["cnv_demographic"].enabled = false; // tab
                    _application["cnv_billing"].enabled = false; // tab
                    //_application["report_cb"].enabled = false;
                    /*       M E N U   I T E M S   */
                    _application["dp2"].item[0].@enabled = true; //Style
                    _application["dp2"].item[1].@enabled = true; // Logout
                    _application["dp2"].item[2].@enabled = true; // Help
                    _application["dp2"].item[3].@enabled = false; // modules
                    _application["dp2"].item[3].item[0].@enabled = false; // add client
                    _application["dp2"].item[3].item[1].@enabled = false; // Sales Rep
                    _application["dp2"].item[3].item[2].@enabled = false; // user
                    _application["dp2"].item[3].item[3].@enabled = false; // adj code
                    _application["dp2"].item[3].item[4].@enabled = false; // regerral code
                    _application["dp2"].item[4].@enabled = false; // Actions
                    _application["dp2"].item[4].item[0].@enabled = false; // Send Welcome
                    _application["dp2"].item[4].item[1].@enabled = false; // Build 19
                    _application["dp2"].item[4].item[2].@enabled = false; // billing date
                    _application["dp2"].item[4].item[3].@enabled = false; // adjust balance
                    _application["dp2"].item[4].item[4].@enabled = false; // card attempts
                    _application["dp2"].item[4].item[5].@enabled = false; // Credit report status
                    _application["dgNotes"].doubleClickEnabled = false;
                    _application["dc"].enabled = false;
                    _application["nc"].enabled = false;
                    _application["aw"].enabled = false;
                    _application["cc"].enabled = false;
                    break;
                /* U S E R   U S E R   U S E R   U S E R  */
                case 1:
                    this.setSecurity(0);
                    _application["btn_search"].enabled = true;
                    _application["dp2"].item[4].@enabled = false; // Action
                    _application["dp2"].item[4].item[0].@enabled = false; // Send Welcome
                    break;
                /*       S T A F F    S T A F F   S T A F F        */
                case 3:
                    this.setSecurity(0);
                    this.setSecurity(1);
                    _application["cnv_demographic"].enabled = true;
                    _application["btnClientSave"].enabled = false;
                    _application["cnv_billing"].enabled = true;
                    _application["btnBillingSave"].enabled = false;
                    _application["dp2"].item[4].@enabled = true; // Action
                    _application["dp2"].item[4].item[0].@enabled = true; // send welcome
                    _application["dp2"].item[4].item[1].@enabled = true; // 19's download
                    _application["dgNotes"].doubleClickEnabled = true; // notes edit
                    _application["btnAddNote"].enabled = true; // notes add
                    // allow detail print 8/17/2008
                    break;
                /*  M A N A G E R II   M A N A G E R II    M A N A G E R II
                 can only inquire and add new sales reps */
                case 5:
                    this.setSecurity(0); // manager2
                    _application["dp2"].item[3].@enabled = true; // module loader
                    _application["dp2"].item[3].item[0].@enabled = false; // add client
                    _application["dp2"].item[3].item[1].@enabled = true; // Sales Rep
                    _application["dp2"].item[3].item[2].@enabled = false; // user
                    _application["dp2"].item[3].item[3].@enabled = false; // adj code
                    _application["dp2"].item[3].item[4].@enabled = false; // regerral code
                    break;
                /*  M A N A G E R     M A N A G E R      M A N A G E R   */
                case 7:
                    this.setSecurity(0);
                    this.setSecurity(1);
                    _application["cnv_demographic"].enabled = true;
                    _application["btnClientSave"].enabled = true;
                    _application["cnv_billing"].enabled = true;
                    _application["btnBillingSave"].enabled = true;
                    _application["btnAddNote"].enabled = true;
                    _application["dgNotes"].doubleClickEnabled = true;
                    _application["dp2"].item[3].@enabled = true; // module loader
                    _application["dp2"].item[3].item[0].@enabled = true; // add client
                    _application["dp2"].item[3].item[1].@enabled = true; // Sales Rep
                    _application["dp2"].item[3].item[2].@enabled = false; // user
                    _application["dp2"].item[3].item[3].@enabled = false; // adj code
                    _application["dp2"].item[3].item[4].@enabled = false; // regerral code  
                    _application["dp2"].item[4].@enabled = true; // Actions
                    _application["dp2"].item[4].item[0].@enabled = true; // send welcome
                    _application["dp2"].item[4].item[1].@enabled = true; // 19's download
                    _application["aw"].enabled = true;
                    _application["cc"].enabled = true;
                    _application["nc"].enabled = true;
                    //	_application["ccProcess_btn"].enabled = true;
                    //  _application["print_btn"].enabled = true;						// print history button
                    break;
                /* A D M I N I S T R A T O R   A D M I N I S T R A T O R   A D M I N I S T R A T O R   */
                case 9:
                    this.setSecurity(0);
                    this.setSecurity(1);
                    _application["cnv_demographic"].enabled = true;
                    _application["btnClientSave"].enabled = true;
                    _application["cnv_billing"].enabled = true;
                    _application["btnBillingSave"].enabled = true;
                    _application["btn_search"].enabled = true;
                    //_application["report_cb"].enabled = true;
                    //_application["ccProcess_btn"].enabled = true;
                    _application["dp2"].item[0].@enabled = true; // Style
                    _application["dp2"].item[1].@enabled = true; // Log Out
                    _application["dp2"].item[2].@enabled = true; // Help
                    _application["dp2"].item[3].@enabled = true; // Modules
                    _application["dp2"].item[3].item[0].@enabled = true; // add client
                    _application["dp2"].item[3].item[1].@enabled = true; // Sales Rep
                    _application["dp2"].item[3].item[2].@enabled = true; // user
                    _application["dp2"].item[3].item[3].@enabled = true; // adj code
                    _application["dp2"].item[3].item[4].@enabled = true; // regerral code    
                    _application["dp2"].item[4].@enabled = true; // Actions
                    _application["dp2"].item[4].item[0].@enabled = true; // send welcome
                    _application["dp2"].item[4].item[1].@enabled = true; // 19's download
                    _application["dp2"].item[4].item[2].@enabled = true; // billing date
                    _application["dp2"].item[4].item[3].@enabled = true; // adjust balance
                    _application["dp2"].item[4].item[4].@enabled = true; // card attempts
                    _application["dp2"].item[4].item[5].@enabled = true; // Credit report status
                    _application["btnAddNote"].enabled = true;
                    _application["dgNotes"].doubleClickEnabled = true;
                    _application["dc"].enabled = true;
                    _application["nc"].enabled = true;
                    _application["aw"].enabled = true;
                    _application["cc"].enabled = true;
                    break;
            }
        }
    } // end of class	
}