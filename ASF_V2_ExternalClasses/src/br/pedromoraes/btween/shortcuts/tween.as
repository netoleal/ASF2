package br.pedromoraes.btween.shortcuts
{
	import br.pedromoraes.btween.BTween;

	public function tween( time : int = -1, transition : Function = null, delay : int = 0, rounded : Boolean = false, name : String = "" ) : BTween
	{
		return new BTween( time, transition, delay, rounded, name );
	}
}