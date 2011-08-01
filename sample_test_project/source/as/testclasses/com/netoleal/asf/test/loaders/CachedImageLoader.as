package com.netoleal.asf.test.loaders
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	[Event( name="complete", type="flash.events.Event" )]
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	public class CachedImageLoader extends Sprite
	{
		private static var items:Object;
		
		private var loader:CachedImageLoaderItem;
		private var content:DisplayObject;
		private var _url:String;
		private var _fade:Boolean;
		
		public function CachedImageLoader( )
		{
			super( );
		}
		
		public static function hasImageCached( url:String ):Boolean
		{
			return items != null && items[ url ] != null;
		}
		
		public function load( url:String, forceNew:Boolean = false, fadeInWhenComplete:Boolean = false ):CachedImageLoaderItem
		{
			forceNew = false;
			
			var forceStr:String = forceNew? "_" + Math.round( Math.random( ) * ( new Date( ).getTime( ) ) ).toString( ): "";
			this._url = url;
			this._fade = fadeInWhenComplete;
			
			if( !items ) items = new Object( );
			if( !items[ url + forceStr ] ) items[ url + forceStr ] = loader = new CachedImageLoaderItem( url );
			
			loader = items[ url + forceStr ];
			
			if( _fade )
			{
				alpha = 0;
			}
			
			if( loader.isLoading )
			{
				loader.addEventListener( Event.COMPLETE, onComplete );
				loader.addEventListener( ProgressEvent.PROGRESS, onProgress );
			}
			else
			{
				this.dispatchComplete( );
			}
			
			return loader;
		}
		
		public function get isLoaded( ):Boolean
		{
			return loader.isLoaded;
		}
		
		public function get contentURL( ):String
		{
			return _url;
		}
		
		public function dispose( ):void
		{
			if( loader )
			{
				loader.removeEventListener( Event.COMPLETE, onComplete );
				loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			}
			
			if( content )
			{
				this.removeChild( content );
			}
			
			content = null;
			loader = null;
		}
		
		private function onProgress( evt:ProgressEvent ):void
		{
			this.dispatchEvent( evt );
		}
		
		private function onComplete( evt:Event ):void
		{
			loader.removeEventListener( Event.COMPLETE, onComplete );
			loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			
			this.dispatchComplete( );
		}
		
		private function dispatchComplete( ):void
		{
			this.content = loader.content;
			this.addChild( content );
			
			if( _fade )
			{
				fadeIn( this );
			}

			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}