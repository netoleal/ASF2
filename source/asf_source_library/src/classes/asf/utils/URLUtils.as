package asf.utils
{
	public class URLUtils
	{
		public static function getQueryStringParam( name:String ):String
		{
			var url:Array = SWFAddress.getBaseURL( ).split( "?" );		
			var query:String;
			var paramValue:String = "";
			var params:Array;
			var param:String;
			
			if( url.length == 1 ) return paramValue;
			
			query = url[ 1 ];
			params = query.split( "&" );
			
			for each( param in params )
			{
				if( String( param.split( "=" )[ 0 ] ).toLowerCase( ) == name.toLowerCase( ) )
				{
					paramValue = param.split( "=" )[ 1 ];
					return paramValue;
				}
			}
			
			return paramValue;
		}
		
		public static function noCacheFile( filePath:String ):String
		{
			var noCache:String = String( new Date( ).getTime( ) );
			if( filePath.indexOf( "?" ) == -1 )
			{
				filePath = filePath + "?" + noCache;
			}
			else
			{
				filePath = filePath + "&" + noCache;
			}
			
			return filePath;
		}
		
		public static function getLinkByLevel( level:uint = 1 ):String
		{
			 return getLinkByIndex( level - 1 );
		}
		
		public static function getLinkByIndex( index:uint = 0 ):String
		{
			var levels:Array;
			
			levels = link.split( "/" );
			
			if( levels.length - 1 < index ) return "";
			
			return levels[ index ];
		}
		
		public static function getLastLink( ):String
		{
			return getLinkByLevel( numLevels );
		}
		
		public static function get numLevels( ):uint
		{
			return link.split( "/" ).length;
		}
		
		public static function get link( ):String
		{
			var link:String = SWFAddress.getValue( );
			
			if( link.indexOf( "/" ) == -1 ) return link;
			if( link.indexOf( "/" ) == 0 ) link = link.substr( 1 );
			
			return link;
		}
	}
}