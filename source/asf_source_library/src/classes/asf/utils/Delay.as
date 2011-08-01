/*
Class: asf.utils.Delay
Author: Neto Leal
Created: Apr 28, 2011

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
package asf.utils
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[Event( name="delayComplete", type="asf.utils.Delay")]
	
	public class Delay extends EventDispatcher
	{
		public static const DELAY_COMPLETE:String = "delayComplete";
		
		private var callback:Function;
		private var args:Array;
		
		private var interval:int = -1;
		private var transition:Sequence;
		
		public function Delay( )
		{
			super( null );
			transition = new Sequence( );
		}
		
		public function execute( p_callback:Function, delay:uint = 0, ... p_args ):ISequence
		{
			callback = p_callback; 
			args = [ ].concat( p_args );
			
			return start( delay ).queue( executeCallback );
		}
		
		public function start( delay:uint = 0 ):ISequence
		{
			transition.notifyStart( );
			
			clearDelay( );
			interval = setTimeout( completeDelay, delay );
			return transition;
		}
		
		private function completeDelay( ):void
		{
			clearDelay( );
			transition.notifyComplete( );
			dispatchComplete( );
		}
		
		private function clearDelay( ):void
		{
			if( interval != -1 ) clearTimeout( interval );
			interval = -1;
		}
		
		private function executeCallback( ):void
		{
			if( callback != null ) callback.apply( null, args );
		}
		
		private function dispatchComplete( ):void
		{
			this.dispatchEvent( new Event( DELAY_COMPLETE ) );
		}
		
		public static function execute( callback:Function, delay:uint = 0, ... p_args ):Sequence
		{
			var d:Delay = new Delay( );
			return ( d.execute as Function ).apply( null, [ callback, delay ].concat( p_args ) );
		}
		
		public static function start( delay:uint = 0 ):ISequence
		{
			return new Delay( ).start( delay );
		}
	}
}