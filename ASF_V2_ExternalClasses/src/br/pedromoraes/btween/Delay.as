package br.pedromoraes.btween
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Delay extends Sequenceable implements ISequenceable
	{

		public static var sprite:Sprite = new Sprite();

		public static function call(piTime:int = 0, ... paArgs:Array):ISequenceable {
			var seq:ISequenceable = new Delay(piTime).start();
			seq.queue.apply(0, paArgs);
			return seq;
		}

		private var time:int;
		private var startTime:int;

		public function Delay(piTime:int = 0)
		{
			time = piTime;
			super();
		}

		public override function start(...paParams):ISequenceable
		{
			startTime = getTimer();
			sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new BTweenEvent(BTweenEvent.START));
			return this;
		}
		
		public override function stop():ISequenceable
		{
			sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			return this;
		}
		
		private function onEnterFrame(pEvt:*=null):void
		{
			if (getTimer() - startTime >= time)
			{
				stop();
				dispatchEvent(new BTweenEvent(BTweenEvent.COMPLETE));
			}
		}
	}
}