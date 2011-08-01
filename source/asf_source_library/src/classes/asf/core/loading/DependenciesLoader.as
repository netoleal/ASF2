/*
Class: asf.core.loading.DependenciesLoader
Author: Neto Leal
Created: Apr 13, 2011

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
package asf.core.loading
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.dependencies.DependenciesModel;
	import asf.core.models.dependencies.FileModel;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.interfaces.ILoaderPlugin;
	import asf.log.LogLevel;
	
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class DependenciesLoader extends EventDispatcher
	{
		private var app:ApplicationModel;
		private var appVC:ApplicationViewController;
		
		private var _loader:ILoaderPlugin;
		private var dependenciesModel:DependenciesModel;
		private var externalLoader:URLLoader;
		private var isLoadingExternal:Boolean = false;
		private var _isPaused:Boolean = false;
		
		public function DependenciesLoader( p_loader:ILoaderPlugin, p_app:ApplicationModel, p_appVC:ApplicationViewController )
		{
			super( null );
			
			app = p_app;
			appVC = p_appVC;
			
			dependenciesModel = app.dependencies;
			
			_loader = p_loader;
			_loader.setApp( p_app );
			
			_loader.addEventListener( Event.COMPLETE, onLoaderComplete );
			_loader.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onDependenciesIOError );
			
			populateQueue( dependenciesModel );
		}
		
		private function onDependenciesIOError( evt:IOErrorEvent ):void
		{
			appVC.log( LogLevel.ERROR_1, "Error loading dependence" );
			this.dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ) );
		}
		
		private function onLoaderProgress( evt:ProgressEvent ):void
		{
			this.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, true, false, evt.bytesLoaded, evt.bytesTotal ) );
		}
		
		private function onLoaderComplete( evt:Event ):void
		{
			appVC.log( LogLevel.INFO_3 );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function addFileToQueue( file:FileModel ):void
		{
			appVC.log( LogLevel.INFO_3, file.type + ": " + file.url );
			loader.addToQueue( file );
		}
		
		private function populateQueue( model:DependenciesModel ):void
		{
			var file:FileModel;
			
			for each( file in model.files )
			{
				appVC.log( LogLevel.INFO_3, file.type + ": " + file.url );
				loader.addToQueue( file );
			}
		}
		
		public function get loader( ):ILoaderPlugin
		{
			return _loader;
		}
		
		public function load( ):void
		{
			appVC.log( LogLevel.INFO_3, "Start loading dependencies" );
				
			if( !hasExternal )
			{
				loader.startQueue( );
			}
			else
			{
				loadExternalSource( );
			}
		}
		
		private function get hasExternal( ):Boolean
		{
			return StringUtil.trim( dependenciesModel.externalSourceURL ) != ""
		}
		
		private function loadExternalSource( ):void
		{
			externalLoader = new URLLoader( );
			
			isLoadingExternal = true;
			
			appVC.log( LogLevel.INFO_3, "Starting loading external file for dependencies: " + dependenciesModel.externalSourceURL );
			
			externalLoader.addEventListener( Event.COMPLETE, onExternalSourceLoaded );
			externalLoader.addEventListener( IOErrorEvent.IO_ERROR, onExternalSourceError );
			
			externalLoader.load( new URLRequest( dependenciesModel.externalSourceURL ) );
		}
		
		public function pauseLoading( ):void
		{
			_isPaused = true;
			
			appVC.log( LogLevel.INFO_3 );
			
			if( hasExternal )
			{
				try
				{
					externalLoader.close( );
				}
				catch( e:Error ){ }
			}
			else
			{
				loader.pause( );
			}
		}
		
		public function resumeLoading( ):void
		{
			_isPaused = false;
			
			appVC.log( LogLevel.INFO_3 );
			
			if( hasExternal )
			{
				if( !isLoadingExternal )
				{
					loadExternalSource( );
				}
				else
				{
					externalLoader.load( new URLRequest( dependenciesModel.externalSourceURL ) );
				}
			}
			else
			{
				loader.resume( );
			}
		}
		
		private function onExternalSourceError(event:IOErrorEvent):void
		{
			appVC.log( LogLevel.ERROR_1, "Error loading external sources for: " + this.app.id );
			throw new Error( "Error loading external sources for: " + this.app.id );
		}
		
		private function onExternalSourceLoaded(event:Event):void
		{
			var data:XML = new XML( externalLoader.data );
			var externalModel:DependenciesModel = new DependenciesModel( data, app );
			
			populateQueue( externalModel );
			
			isLoadingExternal = false;
			
			loader.startQueue( );
		}
		
		public function isLoaded( ):Boolean
		{
			if( hasExternal && !externalLoader ) return false;
			else if( hasExternal && isLoadingExternal ) return false;
			else return loader.isLoaded( );
		}
		
		public function isLoading( ):Boolean
		{
			if( hasExternal && !externalLoader ) return false;
			else if( hasExternal && isLoadingExternal ) return true;
			else return loader.isLoading( );
		}
		
		public function isPaused( ):Boolean
		{
			return _isPaused;
		}
	}
}