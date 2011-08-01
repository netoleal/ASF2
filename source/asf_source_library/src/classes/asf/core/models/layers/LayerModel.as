/*
Class: asf.core.models.layers.LayerModel
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
package asf.core.models.layers
{
	import asf.core.models.app.ApplicationModel;
	
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class LayerModel extends Proxy
	{
		private var raw:XML;
		private var app:ApplicationModel;
		
		private var _layersDict:Object;
		private var _layers:Vector.<LayerModel>;
		
		public function LayerModel( p_raw:*, p_app:ApplicationModel )
		{
			try
			{
				raw = XML( p_raw );
			}
			catch( e:Error )
			{
				raw = <empty />;
			}
			
			app = p_app;
			_layersDict = new Object( );
			populate( );
		}
		
		override flash_proxy function getProperty( name:* ):*
		{
			return getLayer( name );
		}
		
		public function getLayer( name:String ):LayerModel
		{
			return _layersDict[ name ];
		}
		
		public function get layers( ):Vector.<LayerModel>
		{
			return _layers;
		}
		
		private function populate( ):void
		{
			if( !_layers )
			{
				var children:XMLList = raw.children( );
				var child:XML;
				var layer:LayerModel;
				
				_layers = new Vector.<LayerModel>( );
				
				if( raw.hasComplexContent( ) )
				{
					for each( child in children )
					{
						layer = new LayerModel( child, app );
						
						_layers.push( layer );
						_layersDict[ layer.name ] = layer;
					}
				}
			}
		}
		
		public function get name( ):String
		{
			return app.getParsedValue( raw.name( ) );
		}
		
		public function get mouseEnabled( ):Boolean
		{
			return app.getParsedValue( raw.@mouseEnabled ) != "false";
		}
		
		public function get align( ):String
		{
			return app.getParsedValue( raw.@align );
		}
		
		public function get box( ):Rectangle
		{
			if( app.getParsedValue( raw.@box ) == "" ) return null;
			return parseRectangle( app.getParsedValue( raw.@box ) );
		}
		
		public function get scrollRect( ):Rectangle
		{
			if( app.getParsedValue( raw.@scrollRect ) == "" ) return null;
			return parseRectangle( app.getParsedValue( raw.@scrollRect ) );
		}
		
		private function parseRectangle( rawRect:String ):Rectangle
		{
			var values:Array = rawRect.split( "," );
			var props:Array = [ "x", "y", "width", "height" ];
			var prop:String;
			var n:uint = 0;
			var res:Rectangle = new Rectangle( );
			
			for each( prop in props )
			{
				res[ prop ] = values[ n ]? parseInt( values[ n ] ): 0;
				n++;
			}
			
			return res;
		}
		
		public function get marginLeft( ):int
		{
			return margins[ 0 ] != ""? parseInt( margins[ 0 ] ): 0;
		}
		
		public function get marginTop( ):int
		{
			return margins[ 1 ] != null? ( margins[ 1 ] != ""? parseInt( margins[ 1 ] ): 0 ) :0;
		}
		
		public function get width( ):String
		{
			return app.getParsedValue( raw.@width );
		}
		
		public function get height( ):String
		{
			return app.getParsedValue( raw.@height );
		}
		
		private function get margins( ):Array
		{
			var m:String = app.getParsedValue( raw.@margins );
			return m.split( "," );
		}
	}
}