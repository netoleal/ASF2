package com.robertpenner.easing.quint
{
	public function easeInOutQuint(t:Number, b:Number,
									 c:Number, d:Number):Number
	{
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t * t * t + b;

		return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
	}
}