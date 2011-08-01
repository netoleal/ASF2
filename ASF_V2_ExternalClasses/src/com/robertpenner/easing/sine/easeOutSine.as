package com.robertpenner.easing.sine
{
	public function easeOutSine(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return c * Math.sin(t / d * (Math.PI / 2)) + b;
	}
}