/*
Class: com.netoleal.asf.test.viewcontrollers.sections.gallery.GalleryThumbViewController
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
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	import asf.utils.Delay;
	
	import com.netoleal.asf.test.models.GalleryImageModel;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class GalleryThumbViewController extends ButtonViewController implements ITransitionable
	{
		private var model:GalleryImageModel;
		private var loader:Loader;
		private var section:Section;
		
		public function GalleryThumbViewController(p_view:MovieClip, p_model:GalleryImageModel, p_section:Section)
		{
			section = p_section;
			
			super(p_view, { over: ( section.application as Section ).application.sounds.getSoundItem( "dclick" ) } );
			
			model = p_model;
			
			loader = new Loader( );
			
			if( view.$image )
			{
				view.$image.addChild( loader );
			}
			else
			{
				view.addChild( loader );
			}
			
			var context:LoaderContext = new LoaderContext( );
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			loader.load( new URLRequest( model.thumbURL ), context );
			loader.alpha = 0;
			
			alpha = 0;
			visible = false;
		}
		
		public function getModel( ):GalleryImageModel
		{
			return model;
		}
		
		private function onLoadComplete(event:Event):void
		{
			fadeIn( loader );
		}
		
		public function open(p_delay:uint=0):ISequence
		{
			Delay.execute( section.application.sounds.play, p_delay, "imageIn" );
			return fadeIn( view, 333, p_delay );
		}
		
		public function close(p_delay:uint=0):ISequence
		{
			return fadeOut( view, 300, p_delay );
		}
		
		public override function dispose( ):void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			try
			{
				loader.close( );
			}
			catch( e:Error ){ }
			
			section = null;
			loader.parent.removeChild( loader );
			loader = null;
			super.dispose( );
		}
	}
}