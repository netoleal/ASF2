package br.pedromoraes.btween.properties.s2d
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ScaleAsBitmapProperty implements IProperty
	{
		
		protected var copy : Bitmap;
		public var _target : DisplayObject;
		public var scaleTo : Number;
		public var scaleFrom : Number;
		public var visibleAtStart : Boolean;
		public var visibleAtEnd : Boolean;
		public var fade : Boolean;
		private var middlePoint : Point;
		private var targetPoint : Point;
		
		public function ScaleAsBitmapProperty( target : DisplayObject, fade : Boolean = true, scaleTo : Number = 1, scaleFrom : Number = 0, visibleAtStart : Boolean = false, visibleAtEnd : Boolean = true ) : void
		{
			if ( !target.stage )
			{
				throw new Error( 'ScaleAsBitmapProperty: target displayobject needs the be added to the stage!' );
			}
			this._target = target;
			this.scaleTo = scaleTo;
			this.scaleFrom = scaleFrom;
			this.visibleAtStart = visibleAtStart;
			this.visibleAtEnd = visibleAtEnd;
			this.fade = fade;
		}

		public function get target() : Object
		{
			return _target;
		}
		
		public function set target( target : Object ) : void
		{
			_target = target as DisplayObject;
		}
		
		public function update( btween : BTween, elapsed : int ) : void
		{
			var index : Number = btween.getValue( 0, 1, elapsed );

			if ( !copy )
			{
				addCopy();
				_target.visible = visibleAtStart;
			}

			var scale : Number = scaleFrom + ( scaleTo - scaleFrom ) * index;

			copy.scaleX = copy.scaleY = scale;

			if ( fade )
			{
				copy.alpha = scale;
			}

			copy.x = middlePoint.x + ( targetPoint.x - middlePoint.x ) * index;
			copy.y = middlePoint.y + ( targetPoint.y - middlePoint.y ) * index;
			
			if ( index == 1 )
			{
				_target.visible = visibleAtEnd;
				removeCopy();
			}
		}
		
		private function addCopy() : void
		{
			var bounds : Rectangle = _target.getBounds( _target.stage );
			var bdata : BitmapData = new BitmapData( bounds.width | 1, bounds.height | 1, true, 0 );
			bdata.draw( _target );
			copy = new Bitmap( bdata, PixelSnapping.ALWAYS, false );
			middlePoint = new Point( bounds.x + bounds.width / 2, bounds.y + bounds.height / 2 );
			targetPoint = new Point( bounds.x, bounds.y );
			_target.stage.addChild( copy );
		}
		
		private function removeCopy() : void
		{
			copy.visible = false;
			copy.stage.addChild( copy );
			copy.bitmapData.dispose();
			copy = null;
		}
		
		public function reverse():void
		{
			var c : ScaleAsBitmapProperty = clone() as ScaleAsBitmapProperty;
			scaleTo = c.scaleFrom;
			scaleFrom = c.scaleTo;
			visibleAtEnd = c.visibleAtStart;
			visibleAtStart = c.visibleAtEnd;
		}
		
		public function clone() : IProperty
		{
			return new ScaleAsBitmapProperty( _target, fade, scaleTo, scaleFrom, visibleAtStart, visibleAtEnd );
		}
		
	}
}