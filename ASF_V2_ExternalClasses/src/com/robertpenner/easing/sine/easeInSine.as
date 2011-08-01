package com.robertpenner.easing.sine
{
	public function easeInSine(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
	}

}