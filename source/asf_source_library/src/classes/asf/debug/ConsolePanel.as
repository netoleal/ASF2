package asf.debug
{
	import asf.core.app.ASF;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ConsolePanel extends BasePanel
	{
		private var tf:TextField;
		private var scroll:ScrollBar;
		private var messages:uint = 0;
		private var colors:Array = [ 0, 0x999999 ];
		
		public function ConsolePanel( p_app:ASF )
		{
			super( p_app );
			
			tf = new TextField( );
			scroll = new ScrollBar( 100 );
			
			tf.width = 380;
			tf.height = 100;
			tf.mouseEnabled = false;
			tf.multiline = tf.wordWrap =  true;
			tf.defaultTextFormat = new TextFormat( "Arial", 10, colors[ messages % 2 == 0? 0: 1 ] );
			
			scroll.x = tf.x + tf.width + 10;
			
			scroll.addEventListener( Event.CHANGE, onScrollChange );
			
			addChild( tf );
			addChild( scroll );
		}
		
		private function onScrollChange( evt:Event ):void
		{
			tf.scrollV = tf.maxScrollV * scroll.getValue( );
		}
		
		public function addLog( msg:String ):void
		{
			var f:TextFormat = tf.defaultTextFormat;
			f.color = colors[ messages % 2 == 0? 0: 1 ];
			
			tf.defaultTextFormat = f;
			tf.appendText( msg + "\n" );
			
			scroll.setProportions( tf.numLines, tf.bottomScrollV - tf.scrollV );
			scroll.setValue( 1 );
			
			messages++;
		}
		
		public function clear( ):void
		{
			tf.text = "";
			messages = 0;
		}
		
		public override function get title():String
		{
			return "Console";
		}
		
		public override function get contentHeight():uint
		{
			return 120;
		}
	}
}