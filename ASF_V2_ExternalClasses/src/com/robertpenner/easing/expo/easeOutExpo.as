package com.robertpenner.easing.expo
{
	public function easeOutExpo(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return t == d ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
	}
}