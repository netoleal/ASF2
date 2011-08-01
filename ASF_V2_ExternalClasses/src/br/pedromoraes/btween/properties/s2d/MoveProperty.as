package br.pedromoraes.btween.properties.s2d
{
	import br.pedromoraes.btween.properties.BaseProperty;

	public class MoveProperty extends BaseProperty
	{

		public function MoveProperty(pTarget:Object, pnX:Number, pnY:Number):void
		{
			super(pTarget, { x : pnX, y : pnY });
		}

	}

}