/*
Class: com.netoleal.asf.test.viewcontrollers.sections.gallery.GalleryImageViewController
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
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.sample.view.assets.ButtonBack;
	import com.netoleal.asf.sample.view.assets.Loading;
	import com.netoleal.asf.test.models.GalleryImageModel;
	import com.netoleal.asf.test.viewcontrollers.assets.BackButtonViewController;
	import com.netoleal.asf.test.viewcontrollers.assets.LoadingViewController;
	import com.netoleal.asf.test.viewcontrollers.sections.AbstractSectionViewController;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class GalleryImageSectionViewController extends AbstractSectionViewController implements ITransitionable
	{
		private var model:GalleryImageModel;
		private var previous:Section;
		
		private var back:ButtonViewController;
		private var loader:Loader;
		private var loading:LoadingViewController;
		
		public function GalleryImageSectionViewController(p_view:*, p_section:Section, p_model:GalleryImageModel, p_previousSection:Section)
		{
			super(p_view, p_section);
			
			model = p_model;
			previous = p_previousSection;
			
			back = new BackButtonViewController( new ButtonBack( ), section.application._.back );
			loading = new LoadingViewController( new Loading( ) );
			
			loader = new Loader( );
			
			section.layers.back.addChild( back.view );
			section.layers.image.addChild( loader );
			section.layers.image.addChild( loading.view );
			
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			
			loader.alpha = 0;
			
			loading.view.x = 100;
			loading.view.y = 50;
			
			loading.open( ).queue( loader.load, new URLRequest( model.imageURL ) );
			
			back.addEventListener( MouseEvent.CLICK, onBackClick );
		}
		
		private function onLoadProgress( evt:ProgressEvent ):void
		{
			loading.setProgress( evt.bytesLoaded / evt.bytesTotal );
		}
		
		private function onLoadComplete(event:Event):void
		{
			loading.close( ).queue( fadeIn, loader );
		}
		
		private function onBackClick(event:MouseEvent):void
		{
			section.application.navigation.openSection( previous );
		}
		
		public override function dispose():void
		{
			section.layers.back.removeChild( back.view );
			section.layers.image.removeChild( loading.view );
			section.layers.image.removeChild( loader );
			
			back.removeEventListener( MouseEvent.CLICK, onBackClick );
			back.dispose( );
			
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			
			loading.dispose( );
			
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			
			try
			{
				loader.close( );
			}
			catch( e:Error ){ }
			
			section = null;
			model = null;
			previous = null;
			
			super.dispose( );
		}
	}
}