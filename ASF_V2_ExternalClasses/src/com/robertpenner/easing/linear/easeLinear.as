package com.robertpenner.easing.linear
{
	public function easeLinear(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return c * t / d + b;
	}

}