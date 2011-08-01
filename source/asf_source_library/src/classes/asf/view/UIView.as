/*
Class: asf.view.UIView
Author: Neto Leal
Created: May 9, 2011

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
package asf.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Util class for disposable view elements.
	 * This class handles all event listeners and remove them all on dispose.
	 * Thanks to Silvio Paganini: s2paganini@gmail.com
	 *  
	 * @author neto.leal
	 * 
	 */
	public class UIView extends Sprite
	{
		private var events:Object;
		
		public function UIView( autoDispose:Boolean = true )
		{
			super( );
			
			if( autoDispose )
			{
				addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			}
		}
		
		private function onRemovedFromStage( event:Event ):void
		{
			dispose( );
		}
		
		public function dispose( ):void
		{
			removeAllListeners( );
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if( !events ) events = { };
			if( !events[ type ] ) events[ type ] = [ ];
			if( events[ type ].indexOf( listener ) != -1 ) return;
			
			events[ type ].push( listener );
			
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			var i:int;
			
			if( !events || !events[ type ] || events[ type ].indexOf( listener ) == -1 ) return;
			
			i = events[ type ].indexOf( listener );
			
			events[ type ][ i ] = null;
			events[ type ].splice( i, 1 );
			
			if( events[ type ].length == 0 ) 
			{
				events[ type ] = null;
				delete events[ type ];
			}
			
			super.removeEventListener( type, listener, useCapture );
		}
		
		public function removeAllEventListeners( type:String ):void
		{
			if( !events || !events[ type ] ) return;
			
			var listeners:Array = events[ type ];
			var listener:Function;
			
			for each( listener in listeners )
			{
				super.removeEventListener( type, listener );
			}
			
			events[ type ] = null;
			delete events[ type ];
		}
		
		public function removeAllListeners( ):void
		{
			if( !events ) return;
			
			var type:String;
			
			for( type in events )
			{
				removeAllEventListeners( type );
			}
			
			events = null;
		}
	}
}