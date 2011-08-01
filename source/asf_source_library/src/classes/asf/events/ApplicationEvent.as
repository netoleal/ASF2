/*
Class: asf.events.ApplicationEvent
Author: Neto Leal
Created: Apr 14, 2011

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
package asf.events
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static const CONFIG_FILE_LOADED:String = "configFileLoaded";
		public static const WILL_LOAD_DEPENDENCIES:String = "willLoadDependencies";
		public static const DEPENDENCIES_UNLOAD:String = "dependenciesUnload";
		public static const WILL_DISPATCH_LOAD_COMPLETE:String = "willDispatchLoadComplete";
		public static const DISPOSE:String = "dispose";
		
		public function ApplicationEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
	}
}