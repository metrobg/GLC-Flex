
package com.ace.FooterDataGrid
{
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;

 	[DefaultProperty("footer")]
	public class FooterDataGrid extends DataGrid implements IFooterDataGrid
	{
		include "_footerDataGrid.as";
 
		public function createListData(text:String, dataField:String, i:int):BaseListData
		{
			return new DataGridListData(text, dataField, i, null, this, -1);
		}
	}
}
