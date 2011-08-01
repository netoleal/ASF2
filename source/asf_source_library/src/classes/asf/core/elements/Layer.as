/*
Class: asf.core.elements.Layer
Author: Neto Leal
Created: Apr 19, 2011

The MIT License
Copyright (c) 2011 Neto Leal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package asf.core.elements
{
	import asf.core.models.layers.LayerModel;
	import asf.utils.Align;
	import asf.view.UIView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	dynamic public class Layer extends UIView
	{
		private var model:LayerModel;
		private var _sublayers:Vector.<Layer>;
		private var _parentLayer:Layer;
		protected var eventsEnabled:Boolean = true;
		
		public function Layer( p_container:DisplayObjectContainer, p_model:LayerModel, p_parentLayer:Layer )
		{
			model = p_model;
			_parentLayer = p_parentLayer;
			
			this.name = model.name;
			
			if( model.scrollRect )
			{
				this.scrollRect = model.scrollRect;
			}
			
			applyAlign( );
			createSubLayers( );
			
			this.mouseChildren = this.mouseEnabled = model.mouseEnabled;
			
			super( true );
		}
		
		private function applyAlign( ):void
		{
			var anchors:int = 0;
			
			if( model.align != "" )
			{
				var al:String = model.align.toLowerCase( );
				
				if( al.indexOf( Align.ANCHOR_TOP ) 		!= -1 ) anchors += Align.TOP;
				if( al.indexOf( Align.ANCHOR_BOTTOM ) 	!= -1 ) anchors += Align.BOTTOM;
				if( al.indexOf( Align.ANCHOR_CENTER ) 	!= -1 ) anchors += Align.CENTER;
				if( al.indexOf( Align.ANCHOR_LEFT ) 	!= -1 ) anchors += Align.LEFT;
				if( al.indexOf( Align.ANCHOR_MIDDLE ) 	!= -1 ) anchors += Align.MIDDLE;
				if( al.indexOf( Align.ANCHOR_RIGHT ) 	!= -1 ) anchors += Align.RIGHT;
			}
			
			if( anchors > 0 )
			{
				Align.add( this, anchors, { width: model.width, height: model.height, margin_left: model.marginLeft, margin_top: model.marginTop, box: model.box } );
			}
			else
			{
				this.x = model.marginLeft;
				this.y = model.marginTop;
			}
		}
		
		public override function toString( ):String
		{
			var path:Array = [ this.name ];
			var p:Layer = parentLayer;
			
			while( p != null )
			{
				path.push( p.name );
				p = p.parentLayer;
			}
			
			return "[Layer " + path.reverse( ).join( "." ) + "]";
		}
		
		public function get parentLayer( ):Layer
		{
			return _parentLayer;
		}
		
		private function createSubLayers( ):void
		{
			var childModel:LayerModel;
			var sublayer:Layer;
			
			_sublayers = new Vector.<Layer>( );
			
			for each( childModel in model.layers )
			{
				sublayer = new Layer( this, childModel, this );
				
				_sublayers.push( sublayer );
				this.addChild( sublayer );
			}
		}
		
		public override function dispose( ):void
		{
			var sublayer:Layer;
			
			for each( sublayer in _sublayers )
			{
				delete this[ sublayer.name ];
				sublayer.dispose( );
				this.removeChild( sublayer );
			}
			
			this.model = null;
			this._parentLayer = null;
			this._sublayers = null;
			
			super.dispose( );
		}
		
		public function get sublayers( ):Vector.<Layer>
		{
			return _sublayers;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild( child );
			this[ child.name ] = child;
			putSubLayersOnTop( );
			return child;
		}
		
		private function putSubLayersOnTop( ):void
		{
			var subLayer:Layer;
			
			for each( subLayer in sublayers )
			{
				subLayer.eventsEnabled = false;
				super.addChild( subLayer );
				subLayer.eventsEnabled = true;
			}
		}
		
		public override function dispatchEvent(event:Event):Boolean
		{
			if( !eventsEnabled ) return false;
			return super.dispatchEvent( event );
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			this[ child.name ] = null;
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt( child, index );
			this[ child.name ] = child;
			putSubLayersOnTop( );
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt( index );
			this[ child.name ] = null;
			return child;
		}
	}
}