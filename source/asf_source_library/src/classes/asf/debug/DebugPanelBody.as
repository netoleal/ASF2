/*
Class: asf.debug.DebugPanelBody
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
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ShowHideViewController;
	import asf.interfaces.ITransitionable;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	internal class DebugPanelBody extends Sprite
	{
		private var bg:Shape;
		private var panels:Array;
		private var currentPanel:BasePanel;
		private var title:TextField;
		
		public function DebugPanelBody( p_app:ASF )
		{
			super( );
			
			var panel:BasePanel;
			var w:Number = 2;
			var bt:PanelButton;
			
			panels = [ 
				  new PerformancePanel( p_app )
				, new NavigationPanel( p_app ) 
			];
			
			for each( panel in panels )
			{
				bt = new PanelButton( panel );
				
				bt.addEventListener( MouseEvent.CLICK, buttonClick );
				
				bt.x = w;
				bt.y = 2;
				
				w += bt.width + 2;
				
				addChild( bt );
			}
			
			title = new TextField( );
			
			var titleFmt:TextFormat = DebugPanel.getTextFormat( );
			
			titleFmt.bold = true;
			titleFmt.size = 11;
			
			title.defaultTextFormat = titleFmt;
			
			bg = new Shape( );
			
			bg.graphics.beginFill( 0xFFFFFF, 0.9 );
			bg.graphics.lineStyle( 0, 1 );
			bg.graphics.drawRect( 0, 0, Math.max( w + 2, 400 ), 100 );
			bg.graphics.endFill( );
			
			title.y = 20;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.multiline = false;
			title.mouseEnabled = false;
			
			addChildAt( bg, 0 );
			addChild( title );
			
			showPanel( panels[ 0 ] );
		}
		
		private function buttonClick( evt:MouseEvent ):void
		{
			showPanel( ( evt.currentTarget as PanelButton ).getPanel( ) );
		}
		
		private function showPanel( panel:BasePanel ):void
		{
			if( currentPanel )
			{
				removeChild( currentPanel );
			}
			
			currentPanel = panel;
			title.text = currentPanel.title;
			
			currentPanel.y = title.y + title.height;
			
			bg.height = currentPanel.y + currentPanel.contentHeight;
			
			addChild( currentPanel );
		}
		
		public function dispose( ):void
		{
		}
	}
}

import asf.debug.BasePanel;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

internal class PanelButton extends Sprite
{
	private var panel:BasePanel;
	
	public function PanelButton( p_panel:BasePanel )
	{
		var bt:SimpleButton = new SimpleButton( );
		var normal:Sprite = new Sprite( );
		var over:Sprite = new Sprite( );
		var txt:TextField = new TextField( );
		var fmt:TextFormat = new TextFormat( );
		
		panel = p_panel;
		
		fmt.font = "Arial";
		fmt.size = 10;
		fmt.color = 0xFFFFFF;
		
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.multiline = false;
		
		txt.text = panel.title;
		txt.setTextFormat( fmt );
		
		draw( txt.width, txt.height, normal, 0 );
		draw( txt.width, txt.height, over, 0x666666 );
		
		bt.upState = normal;
		bt.overState = over;
		bt.downState = over;
		bt.hitTestState = normal;
		
		txt.mouseEnabled = false;
		
		addChild( bt );
		addChild( txt );
	}
	
	public function getPanel( ):BasePanel
	{
		return panel;
	}
	
	private function draw( width:uint, height:uint, target:Sprite, color:uint ):void
	{
		target.graphics.lineStyle( 0, 0 );
		target.graphics.beginFill( color, 1 );
		target.graphics.drawRect( 0, 0, width, height );
		target.graphics.endFill( );
	}
}