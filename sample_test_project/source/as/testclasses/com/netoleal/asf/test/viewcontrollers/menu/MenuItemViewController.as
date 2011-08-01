/*
Class: com.netoleal.asf.test.viewcontrollers.menu.MenuItemViewController
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
package com.netoleal.asf.test.viewcontrollers.menu
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import flash.display.MovieClip;
	
	public class MenuItemViewController extends ButtonViewController implements ITransitionable
	{
		private var section:Section;
		
		public function MenuItemViewController(p_view:MovieClip, p_section:Section)
		{
			section = p_section;
			
			super( p_view, { 
				over: section.application.sounds.getSoundItem( "dclick" ), 
				click: section.application.sounds.getSoundItem( "click" ) 
			} );
			
			view.$text.text = section.mainApplication.dictionary.menu[ section.id ] || section.id;
			view.alpha = 0;
			view.mouseChildren = false;
		}
		
		public function getSection( ):Section
		{
			return section;
		}
		
		public function open( delay:uint = 0 ):ISequence
		{
			transition.notifyStart( );
			fadeIn( view, 333, delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public function close( delay:uint = 0 ):ISequence
		{
			transition.notifyStart( );
			fadeOut( view, 333, delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function dispose():void
		{
			section = null;
			super.dispose( );
		}
	}
}