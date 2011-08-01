package br.pedromoraes.btween.properties.movieclip
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.BaseProperty;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.MovieClip;
	import flash.display.FrameLabel;

	public class FrameProperty extends BaseProperty implements IProperty
	{

		public function FrameProperty( target : MovieClip, frame : * = null ) : void
		{
			if ( frame is String )
			{
				frame = getLabelFrame( target, frame );
			}

			if ( frame == null )
			{
				frame = target.totalFrames;
			}
			super( target, { frame : frame } );
		}

		private function getLabelFrame( target : MovieClip, name : String ) : int
		{
			var frame : int;
			var labels : Array = target.currentLabels;
			var found : Boolean = false;
			for ( var i : uint = 0; i < labels.length; i++ ) {
				var label : FrameLabel = labels[i];
				if ( label.name == name ) {
					frame = label.frame;
					found = true;
					break;
				}
			}
			return frame;
		}
		
		public override function update( tween : BTween, elapsed : int ) : void
		{
			if ( !startValues ) init();
			index = tween.getValue( 0, 1, elapsed );

			target.gotoAndStop( startValues.frame + Math.floor( ( properties.frame - startValues.frame ) * index ) );
		}
		
		public override function init() : void
		{
			startValues = new Object();
			startValues.frame = target.currentFrame;
		}

	}

}