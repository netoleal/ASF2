package asf.remoting
{
	import flash.net.NetConnection;
	import flash.utils.*;

	dynamic public class Gateway extends Proxy
	{
		private var connection:NetConnection;
		private var _namespacePath:String;
		
		private var gurl:String;
		private var closed:Boolean = true;
		
		public function Gateway( p_gatewayURL:String = "", p_namespacePath:String = "" )
		{
			super( );
			
			this.namespacePath = p_namespacePath;
			this.gurl = p_gatewayURL;
			
			connection = new NetConnection( );
			connect( );
		}
		
		public function set objectEncoding( value:int ):void
		{
			connection.objectEncoding = value;
		}
		
		public function get objectEncoding( ):int
		{
			return connection.objectEncoding;
		}
		
		private function connect( ):void
		{
			if( !closed ) return;
			if( gurl != "" )
			{
				connection.connect( gurl );
				closed = false;
			}
		}
		
		public function set gatewayURL( value:String ):void
		{
			gurl = value;
			
			try
			{
				connection.close( );
			}
			catch( e:Error )
			{}
			
			connect( );
		}
		
		public function get gatewayURL( ):String
		{
			return gurl;
		}
		
		public function set namespacePath( value:String ):void
		{
			this._namespacePath = value;
			
			if( _namespacePath != "" && _namespacePath.substr( -1 ) != "." ) _namespacePath += ".";
		}
		
		public function get namespacePath( ):String
		{
			return _namespacePath;
		}
		
		public function close( ):void
		{
			try
			{
				connection.close( );
			}
			catch( e:Error )
			{ }
			
			closed = true;
		}
		
		
		
		override flash_proxy function callProperty( name:*, ...rest ):*
		{
			return ( call as Function ).apply( null, [ namespacePath + name ].concat( rest ) );
		}
		
		public function call( methodWithFullService:String, ... rest ):ServiceResponder
		{
			if( gurl == "" )
			{
				throw new Error( "[remoting.Gateway] ERROR Gateway URL must not be empty" );
				return null;
			}
			
			connect( );
			
			var responder:ServiceResponder = new ServiceResponder( this );
			//var methodName:String = ( ( servicePath != "" )? servicePath: namespacePath ) + p_methodName;
			
			( connection.call as Function ).apply( null, [ methodWithFullService , responder ].concat( rest ) );
			 
			return responder;
		}
		
		override flash_proxy function getProperty( name:* ):*
		{
			throw new Error( "There is no property called: " + name + " in [Gateway]" );
			return null;
		}
	}
}