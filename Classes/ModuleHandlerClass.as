package com.metrobg.Classes
{
	import mx.core.Application;
	import mx.controls.Alert;
	import mx.modules.ModuleLoader;
	import mx.events.ModuleEvent;
	
public class ModuleHandlerClass {
	
 private var _application:Application;
 public var openModules:Number = 0;
 	 
public function ModuleHandlerClass(currentApp:Application) {	
	this._application = currentApp;
}
		
public function addModule(strModuleFile:String,mdlModule:ModuleLoader):String {
		var strModuleURL:String =  strModuleFile
		mdlModule.url = strModuleURL;
		_application["progress"].visible = true;
	    _application["progress"].source = mdlModule;
		mdlModule.loadModule();	
		
		return '';
}		
	 
public function closeModule(strModule:String):void {
			var mdlModule:ModuleLoader = _application[strModule];
			mdlModule.unloadModule();
			mdlModule.url = null;
			//_application["currentState"] = Application.application.variables.currentState;
	   		_application["currentState"] = _application["variables"].currentState;
	   		openModules--;
} 

public function errorHandler(strModule:String,e:ModuleEvent):void {
	Alert.show("There was an error loading the module." + 
	    	   " Please contact the Help Desk.");
	closeModule(strModule);
	_application["progress"].visible = false;
	_application["progress"].source = null;
	_application["progress"].setProgress(0,0);
	
}
		
public function getNextModule():String {
	var strNewModule:String = null;
		for (var i:int=0;i<10;i++) {
		  if (_application["module"+i.toString()].url == null) {
			strNewModule = "module"+i.toString()
			break
		 }
	}
	if (strNewModule == null) {
		Alert.show("Too many modules are open, please close some and try again.");
	}
	return strNewModule;

}

private function ModuleFocus(strModule:String):void {
	var mdlModule:ModuleLoader = this[strModule.substr(strModule.indexOf(".")+1)];
	mdlModule.visible;
	
}

public function moduleLoadDone(mdlModule:ModuleLoader):void {
	_application["progress"].visible = false;
	_application["progress"].source = null;
	_application["progress"].setProgress(0,0);
	openModules++;
}
	
	}
}