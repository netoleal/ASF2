package com.robertpenner.easing.elastic
{
	public function easeOutElastic(t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			if (t==0) return b;
			if ((t/=d)==1) return b+c;
			var p:Number = !Boolean(p_params) || isNaN(p_params.period) ? d*.3 : p_params.period;
			var s:Number;
			var a:Number = !Boolean(p_params) || isNaN(p_params.amplitude) ? 0 : p_params.amplitude;
			if (!Boolean(a) || a < Math.abs(c)) {
				a = c;
				s = p/4;
			} else {
				s = p/(2*Math.PI) * Math.asin (c/a);
			}
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}
}