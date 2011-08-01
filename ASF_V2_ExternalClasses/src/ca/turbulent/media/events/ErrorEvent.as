package ca.turbulent.media.events
{
	import flash.events.Event;

	public class ErrorEvent extends Event
	{
		
		
		public static const CONNECTION_ERROR				:String				= "connectionErrorEvent";
		public static const ERROR							:String				= "errorEvent";
		public static const FILE_NOT_FOUND_ERROR			:String				= "streamNotFoundErrorEvent";
		public static const SECURITY_ERROR					:String 			= "securityErrorEvent";
		
		public var errorObject								:Object;
		public var errorMessage								:String				= ""; 
		
		public function ErrorEvent(type:String, errorMsg:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			errorMessage = errorMsg;
		}
		
		override public function clone():Event { return new ErrorEvent(this.type, errorMessage, false, false); }
	}
}