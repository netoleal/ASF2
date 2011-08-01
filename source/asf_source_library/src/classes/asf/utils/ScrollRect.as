package asf.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class ScrollRect
	{
		private var t:DisplayObject;
		private var r:Rectangle;
		
		public function ScrollRect( target:DisplayObject, x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			r = new Rectangle( x, y, width, height );
			
			t = target;
			t.scrollRect = r;
		}
		
		public function dispose( ):void
		{
			t.scrollRect = null;
			t = null;
			r = null;
		}
		
		private function update( ):void
		{
			if( t ) t.scrollRect = r;
		}
		
		public function set height( value:Number ):void
		{
			if( r ) r.height = value;
			update( );
		}
		
		public function get height( ):Number
		{
			if( r ) return r.height;
			return 0;
		}
		
		public function get rectangle( ):Rectangle
		{
			if( r ) return r.clone( );
			return null;
		}
		
		public function set width( value:Number ):void
		{
			if( r ) r.width = value;
			update( );
		} 
		
		public function get width( ):Number
		{
			if( r ) return r.width;
			return 0;
		}
		
		public function set y( value:Number ):void
		{
			if( r ) r.y = value;
			update( );
		} 
		
		public function get y( ):Number
		{
			if( r ) return r.y;
			return 0;
		}
		
		public function set x( value:Number ):void
		{
			if( r ) r.x = value;
			update( );
		} 
		
		public function get x( ):Number
		{
			if( r ) return r.x;
			return 0;
		}
	}
}