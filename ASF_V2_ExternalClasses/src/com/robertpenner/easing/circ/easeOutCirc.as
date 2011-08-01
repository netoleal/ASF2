package com.robertpenner.easing.circ
{
	public function easeOutCirc(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return c * Math.sqrt(1 - (t = t/d - 1) * t) + b;
	}
}