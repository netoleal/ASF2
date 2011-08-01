package asf.log
{
	public final class Logger
	{
		public var level:int = 0;
		private static var history:Array;
		
		public function log( message:*, mlevel:int = -1, inc:int = 0 ):String
		{
			var m:*;
			
			if( message && message.hasOwnProperty( "toString" ) )
			{
				m = message.toString( );
			}
			else if( message == null )
			{
				m = "";
			}
			else
			{
				m = message;
			}
			
			var levels:Array = new Array( );
				
			levels[ LogLevel.MUTE_0 ] = "";
			levels[ LogLevel.INFO_3 ] = "info:	";
			levels[ LogLevel.ERROR_1 ] = "error:	";
			levels[ LogLevel.WARNING_2 ] = "warning	";
			
			if( mlevel == -1 )
			{
				return _trace( "", inc, m );
			}
			
			if( mlevel <= level )
			{
				if( level == LogLevel.MUTE_0 ) return _trace( "", inc, m );
				else return _trace( levels[ mlevel ], inc, m );
			}
			
			return "";
		}
		
		public function info( message:String ):void
		{
			log( message, LogLevel.INFO_3, -1 );
		}
		
		public function warn( message:String ):void
		{
			log( message, LogLevel.WARNING_2, -1 );
		}
		
		public function error( message:String ):void
		{
			log( message, LogLevel.ERROR_1, -1 );
		}
		
		public static function _trace( prefix:String, inc:int = 0, ... args ):String
		{
			if( history == null ) history = new Array( );
			var msg:String = prefix + " " + parseMethodName( getMethodByIndex( 5 + inc ), args );
			
			history.push( msg );
			
			trace( msg );
			
			return msg;
		}
		
		public static function getHistory( ):Array
		{
			return history.concat( );
		}
		
		public static function getHistoryString( ):String
		{
			return getHistory( ).join( "\n" );
		}
		
		private static function parseMethodName( method:String, args:Array = null ):String {
			
			try {
				
				var className:String = "";
				var sMethod:String;
				
				if( method.indexOf( "$iinit" ) != -1 ){
					className = String( method.split( "$" )[ 0 ].split( "." ).pop( ) );
					sMethod = "@CONSTRUCTOR";
				} else {
					className = String( method.split( "/" )[ 0 ].split( "." ).pop( ) );
					sMethod = method.split( "/" )[ 1 ];
				}
				
				if( sMethod == null )
				{
					sMethod = "@CONSTRUCTOR";
					className = method.replace( "()", "" );
				}
				
				sMethod = sMethod.replace( "::", "" );
				sMethod = sMethod.replace( "()", "" );
				sMethod = sMethod.replace( "[", "" );
				sMethod = sMethod.replace( "]", "" );
				sMethod = sMethod.replace( " ", "" );
				
				return "[" + className + "]." + sMethod + " ( " + ( args || "" ) + " )";
			
			} 
			catch ( e:Error )
			{
				return "[Erro] " + e;
			}
			
			return "[nada]";
		}
		
		private static function getMethodName( ):String {
			
			return getMethodByIndex( 3 );
			
		}
		
		private static function getMethodByIndex( index:uint = 1 ):String {
			
			var methodName:String = "";
			
			try 
			{				
				throw new Error( "" );	
			} 
			catch( e:Error )
			{
				
				try {
					var stack:String = e.getStackTrace( );
					var errors:Array = stack.split( "\n" );
					var method:String = errors[ index ].replace( "\tat ", "" );
					
					method = method.substr( 0, method.indexOf( "[" ) );
					
					methodName = method;
				
				} catch( e:Error ){
					
					methodName = "";
					
				}
				
			}
			
			return methodName;
		}
	}
}