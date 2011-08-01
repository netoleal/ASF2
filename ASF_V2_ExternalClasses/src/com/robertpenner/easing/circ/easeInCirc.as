package com.robertpenner.easing.circ
{
	public function easeInCirc(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
	}
}