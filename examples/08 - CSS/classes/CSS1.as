﻿package  {		import flash.display.MovieClip;	import asf.view.BaseLoaderApplication;	import flash.net.URLRequest;	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;	import asf.events.DependenciesProgressEvent;	import hype.extended.layout.GridLayout;		public class CSS1 extends BaseLoaderApplication 	{		private var style:Object;				public function CSS1( ) 		{			super( new LoaderMaxFactoryPlugin( ) );						loadApplicationConfigFile( new URLRequest( "css_1.xml" ) );		}				protected override function appLoadComplete( evt:DependenciesProgressEvent ):void		{			var square:Square;			var count:uint;			var n:uint;			var layout:GridLayout;						style = app.styles.getStyleFor( this );						count = parseInt( app.params.squareCount );						layout = new GridLayout( 				parseInt( style.marginLeft ), 				parseInt( style.marginTop ), 				parseInt( style.xSpacement ), 				parseInt( style.ySpacement ),				parseInt( style.columns ) );						for( n = 0; n < count; n++ )			{				square = new Square( parseInt( style.squareWidth ), parseInt( style.squareHeight ) );				layout.applyLayout( square );								addChild( square );			}		}	}}import flash.display.Shape;internal class Square extends Shape{	public function Square( w:Number, h:Number )	{		var color:uint = Math.round( Math.random( ) * 0xFFFFFF );				graphics.beginFill( color, 1 );		graphics.drawRect( 0, 0, w, h );		graphics.endFill( );	}}