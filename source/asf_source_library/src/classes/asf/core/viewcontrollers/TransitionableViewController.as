/*
Class: asf.core.viewcontrollers.TransitionableViewController
Author: Neto Leal
Created: May 13, 2011

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
package asf.core.viewcontrollers
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	public class TransitionableViewController extends AbstractViewController implements ITransitionable
	{
		protected var transition:Sequence;
		
		public function TransitionableViewController(p_view:*)
		{
			super(p_view);
			transition = new Sequence( );
		}
		
		public function open( p_delay:uint = 0 ):ISequence
		{
			throw new Error( "Method TransitionableViewController.open must be overridden" );
			return null;
		}
		
		public function close( p_delay:uint = 0 ):ISequence
		{
			throw new Error( "Method TransitionableViewController.close must be overridden" );
			return null;
		}
		
		public override function dispose():void
		{
			transition = null;
			super.dispose( );
		}
	}
}