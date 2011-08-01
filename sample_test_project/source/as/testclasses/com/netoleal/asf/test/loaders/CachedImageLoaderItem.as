package com.netoleal.asf.test.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	[Event( name="complete", type="flash.events.Event" )]
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	public class CachedImageLoaderItem extends EventDispatcher
	{
		private var url:String;
		private var loader:Loader;
		private var loaded:Boolean = false;
		private var loading:Boolean = false;
		
		public function CachedImageLoaderItem( p_url:String )
		{
			super( );
			
			url = p_url;
			loader = new Loader( );
			
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			
			load( );
		}
		
		public function get content( ):DisplayObject
		{
			var bmp:BitmapData;
			var bounds:Rectangle;
			var matrix:Matrix;
			
			try
			{
				if( loader.content is Bitmap )
				{
					try
					{
						return new Bitmap( ( loader.content as Bitmap ).bitmapData.clone( ), PixelSnapping.AUTO, true );
					}
					catch( e:Error )
					{
						return loader.content;
					}
				}
			}
			catch( e:Error )
			{
				log( "Could not duplicate content: " + e );
			}
			
			bmp = new BitmapData( loader.width, loader.height, true, 0 );
			bounds = loader.getBounds( loader );
			matrix = new Matrix( );
			
			matrix.translate( -bounds.x, - bounds.y );
			try
			{
				bmp.draw( loader, matrix );
				return new Bitmap( bmp, PixelSnapping.AUTO, true );
			}
			catch( e:Error ){ }
			
			return loader;
		}
		
		public function get isLoaded( ):Boolean
		{
			return loaded;
		}
		
		public function get isLoading( ):Boolean
		{
			return loading;
		}
		
		private function load( ):void
		{
			loading = true;
			loader.load( new URLRequest( url ) );
		}
		
		private function onProgress( evt:ProgressEvent ):void
		{
			this.dispatchEvent( evt );
		}
		
		private function onComplete( evt:Event ):void
		{
			loading = false;
			loaded = true;
			
			this.dispatchEvent( evt );
		}
	}
}