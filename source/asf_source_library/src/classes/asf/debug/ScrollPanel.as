/*
Class: asf.debug.ScrollPanel
Author: Neto Leal
Created: May 23, 2011

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
package asf.debug
{
	import asf.utils.ScrollRect;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ScrollPanel extends Sprite
	{
		private var content:Sprite;
		private var rect:ScrollRect;
		private var scrollContent:Sprite;
		
		private var scroll:ScrollBar;
		
		public function ScrollPanel( p_content:Sprite, p_width:uint = 150, p_height:uint = 150 )
		{
			super( );
			
			scrollContent = new Sprite( );
			content = p_content;
			
			scrollContent.addChild( content );
			addChild( scrollContent );
			
			rect = new ScrollRect( scrollContent, 0, 0, p_width, p_height );
			
			scroll = new ScrollBar( p_height );
			scroll.x = p_width - scroll.width - 2;
			
			scroll.addEventListener( Event.CHANGE, updateScroll );
			content.addEventListener( Event.RESIZE, onContentResize );
			
			addChild( scroll );
			onContentResize( null );
		}
		
		private function onContentResize( evt:Event = null ):void
		{
			scroll.setProportions( content.height, rect.height );
			if( !scroll.visible )
			{
				rect.y = 0;
			}
		}
		
		private function updateScroll( evt:Event ):void
		{
			rect.y = ( content.height - rect.height ) * scroll.getValue( );
		}
	}
}

