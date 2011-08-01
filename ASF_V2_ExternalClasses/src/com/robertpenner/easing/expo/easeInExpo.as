package com.robertpenner.easing.expo
{
	public function easeInExpo(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
	}
}