package br.pedromoraes.btween
{
	import flash.events.Event;

	public class BTweenEvent extends Event
	{
		
		public static var START:String = "start";
		public static var UPDATE:String = "update";
		public static var COMPLETE:String = "complete";
		
		public function BTweenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			var copy:BTweenEvent = new BTweenEvent(type, bubbles, cancelable);
			return copy;
		}
	}
}