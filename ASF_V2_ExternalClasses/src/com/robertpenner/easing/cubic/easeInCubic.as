package com.robertpenner.easing.cubic
{
	public function easeInCubic(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return c * (t /= d) * t * t + b;
	}
}