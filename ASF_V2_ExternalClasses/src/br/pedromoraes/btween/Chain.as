package br.pedromoraes.btween
{
	
	public class Chain extends Sequenceable implements ISequenceable
	{

		protected var _list:Array;
		
		public function Chain(... paList:Array)
 		{
 			list = paList;
 		}

 		public function get list():Array
 		{
 			return _list;
 		}

 		public function set list(paList:Array):void
 		{
 			_list = paList;
 			recurse(_list)
 		}

		public override function start(... paList:Array):ISequenceable
		{
			if (paList.length > 0) list = paList;
			if (_list[0])
			{
				_list[0].start();
				dispatchEvent(new BTweenEvent(BTweenEvent.START));
			}
			return this;
		}
		
		public override function stop():ISequenceable
		{
			var item:ISequenceable;
			var current:ISequenceable = this;  
			for (var i:int = 0; i < _list.length; i ++)
			{
				item = _list[i];
				current.removeEventListener(BTweenEvent.COMPLETE, item.start)
				item.removeEventListener(BTweenEvent.UPDATE, onUpdate);
				item.stop();
				current = item;
			}
			if (item) item.removeEventListener(BTweenEvent.COMPLETE, onComplete);
			return this;
		}
		
		protected function recurse(paList:Array, pStarter:ISequenceable = null):ISequenceable
		{
			var l:Array = paList;
			var item:Object;
			var current:ISequenceable = pStarter;  
			for (var i:int = 0; i < l.length; i ++)
			{
				item = l[i];
				if (item is Function)
				{
					item = new Call(item as Function, []);
				}
				else if (item is Number || item is int)
				{
					item = new Delay(int(item))
				}
				else if (item is Array)
				{
					item = recurse(item as Array, current || this); 
				}

				if (item is ISequenceable)
				{
					item.addEventListener(BTweenEvent.UPDATE, onUpdate);
					if (pStarter)
					{
						pStarter.queue(item);
					}
					else if (current)
					{
						current.queue(item);
					}
					current = item as ISequenceable;
				}
				l[i] = item;
			}
			if (item) item.addEventListener(BTweenEvent.COMPLETE, onComplete);
			return item as ISequenceable;
		}
		
		protected function onUpdate(pEvt:BTweenEvent):void
		{
			dispatchEvent(new BTweenEvent(BTweenEvent.UPDATE));
		}
		
		protected function onComplete(pEvt:BTweenEvent):void
		{
			dispatchEvent(new BTweenEvent(BTweenEvent.COMPLETE));
		}

	}
}