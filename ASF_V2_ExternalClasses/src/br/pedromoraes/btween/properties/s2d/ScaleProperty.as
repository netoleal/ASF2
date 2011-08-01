package br.pedromoraes.btween.properties.s2d
{
	import br.pedromoraes.btween.properties.BaseProperty;

	public class ScaleProperty extends BaseProperty
	{

		public function ScaleProperty(pTarget:Object, pnScaleX:Number, pnScaleY:Number):void
		{
			super(pTarget, { scaleX : pnScaleX,	scaleY : pnScaleY });
		}

	}

}