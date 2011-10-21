/*
Class: asf.debug.PerformancePanel
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
	
	import com.flashdynamix.utils.SWFProfiler;
	
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	internal class PerformancePanel extends BasePanel
	{
		private var profiler:SWFProfiler;
		private var txt:TextField;
		
		public function PerformancePanel( p_app:ASF )
		{
			super( p_app );
			
			SWFProfiler.init( app.container.stage, app.container );
			
			txt = new TextField( );
			
			txt.defaultTextFormat = DebugPanel.getTextFormat( );
			
			txt.mouseEnabled = false;
			txt.width = 400;
			txt.wordWrap = true;
			txt.multiline = true;
			
			SWFProfiler.start( );
			setInterval( refresh, 500 );
			
			addChild( txt );
		}
		
		private function refresh( ):void
		{
			var s:String = "";
			var debugger:String = (Capabilities.isDebugger) ? ' / Debugger' : '';
			var info:String = String("Flash Platform: " + Capabilities.version + " / " + Capabilities.playerType + debugger + " / " + Capabilities.os + " / " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
			
			s += "FPS: " + trunc( SWFProfiler.currentFps ) + " / " + trunc( SWFProfiler.averageFps ) + " max: " + trunc( SWFProfiler.maxFps );
			s += "\nMEM: " + trunc( SWFProfiler.currentMem );
			s += "\nPlayer Info: " + info;
			
			txt.text = s;
		}
		
		private function trunc( input:* ):String
		{
			return String( input ).substr( 0, 5 );
		}
		
		public override function get title():String
		{
			return "Performance";
		}
	}
}