﻿package  {		import flash.display.MovieClip;	import asf.view.BaseLoaderApplication;	import flash.net.URLRequest;	import asf.events.DependenciesProgressEvent;	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;	import asf.events.ApplicationEvent;	import flash.events.Event;		public class Dictionary1 extends BaseLoaderApplication 	{		public function Dictionary1( ) 		{			super( new LoaderMaxFactoryPlugin( ) );						$hello.text = "";						loadApplicationConfigFile( new URLRequest( "dictionary_1.xml" ) );		}				protected override function appLoadComplete( evt:DependenciesProgressEvent ):void		{			$hello.text = app._.hello;		}	}}