package com.robertpenner.easing.bounce
{
	public function easeInOutBounce (t:Number, b:Number, c:Number, d:Number):Number {
		if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
		else return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
}