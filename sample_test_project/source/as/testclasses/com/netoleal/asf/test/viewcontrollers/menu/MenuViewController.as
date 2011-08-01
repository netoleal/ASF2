/*
Class: com.netoleal.asf.test.viewcontrollers.menu.MenuViewController
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
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.sample.view.assets.MenuButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import hype.extended.layout.GridLayout;
	
	[Event(name="resize", type="flash.events.Event")]
	
	public class MenuViewController extends TransitionableViewController implements ITransitionable
	{
		private var section:Section;
		private var items:Vector.<MenuItemViewController>;
		
		public function MenuViewController(p_view:*, p_section:Section)
		{
			super(p_view);
			
			section = p_section;
		}
		
		public override function open( p_delay:uint=0 ):ISequence
		{
			var seq:ISequence;
			var n:uint = 0;
			var btwDelay:uint = 50;
			var subSection:Section;
			var item:MenuItemViewController;
			var layout:GridLayout = new GridLayout( 0, 0, 0, 30, 1 );
			
			items = new Vector.<MenuItemViewController>( );
			
			for each( subSection in section.navigation.sections )
			{
				if( subSection.params.showInMenu != "false" )
				{
					item = new MenuItemViewController( new MenuButton( ), subSection );
					
					item.addEventListener( MouseEvent.CLICK, onItemClick );
					
					layout.applyLayout( item.view );
					viewAsSprite.addChild( item.view );
					items.push( item );
					
					seq = item.open( p_delay + ( n * btwDelay ) );
					n++;
				}
			}
			
			this.dispatchEvent( new Event( Event.RESIZE ) );
			
			return seq;
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			var item:MenuItemViewController = event.target as MenuItemViewController;
			
			section.navigation.openSection( { 
				section: item.getSection( ), 
				closeCurrentBeforeOpen: true,
				setAsCurrent: true
			} );
		}		
		
	}
}