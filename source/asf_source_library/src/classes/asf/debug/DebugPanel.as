/*
Class: asf.debug.DebugPanel
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
	import asf.core.viewcontrollers.ShowHideViewController;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class DebugPanel extends Sprite
	{
		private var bt:DebugButton;
		private var body:ShowHideViewController;
		
		public function DebugPanel( p_app:ASF )
		{
			super( );
			
			bt = new DebugButton( );
			body = new ShowHideViewController( new DebugPanelBody( p_app ), false );
			
			body.view.x = bt.width + 2;
			
			addChild( bt );
			addChild( body.view );
			
			bt.addEventListener( MouseEvent.MOUSE_DOWN, buttonDown );
			bt.addEventListener( MouseEvent.CLICK, buttonClick );
		}
		
		private function buttonDown( evt:MouseEvent ):void
		{
			bt.stage.addEventListener( MouseEvent.MOUSE_UP, buttonUp );
			this.startDrag( );
		}
		
		private function buttonUp( evt:MouseEvent ):void
		{
			bt.stage.removeEventListener( MouseEvent.MOUSE_UP, buttonUp );
			this.stopDrag( );
		}
		
		public function getPanel( type:Class ):*
		{
			return ( body.view as DebugPanelBody ).getPanel( type );
		}
		
		private function buttonClick( evt:MouseEvent ):void
		{
			body.setVisible( !body.visible );
		}
		
		public static function getTextFormat( ):TextFormat
		{
			var fmt:TextFormat = new TextFormat( );
			
			fmt.font = "Arial";
			fmt.size = 10;
			
			return fmt;
		}
	}
}

import asf.core.util.Sequence;
import asf.core.viewcontrollers.ShowHideViewController;
import asf.interfaces.ISequence;

import flash.display.SimpleButton;
import flash.display.Sprite;

internal class DebugButton extends SimpleButton
{
	private var sh:ShowHideViewController;
	
	public function DebugButton( )
	{
		sh = new ShowHideViewController( this, true );
		
		var size:uint = 20;
		var inSize:Number = size * 0.6;
		
		var normal:Sprite = new Sprite( );
		var over:Sprite = new Sprite( );
		
		normal.graphics.lineStyle( 1, 0 );
		normal.graphics.beginFill( 0xFFFFFF, 0.9 );
		normal.graphics.drawRect( 0, 0, size, size );
		normal.graphics.beginFill( 0 );
		normal.graphics.drawRect( ( size - inSize ) / 2, ( size - inSize ) / 2, inSize, inSize );
		normal.graphics.endFill( );
		
		over.graphics.lineStyle( 1, 0 );
		over.graphics.beginFill( 0xFFFFFF, 0.9 );
		over.graphics.drawRect( 0, 0, size, size );
		over.graphics.beginFill( 0xFFCC00 );
		over.graphics.drawRect( ( size - inSize ) / 2, ( size - inSize ) / 2, inSize, inSize );
		over.graphics.endFill( );
		
		this.upState = normal;
		this.overState = over;
		this.downState = overState;
		this.hitTestState = upState;
	}
	
	public function open( ):ISequence
	{
		return sh.setVisible( true );
	}
	
	public function close( ):ISequence
	{
		return sh.setVisible( false );
	}
}