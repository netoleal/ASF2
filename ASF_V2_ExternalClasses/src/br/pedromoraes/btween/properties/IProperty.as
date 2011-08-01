package br.pedromoraes.btween.properties
{
	import br.pedromoraes.btween.BTween;
	
	public interface IProperty
	{

		function get target():Object;
		function set target(pTarget:Object):void;

		function update(pTween:BTween, piElapsed:int):void
		
		function reverse():void
		
		function clone():IProperty

	}
}