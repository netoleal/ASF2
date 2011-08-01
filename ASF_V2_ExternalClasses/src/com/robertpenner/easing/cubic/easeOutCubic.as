package com.robertpenner.easing.cubic
{
	public function easeOutCubic(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return c * ((t = t / d - 1) * t * t + 1) + b;
	}
}