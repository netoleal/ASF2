/*
Class: com.netoleal.asf.test.view.sections.ContactSectionView
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
package com.netoleal.asf.test.view.sections
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.interfaces.ISectionView;
	import asf.interfaces.ISequence;
	
	import com.netoleal.asf.sample.view.assets.ContactSection;
	
	public class ContactSectionView extends ContactSection implements ISectionView
	{
		protected var transition:Sequence;
		private var section:Section;
		
		public function ContactSectionView()
		{
			super();
			transition = new Sequence( );
		}
		
		public function init(p_section:Section, ...parameters):void
		{
			section = p_section;
			
			this.$facebook.text = section._.facebook;
			this.$mail.text = section._.mail;
			this.$twitter.text = section._.twitter;
			
			this.$title.$text.text = section._.title;
		}
		
		public function open(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			fadeIn( this, 333, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public function close(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			fadeOut( this, 333, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public function dispose():void
		{
			transition.dispose( );
		}
	}
}