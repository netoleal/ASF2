package br.pedromoraes.btween.properties.sound
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class VolumeProperty implements IProperty
	{
		
		public var startValues:Object;

		private var index:Number;

		public var volume:Number;

		protected var _target:SoundChannel;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as SoundChannel }
		
		public function VolumeProperty(pTarget:SoundChannel, pnVolume:Number)
		{
			_target = pTarget;
			volume = pnVolume;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			_target.soundTransform = new SoundTransform(startValues.volume + (volume - startValues.volume) * index);
		}

		public function reverse():void
		{
			if (!startValues) init();
			var rev:Object = {volume:volume};
			volume = startValues.soundTransform.volume;
			startValues = rev;
		}

		public function clone():IProperty
		{
			return new VolumeProperty(_target, volume);
		}

		private function init():void
		{
			startValues = {volume:_target.soundTransform.volume};
		}

	}
}