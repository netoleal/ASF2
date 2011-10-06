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
	import asf.interfaces.ISpecialProperty;
	import asf.utils.EnterFrameDispatcher;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	
	public class SimpleTween extends Sequence implements ISequence
	{
		public static const TYPE_ENTERFRAME:String = "enterFrame";
		public static const TYPE_INTERVAL:String = "interval";
		
		private static var specialProperties:Object;
		
		private var start:Number;
		private var end:Number;
		private var time:uint;
		
		private var targets:Array;
		
		private var props:Array;
		private var propsStartValues:Dictionary;
		private var ease:Function;
		
		private var startTime:uint;
		
		private var updateCallback:Function;
		private var interval:int = -1;
		private var startDelay:int = -1;
		
		private var _progress:Number = 0;
		private var _value:Number = 0;
		private var _running:Boolean = false;
		
		public function SimpleTween( )
		{
			super( );
		}
		
		public static function registerSpecialProperty( name:String, property:ISpecialProperty ):void
		{
			if( !specialProperties ) specialProperties = { };
			specialProperties[ name ] = property;
		}
		
		public static function unregisterSpecialProperty( name:String ):void
		{
			if( specialProperties && specialProperties[ name ] && specialProperties[ name ] is ISpecialProperty )
			{
				( specialProperties[ name ] as ISpecialProperty ).dispose( );
				
				specialProperties[ name ] = null;
				delete specialProperties[ name ];
			}
		}
		
		/**
		 * Faz uma interpolação de propriedades em um objeto
		 *  
		 * @param p_target Objeto que vai receber a interpolação
		 * @param p_props Propriedades a serem interpoladas no target
		 * @param p_time Duração da animação em millisegundos
		 * @param p_ease Função de easing
		 * @param delay Tempo de espera para iniciar a tween em millisegundos
		 * @param type Tipo: 'enterFrame' usa a velocidade do framerate do SWF ou 'interval' usa um setInterval de 1000/30 (30 fps)
		 * @return SimpleTween
		 * 
		 */
		public function make( p_target:*, p_props:Object, p_time:uint = 333, p_ease:Function = null, delay:uint = 0, type:String = TYPE_INTERVAL ):ISequence
		{
			return makeMultiple( [ p_target ], [ p_props ], p_time, p_ease, delay, type );
		}
		
		/**
		 * Realiza uma interpolação em múltiplos targets simultaneamente
		 *  
		 * @param p_targets
		 * @param p_props
		 * @param p_time Duração da animação em millisegundos
		 * @param p_ease Função de easing
		 * @param delay Tempo de espera para iniciar a tween em millisegundos
		 * @param type Tipo: 'enterFrame' usa a velocidade do framerate do SWF ou 'interval' usa um setInterval de 1000/30 (30 fps)
		 * @return SimpleTween
		 * 
		 */
		public function makeMultiple( p_targets:Array, p_props:Array, p_time:uint = 333, p_ease:Function = null, p_delay:uint = 0, type:String = TYPE_INTERVAL ):ISequence
		{
			var propName:String;
			var target:*;
			var tProps:Object;
			var n:uint = 0;
			
			targets = p_targets;
			props = p_props;
			propsStartValues = new Dictionary( true );
			
			for each( target in targets )
			{
				if( n < props.length )
				{
					propsStartValues[ target ] = new Object( );
					for( propName in props[ n ] ) propsStartValues[ target ][ propName ] = getTargetPropertyValue( target, propName );
					n++;
				}
			}
			
			return interpolate( 0, 1, p_time, p_ease, p_delay, type );
		}
		
		private function getTargetPropertyValue( target:*, propName:String ):Number
		{
			if( specialProperties && specialProperties[ propName ] && specialProperties[ propName ] is ISpecialProperty )
			{
				return ( specialProperties[ propName ] as ISpecialProperty ).getValue( target );
			}
			
			return target[ propName ];
		}
		
		private function setTargetPropertyValue( target:*, propName:String, value:Number, start:Number, end:Number ):void
		{
			if(  specialProperties && specialProperties[ propName ] && specialProperties[ propName ] is ISpecialProperty )
				( specialProperties[ propName ] as ISpecialProperty ).setValue( target, value, start, end );
			else
				target[ propName ] = value;
		}
		
		private function defaultEase(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		/**
		 * Cria uma interpolação numérica simples entre dois números.
		 *  
		 * @param p_startValue Valor inicial
		 * @param p_endValue Valor final
		 * @param p_time Duração em millisegundos
		 * @param p_easingTransition Função de easing. Ex.: Qualquer uma do Robert Penner
		 * @param delay Tempo de espera antes de iniciar em millisegundos
		 * @param type Tipo: 'enterFrame' usa a velocidade do framerate do SWF ou 'interval' usa um setInterval de 1000/30 (30 fps) 
		 * @return SimpleTween
		 * 
		 */
		public function interpolate( p_startValue:Number = 0, p_endValue:Number = 1, p_time:uint = 333, p_easingTransition:Function = null, delay:uint = 0, type:String = SimpleTween.TYPE_INTERVAL ):ISequence
		{
			notifyStart( );
			
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
		
		/**
		 * Finaliza a animação 
		 * 
		 */
		public function stop( ):void
		{
			EnterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, step );
			
			if( interval != -1 ) clearInterval( interval );
			if( startDelay != -1 ) clearTimeout( startDelay );
			
			updateCallback = null;
			targets = null;
			props = null;
			propsStartValues = null;
			_running = false;
		}
		
		private function step( evt:Event = null ):void
		{
			var elapsed:Number = getTimer( ) - startTime;
			
			updateToProgress( Math.max( 0, Math.min( 1, elapsed / time ) ) );
		}
		
		/**
		 * Pula para o fim da animação 
		 * @return 
		 * 
		 */
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
		
		public function getInterpolatedValue( p_start:Number, p_end:Number ):Number
		{
			if( ease != null )
			{
				return ease( progress * time, p_start, p_end - p_start, time );
			}
			
			return ( progress * ( p_end - p_start ) ) + p_start;
		}
		
		private function updateTargetProperties( ):void
		{
			if( targets && props )
			{
				var target:*;
				var n:uint = 0;
				var propName:String;
				var propStepValue:Number;
				var propTargetValue:Number;
				var propCurrentValue:Number;
				
				for each( target in targets )
				{
					if( propsStartValues[ target ] )
					{
						for( propName in propsStartValues[ target ] )
						{
							propTargetValue = props[ n ][ propName ];
							propCurrentValue = propsStartValues[ target ][ propName ];
							propStepValue = getInterpolatedValue( propCurrentValue, propTargetValue );
							
							setTargetPropertyValue( target, propName, propStepValue, propCurrentValue, propTargetValue );
						}
						
						n++;
					}
				}
			}
		}
		
		private function complete( ... args ):ISequence
		{
			stop( );
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
			
			return super.notifyComplete.apply( null, args );
		}
		
		/**
		 * Use para executar uma função a cada passo da interpolação. 
		 * @param callback Função que deverá ser chamada a cada passo da interpolação. Ela pode receber um parâmetro numérico com o valor atual da interpolação. Caso seja uma animação de propriedades, o valor será entre 0 e 1.
		 * @return 
		 * 
		 */
		public function update( callback:Function ):SimpleTween
		{
			updateCallback = callback;
			return this;
		}
		
		/**
		 * Retorna o valor numérico parcial da animação. Se for uma animação de propriedades, será entre 0 e 1 
		 * @return 
		 * 
		 */
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * Retorna o progresso da animação entre 0 e 1 
		 * @return 
		 * 
		 */
		public function get progress():Number
		{
			return _progress;
		}

		/**
		 * Retorna se a interpolação está ou não em execução 
		 * @return 
		 * 
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * Atalho para criar uma nova tween. O mesmo que new SimpleTween( ); 
		 * @return 
		 * 
		 */
		public static function create( ):SimpleTween
		{
			return new SimpleTween( );
		}
		
		/**
		 * Finaliza e limpa a sequence 
		 * 
		 */
		public override function dispose( ):void
		{
			stop( );
			super.dispose( );
		}
		
		public override function notifyComplete( ... args ):ISequence
		{
			if( running )
			{
				return complete.apply( null, args );
			}
			
			return this;
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
			return create( ).make( target, { alpha: amount }, time, null, delay );
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