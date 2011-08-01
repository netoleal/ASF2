/**
 * Class com.ford.focus.drive.events.InOutEvent
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 2:45:08 PM
 *
 **/
package asf.events
{
	import flash.events.Event;
	
	public class InOutEvent extends Event
	{
		public static const IN_START:String = "inStart";
		public static const IN_END:String = "inEnd";
		
		public static const OUT_START:String = "outStart";
		public static const OUT_END:String = "outEnd";
		
		public function InOutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}