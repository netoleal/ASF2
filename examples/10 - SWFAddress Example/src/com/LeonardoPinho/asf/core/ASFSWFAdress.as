package com.LeonardoPinho.asf.core
{
	import asf.core.app.ASF;
	
	import com.LeonardoPinho.asf.events.AppEvent;
	import com.LeonardoPinho.events.ResultEvents;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class ASFSWFAdress
	{
		public var app:ASF;
		public var validBranch:Array = [];
				
		public function ASFSWFAdress(param:ASF)
		{
			app = param;
			validBranch = app.navigation.sectionsIDs.toString().split(",");	
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, urlAdress);	
		}
			
		public function branch(value:String):void
		{
			if (isValid(value)) 
			{
				SWFAddress.setValue(value);
				if(ExternalInterface.available == true){
					ExternalInterface.call('function(str){top.document.title = str;} ', app.params.title + ": " + value.substr(0,1).toUpperCase()+value.substr(1,value.length-1)) 
				}
			}
						
		}
		
		private function isValid(branch:String):Boolean
		{
			var value:Boolean;
			
			for (var i:int = 0; i < validBranch.length; i++) 
			{
				if(branch+"Section" == validBranch[i]){
					value = true;
				}
			}
			
			return value;
		}
				
		public function urlAdress(e:SWFAddressEvent):void
		{
			app.dispatchEvent(new ResultEvents(AppEvent.ASF_SWFADRESS, false, false, e.pathNames[0]));
			app.navigation.openSection( { sectionID: e.pathNames[0]+"Section"} );				
		}
				
		
	}
}