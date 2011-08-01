package ca.turbulent.media.events
{
	
	import flash.events.Event;

	public class TextDataEvent extends Event
	{
		public static const TEXT_DATA_RECEIVED		:String = "textDataReceived";
		public var textData							:Object;
		public var text								:String;
		
		public function TextDataEvent(type:String, txtData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			textData = txtData;
			text = textData.text;
		}
		
	}
}