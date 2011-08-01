package com.robertpenner.easing.quad
{
	public function easeOutQuad(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return -c * (t /= d) * (t - 2) + b;
	}
}