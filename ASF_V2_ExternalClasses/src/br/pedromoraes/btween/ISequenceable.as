package br.pedromoraes.btween
{
	import flash.events.IEventDispatcher;
	
	public interface ISequenceable extends IEventDispatcher
	{

		function start(... paParams:Array):ISequenceable

		function stop():ISequenceable
		
		function queue(pObj:Object = null, ... paParams:Array):ISequenceable
		
		function back(pTransition:Function = undefined):ISequenceable

		function change(pParams:Object):ISequenceable
		
		function evt(evt:String,handler:Function):ISequenceable

	}
}