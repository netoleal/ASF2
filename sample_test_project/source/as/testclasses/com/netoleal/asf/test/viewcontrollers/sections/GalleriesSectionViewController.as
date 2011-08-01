/*
Class: com.netoleal.asf.test.viewcontrollers.sections.GallerySectionViewController
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
package com.netoleal.asf.test.viewcontrollers.sections
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.sample.view.assets.GalleryButton;
	import com.netoleal.asf.sample.view.assets.MenuButton;
	import com.netoleal.asf.test.viewcontrollers.menu.MenuItemViewController;
	
	import flash.events.MouseEvent;
	
	import hype.extended.layout.GridLayout;
	
	public class GalleriesSectionViewController extends AbstractSectionViewController implements ITransitionable
	{
		private var menuItems:Vector.<MenuItemViewController>;
		
		public function GalleriesSectionViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
			
			view.$title.$text.text = section._.title;
		}
		
		public override function open( p_delay:uint = 0 ):ISequence
		{
			var layout:GridLayout = new GridLayout( 0, 0, 150, 0, section.navigation.sections.length );
			var item:MenuItemViewController;
			var gallery:Section;
			var seq:ISequence;
			var n:uint = 0;
			var btwDelay:uint = 50;
			
			menuItems = new Vector.<MenuItemViewController>( );
			
			super.open( p_delay );
			
			for each( gallery in section.navigation.sections )
			{
				if( gallery.params.showInMenu != "false" )
				{
					item = new MenuItemViewController( new GalleryButton( ), gallery );
					
					item.addEventListener( MouseEvent.CLICK, onMenuItemClick );
					
					layout.applyLayout( item.view );
					seq = item.open( p_delay + ( n * btwDelay ) );
					
					section.layers.menu.addChild( item.view );
					menuItems.push( item );
					
					n++;
				}
			}
			
			return seq.queue( navigateFirst );
		}
		
		private function onMenuItemClick(event:MouseEvent):void
		{
			var item:MenuItemViewController = event.target as MenuItemViewController;
			
			section.navigation.openSection( item.getSection( ) );
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			var item:MenuItemViewController;
			var n:uint = 0;
			var btwDelay:uint = 30;
			var seq:ISequence;
			
			for each( item in menuItems )
			{
				item.removeEventListener( MouseEvent.CLICK, onMenuItemClick );
				seq = item.close( p_delay + ( n * btwDelay ) );
			}
			
			if( !seq ) return super.close( p_delay );
			return seq.queue( super.close );
		}
		
		private function navigateFirst( ):Sequence
		{
			transition.notifyStart( );
			section.navigation.openSection( section.navigation.sections[ 0 ] );
			transition.notifyComplete( );
			
			return transition;
		}
		
		public override function dispose():void
		{
			var item:MenuItemViewController;
			
			log( );
			
			for each( item in menuItems )
			{
				section.layers.menu.removeChild( item.view );
				item.dispose( );
			}
			
			menuItems = null;
			
			super.dispose( );
		}
	}
}