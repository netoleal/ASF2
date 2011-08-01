/*
Class: asf.core.commands.CommandsDispatcher
Author: Neto Leal
Created: Apr 29, 2011

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
package asf.core.commands
{
	import asf.interfaces.ICommand;
	import flash.utils.Dictionary;
	
	public class CommandsDispatcher
	{
		
		private static var initialized:Boolean;
		
		private static var events:Object;
		
		private static var history:Array;
		
		public static function init( ):void {
			
			if( initialized ) return;
			
			events = new Object( );
			history = new Array( );
			
			initialized = true;
			
		}
		
		public static function registerCommand( eventName:String ):Boolean {
			
			init( );
			
			if( events[ eventName ] == null ) events[ eventName ] = new Dictionary( true );
			
			return true;
			
		}
		
		public static function pushCommand( eventName:String, command:*, ... restArguments ):void {
			
			push( eventName, command, restArguments );
			
		}
		
		public static function removeCommand( eventName:String, command:* ):void {
			
			remove( eventName, command );
			
		}
		
		public static function pushFunction( eventName:String, method:Function, ... restArguments ):void {
			
			push( eventName, method, restArguments );
				
		}
		
		public static function removeFunction( eventName:String, method:Function ):void {
			
			remove( eventName, method );
			
		}
		
		private static function push( eventName:String, eventListener:*, arguments:Array = null ):void {
			
			init( );
			
			registerCommand( eventName );
			
			var elmnt:CommandsDispatcherElement = new CommandsDispatcherElement( );
			
			elmnt.whatToExecute = eventListener;
			elmnt.arguments = arguments;
			
			events[ eventName ][ elmnt ] = elmnt;
			
		}
		
		private static function remove( eventName:String, eventListener:* ):void {
			
			var dict:Dictionary;
			var elmnt:CommandsDispatcherElement;
			
			init( );
			
			if( events[ eventName ] == null ) return;
			
			dict = events[ eventName ];
			for each( elmnt in dict )
			{
				if( elmnt.whatToExecute == eventListener )
				{
					elmnt.dispose( );
					dict[ elmnt ] = null;
					delete dict[ elmnt ];
				}
			}
			 
		}
		
		public static function clearCommand( eventName:String ):void {
			
			unregisterCommand( eventName );
			registerCommand( eventName );
			
		}
		
		public static function unregisterCommand( eventName:String ):void {
			
			delete events[ eventName ];
		}
		
		public static function broadcastCommand( eventName:String, ... extraArguments ):void {
			
			if( events == null ) return;
			
			var dict:Dictionary = events[ eventName ];
			if( dict == null ) return;
			
			var elmnt:CommandsDispatcherElement;
			var args:Array;
			
			history.push( { eventName: eventName, extraArguments: extraArguments } );
			
			for each( elmnt in dict )
			{
				if( elmnt.canExecute )
				{
					args = elmnt.arguments;
					if( extraArguments != null && extraArguments.length > 0 ) 
					{
						if( args == null ) args = [ ];
						args = args.concat( extraArguments );
					}
						
					if( elmnt.whatToExecute is Function ) {
						
						( elmnt.whatToExecute as Function ).apply( null, args );
						
					}
					else if( elmnt.whatToExecute is Class ) 
					{
						var instance:ICommand = new elmnt.whatToExecute();
						instance.execute.apply( null, args );
					}
					else if( elmnt.whatToExecute is ICommand ) 
					{
						elmnt.whatToExecute.execute.apply( null, args );
					}
					
				}
				
			}
			/*
			if( AppGlobalCommands.all.indexOf( eventName ) == -1 )
			{
				broadcastEvent( AppGlobalCommands.FRONT_CONTROLLER_EVENT_BROADCASTED );
			}
			*/
			
		}
		
		public static function getHistory( ):Array
		{
			return history.concat( );
		}
		
		public static function stopBroadcasting( eventName:String ):void {
			
			flagEvent( eventName, false );
			
		}
		
		public static function restoreBroadcasting( eventName:String ):void {
			
			flagEvent( eventName, true );
			
		}
		
		private static function flagEvent( eventName:String, flag:Boolean ):void {
			
			var dict:Dictionary = events[ eventName ];
			if( dict == null ) return;
			var elmnt:CommandsDispatcherElement;
			
			for each( elmnt in dict ){
				
				elmnt.canExecute = flag;
				
			}
			
		}

	}
	
}