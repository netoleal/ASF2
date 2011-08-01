/*
Class: .ASFv2
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
package 
{
	import asf.core.app.ASF;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.interfaces.ILoaderFactoryPlugin;
	import asf.log.LogLevel;
	import asf.plugins.analytics.ConsoleLogAnalyticsPlugin;
	import asf.plugins.bulkloader.BulkLoaderFactoryPlugin;
	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;
	import asf.plugins.loadermax.LoaderMaxPlugin;
	import asf.utils.Align;
	import asf.view.BaseLoaderApplication;
	
	import com.netoleal.asf.sample.view.assets.Loading;
	import com.netoleal.asf.test.viewcontrollers.assets.LoadingViewController;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	[SWF( frameRate="31", backgroundColor="#FFFFFF", width="960", height="700" )]
	
	public class ASFv2 extends BaseLoaderApplication
	{
		private var loading:LoadingViewController;
		
		public function ASFv2( )
		{
			var loaderFactory:ILoaderFactoryPlugin;
			
			loaderFactory = new LoaderMaxFactoryPlugin( );
			//loaderFactory = new BulkLoaderFactoryPlugin( );
			
			super( loaderFactory );
			
			app.analyticsPlugin = new ConsoleLogAnalyticsPlugin( );
			
			loading = new LoadingViewController( new Loading( ) );
			
			app.params.defaults.logLevel = LogLevel.INFO_3; //LogLevel.MUTE_0;
			app.params.defaults.config = "../xml/application.xml";
			app.params.defaults.noCache = String( Math.random( ) * ( new Date( ).getTime( ) ) );
			
			app.logLevel = app.params.logLevel;
			
			loading.open( ).queue( this.loadApplicationConfigFile, new URLRequest( app.params.config ) );
			
			addChild( app.view );
			addChild( loading.view );
			
			Align.add( loading.view, Align.CENTER + Align.MIDDLE, { width: 0, height: 0 } );
		}
		
		protected override function appWillDispatchLoadComplete(event:Event):void
		{
			app.pauseLoading( );
			
			Align.remove( loading.view );
			
			log( );
			
			app.removeEventListener( ApplicationEvent.CONFIG_FILE_LOADED, appConfigFileLoaded );
			app.removeEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, appWillDispatchLoadComplete );
			app.removeEventListener( DependenciesProgressEvent.LOAD_PROGRESS, appLoadProgress );
			
			loading.close( )
				.queue( removeChild, loading.view )
				.queue( loading.dispose )
				.queue( app.resumeLoading );
		}
		
		protected override function appLoadProgress(event:DependenciesProgressEvent):void
		{
			loading.setProgress( event.bytesLoaded / event.bytesTotal );
		}
		
		protected override function appConfigFileLoaded(event:Event):void
		{
			log( app.params.test );
			log( app.params.debug );
			log( app.params.param );
			log( app.params.base );
			log( app.params.param2 );
			log( app.params.param3 );
		}
	}
}