package com.robertpenner.easing.quint
{
	public function easeInQuint(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return c * (t /= d) * t * t * t * t + b;
	}
}