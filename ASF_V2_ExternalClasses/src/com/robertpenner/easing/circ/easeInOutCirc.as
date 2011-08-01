package com.robertpenner.easing.circ
{
	public function easeInOutCirc(t:Number, b:Number,
									 c:Number, d:Number):Number
	{
		if ((t /= d / 2) < 1)
			return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;

		return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
	}

}