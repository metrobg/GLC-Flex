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
                    // run state	 LOGOUT
                    /*  I M A G E   I C O N S   */
                    _application["aw"].visible = false;
                    _application["dl"].visible = false;
                    /*    B U T T O N S   */
                    _application["ccProcess_btn"].enabled = false;
                    _application["editClient_btn1"].enabled = false;
                    _application["editBilling_btn1"].enabled = false;
                    _application["history_btn"].enabled = false;
                    _application["listPrint_btn"].enabled = false;
                    _application["printBilling_btn"].enabled = false;
                    _application["print_btn"].enabled = false;
                    //_application["run_btn"].enabled = false;			
                    _application["saveBilling_btn"].enabled = false;
                    _application["saveClient_btn"].enabled = false;
                    _application["search_btn"].enabled = false;
                    /*     C O M B O  B O X E S        */
                    _application["menu_pm"].visible = false;
                    //_application["report_cb"].enabled = false;
                    /*       M E N U   I T E M S   */
                    _application["dp2"].item[0].@enabled = false;
                    _application["dp2"].item[1].@enabled = false;
                    _application["dp2"].item[2].@enabled = false;
                    _application["dp2"].item[3].@enabled = false;
                    _application["dp2"].item[4].@enabled = false;
                    break;
                /* U S E R   U S E R   U S E R   U S E R  */
                case 1:
                    this.setSecurity(0);
                    _application["menu_pm"].visible = false;
                    _application["menu_pm"].enabled = true;
                    _application["search_btn"].enabled = true;
                    _application["dp2"].item[0].@enabled = true;
                    break;
                /*       S T A F F    S T A F F   S T A F F        */
                case 3:
                    this.setSecurity(0);
                    this.setSecurity(1);
                    _application["editClient_btn1"].enabled = true;
                    _application["saveClient_btn"].enabled = false;
                    _application["editBilling_btn1"].enabled = true;
                    _application["saveBilling_btn"].enabled = false;
                    _application["dp2"].item[2].@enabled = true; // misc
                    _application["dp2"].item[2].editItem[0].@enabled = true; // send welcome
                    _application["dp2"].item[3].@enabled = true; // downloads 
                    _application["dp2"].item[3].editItem[0].@enabled = true; // 19's download
                    _application["dp2"].item[3].editItem[1].@enabled = false; // IDA fraud alerts
                    // allow detail print 8/17/2008
                    _application["printBilling_btn"].enabled = true;
                    break;
                /*  M A N A G E R II   M A N A G E R II    M A N A G E R II */
                case 5: // manager2
                    this.setSecurity(1);
                    _application["dp2"].item[1].@enabled = true; // module loader
                    _application["dp2"].item[1].editItem[1].@enabled = true; // add agent
                    _application["dp2"].item[1].editItem[0].@enabled = false;
                    _application["dp2"].item[1].editItem[2].@enabled = false;
                    _application["dp2"].item[1].editItem[3].@enabled = false;
                    _application["dp2"].item[1].editItem[4].@enabled = false;
                    break;
                /*  M A N A G E R     M A N A G E R      M A N A G E R   */ /*
                   case 7:																// manager2
                   this.setSecurity(1);
                   _application["dp2"].item[1].@enabled = true;					// module loader
                   _application["dp2"].item[1].editItem[1].@enabled = true;		// add agent
                   _application["dp2"].item[1].editItem[0].@enabled = false;
                   _application["dp2"].item[1].editItem[2].@enabled = false;
                   _application["dp2"].item[1].editItem[3].@enabled = false;
                   _application["dp2"].item[1].editItem[4].@enabled = false;

                   _application["ccProcess_btn"].enabled = false;
                   break;
                 */
                case 7: // manager2
                    this.setSecurity(9);
                    _application["dp2"].item[1].@enabled = true; // module loader
                    _application["dp2"].item[1].editItem[1].@enabled = true; // add agent
                    _application["dp2"].item[1].editItem[0].@enabled = true; // sales rep
                    _application["dp2"].item[1].editItem[2].@enabled = false; // admin user
                    _application["dp2"].item[1].editItem[3].@enabled = false; // adjustment codes
                    _application["dp2"].item[1].editItem[4].@enabled = false; // referral codes         
                    _application["ccProcess_btn"].enabled = true;
                    _application["print_btn"].enabled = true; // print history button
                    _application["nc"].enabled = true; // new client icon
                    break;
                /* A D M I N I S T R A T O R   A D M I N I S T R A T O R   A D M I N I S T R A T O R   */
                case 9:
                    _application["editClient_btn1"].enabled = true;
                    _application["editBilling_btn1"].enabled = true;
                    _application["menu_pm"].enabled = true;
                    _application["editBilling_btn1"].enabled = true;
                    _application["editClient_btn1"].enabled = true;
                    _application["dl"].visible = true;
                    _application["aw"].visible = true;
                    _application["listPrint_btn"].enabled = true;
                    _application["print_btn"].enabled = true;
                    _application["search_btn"].enabled = true;
                    //_application["report_cb"].enabled = true;
                    _application["ccProcess_btn"].enabled = true;
                    _application["saveBilling_btn"].enabled = true;
                    _application["printBilling_btn"].enabled = true;
                    _application["saveClient_btn"].enabled = true;
                    _application["dp2"].item[0].@enabled = true; // mainview
                    _application["dp2"].item[1].@enabled = true; // module loader
                    _application["dp2"].item[2].@enabled = true; // miscellaneous
                    _application["dp2"].item[3].@enabled = true; // downloads
                    _application["dp2"].item[4].@enabled = false; // styles
                    break;
            }
        }
    } // end of class	
}