/*
Class: asf.plugins.loadermax.LoaderMaxPlugin
Author: Neto Leal
Created: Apr 18, 2011

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
package asf.plugins.loadermax
{
	import asf.core.loading.LoadingTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.dependencies.FileModel;
	import asf.interfaces.ILoaderPlugin;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class LoaderMaxPlugin extends EventDispatcher implements ILoaderPlugin
	{
		protected var app:ApplicationModel;
		protected var queue:LoaderMax;
		protected var queueSize:uint = 0;
		protected var loadedItems:uint = 0;
		
		public function LoaderMaxPlugin( auditSize:Boolean = true )
		{
			super( null );
			
			queue = new LoaderMax( { auditSize: auditSize } );
			
			queue.addEventListener( LoaderEvent.COMPLETE, onQueueComplete );
			queue.addEventListener( LoaderEvent.PROGRESS, onQueueProgress );
		}
		
		public function setApp( p_app:ApplicationModel ):void
		{
			app = p_app;
		}
		
		public function getApp( ):ApplicationModel
		{
			return app;
		}
		
		protected function onQueueComplete( evt:LoaderEvent ):void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onQueueProgress( evt:LoaderEvent ):void
		{
			var e:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS, evt.bubbles, evt.cancelable, queue.bytesLoaded, queue.bytesTotal );
			this.dispatchEvent( e );
		}
		
		public function addToQueue( file:FileModel ):void
		{
			var item:LoaderCore;
			var params:Object = 
			{
				estimatedBytes: file.weight,
				name: file.id
			};
			var context:LoaderContext = new LoaderContext( );
			var soundContext:SoundLoaderContext = new SoundLoaderContext( );
			
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			switch( file.type )
			{
				case LoadingTypes.SWF:
				{
					params.context = context;
					item = new SWFLoader( file.url, params );
					break;
				}
				case LoadingTypes.IMAGE:
				{
					params.context = context;
					item = new ImageLoader( file.url, params );
					break;
				}
				case LoadingTypes.SOUND:
				{
					params.autoPlay = false;
					item = new MP3Loader( file.url, params );
					break;
				}
				case LoadingTypes.BINARY:
				case LoadingTypes.XML:
				case LoadingTypes.TXT:
				{
					item = new DataLoader( file.url, params );
					break;
				}
				case LoadingTypes.VIDEO:
				{
					item = new VideoLoader( file.url, params );
					break;
				}
			}
			
			if( item )
			{
				item.addEventListener( LoaderEvent.COMPLETE, onItemLoadComplete );
				item.addEventListener( LoaderEvent.ERROR, onItemLoadError );
				
				queueSize++;
				queue.append( item );
			}
		}
		
		protected function onItemLoadError(event:LoaderEvent):void
		{
			var evt:IOErrorEvent = new IOErrorEvent( IOErrorEvent.IO_ERROR );
			var item:LoaderCore = event.target as LoaderCore;
			
			evt.text = "Error loading file: " + item.toString( );
			
			this.dispatchEvent( evt );
		}
		
		protected function onItemLoadComplete( evt:Event ):void
		{
			loadedItems++;
		}
		
		public function isLoaded( ):Boolean
		{
			return queue.status == LoaderStatus.COMPLETED || getTotalItems( ) == 0;
		}
		
		public function isLoading( ):Boolean
		{
			return queue.status == LoaderStatus.LOADING;
		}
		
		public function isPaused( ):Boolean
		{
			return queue.status == LoaderStatus.PAUSED;
		}
		
		public function startQueue(p_maxConnections:uint=0):void
		{
			queue.load( );
		}
		
		public function pause():void
		{
			queue.pause( );
		}
		
		public function resume():void
		{
			queue.resume( );
		}
		
		public function clear():void
		{
			queue.unload( );
		}
		
		public function dispose():void
		{
			queue.empty( true, true );
			
			queue.removeEventListener( LoaderEvent.COMPLETE, onQueueComplete );
			queue.removeEventListener( LoaderEvent.PROGRESS, onQueueProgress );
			
			queue = null;
		}
		
		public function getFile(idOrURL:String):*
		{
			var loader:LoaderCore = queue.getLoader( idOrURL );
			if( loader.content is ContentDisplay )
			{
				return loader.content.rawContent;
			}
			
			return loader.content;
		}
		
		public function getVideo( idOrURL:String ):NetStream
		{
			var loader:VideoLoader = queue.getLoader( idOrURL );
			return loader.netStream;
		}
		
		public function getXML( idOrURL:String ):XML
		{
			return new XML( getFile( idOrURL ) );
		}
		
		public function getMP3(idOrURL:String):Sound
		{
			return getFile( idOrURL );
		}
		
		public function getImageData(idOrURL:String):BitmapData
		{
			var img:ImageLoader = queue.getLoader( idOrURL );
			
			return ( img.rawContent as Bitmap ).bitmapData;
		}
		
		public function getImage( idOrURL:String ):Bitmap
		{
			var img:ImageLoader = queue.getLoader( idOrURL );
			
			return ( img.rawContent as Bitmap );
		}
		
		public function getSWF(idOrURL:String):*
		{
			return getFile( idOrURL );
		}
		
		public function getByteArray(idOrURL:String):ByteArray
		{
			return getFile( idOrURL );
		}
		
		public function getTotalItems( ):uint
		{
			return queueSize;
		}
		
		public function getItemsLoaded( ):uint
		{
			return loadedItems;
		}
		
		public function getBytesTotal( ):Number
		{
			return queue.bytesTotal;
		}
		
		public function getBytesLoaded( ):Number
		{
			return queue.bytesLoaded;
		}
		
		public function hasItem( idOrURL:String ):Boolean
		{
			return queue.getLoader( idOrURL ) != null;
		}
	}
}