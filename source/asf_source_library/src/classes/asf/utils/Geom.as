/**
* ...
* @author Neto Leal
* @version 0.1
*/

package  asf.utils {

	public class Geom {
		
		public static function toRadians(v:Number):Number{
			return v / 180 * Math.PI;
		}
		
		public static function toDegrees(v:Number):Number{
			return v * 180 / Math.PI;
		}
		
		public static function limitAngle( v:Number ):Number
		{
			if( v > 360 ) return 360 - v;
			else if( v < 0 ) return 360 + v;
			else return v;
		}
		
	}
	
}
