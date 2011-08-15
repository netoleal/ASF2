// ActionScript file
package
{
	import asf.log.Logger;
	
	import flash.external.ExternalInterface;

	/**
	 * Função útil que executa traces marcando sua origem. Por exemplo:
	 * 
	 * <pre>
	 * package utils
	 * {
	 * 		class Test
	 * 		{
	 * 			public function aMethod( ):void
	 * 			{
	 * 				log( "hello!" ); // output: [utils::Test].aMethod( hello );
	 * 			}
	 * 		}
	 * }
	 * 
	 * </pre> 
	 * 
	 * Bastante útil para substituir o trace e ter seu painel de console bem marcado.
	 * Internamente ela usa o stack de um erro para mapear de onde veio a chamada da função.
	 * <br/>
	 * Adicionalmente a log tenta executar o método console.log via ExternalInterface no Browser
	 */
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