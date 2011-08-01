package asf.remoting
{
	public class GatewaySingle
	{
		private static var instance:Gateway;
		
		public static function getInstance( ):Gateway
		{
			if( !instance ) instance = new Gateway( );
			return instance;
		}
	}
}