package asf.fx
{
	import asf.interfaces.ISequence;

	public function stweens( p_targets:Array, p_props:Array, p_time:uint = 333, p_ease:Function = null, p_delay:uint = 0, type:String = SimpleTween.TYPE_INTERVAL ):ISequence
	{
		return SimpleTween.create().makeMultiple(p_targets, p_props, p_time, p_ease, p_delay, type );
	}
}