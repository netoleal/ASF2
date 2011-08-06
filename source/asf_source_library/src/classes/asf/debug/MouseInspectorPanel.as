/*
Class: asf.debug.MouseInspectorPanel
Author: Neto Leal
Created: Aug 3, 2011

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
	import asf.core.app.ASF;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MouseInspectorPanel extends BasePanel
	{
		private var rect:Shape;
		private var tf:TextField;
		private var target:DisplayObject;
		
		public function MouseInspectorPanel( p_app:ASF )
		{
			super( p_app );
			
			tf = new TextField( );
			rect = new Shape( );
			
			tf.width = 320;
			tf.height = 100;
			tf.mouseEnabled = false;
			tf.multiline = tf.wordWrap =  true;
			tf.defaultTextFormat = new TextFormat( "Arial", 10, 0 );
			
			addChild( tf );
			
			rect.graphics.lineStyle( 0, 0xFFCC00, 0.6 );
			rect.graphics.beginFill( 0xFFCC00, 0.4 );
			rect.graphics.drawRect( 0, 0, 100, 100 );
			rect.graphics.endFill( );
			
			addEventListener( Event.ADDED_TO_STAGE, added );
			addEventListener( Event.REMOVED_FROM_STAGE, removed );
		}
		
		private function added( evt:Event ):void
		{
			addEventListener( Event.ENTER_FRAME, update );
			
			app.stage.addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
			app.stage.addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
		}
		
		private function removed( evt:Event ):void
		{
			removeEventListener( Event.ENTER_FRAME, update );
			mouseOut( null );
			if( app.stage.contains( rect ) ) app.stage.removeChild( rect );
			
			app.stage.removeEventListener( MouseEvent.MOUSE_OVER, mouseOver );
			app.stage.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
		}
		
		private function mouseOver( evt:MouseEvent ):void
		{
			target = evt.target as DisplayObject;
		}
		
		private function update( evt:Event = null ):void
		{
			if( target )
			{
				var p:Point = new Point( target.x, target.y );
				var b:Rectangle = target.getBounds( target );
				var contentText:Array = [ ];
				
				if( target.parent )
				{
					p = target.parent.localToGlobal( p );
				}
				
				rect.width = b.width;
				rect.height = b.height;
				
				rect.x = p.x + b.x;
				rect.y = p.y + b.y;
				
				contentText = [
					"target: <b>" + getTargetName( target ) + "</b>",
					"positions: local( x: <b>" + target.x + "</b>, y: <b>" + target.y + "</b> ) global( x: <b>" + p.x + "</b>, y: <b>" + p.y + "</b> )",
					"path: " + getFullPath( target )
				];
				
				tf.htmlText = contentText.join( "<br>" );
				
				if( !app.stage.contains( rect ) ) app.stage.addChild( rect );
			}
			else
			{
				if( app.stage.contains( rect ) ) app.stage.removeChild( rect );
			}
		}
		
		private function getFullPath(target:DisplayObject):String
		{
			var ar:Array = new Array( );
			
			//ar.push( getTargetName( target ) );
			
			while( target )
			{
				if( target.parent )
				{
					target = target.parent;
					ar.push( getTargetName( target ) );
				}
				else
				{
					target = null;
				}
				
			}
			
			return ar.join( " / " );
		}
		
		private function getTargetName( target:DisplayObject ):String
		{
			if( target.name && target.name != "" && target.name.substr( 0, "instance".length ) != "instance" )
			{
				return target.toString( ) + " {" + target.name + "}"; 
			}
			
			return target.toString( );
		}
		
		private function mouseOut( evt:MouseEvent ):void
		{
			target = null;
		}
		
		public override function get title():String
		{
			return "Mouse Inspector";
		}
		
		public override function get contentHeight():uint
		{
			return 100;
		}
	}
}