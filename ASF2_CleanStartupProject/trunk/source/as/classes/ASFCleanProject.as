/*
Class: .ASFCleanProject
Author: Neto Leal
Created: May 27, 2011

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
	import asf.events.DependenciesProgressEvent;
	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;
	import asf.view.BaseLoaderApplication;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class ASFCleanProject extends BaseLoaderApplication
	{
		public function ASFCleanProject()
		{
			super( new LoaderMaxFactoryPlugin( ) );
			
			app.params.defaults.config = "../xml/application.xml";
			
			loadApplicationConfigFile( new URLRequest( app.params.config ) );
			
			addChild( app.view );
		}
		
		protected override function appConfigFileLoaded(event:Event):void
		{
			
		}
		
		protected override function appWillDispatchLoadComplete(event:Event):void
		{
			
		}
		
		protected override function appWillLoadDependencies(event:Event):void
		{
			
		}
		
		protected override function appLoadComplete(event:DependenciesProgressEvent):void
		{
			
		}
		
		protected override function appLoadProgress(event:DependenciesProgressEvent):void
		{
			
		}
		
		protected override function appLoadStart(event:DependenciesProgressEvent):void
		{
			
		}
	}
}