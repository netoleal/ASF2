/*

Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

@author pedromoraes@gmail.com


"If God does not exist, everything is permitted" - Fyodor Dostoevsky, in The Brothers Karamazov
"'Everything is permitted' does not mean that nothing is forbidden..." /
	"One can be virtuous through a whim" - Albert Camus, in The Absurd Man

BTween is aimed to provide both a very strict and verbose syntax - which motivated me to write this api - and a very loose,
quick'n'dirty one.

First one is intended to comply with the complexity of current flash/flex applications, which will benefit from the
tighter use of good OOP practices and patterns. Second is given to the simple uses we still may have of flash - you certainly
won't want to loose time creating a fully standardized and documented application when coding a simple banner, for example.
I strongly disrecommend the use of long chains of tweens in a single line for a serious application, as well as I recommend
the use of the regular Event model in most cases, and the instantiation of BTween objects instead of the
"static calls" way.

So this looks good to me:
var tween:BTween = new BTween();
tween.addEventListener(BTWeenEvent.COMPLETE, doSomething);
tween.addTarget(blueBall,{y:100});
tween.addTarget(redBall,{y:200});
tween.start();

While this might be good for a banner that will be sent to trash after a couple of days of use
BTween.make().start({target:blueBall,y:100},{target:redBall,y:200}).queue(doSomething);

With this being an intermediary approach:
var tween:BTween = new BTween();
tween.queue(doSomething);
tween.start({target:blueBall,y:100},{target:redBall,y:200});

This flexibility haven't made of BTween a sumo fighter, though. The minimal footprint is around 3k, making it light enough
to be used in banners or other weight-sensitive uses. The API is also meant to be easily extensible, you can actually code your own extension in a
few minutes, implementing IProperty or ISequenceable interfaces.

BTween is in ALPHA state, though I've been using it for half an year, and even its design is being improved each day.
If anyone is interested in helping, I'd be happy to move it to google code or a similar repository.

Please send your thoughts to pedromoraes@gmail.com. No support requests please.

*/

package br.pedromoraes.btween
{
	import br.pedromoraes.btween.properties.IProperty;
	import br.pedromoraes.btween.shortcuts.delay;
	import br.pedromoraes.btween.shortcuts.tween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Dispatched when tween is started
	 *
	 * @eventType br.pedromoraes.btween.BTweenEvent
	 */
	[Event(name="start", type="br.pedromoraes.btween.BTweenEvent")]

	/**
	 * Dispatched on each tween step
	 *
	 * @eventType br.pedromoraes.btween.BTweenEvent
	 */
	[Event(name="update", type="br.pedromoraes.btween.BTweenEvent")]

	/**
	 * Dispatched when tween is finished
	 *
	 * @eventType br.pedromoraes.btween.BTweenEvent
	 */
	[Event(name="complete", type="br.pedromoraes.btween.BTweenEvent")]

	public class BTween extends Sequenceable implements ISequenceable
	{
		
		public static var DEFAULT_TIME:int = 300;
		public static var DEFAULT_TRANSITION:Function = easeOut;
		public static var sprite:Sprite = new Sprite();
		public static var instances:Array = new Array();

		public var tweens:Array = new Array();
		public var time:int;
		public var delay:int;
		public var name:String;
		public var transition:Function;
		public var rounded:Boolean;
		public var cloneOf:BTween;
		public var reversionPending:Boolean;

		private var started:Boolean;
		private var completed:Boolean;
		private var startTime:int;

		/**
		 * Constructor
		 * 
		 * @param piTime Tween duration
		 * @param pTransition Easing equation.
		 * @param piDelay Delay to start tweening
		 * @param pbRounded	Use Math.round() on values
		 */
		public function BTween(piTime:int = -1, pTransition:Function = null, piDelay:int = 0, pbRounded:Boolean = false, psName:String = '')
		{
			//only caching top level functions
			tween, delay;
			
			time = piTime >= 0 ? piTime : DEFAULT_TIME;
			transition = pTransition || DEFAULT_TRANSITION;
			rounded = rounded;
			delay = piDelay || 0;
			name = psName;
		}

		/**
		 * <p>Creates a BTween instance - static shortcut for constructor.</p>
		 * Here to allow the uglyness of things such as BTween.make().start(something);	
		 * 
		 * @param piTime Tween duration
		 * @param pTransition Easing equation.
		 * @param piDelay Delay to start tweening
		 * @param pbRounded Use Math.round() on values
		 * 
		 * @return created instance
		 */
		public static function make(piTime:int = undefined, pTransition:Function = undefined, piDelay:int = undefined, pbRounded:Boolean = false, psName:String = ''):BTween
		{
			return new BTween(piTime, pTransition, piDelay, pbRounded, psName);
		}

		private static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (t /= d) * (t - 2) + b;
		}

		/**
		 * Sets action (ISequenceable, delay or method) to be executed on the end of current tween. Numbers are
		 * turned into a Delay as if a new Delay(time in ms) was referred, and methods are turned into a new Call(method).
		 * 
		 * <p>Example:</p>
		 * <p>tween.queue(hideBall, ball); // executes a hideBall(ball); at the end of this tweening.</p>
		 * <p>tween.queue().back(); // enqueues a clone of itself, the reverses that. So, this performs a yo-yo behaviour.</p>
		 * <p>tween.queue(100).queue(tween2); // enqueues a delay of 100ms, the the ISequenceable tween2.</p>
		 * 
		 * @param pObj Object to be placed in the queue 
		 * @param ... paParams arguments - might have diferent meanings, according to the enqueued type
		 * 
		 * @return this instance
		 */
		public override function queue(pObj:Object = null, ... paParams:Array):ISequenceable
		{ 
			if (pObj is BTween || pObj == null)
			{
				var instance:BTween = pObj as BTween || this.clone();
				if (paParams.length) instance.add.apply(instance, paParams);
				addEventListener(BTweenEvent.COMPLETE, instance.start);
				return instance;
			}
			else 
				return super.queue.apply(this, [pObj].concat(paParams));
		}
		
		/**
		 * Starts this instance's transformations. Arguments are equivalent to an .add() call
		 *  
		 * @param ... paParams arguments - tweens to be put into queue prior to starting
		 * 
		 * @return this instance
		 * 
		 * @see add
		 */
		public override function start(... paParams:Array):ISequenceable
		{
			if (paParams.length == 0 || paParams[0] is BTweenEvent)
			{
				instances.push(this);
				completed = false;
				sprite.addEventListener(Event.ENTER_FRAME, update);
				startTime = getTimer();
				started = false;

				if (reversionPending)
				{
					copyReversedValues();
				}
				//update();
			}
			else
			{
				add.apply(this, paParams);
				start();
			}
			return this;
		}
		
		/**
		 * Stops the transformations. No further events will be dispathed also.
		 * 
		 * @return this instance
		 */
		public override function stop():ISequenceable
		{
			var liHit:int = instances.indexOf(this);
			if (liHit > -1) instances.splice(liHit, 1);
			sprite.removeEventListener(Event.ENTER_FRAME, update);
			return this;
		}

		/**
		 * Reverses all transformations.
		 * 
		 * @param		pTransition		Easing method (if not provided, current will be kept)
		 * 
		 * @return this instance
		 */
		public override function back(pTransition:Function = null):ISequenceable
		{
			transition = pTransition || transition;
			var tween:Object,i:int;
			for (i = 0; i < tweens.length; i ++)
			{
				tween = tweens[i];
				if (tween.startValues)
				{
					if (tween is IProperty)
					{
						tween.reverse();
						tweens[i] = tween;
					} 
					else
						tweens[i] = reverse(tween);
				}
				else
				{
					tweens[i] = copy(tween);
					reversionPending = true;
				}
			}
			return this;
		}

		public function addTarget(pTarget:Object, ... paTweens:Array):BTween
		{
			var laTweens:Array = paTweens[0] is Array ? paTweens[0] : paTweens;
			for each (var tween:Object in laTweens)
			{
				var target:Object = tween.target || pTarget;
				if (target is Array)
				{
					delete(tween.target);
					for each (var t:Object in target)
						addTarget(t, tween);
				}
				else
				{
					tweens.push(tween is IProperty ? tween : prepare(pTarget, tween));
				}
			}

			return this;
		}

		/**
		 * Pushes transformations into the array. Objects must implement IProperty or, being dynamic have the proper format.
		 * 
		 * @param		paParams		Array of transformations
		 * 
		 * @return this instance
		 */
		public function addTargetArray(paParams:Array):BTween
		{
			tweens = tweens.concat(paParams);
			return this;
		}

		/**
		 * Pushes transformations into the array. If the first param has a target property, the subsequent will assume
		 * that same target unless they specify their own
		 * 
		 * @param		... paParams (N) instances of IProperty implementations or Dynamic Objects with transformation specs
		 * 
		 * @return this instance
		 */
		public function add(... paParams:Array):BTween
		{
			var obj:Object = paParams[0];
			if (obj.hasOwnProperty('target'))
				return addTarget(obj.target, paParams);
			else
				return addTargetArray(paParams);
		}
		
		private function reverse(obj:Object):Object
		{
			var s:String;
			var res:Object = {target:obj.target,startValues:{}};
			if (obj.startValues)
			{
				for (s in obj.startValues)
				{
					if (isValidProperty(obj, s))
						res[s] = obj.startValues[s];
				}
				for (s in obj)
				{
					if (isValidProperty(obj, s))
						res.startValues[s] = obj[s];
				}
			}
			return res;
		}

		private function prepare(pTarget:Object, pTween:Object):Object
		{
			var res:Object = new Object();
			if (pTween.target)
				res.target = pTween.target is Array ? pTarget : pTween.target;
			else
				res.target = pTarget;
			for (var s:String in pTween)
			{
				if (isValidProperty(res.target, s))
					res[s] = pTween[s];
			}
			return res;
		}

		private function storeStartValues():void
		{
			var tween:Object,i:int;
			for (i = tweens.length - 1; i >= 0; i --)
			{
				tween = tweens[i];
				if (!(tween is IProperty))
				{
					tween.startValues = new Object();
					for (var s:String in tween)
					{
						if (isValidProperty(tween, s) && tween.target)
						{
							tween.startValues[s] = tween.target[s];
							if ( isNaN( tween.startValues[s] ) ) tween.startValues[s] = 0;
						}	
					}
				}
			}
		}

		private function copyReversedValues():void
		{
			var tween:Object,i:int;
			for (i = 0; i < tweens.length; i ++)
			{
				tween = tweens[i];
				if (!(tween is IProperty))
				{
					for (var s:String in tween)
					{
						if (cloneOf)
						{
							if (cloneOf.tweens[i].startValues[s] != undefined)
								tween[s] = cloneOf.tweens[i].startValues[s];
						}
					}
					delete tween.startValues;
				}
				else
				{
					tween.reverse();
				}
			}
		}

		private function isValidProperty(pTween:Object, s:String):Boolean
		{
			if (s == 'target')
				return false;
			else if (pTween.hasOwnProperty(s))
				return typeof pTween[s] == "number";
			else
				return false;	
		}

		public function update(evt:*=null):void
		{
			if (completed)
			{
				var completeEvt:BTweenEvent = new BTweenEvent(BTweenEvent.COMPLETE);
				dispatchEvent(completeEvt);
				stop();
			}
			
			var t:int = getTimer() - (startTime + delay);
			if (t < 0) return;

			if (!started)
			{
				storeStartValues();
				var startEvt:BTweenEvent = new BTweenEvent(BTweenEvent.START);
				dispatchEvent(startEvt);
				started = true;
			}

			var tween:Object, i:int;
			for (i = 0; i < tweens.length; i ++)
			{
				tween = tweens[i];

				if (tween is IProperty)
				{
					tween.update(this, t);
				}
				else
				{
					for (var prop:String in tween)
					{
						if (prop != 'startValues' && prop != 'target' && tween.target)
						{
							tween.target[prop] = getValue(tween.startValues[prop], tween[prop], t);
						}
					}
				}
			}

			if (hasEventListener(BTweenEvent.UPDATE))
			{
				var updateEvt:BTweenEvent = new BTweenEvent(BTweenEvent.UPDATE);
				dispatchEvent(updateEvt);
			}

			if (t >= time)
			{
				completed = true;
			}
		}

		/**
		 * Get value applying selected easing equation
		 * 
		 * @param		pnStart		Transformation start time
		 * @param		pnTarget	Transformation target value
		 * @param		piElapsed	Transformation elapsed time 
		 * 
		 * @return		Result value
		 */
		public function getValue(pnStart:Number, pnTarget:Number, piElapsed:int):Number
		{
			var result:Number,diff:Number;
			if (piElapsed >= time)
			{
				result = pnTarget;
			}
			else
			{
				diff = pnTarget - pnStart;
				result = transition(piElapsed, pnStart, diff, time);
			}
			return rounded ? Math.round(result) : result;
		}
		
		/**
		 * Clones this tween
		 * 
		 * @return		Cloned instance
		 */
		public function clone():BTween
		{
			var instance:BTween = new BTween(time, transition, delay, rounded);
			if (name) instance.name = name;
			var tween:Object,i:int;
			for (i = 0; i < tweens.length; i ++)
			{
				tween = tweens[i];
				instance.tweens.push(tween is IProperty ? tween.clone() : copy(tween));
			}
			instance.cloneOf = this;
			return instance;
		}
		
		private function copy(pObj:Object):Object
		{
			if (pObj is IProperty)
				return pObj;
			else
			{
				var res:Object = {};
				for (var s:String in pObj)
				{
					res[s] = pObj[s];
				}
				return res;
			}
		}
		/**
		 * Should stop and free all used resources mkl
		 */
		public function dispose():void
		{
			stop();
			tweens = null;
			transition = null;
			cloneOf = null;
		}
		
		public override function toString():String
		{
			var lsDebugTargets:String = "";
			for each (var tween:Object in tweens)
			{
				lsDebugTargets += "[" + tween.target + " ( ";
				for (var prop:String in tween)
				{
					if (prop != "target") lsDebugTargets += prop + ":" + tween[prop] + ",";
				}
				lsDebugTargets += ")] ";
			}
			return("BTween: time=" + time + ",delay=" + delay + ",targets:" + lsDebugTargets);
		}

	}

}