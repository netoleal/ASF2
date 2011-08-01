package com.robertpenner.easing.cubic
{
	public function easeInOutCubic(t:Number, b:Number,
									 c:Number, d:Number):Number
	{
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t + b;

		return c / 2 * ((t -= 2) * t * t + 2) + b;
	}
}