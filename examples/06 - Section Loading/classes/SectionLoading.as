﻿package  {		import flash.display.MovieClip;	import asf.view.BaseLoaderApplication;	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;	import flash.net.URLRequest;	import asf.core.viewcontrollers.ButtonViewController;	import asf.events.DependenciesProgressEvent;	import flash.events.MouseEvent;	import view.Loading;	import asf.events.NavigationEvent;	import asf.core.elements.Section;	import asf.events.ApplicationEvent;	import flash.events.Event;	import asf.utils.Delay;	import asf.log.LogLevel;		public class SectionLoading extends BaseLoaderApplication 	{		{			Cache;		}				private var btHome:ButtonViewController;		private var btImages:ButtonViewController;		private var loading:LoadingViewController;				public function SectionLoading( ) 		{			super( new LoaderMaxFactoryPlugin( ) );						btHome = new ButtonViewController( $menu1 );			btImages = new ButtonViewController( $menu2 );			loading = new LoadingViewController( new Loading( ) );						btHome.view.$label.text = "Home";			btImages.view.$label.text = "Images";						loadApplicationConfigFile( new URLRequest( "section_loading_1.xml" ) );						app.navigation.addEventListener( NavigationEvent.CHANGE, onAppNavigationChange );						addChild( app.view );		}				protected override function appConfigFileLoaded( event:Event ):void		{			app.layers.loading.addChild( loading.view );		}				protected override function appLoadComplete(event:DependenciesProgressEvent):void		{			btHome.addEventListener( MouseEvent.CLICK, onMenuClick );			btImages.addEventListener( MouseEvent.CLICK, onMenuClick );		}				private function onAppNavigationChange( evt:NavigationEvent ):void		{			var section:Section = evt.section;			section.addEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionWillLoad );		}				private function onSectionWillLoad( evt:ApplicationEvent ):void		{			var section:Section = evt.target as Section;						section.removeEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionWillLoad );						section.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );			section.addEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, onSectionWillDispatchComplete );						section.pauseLoading( );						loading.setProgress( 0 );			loading.animateIn( ).queue( section.resumeLoading );		}				private function onSectionLoadProgress( evt:DependenciesProgressEvent ):void		{			loading.setProgress( evt.bytesLoaded / evt.bytesTotal );		}				private function onSectionWillDispatchComplete( evt:ApplicationEvent ):void		{			var section:Section = evt.target as Section;						section.removeEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );			section.removeEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, onSectionWillDispatchComplete );						loading.setProgress( 1 );						section.pauseLoading( );			loading.animateOut( ).queue( section.resumeLoading );		}				private function onMenuClick( evt:MouseEvent ):void		{			switch( evt.target )			{				case btHome:				{					app.navigation.openSection( "home" );					break;				}				case btImages:				{					app.navigation.openSection( "images" );					break;				}			}		}	}}