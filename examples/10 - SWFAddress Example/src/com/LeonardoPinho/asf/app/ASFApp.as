package com.LeonardoPinho.asf.app
{
	import asf.core.app.ASF;
	
	public class ASFApp extends Object
	{
		private static var _application:ASF;
		
		public static function set application(_app:ASF):void
		{
			_application = _app;
		}
		
		public static function get app():ASF{
			return _application;			
		}
	}
}