package br.pedromoraes.btween
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author pedromoraes@gmail.com
	 */
	public class FramePlayer extends Sequenceable implements ISequenceable
	{
		
		private var movie : MovieClip;
		private var from : int;
		private var to : int;
		private var frame : int;
		
		private static var instances : Dictionary = new Dictionary();

		public static function getInstance( movie : MovieClip ) : FramePlayer
		{
			if ( instances[ movie ] )
				return instances[ movie ].stop();
			else
				return new FramePlayer( movie, 0, 0 );
		}
		
		public static function play( movie : MovieClip, from : *, to : * ) : ISequenceable
		{
			trace('frameplayer', movie.name, from, to );
			return FramePlayer.getInstance( movie ).setFrames( from, to ).start();
		}
		
		public function FramePlayer( movie : MovieClip, from : *, to : * )
		{
			this.movie = movie;
			if ( !( from == 0 && to == 0 ) ) setFrames( from, to );
		}

		public function setFrames( from : *, to : * ) : FramePlayer
		{
			if ( from == null ) from = movie.currentFrame;

			if ( from is String || to is String )
			{
				var labels : Object = getFrameLabels( movie );
				
				if ( from is String ) from = labels[ from ];
				if ( to is String ) to = labels[ to ];
			}

			this.from = from;
			this.to = to;

			return this;
		}
		
		private function getFrameLabels( movie : MovieClip ) : Object
		{
			var labels:Array = movie.currentLabels;
			var res : Object = {};
			for (var i:uint = 0; i < labels.length; i++) {
				res[ labels[i].name ] = labels[i].frame;
			}
			return res;
		}

		public override function start(...paParams):ISequenceable
		{
			frame = 0;
			instances[ movie ] = this;
			movie.gotoAndStop( from );
			movie.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(new BTweenEvent(BTweenEvent.START));
			return this;
		}
		
		public override function stop():ISequenceable
		{
			delete instances[ movie ];
			movie.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			return this;
		}
		
		private function onEnterFrame(pEvt:*=null):void
		{
			frame ++;
			movie.gotoAndStop( from + frame * ( to > from ? 1 : -1 ) );
			dispatchEvent(new BTweenEvent(BTweenEvent.UPDATE));
			if ( movie.currentFrame == to )
			{
				stop();
				dispatchEvent(new BTweenEvent(BTweenEvent.COMPLETE));
			}
		}
		
	}

}