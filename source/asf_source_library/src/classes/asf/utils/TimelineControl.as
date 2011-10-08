package asf.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TimelineControl
	{
		public var onFrame:Function;
		public var onReach:Function;
		public var onFirstFrame:Function;
		public var onLastFrame:Function;
		
		private var mc:MovieClip;
			
		private var targetFrame:uint;
		
		private var isOnFirstFrame:Boolean;
		private var isOnLastFrame:Boolean;
		private var isOnTargetFrame:Boolean;
		
		private var loopFrom:uint;
		private var loopTo:uint;
		
		private var looping:Boolean;
		private var yoyo:Boolean;
		private var _frame:Number = 0;
		
		private var frameFunctions:Object;
		
		private var speed:Number;
		
		/**
		* Contructor
		* 
		* @param	mcToControl - MovieClip instance to control
		* @param	speed - A speed factor to use in animations
		*/
		public function TimelineControl( mcToControl:MovieClip, speed:Number = 1 ) {
						
			
			this.mc = mcToControl;
			EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.speed = speed;
			
			this.frameFunctions = new Object( );
		}
		
		public function dispose( ):void
		{
			EnterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, this.enterFrame );
			this.mc = null;
		}
		
		/**
		* Add a function to be fired at a frame
		* 
		* @param	frameNumber Number of the frame
		* @param	frameFunction Function to be executed
		* @param	scope Function scope
		* @param	args Arguments for function execution if needed
		* @param	removeAfterExec Define if function should be removed after execution
		*/
		public function addFrameFunction( frameNumber:uint, frameFunction:Function, scope:Object = null, args:Array = null, removeAfterExec:Boolean = false ):void {
			
			if( !this.frameFunctions[ frameNumber ] ) {
				this.frameFunctions[ frameNumber ] = new Array();
			}
				
			this.frameFunctions[ frameNumber ].push( { frameFunction: frameFunction, scope: scope, args: args, removeAfterExec : removeAfterExec } );
		}
				
		/**
		* Stop calling a function at a frame
		* 
		* @param	frameNumber
		* @param	frameFunction Optional
		*/
		public function removeFrameFunction( frameNumber:uint, frameFunction:Function ):void {
	
			if( this.frameFunctions[ frameNumber ] ) {
				//trace( "[TimeLineControl] I will remove a function from frame " + frameNumber + ", ok?" );
				var fnReg:Object;
				
				for(var n:uint = 0, t:uint = this.frameFunctions[ frameNumber ].length; n < t; n++ ){
					fnReg = this.frameFunctions[ frameNumber ][ n ];
					
					if( fnReg.frameFunction == frameFunction || frameFunction == null ){
						this.frameFunctions[ frameNumber ].splice( n , 1 );
					}
				}
			}
			
		}
		
		/**
		* Stop calling a specific function or all functions at all frames
		* 
		*/
		public function removeAllFramesFunction( ):void {
			this.frameFunctions = new Object( );
		}
		
		/**
		* Animate the timeline with a specifc range. 
		* If frames are omitted, the loop will be between 1 and totalFrames
		* 
		* @param	fromFrame start frame to loop
		* @param	toFrame end frame to loop
		*/
		public function loop( fromFrame:uint = 1, toFrame:uint = 0, isYoyo:Boolean = false ):void {
			
			this.isOnFirstFrame = false;
			this.isOnLastFrame = false;
			this.isOnTargetFrame = false;
					
			this.loopFrom = fromFrame;
			this.loopTo = ( toFrame == 0 )? this.mc.totalFrames : toFrame;
			this.yoyo = isYoyo;
			
			EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.gotoAndStop( loopFrom );
			this.looping = true;
			this.targetFrame = loopTo;
			
		}
		
		/**
		* Same functionality of gotoAndPlay method from MovieClip class
		* 
		* @param	frame frame to start playing
		*/
		public function gotoAndPlay( frame:Object ):void {
			this.isOnFirstFrame = false;
			this.isOnLastFrame = false;
			this.isOnTargetFrame = false;
			
			EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.looping = false;
			this.mc.gotoAndPlay( frame );
			
		}
		
		/**
		* Same functionality of gotoAndStop method from MovieClip class
		* 
		* @param	frame frame to jump to and stop
		*/
		public function gotoAndStop( frame:Object ):void {
			this.isOnFirstFrame = false;
			this.isOnLastFrame = false;
			this.isOnTargetFrame = false;
			
			EnterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.looping = false;
			this.targetFrame = 0;
			this.mc.gotoAndStop( frame );
			
		}
		
		/**
		* Stop timeline animation
		* 
		* @param	none
		*/
		public function stop( ):void {
			
			EnterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.looping = false;
			this.targetFrame = 0;
			this.onReach = null;
			
			if( mc ) this.mc.stop( );
		}
		
		/**
		* Play timeline animation normally
		* 
		* @param	none
		*/
		public function play( ):void 
		{
			this.isOnFirstFrame = false;
			this.isOnLastFrame = false;
			this.isOnTargetFrame = false;
			
			EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			this.looping = false;
			this.mc.play( );
		}
			
		/**
		* Return the timeline MovieClip
		* 
		* @return
		*/
		public function get targetMovieClip( ):MovieClip {
			return this.mc;
		}
		
		/**
		* Play backwards the timeline to a frame.
		* 
		*/
		public function playBackwards( ):void {
			
			this.animateToFrame( 1 );
			
		}
		
		/**
		* Goto a specific frame animating.
		* 
		* @param	number
		*/
		public function animateToFrame( number:uint , callback:Function = null, scope:Object = null, args:Array = null ):void 
		{
			this.isOnFirstFrame = false;
			this.isOnLastFrame = false;
			this.isOnTargetFrame = false;
			
			this.looping = false;
			this.mc.stop( );
			this.targetFrame = number;
			
			EnterFrameDispatcher.addEventListener( Event.ENTER_FRAME, this.enterFrame );
			
			if(callback != null) {
				//this.onReach = callback;
				this.addFrameFunction(number, callback, scope, args, true);
			}
		}
		
		/**
		* Returns the current frame of timeline
		* 
		* @return
		*/
		public function get currentframe( ):uint {
			return this.mc.currentFrame;
		}
		
		/**
		* Returns total frame of timeline
		* 
		* @return
		*/
		public function get totalframes( ):uint {
			return this.mc.totalFrames;
		}
		
		/**
		* Return the speed
		* 
		* @return
		*/
		public function get _speed():uint {
			return this.speed;
		}
		
		/**
		* Set speed. 
		* Exemple: If you set _speed = 2, the timeline will run twice faster.
		* 
		* @param	speed
		*/
		public function set _speed(speed:uint):void {
			this.speed = Math.ceil(speed);
		}
		
		/**
		* Handle for enterFrame
		* 
		* @param	void
		*/
		private function enterFrame( event:Event ):void {
			
			if( this.mc == null )
			{
				return;
			}
			
			if( this._frame != this.currentframe ){
				this._frame = this.currentframe;
				if( this.onFrame != null ) this.onFrame( this._frame );
				
				this.execFrameFunction(this.currentframe);
			}
			
			if( this.targetFrame != 0 ) {
				var factor:Number = ( this.targetFrame > this.mc.currentFrame )? this.speed : -(this.speed);
				
				// adjusts the factor (speed)
				if(factor > 0) {
					if((this.mc.currentFrame + factor) > this.targetFrame) {
						factor = (this.targetFrame - this.mc.currentFrame);
					}
				} else {
					if((this.mc.currentFrame + factor) < this.targetFrame) {
						factor = (this.targetFrame - this.mc.currentFrame);
					}
				}
				
				if( mc && this.mc.currentFrame != this.targetFrame ){
					this.isOnTargetFrame = false;
					this.mc.gotoAndStop( this.mc.currentFrame + factor );
				}
				
				if( mc && this.mc.currentFrame == this.targetFrame ){
					if( !this.isOnTargetFrame ){
						if( this.onReach != null )
						{
							try
							{
								this.onReach( this.mc.currentFrame );
							}
							catch( e:Error )
							{
								this.onReach( );
							}
						}
						this.isOnTargetFrame = true;
						this.targetFrame = 0;
					}
					if( this.looping ){
						
						if( !this.yoyo ){
							
							this.gotoAndStop( this.loopFrom );
							this.looping = true;
							this.targetFrame = this.loopTo;
							
						} else {
							
							this.targetFrame = ( this.currentframe == this.loopFrom )? this.loopTo: this.loopFrom;
							
						}
					}
				}	
			}
			
			//Check if is on first frame
			if( mc && this.mc.currentFrame == 1 ) {
				if( !this.isOnFirstFrame ){
					if( this.onFirstFrame != null ) this.onFirstFrame( );
					this.isOnFirstFrame = true;
				}
			} else {
				this.isOnFirstFrame = false;
			}
			
			//Check if is on last frame
			if( mc && this.mc.currentFrame == this.mc.totalFrames ){
				if( !this.isOnLastFrame ){
					if( this.onLastFrame != null ) this.onLastFrame( );
					this.isOnLastFrame = true;
				}
			} else {
				this.isOnLastFrame = false;
			}
			
		}
		
		/**
		* Exec functions of desired frame
		* @param	frameNumber	desired frame
		* @param	removeAfterExec	remove functions from frame after exec
		*/
		public function execFrameFunction( frameNumber:uint , removeAfterExec:Boolean = false ):void {
					
			var fnReg:Object;
			
			if( this.frameFunctions && 
				this.frameFunctions[ frameNumber ] != null && 
				this.frameFunctions[ frameNumber ].length == 0 ) return;
			
			try
			{
				for(var n:uint = 0, t:uint = this.frameFunctions[ frameNumber ].length; n < t; n++ )
				{
					fnReg = this.frameFunctions[ frameNumber ][ n ];
					fnReg.frameFunction.apply( fnReg.scope, fnReg.args );
					
					if( fnReg.removeAfterExec ) {
						this.removeFrameFunction( frameNumber, fnReg.frameFunction );
					}
				}
			}
			catch( e:Error ){ }
			
			if( removeAfterExec ) 
			{
				this.frameFunctions[ frameNumber ] = new Array;
			}
			
		}
	}
}