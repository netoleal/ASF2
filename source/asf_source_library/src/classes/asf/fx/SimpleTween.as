/*
Class: asf.fx.SimpleTween
Author: Neto Leal
Created: Jul 29, 2011

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
package asf.fx
{
	import asf.core.util.Sequence;
	import asf.events.SequenceEvent;
	import asf.interfaces.ISequence;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import asf.utils.EnterFrameDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	
	public class SimpleTween extends EventDispatcher implements ISequence
	{
		public static const TYPE_ENTERFRAME:String = "enterFrame";
		public static const TYPE_INTERVAL:String = "interval";
		
		private var start:Number;
		private var end:Number;
		private var time:uint;
		
		private var target:*;
		private var props:Object;
		private var propsStartValues:Object;
		private var ease:Function;
		
		private var startTime:uint;
		private var seq:Sequence;

		private var updateCallback:Function;
		private var interval:int = -1;
		private var startDelay:int = -1;
		
		private var _progress:Number = 0;
		private var _value:Number = 0;
		private var _running:Boolean = false;
		
		public function SimpleTween( )
		{
			super( null );
			
			seq = new Sequence( );
		}
		
		public function make( p_target:*, p_props:Object, p_time:uint = 333, p_ease:Function = null, delay:uint = 0, type:String = TYPE_INTERVAL ):ISequence
		{
			var propName:String;
			
			target = p_target;
			props = p_props;
			propsStartValues = new Object( );
			
			for( propName in props ) propsStartValues[ propName ] = target[ propName ];
			
			return interpolate( 0, 1, p_time, p_ease, delay, type );
		}
		
		private function defaultEase(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		public function interpolate( p_startValue:Number = 0, p_endValue:Number = 1, p_time:uint = 333, p_easingTransition:Function = null, delay:uint = 0, type:String = SimpleTween.TYPE_INTERVAL ):ISequence
		{
			seq.notifyStart( );
			
			start = p_startValue;
			end = p_endValue;
			time = p_time;
			ease = p_easingTransition || defaultEase;
			
			_progress = 0;
			_value = start;
			_running = true;
			
			if( delay > 0 )
			{
				startDelay = setTimeout( startTween, delay, type );
			}
			else
			{
				startTween( type );
			}
			
			return this;
		}
		
		private function startTween( type:String ):void
		{
			startTime = getTimer( );
			startDelay = -1;
			interval = -1;
			
			if( type == TYPE_ENTERFRAME )
			{
				EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, step );
			}
			else
			{
				interval = setInterval( step, 1000/30 );
			}
			
			this.dispatchEvent( new SequenceEvent( SequenceEvent.TRANSITION_START ) );
		}
		
		public function stop( ):void
		{
			EnterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, step );
			
			if( interval != -1 ) clearInterval( interval );
			if( startDelay != -1 ) clearTimeout( startDelay );
			
			target = null;
			props = null;
			_running = false;
		}
		
		private function step( evt:Event = null ):void
		{
			var elapsed:Number = getTimer( ) - startTime;
			
			updateToProgress( Math.max( 0, Math.min( 1, elapsed / time ) ) );
		}
		
		public function forceCompleteNow( ):ISequence
		{
			updateToProgress( 1 );
			return this;
		}
		
		private function updateToProgress( p_progress:Number ):void
		{
			_progress = p_progress;
			_value = getInterpolatedValue( start, end );
			
			updateTargetProperties( );
			
			if( updateCallback != null )
			{
				try
				{
					updateCallback( _value );
				}
				catch( e:Error )
				{
					try
					{
						updateCallback( );
					}
					catch( e:Error )
					{
						//nothing
					}
				}
			}
			
			this.dispatchEvent( new Event( Event.CHANGE ) );
			
			if( _progress == 1 )
			{
				complete( );
			}
		}
		
		private function getInterpolatedValue( p_start:Number, p_end:Number ):Number
		{
			if( ease != null )
			{
				return ease( progress * time, p_start, p_end - p_start, time );
			}
			
			return ( progress * ( p_end - p_start ) ) + p_start;
		}
		
		private function updateTargetProperties( ):void
		{
			if( target && props )
			{
				var propName:String;
				var propStepValue:Number;
				var propTargetValue:Number;
				var propCurrentValue:Number;
				
				for( propName in props )
				{
					propTargetValue = props[ propName ];
					propCurrentValue = propsStartValues[ propName ];
					propStepValue = getInterpolatedValue( propCurrentValue, propTargetValue );
					
					target[ propName ] = propStepValue;
				}
			}
		}
		
		private function complete( ):ISequence
		{
			stop( );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
			this.dispatchEvent( new SequenceEvent( SequenceEvent.TRANSITION_COMPLETE ) );
			
			return seq.notifyComplete( );
		}
		
		public function update( callback:Function ):SimpleTween
		{
			updateCallback = callback;
			return this;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function get progress():Number
		{
			return _progress;
		}

		public function get running():Boolean
		{
			return _running;
		}
		
		public static function create( ):SimpleTween
		{
			return new SimpleTween( );
		}
		
		public function delay( milliseconds:uint = 0 ):ISequence
		{
			return seq.delay( milliseconds );
		}
		
		public function queue( queueAction:Function, ... args ):ISequence
		{
			return seq.queue.apply( null, [ queueAction ].concat( args ) );
		}
		
		public function dispose( ):void
		{
			stop( );
			seq.dispose( );
		}
		
		public function notifyStart( ):ISequence
		{
			return seq.notifyStart( );
		}
		
		public function notifyComplete( ):ISequence
		{
			if( running )
			{
				return complete( );
			}
			
			return this;
		}
		
		public function get completed( ):Boolean
		{
			return seq.completed;
		}
		
		//Static Shortcuts
		public static function fadeIn( target:*, time:uint = 333, delay:uint = 0 ):ISequence
		{
			try
			{
				target.visible = true;
			}
			catch( e:Error ){ }
			return create( ).make( target, { alpha: 1 }, time, null, delay );
		}
		
		public static function fadeOut( target:*, time:uint = 333, delay:uint = 0 ):ISequence
		{
			return create( ).make( target, { alpha: 0 }, time, null, delay ).queue( function( ):void
			{
				try
				{
					target.visible = false;
				}
				catch( e:Error ){ }
			} );
		}
		
		public static function fade( target:*, amount:Number = 1, time:uint = 333, delay:uint = 0 ):ISequence
		{
			return create( ).make( target, { allpha: amount }, time, null, delay );
		}
		
		public static function slide( target:*, x:Number, y:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { x: x, y: y }, time, ease, delay );
		}
		
		public static function slideX( target:*, x:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { x: x }, time, ease, delay );
		}
		
		public static function slideY( target:*, y:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { y: y }, time, ease, delay );
		}
		
		public static function size( target:*, width:Number, height:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { width: width, height: height }, time, ease, delay );
		}
		
		public static function width( target:*, value:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { width: value }, time, ease, delay );
		}
		
		public static function height( target:*, value:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { height: value }, time, ease, delay );
		}
		
		public static function rotation( target:*, value:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { rotation: value }, time, ease, delay );
		}
		
		public static function scale( target:*, value:Number, time:uint = 333, delay:uint = 0, ease:Function = null ):ISequence
		{
			return create( ).make( target, { scaleX: value, scaleY: value }, time, ease, delay );
		}
	}
}