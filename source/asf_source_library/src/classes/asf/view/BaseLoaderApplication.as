/*
Class: asf.view.BaseLoaderApplication
Author: Neto Leal
Created: Jun 9, 2011

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
package asf.view
{
	import asf.core.app.ASF;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.interfaces.ILoaderFactoryPlugin;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class BaseLoaderApplication extends UIView
	{
		protected var app:ASF;
		
		public function BaseLoaderApplication( loaderFactory:ILoaderFactoryPlugin, id:String = "", setStage:Boolean = true )
		{
			super( true );
			
			if( setStage )
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			app = new ASF( new Sprite( ), root.loaderInfo, loaderFactory, id );
			
			app.addEventListener( ApplicationEvent.CONFIG_FILE_LOADED, appConfigFileLoaded );
			app.addEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, appWillDispatchLoadComplete );
			app.addEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, appWillLoadDependencies );
			
			app.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, appLoadComplete );
			app.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, appLoadProgress );
			app.addEventListener( DependenciesProgressEvent.LOAD_START, appLoadStart );
		}
		
		protected function loadApplicationConfigFile( configFileURL:URLRequest ):void
		{
			app.loadModel( configFileURL );
		}
		
		protected function appLoadStart(event:DependenciesProgressEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function appLoadProgress(event:DependenciesProgressEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function appLoadComplete(event:DependenciesProgressEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function appWillLoadDependencies(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function appWillDispatchLoadComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function appConfigFileLoaded(event:Event):void
		{
			
		}
	}
}