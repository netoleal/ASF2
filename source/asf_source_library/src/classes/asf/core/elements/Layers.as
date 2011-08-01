/*
Class: asf.core.elements.Layers
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
	import asf.core.models.layers.LayersModel;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class Layers extends Proxy
	{
		private var mainLayer:Layer;
		private var dict:Object;
		
		private var container:DisplayObjectContainer;
		
		public function Layers( view:DisplayObjectContainer, model:LayersModel )
		{
			container = view;
			mainLayer = new Layer( view, model, null );
			view.addChild( mainLayer );
			
			dict = new Object( );
			
			dict[ mainLayer.name ] = mainLayer;
			keepLayers( mainLayer );
		}
		
		private function keepLayers( parentLayer:Layer ):void
		{
			var child:Layer;
			
			for each( child in parentLayer.sublayers )
			{
				dict[ child.name ] = child;
				keepLayers( child );
			}
		}
		
		public function toString( ):String
		{
			return "[Object Layers]";
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			throw new Error( "There is no method called '" + name + "' in [Layers]" );
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return getLayer( name );
		}
		
		public function getLayer( name:String ):Layer
		{
			return dict[ name ];
		}
		
		public function dispose( ):void
		{
			var k:String;
			
			mainLayer.dispose( );
			container.removeChild( mainLayer );
			
			container = null;
				
			for( k in dict )
			{
				dict[ k ] = null;
				delete dict[ k ];
			}
			
			dict = null;
		}
	}
}