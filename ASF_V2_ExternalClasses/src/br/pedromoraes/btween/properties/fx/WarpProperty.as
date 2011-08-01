package br.pedromoraes.btween.properties.fx
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//TODO Rewrite with decent code.

	public class WarpProperty implements IProperty
	{

		public var index:Number;
		public var startValues:Object;

		private var canvas:Bitmap;
		private var ctnr:Sprite;
		private var map:BitmapData;
		private var direction:int;
		private var translateX:Number;
		private var translateY:Number;
		private var factor:Number;
		private var _width:Number;
		private var _height:Number;

		protected var _target:DisplayObject;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as DisplayObject }

		public function WarpProperty(pTarget:DisplayObject, pnWidth:Number = 0, pnHeight:Number = 0, pnFactor:Number = 1, piDirection:int = 1, pbTransparent:Boolean = false, pnTranslateX:Number = 0, pnTranslateY:Number = 0)
		{
			_target = pTarget;

			_width = pnWidth || pTarget.width;
			_height = pnHeight || pTarget.height;
			direction = piDirection;
			factor = pnFactor;
			translateX = pnTranslateX;
			translateY = pnTranslateY;
			canvas = new Bitmap(new BitmapData(pnWidth || pTarget.width, pnHeight || pTarget.height, pbTransparent, 0));
			if (translateX != 0 || translateY != 0)
			{
				var translationMat:Matrix = new Matrix();
				translationMat.translate(translateX, translateY);
				canvas.bitmapData.draw(_target, translationMat);
			}
			else
			{
				canvas.bitmapData.draw(_target);
			}
			ctnr = new Sprite();
			if (_target.parent)
			{
				if (_target.parent.getChildByName('Warp_'+_target.name))
				{
					_target.parent.removeChild(_target.parent.getChildByName('Warp_'+_target.name));
				}
			}
			ctnr.name = 'Warp_'+_target.name;
			ctnr.addChild(canvas);
			ctnr.mouseEnabled = true;
			canvas.visible = false;
			_target.parent.addChild(ctnr);
			ctnr.x = _target.x; ctnr.y = _target.y;
		}
		
		public function get cIndex():Number
		{
			return direction == 1 ? index : 1-index;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!_target) return;
			
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);
			
			if (cIndex > 0)
			{
				_target.visible = false;
				applyFilter();
			}

			if (direction == -1 && index == 1)
			{
				_target.visible = true;
				canvas.filters = [];
				if (ctnr.parent)
				{
					ctnr.parent.removeChild(ctnr);
				}
				startValues = null;
			}
			ctnr.x = _target.x; ctnr.y = _target.y; ctnr.alpha = _target.alpha;
			if (translateX != 0 || translateY != 0)
			{
				ctnr.x -= translateX;
				ctnr.y -= translateY;
			}
		}

		public function applyFilter():void
		{
			canvas.filters = [
				new DisplacementMapFilter(
					map, new Point(0, 0),
					BitmapDataChannel.BLUE,
					BitmapDataChannel.RED,
					-150 * factor * cIndex,
					-150 * factor * cIndex,
					DisplacementMapFilterMode.CLAMP,
					0xff040d12, 1
				)
			];
			canvas.transform.colorTransform = new ColorTransform(1- cIndex * .25, 1- cIndex * .25, 1- cIndex * .25, 1);
		}

		public function reverse():void
		{
			direction *= -1;
		}

		public function clone():IProperty
		{
			return new WarpProperty(_target, _width, _height, factor, direction, canvas.bitmapData.transparent, translateX, translateY);
		}

		private function init():void
		{
			startValues = {};
			canvas.visible = true;

			var sp:Sprite = new Sprite();
			var v:Point = new Point(_width/2, _height/2);
			var radius:Number = 2;
			var angle:Number = 0;

			var r:Rectangle = new Rectangle(0, 0, _width, _height);
			var deg2rad:Number = Math.PI / 180;
			sp.graphics.beginFill(0x000000, 1);
			sp.graphics.drawRect(0, 0, _width, _height);
			sp.graphics.endFill();

			var gmtx:Matrix = new Matrix();
			gmtx.createGradientBox(_width, _height);
			sp.graphics.beginGradientFill('linear',[0xff0000,0xff0000], [1, 0], [0,127], gmtx);
			sp.graphics.drawRect(0, 0, _width, _height);
			sp.graphics.endFill();
	
			gmtx.createGradientBox(_width, _height, Math.PI/2);
			sp.graphics.beginGradientFill('linear',[0x0000ff,0x0000ff], [1, 0], [0,127], gmtx);
			sp.graphics.drawRect(0, 0, _width, _height);
			sp.graphics.endFill();

			sp.graphics.moveTo(v.x, v.y);
			var dist:Number;
			var v0:Point = v.clone();
			var color:Number = 256;
			var max:Number = Math.max(_width/2,_height/2)*1.5;

			while (radius < max)
			{
				radius *= 1.025;
				angle += 18;
				color /= 1.00005;
				v = v.add(new Point(Math.sin(angle * deg2rad)*radius, Math.cos(angle * deg2rad)*radius));
				dist = Point.distance(v0, v);
				sp.graphics.lineStyle(5+dist*.2, color << 16 | color << 8 | color, 1, false, "normal", null, null, 20);
				sp.graphics.lineTo(v.x, v.y);	
			}

			map = new BitmapData(_width, _height, false);
			map.draw(sp);
			map.applyFilter(map, map.rect, new Point(0,0), new BlurFilter(50, 50, 1));
		}
		
	}
}