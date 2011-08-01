/*
Class: asf.view.BasicSectionView
Author: Neto Leal
Created: Apr 29, 2011

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
package asf.view
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.interfaces.ISectionView;
	import asf.interfaces.ISequence;
	
	import flash.display.Sprite;
	
	public class BasicSectionView extends UIView implements ISectionView
	{
		protected var section:Section;
		protected var transition:Sequence;
		
		public function BasicSectionView()
		{
			super( true );
			transition = new Sequence( );
		}
		
		public function init(p_section:Section, ... extraArgs):void
		{
			section = p_section;
		}
		
		public function open(p_delay:uint = 0 ):ISequence
		{
			return null;
		}
		
		public function close(p_delay:uint = 0 ):ISequence
		{
			return null;
		}
		
		public override function dispose():void
		{
			section = null;
			transition = null;
			super.dispose( );
		}
	}
}