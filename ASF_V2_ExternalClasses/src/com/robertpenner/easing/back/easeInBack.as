package com.robertpenner.easing.back
{
	public function easeInBack(t:Number, b:Number, c:Number,
								  d:Number, s:Number = 0):Number
	{
		if (!s)
			s = 1.70158;
		
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
	}
}