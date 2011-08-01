package com.app
{
	import asf.core.app.ASF;
	import asf.interfaces.IMainController;
	import asf.utils.Delay;
		
	import com.LeonardoPinho.asf.core.ASFSWFAdress;
	import com.LeonardoPinho.asf.events.AppEvent;
	import com.LeonardoPinho.events.ResultEvents;
	import com.LeonardoPinho.utils.About;
	
	import flash.events.Event;
	
	public class MainController implements IMainController
	{
		private var app:ASF;
		public var swfAdress:ASFSWFAdress;
	
		public function init( p_app:ASF ):void
		{
			//info app 
			About.info( p_app.params.title, p_app.params.startDate, p_app.params.developer );
			
			app = p_app;
				
			app.navigation.openSection( { sectionID: "indexSection" } );
			app.navigation.openSection( { sectionID: "navSection"} );
			
			//swfAdress
			if(p_app.params.swfAdress == "true"){
				app.navigation.closeSection({ sectionID: "homeSection" });
				
				swfAdress = new ASFSWFAdress(p_app);
				app.addEventListener( AppEvent.ASF_SWFADRESS, swfAdressActive );
				app.addEventListener( AppEvent.CURRENT_SECTION, currentSection );
				
			} else {
				app.navigation.openSection( { sectionID: "homeSection" } );
			}
			
		}
		
		public function swfAdressActive(e:ResultEvents):void
		{
			if(e.result == ""){
				swfAdress.branch("home");
				app.navigation.openSection( { sectionID: "homeSection" } );
			}
		}
		
		public function currentSection(e:ResultEvents):void
		{
			var name:Number = e.result.length;
			var branch:String = String(e.result).substr(0,name-8);
			swfAdress.branch(branch);
		}
				
		public function dispose():void
		{
			app = null;
		}
	}
}