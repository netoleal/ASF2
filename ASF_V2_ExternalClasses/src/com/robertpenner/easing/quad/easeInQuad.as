package com.robertpenner.easing.quad
{
	public function easeInQuad(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return c * (t /= d) * t + b;
	}
}