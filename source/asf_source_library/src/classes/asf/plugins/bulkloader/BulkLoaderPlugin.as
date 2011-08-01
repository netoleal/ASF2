/*
Class: asf.plugins.bulkloader.BulkLoaderPlugin
Author: Neto Leal
Created: May 9, 2011

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
package asf.plugins.bulkloader
{
	import asf.core.loading.LoadingTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.dependencies.FileModel;
	import asf.interfaces.ILoaderPlugin;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * Plugin for loading Application dependencies based on BulkLoader
	 * <br/>
	 * Visit https://github.com/arthur-debert/BulkLoader/wiki for more details
	 *  
	 * @author neto.leal
	 * 
	 */
	public class BulkLoaderPlugin extends EventDispatcher implements ILoaderPlugin
	{
		protected var queue:BulkLoader;
		protected var app:ApplicationModel;
		protected var queueSize:int;
		protected var loadedItems:uint = 0;
		protected var _isPaused:Boolean = false;
		
		public function BulkLoaderPlugin( )
		{
			super( null );
			
			queue = new BulkLoader( );
			
			//queue.logLevel = BulkLoader.LOG_VERBOSE;
			
			queue.addEventListener( BulkLoader.COMPLETE, onQueueComplete );
			queue.addEventListener( BulkProgressEvent.PROGRESS, onQueueProgress );
		}
		
		protected function onQueueComplete( evt:BulkProgressEvent ):void
		{
			dispatchComplete( );
		}
		
		private function dispatchComplete( ):void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function onQueueProgress( evt:BulkProgressEvent ):void
		{
			var e:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS, evt.bubbles, evt.cancelable, queue.bytesLoaded, queue.bytesTotal );
			this.dispatchEvent( e );
		}
		
		public function addToQueue(p_file:FileModel):void
		{
			var params:Object = {
				id: p_file.id,
				priority: p_file.priority,
				weight: p_file.weight
			};
			
			var context:LoaderContext = new LoaderContext( );
			var soundContext:SoundLoaderContext = new SoundLoaderContext( );
			var item:LoadingItem;
			
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			switch( p_file.type )
			{
				case LoadingTypes.SWF:
				{
					params.context = context;
					params.type = BulkLoader.TYPE_MOVIECLIP;
					break;
				}
				case LoadingTypes.IMAGE:
				{
					params.context = context;
					params.type = BulkLoader.TYPE_IMAGE;
					break;
				}
				case LoadingTypes.SOUND:
				{
					params.autoPlay = false;
					params.type = BulkLoader.TYPE_SOUND;
					break;
				}
				case LoadingTypes.BINARY:
				{
					params.type = BulkLoader.TYPE_BINARY;
					break;
				}
				case LoadingTypes.XML:
				{
					params.type = BulkLoader.TYPE_XML;
					break;
				}
				case LoadingTypes.TXT:
				{
					params.type = BulkLoader.TYPE_TEXT;
					break;
				}
				case LoadingTypes.VIDEO:
				{
					params.type = BulkLoader.TYPE_VIDEO;
					break;
				}
			}
			
			item = queue.add( p_file.url, params );
			
			item.addEventListener( Event.COMPLETE, onItemComplete );
			item.addEventListener( BulkLoader.ERROR, onItemError );
				
			queueSize++;
		}
		
		protected function onItemError(event:Event):void
		{
			var item:LoadingItem = event.target as LoadingItem;
			var evt:IOErrorEvent = new IOErrorEvent( IOErrorEvent.IO_ERROR );
			
			evt.text = "Error loading file: " + item.url.url;
			
			this.dispatchEvent( evt );
		}
		
		protected function onItemComplete(event:Event):void
		{
			loadedItems++;
		}
		
		public function startQueue(p_maxConnections:uint=0):void
		{
			_isPaused = false;
			queue.start( );
		}
		
		public function setApp(p_app:ApplicationModel):void
		{
			app = p_app;
		}
		
		public function getApp():ApplicationModel
		{
			return app;
		}
		
		public function pause( ):void
		{
			_isPaused = true;
			queue.pauseAll( );
		}
		
		public function resume():void
		{
			_isPaused = false;
			queue.resumeAll( );
			
			if( queue.isFinished )
			{
				dispatchComplete( );
			}
		}
		
		public function clear():void
		{
			queue.clear( );
		}
		
		public function dispose():void
		{
			clear( );
			
			queue.removeEventListener( BulkProgressEvent.COMPLETE, onQueueComplete );
			queue.removeEventListener( BulkProgressEvent.PROGRESS, onQueueProgress );
			
			queue = null;
		}
		
		public function getFile(idOrURL:String):*
		{
			var item:LoadingItem = queue.get( idOrURL );
			if( item )
			{
				return item.content;
			}
			
			return null;
		}
		
		public function getMP3(idOrURL:String):Sound
		{
			return queue.getSound( idOrURL );
		}
		
		public function getImageData(idOrURL:String):BitmapData
		{
			return queue.getBitmapData( idOrURL );
		}
		
		public function getImage(idOrURL:String):Bitmap
		{
			return queue.getBitmap( idOrURL );
		}
		
		public function getSWF(idOrURL:String):*
		{
			return getFile( idOrURL );
		}
		
		public function getByteArray(idOrURL:String):ByteArray
		{
			return queue.getBinary( idOrURL );
		}
		
		public function getXML(idOrURL:String):XML
		{
			return queue.getXML( idOrURL );
		}
		
		public function getVideo(idOrURL:String):NetStream
		{
			return queue.getNetStream( idOrURL );
		}
		
		public function hasItem(idOrURL:String):Boolean
		{
			return queue.hasItem( idOrURL );
		}
		
		public function getTotalItems():uint
		{
			return queue.itemsTotal;
		}
		
		public function getItemsLoaded():uint
		{
			return queue.itemsLoaded;
		}
		
		public function getBytesTotal():Number
		{
			return queue.bytesTotal;
		}
		
		public function getBytesLoaded():Number
		{
			return queue.bytesLoaded;
		}
		
		public function isLoaded():Boolean
		{
			 return queue.isFinished || queue.itemsTotal == 0;
		}
		
		public function isLoading():Boolean
		{
			return queue.isRunning;
		}
		
		public function isPaused():Boolean
		{
			return _isPaused;
		}
	}
}