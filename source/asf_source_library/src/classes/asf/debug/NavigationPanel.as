/*
Class: asf.debug.NavigationPanel
Author: Neto Leal
Created: May 22, 2011

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
package asf.debug
{
	import asf.core.app.ASF;
	import asf.core.elements.Section;
	
	internal class NavigationPanel extends BasePanel
	{
		private var scroll:ScrollPanel;
		
		public function NavigationPanel(p_app:ASF)
		{
			super( p_app );
			
			var bt:SectionItem = new SectionItem( app );
			scroll = new ScrollPanel( bt, 400, contentHeight - 2 );
			
			bt.x = 5;
			
			addChild( scroll );
		}
		
		public override function get title():String
		{
			return "Navigation";
		}
		
		public override function get contentHeight():uint
		{
			return 150;
		}
	}
}

import asf.core.elements.Section;
import asf.core.viewcontrollers.ApplicationViewController;
import asf.debug.DebugPanel;
import asf.events.ApplicationEvent;
import asf.events.DependenciesProgressEvent;
import asf.events.SectionEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

internal class SectionItem extends Sprite
{
	private var section:ApplicationViewController;
	private var childrenContainer:Sprite;
	private var bg:Sprite;
	private var items:Array;
	private var txt:TextField;
	
	public function SectionItem( p_section:ApplicationViewController )
	{
		
		txt = new TextField( );
		items = new Array( );
		
		bg = new Sprite( );
		
		section = p_section;
		
		txt.multiline = false;
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.defaultTextFormat = DebugPanel.getTextFormat( );
		txt.text = getText( );
		
		txt.mouseEnabled = false;
		
		bg.graphics.beginFill( 0xFFFFFF, 1 );
		bg.graphics.drawRect( 0, 0, txt.width, txt.height );
		bg.mouseChildren = false;
		bg.buttonMode = true;
		
		addChild( bg );
		addChild( txt );
		
		if( section.isLoaded )
		{
			enableChildren( );
			onSectionLoadComplete( null );
		}
		else
		{
			section.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, enableChildren );
		}
		
		section.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );
		section.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onSectionLoadComplete );
		section.addEventListener( ApplicationEvent.DEPENDENCIES_UNLOAD, onSectionUnload );
		
		if( section is Section )
		{
			//( section as Section ).addEventListener( SectionEvent.VIEW_OPEN_COMPLETE, onSectionLoadComplete );
		}
		
		bg.addEventListener( MouseEvent.CLICK, open );
	}
	
	private function getText( ):String
	{
		var s:String = section.model.id;
		if( section.navigation.sections.length > 0 )
		{
			s = "+ " + s;
		}
		
		return s;
	}
	
	private function onSectionLoadProgress( evt:DependenciesProgressEvent ):void
	{
		var bt:Number = evt.bytesTotal;
		var bl:Number = evt.bytesLoaded;
		var p:Number = 0;
		
		if( bt != 0 ) p = evt.bytesLoaded / evt.bytesTotal * 100;
		
		if( p == 0 )
		{
			onSectionUnload( null );
		}
		else
		{
			txt.text = getText( ) + " " + Math.round( p ) + "%";
			bg.width = txt.width;
		}
	}
	
	private function onSectionLoadComplete( evt:Event ):void
	{
		var ct:ColorTransform = new ColorTransform( );
		
		ct.color = 0x00FF00;
		
		txt.text = getText( ) + " (loaded)";
		bg.width = txt.width;
		
		bg.transform.colorTransform = ct;
		enableChildren( );
	}
	
	private function onSectionUnload( evt:ApplicationEvent ):void
	{
		txt.text = getText( );
		bg.width = txt.width;
		
		bg.transform.colorTransform = new ColorTransform( );
	}
	
	private function enableChildren( evt:Event = null ):void
	{
		if( evt ) evt.target.removeEventListener( DependenciesProgressEvent.LOAD_COMPLETE, enableChildren );
		
		section.addEventListener( ApplicationEvent.DISPOSE, close );
		
		var subSection:Section;
		var item:SectionItem;
		
		if( !childrenContainer )
		{
			childrenContainer = new Sprite( );
			
			for each( subSection in section.navigation.sections )
			{
				item = new SectionItem( subSection );
				
				item.addEventListener( Event.RESIZE, arrange );
				
				item.x = 10;
				items.push( item );
				
				childrenContainer.addChild( item );
			}
			
			childrenContainer.y = bg.height + 2;
		}
		
		addChild( childrenContainer );
		arrange( );
		
		this.dispatchEvent( new Event( Event.RESIZE ) );
	}
	
	private function arrange( evt:Event = null ):void
	{
		var item:SectionItem;
		var h:Number = 0;
		
		for each( item in items )
		{
			item.y = h;
			h += item.height + 2;
		}
		
		this.dispatchEvent( new Event( Event.RESIZE ) );
	}
	
	public function open( evt:MouseEvent = null ):void
	{
		if( section is Section )
		{
			var s:Section = section as Section;
			s.application.navigation.openSection( s );
		}
	}
	
	public function close( evt:Event = null ):void
	{
		if( contains( childrenContainer ) ) removeChild( childrenContainer );
		this.dispatchEvent( new Event( Event.RESIZE ) );
	}
}