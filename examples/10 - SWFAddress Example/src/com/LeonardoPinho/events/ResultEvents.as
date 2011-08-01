package com.LeonardoPinho.events 
{
	import flash.events.Event;
	
	public class ResultEvents extends Event 
	{
		public static const XML_LOADED:String = "xml carregado";
		public static const STAGE_RESIZE:String = "resize stage";
				
		public var result:*;
		
		public function ResultEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false, ... param: * )
		{ 
			super(type, bubbles, cancelable);
			result = param;			
		} 
		
		public override function clone():Event 
		{ 
			return new ResultEvents(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ResultEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}