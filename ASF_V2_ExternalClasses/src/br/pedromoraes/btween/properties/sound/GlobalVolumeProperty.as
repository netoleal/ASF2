package br.pedromoraes.btween.properties.sound
{
        import br.pedromoraes.btween.BTween;
        import br.pedromoraes.btween.properties.IProperty;
        
        import flash.media.SoundMixer;
        import flash.media.SoundTransform;

        public class GlobalVolumeProperty implements IProperty
        {
                
                public var startValues:Object;

                private var index:Number;

                public var volume:Number;
                
                public function get target() : Object { return null }
                public function set target( value : Object ) : void {}

                public function GlobalVolumeProperty( pnVolume:Number )
                {
                        volume = pnVolume;
                }

                public function update(pTween:BTween, piElapsed:int):void
                {
                        if (!startValues) init();
                        index = pTween.getValue(0, 1, piElapsed);

                        SoundMixer.soundTransform = new SoundTransform(startValues.volume + (volume - startValues.volume) * index);
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
                        return new GlobalVolumeProperty( volume );
                }

                private function init():void
                {
                        startValues = {volume:SoundMixer.soundTransform.volume};
                }

        }
}