/*
Class: com.netoleal.asf.test.viewcontrollers.sections.gallery.GallerySectionViewController
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
package com.netoleal.asf.test.viewcontrollers.sections.gallery
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.sample.view.assets.GalleryThumb;
	import com.netoleal.asf.test.models.GalleryImageModel;
	import com.netoleal.asf.test.models.GalleryModel;
	import com.netoleal.asf.test.viewcontrollers.sections.AbstractSectionViewController;
	
	import flash.events.MouseEvent;
	
	import hype.extended.layout.GridLayout;
	
	public class GallerySectionViewController extends AbstractSectionViewController implements ITransitionable
	{
		private var model:GalleryModel;
		private var items:Vector.<GalleryThumbViewController>;
		
		public function GallerySectionViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
			
			model = new GalleryModel( section.dependencies.getXML( "data_xml" ), section.model );
		}
		
		public override function open(p_delay:uint=0):ISequence
		{
			var item:GalleryThumbViewController;
			var layout:GridLayout = new GridLayout( 0, 0, 66, 66, 8 );
			var itemModel:GalleryImageModel;
			var seq:ISequence = super.open( p_delay );
			var n:uint = 0;
			var btwDelay:uint = 50;
			
			items = new Vector.<GalleryThumbViewController>( );
			
			for each( itemModel in model.images )
			{
				item = new GalleryThumbViewController( new GalleryThumb( ), itemModel, this.section );
				
				item.addEventListener( MouseEvent.CLICK, onItemClick );
				
				section.container.addChild( item.view );
				
				layout.applyLayout( item.view );
				items.push( item );
				
				seq = item.open( p_delay + ( n * btwDelay ) );
				
				n++;
			}
			
			return seq;
		}
		
		private function onItemClick(event:MouseEvent):void
		{
			var item:GalleryThumbViewController = event.target as GalleryThumbViewController;
			
			section.mainApplication.trackAnalytics( section.mainApplication.metrics.asf.sample.gallery.select, item.getModel( ).imageFile );
			
			section.application.sounds.play( "imageClick" );
			section.application.navigation.openSection( "image", item.getModel( ), section );
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			var item:GalleryThumbViewController;
			var n:uint = 0;
			var btwDelay:uint = 15;
			var seq:Sequence;
			
			for each( item in items )
			{
				item.removeEventListener( MouseEvent.CLICK, onItemClick );
				
				seq = item.close( p_delay + ( n * btwDelay ) )
					.queue( section.container.removeChild, item.view )
					.queue( item.dispose ) as Sequence;
				
				n++;
			}
			
			items = null;
			
			if( !seq )
			{
				seq = super.close( p_delay ) as Sequence;
			}
			
			return seq;
		}
		
		public override function dispose( ):void
		{
			model = null;
			super.dispose( );
		}
	}
}