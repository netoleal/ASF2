// ActionScript file
package
{
	import asf.log.Logger;
	
	import flash.external.ExternalInterface;

	public function log( ... args ):void
	{
		var msg:String = Logger._trace( "", -1, args );
		
		try
		{
			ExternalInterface.call( "console.log", msg );
		}
		catch( e:Error )
		{}
	}
}