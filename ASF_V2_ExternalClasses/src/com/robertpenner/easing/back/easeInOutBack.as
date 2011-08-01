package com.robertpenner.easing.back
{
	public function easeInOutBack(t:Number, b:Number, c:Number,
									 d:Number, s:Number = 0):Number
	{
		if (!s)
			s = 1.70158; 
		
		if ((t /= d / 2) < 1)
			return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		
		return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
	}
}