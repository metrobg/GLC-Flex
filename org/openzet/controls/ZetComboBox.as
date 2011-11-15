package org.openzet.controls
{
import mx.controls.ComboBox;
import mx.events.FlexEvent;
import mx.events.ListEvent;

[Event(name="itemClick", type="mx.events.ListEvent")]	
/***
 * Base ComboBox class that extends ComboBox class. This class implements features to have
 * controls such as DataGrid and Tree as its dropDownFactory class. For this purpose, in its Constructor
 * method, this class sets paddingTop and paddingBottom to zero, so no padding should show up when displaying
 * controls like a DataGrid and Tree in a dropdown view. 
 * 
 * @see org.openzet.controls.DGComboBox
 * @see org.openzet.controls.TreeComboBox
 **/
public class ZetComboBox extends ComboBox
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	/**
	 * Constructor
	 * 
	 * <p>Sets paddingTop and paddingBottom to zero lest any disturbing padding should appear.</p>
	 **/
	public function ZetComboBox()
	{
		super();
	}
	
	

 	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 * selectedItem property to track selectedItem of a DataGrid or Tree dropdown.
	 **/
	private var _selectedItem:Object;
	
    /**
	 * @private
	 **/
    override public function set selectedItem(data:Object):void {
	 	super.selectedItem = data; 
		_selectedItem = data;
		if (dropdown) dropdown.selectedItem = data;
		this.invalidateProperties();
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		invalidateDisplayList();
	}
	/**
	 * Overriden method to synchronize ComboBox's selectedItem property and dropdown's selectedItem property. 
	 **/
	override public function get selectedItem():Object {
		return _selectedItem;
	}
		
	/**
	 * @private
	 * 
	 * Height value to specify dropdown's height
	 **/
	private var _dropdownHeight:Number;
	
	
	/**
	 * @private
	 * 
	 **/
	public function set dropdownHeight(value:Number):void {
		_dropdownHeight = value;
		invalidateProperties();
	}
	
	/**
	 * Property to set dropdown's height.
	 **/
	public function get dropdownHeight():Number {
		return _dropdownHeight;
	}

	
	/**
	 * @private
	 * 
	 * Internal index property to track dropdown's selectedIndex.
	 * 
	 **/
	protected var dropdownSelectedIndex:int;
	
	 //--------------------------------------------------------------------------------
    //
    //  Overriden Event Handlers
    //
    //--------------------------------------------------------------------------------
    
	/**
	 * @private
	 * 
	 * Overriden event handler method to add a ListEvent.ITEM_CLICK event listener to a dropdown control and
	 * to reflect dropdownHeight change on a dropdown control.
	 **/
	override protected function downArrowButton_buttonDownHandler(
                                event:FlexEvent):void
    {
        if (dropdown && !isNaN(dropdownHeight)) {
        	if (dropdown.height != dropdownHeight) dropdown.height = dropdownHeight;
        }
        super.downArrowButton_buttonDownHandler(event);
        dropdown.addEventListener(ListEvent.ITEM_CLICK, dropDownItemClickHandler, false, 0, true);
    }
	
	 //--------------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------------
    /**
	 * @private
	 * 
	 * Internal event handler method to update ComboBox's selectedItem property.
	 **/
    protected function dropDownItemClickHandler(event:ListEvent):void {
    	dropdownSelectedIndex = event.rowIndex;
    	selectedIndex = event.rowIndex;
		dropdown.selectedIndex = dropdownSelectedIndex;
		selectedItem = dropdown.selectedItem;
		this.invalidateDisplayList();
    }
}
}