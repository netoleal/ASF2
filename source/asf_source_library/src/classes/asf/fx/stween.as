package asf.fx
{
	import asf.interfaces.ISequence;

	public function stween( p_target:*, p_props:Object, p_time:uint = 333, p_ease:Function = null, delay:uint = 0 ):ISequence
	{
		return SimpleTween.create().make( p_target, p_props, p_time, p_ease, delay );
	}
}