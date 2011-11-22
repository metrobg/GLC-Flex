// ActionScript file
// AgentMaintenance.mxml
import mx.collections.ArrayCollection;
import mx.events.*;
import mx.controls.Alert;
import com.metrobg.Icons.Images;
import ascb.util.*;
import mx.rpc.http.HTTPService;

[Bindable]
public var myAC:ArrayCollection = new ArrayCollection;

[Bindable]
public var mode:String = 'update';

[Bindable]
private var random:Number;

private var newKey:Number;

private var activeRecord:Number;

private var returnCode:Number;

private function makeRandom(service:mx.rpc.http.HTTPService):void
{
    random = NumberUtilities.getUnique();
    service.send();
}

private function getResultOk(r:Number, event:Event):void
{
    var kount:Number = 0;
    var returnCode:Number = 0;
    switch (r)
    {
        case 1:
            //  this.statusTextField = getCodes.lastResult.codes.recordcount + " Record(s) found";
            /* case 1:
               myAC = getCodes.lastResult.codes.code;
               resultGrid.dataProvider = myAC;
               panel1.status = getCodes.lastResult.codes.recordcount + " Records found";
             break; */
            kount = Number(getCodes.lastResult.codes.recordcount);
            if (kount == 0)
            {
                Alert.show('No Matching Record found', "Attention", 0, this, null, Images.badIcon, 0);
                break;
            }
            else if (kount > 1)
            {
                myAC = getCodes.lastResult.codes.code;
                resultGrid.dataProvider = myAC;
                    //statusTextField. = getCodes.lastResult.codes.recordcount + " Records found";
            }
            else
            {
                myAC.removeAll();
                addItemToGrid(getCodes.lastResult.codes.code)
            }
            break;
        case 2:
            returnCode = updateCode.lastResult.root.status;
            if (Number(returnCode) == 2)
            {
                Alert.show("Problem updating Record", "Error", 3, this, null, Images.warningIcon2);
            }
            else
            {
                Alert.show("Record updated", "Success", Alert.OK, this, null, Images.okIcon);
                updateGrid(updateCode);
            }
            break;
        case 3:
            returnCode = addCode.lastResult.root.status;
            if (Number(returnCode) == 2)
            {
                Alert.show("Problem adding record", "Error");
            }
            else
            {
                addItemToGrid(addCode.lastResult.root.code);
                Alert.show("Record Added", "Success", Alert.OK, this, null, Images.okIcon);
                break;
            }
        case 4:
            returnCode = deleteCode.lastResult.root.status;
            if (Number(returnCode) == 2)
            {
                Alert.show("Problem deleting Record", "Error", Alert.OK, this, null, Images.warningIcon2);
            }
            else
            {
                Alert.show("Record Deleted", "Success", Alert.OK, this, null, Images.okIcon);
                // removeItemFromGrid(activeRecord);
                makeRandom(getCodes);
                break;
            }
        case 999:
            Alert.show("Unknown Error", "Attention", Alert.OK, this, null, Images.stopIcon);
            break;
    }
}

private function gridItemSelected(event:ListEvent):void
{
    activeRecord = event.rowIndex - 1;
    mode = 'update';
    delete_btn.enabled = true;
}

private function buttonHandler(value:String):void
{
    if (value == 'delete')
        mode = 'delete';
    if (value == 'save')
        mode = 'update';
    switch (mode)
    {
        case "update":
            makeRandom(updateCode);
            break;
        case 'add':
            if (description_fld.text != '')
            {
                makeRandom(addCode);
            }
            else
            {
                Alert.show("Blank fields not allowed", "Error", 0, this, null, Images.stopIcon);
            }
            break;
        case 'delete':
            codeDelete();
            break;
    }
}

private function alertClickHandler(event:CloseEvent):void
{
    if (event.detail == Alert.YES)
    {
        makeRandom(deleteCode);
    }
}

private function addRecord():void
{
    description_fld.text = '';
    position_ns.value = 1;
    mode = 'add';
    delete_btn.enabled = false;
}

private function addItemToGrid(obj:Object):void
{
    myAC.addItem(obj);
    resultGrid.dataProvider = myAC;
    myAC.refresh();
}

private function removeItemFromGrid(position:Number):void
{
    myAC.removeItemAt(position);
    resultGrid.dataProvider = myAC;
    myAC.refresh();
}

private function codeDelete():void
{
    mode = 'delete';
    //   Alert.show("Delete Code " + code_fld.text.toUpperCase(), "Really Delete", 3, this, alertClickHandler);
    Alert.show("Delete Code " + description_fld.text, "Really Delete", 3, this, alertClickHandler, Images.warningIcon2);
}

private function updateGrid(obj:Object):void
{
    if (this.resultGrid.selectedItem !== null)
    {
        makeRandom(getCodes);
            // myAC.setItemAt({ id: obj.lastResult.root.code.id, description: obj.lastResult.root.code.description, position: obj.lastResult.root.code.position }, activeRecord);
            // myAC.refresh();
    }
}