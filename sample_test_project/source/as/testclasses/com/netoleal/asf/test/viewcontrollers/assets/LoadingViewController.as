/*
Class: com.netoleal.asf.test.viewcontrollers.assets.LoadingViewController
Author: Neto Leal
Created: May 14, 2011

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
package com.netoleal.asf.test.viewcontrollers.assets
{
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.InOutViewController;
	import asf.interfaces.ISectionLoading;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	import asf.utils.Delay;
	
	import flash.display.MovieClip;
	
	public class LoadingViewController extends InOutViewController implements ISectionLoading
	{
		public function LoadingViewController( p_view:MovieClip )
		{
			super( p_view );
			
			view.$animation.stop( );
			setProgress( 0 );
		}
		
		public function setProgress( value:Number ):void
		{
			value = Math.max( 0, Math.min( 1, value ) );
			view.$bar.scaleX = value;
		}
		
		public function open(p_delay:uint=0):ISequence
		{
			view.$animation.play( );
			return Delay.execute( null, p_delay ).queue( animateIn, true );
		}
		
		public function close(p_delay:uint=0):ISequence
		{
			return Delay.execute( null, p_delay ).queue( animateOut, true ).queue( view.$animation.stop );
		}
		
		public override function dispose():void
		{
			view.$animation.stop( );
			super.dispose( );
		}
	}
}