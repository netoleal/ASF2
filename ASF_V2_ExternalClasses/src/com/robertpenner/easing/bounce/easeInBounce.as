package com.robertpenner.easing.bounce
{
	public function easeInBounce (t:Number, b:Number, c:Number, d:Number):Number {
		return c - easeOutBounce (d-t, 0, c, d) + b;
	}
}