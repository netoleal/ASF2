/*
Class: com.netoleal.asf.test.viewcontrollers.assets.BufferingViewController
Author: Neto Leal
Created: May 17, 2011

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
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	public class BufferingViewController extends TransitionableViewController implements ITransitionable
	{
		public function BufferingViewController(p_view:*)
		{
			super(p_view);
			view.gotoAndStop( 1 );
		}
		
		public override function open(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			view.gotoAndPlay( 2 );
			fadeIn( view, 333, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			fadeOut( view, 333, p_delay ).queue( transition.notifyComplete ).queue( view.gotoAndStop, 1 )
			return transition;
		}
	}
}