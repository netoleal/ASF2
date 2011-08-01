package br.pedromoraes.btween
{
	import flash.events.EventDispatcher;

	public class Sequenceable extends EventDispatcher implements ISequenceable
	{

		public function start(... paParams:Array):ISequenceable
		{
			return null;
		}

		public function change(pParams:Object):ISequenceable
		{
			for (var lsProp:String in pParams)
			{
				if (hasOwnProperty(lsProp))
				{
					this[lsProp] = pParams[lsProp];
				}
			}
			return this;
		}

		public function back(pTransition:Function = undefined):ISequenceable
		{
			return null;
		}
		
		public function stop():ISequenceable
		{
			return null;
		}

		public function queue(pObj:Object = null, ... paParams:Array):ISequenceable
		{
			if (pObj is ISequenceable)
			{
				addEventListener(BTweenEvent.COMPLETE, pObj.start);
				return pObj as ISequenceable;
			}
			else if (pObj is Function)
			{
				var call:Call = new Call(pObj as Function, paParams);
				addEventListener(BTweenEvent.COMPLETE, call.start);
				return call;
			}
			else if (pObj is Array)
			{
				var seq : ISequenceable;
				for each ( var item : * in pObj )
				{
					seq = queue( item );
				}
				return seq;
			}
			else if (pObj is Number)
			{
				var delay:Delay = new Delay(pObj as Number);
				addEventListener(BTweenEvent.COMPLETE, delay.start);
				return delay;
			}
			return null;
		}
		
		public function evt(evt:String,handler:Function):ISequenceable
		{
			addEventListener(evt, handler);
			return this;
		}
		
	}
}