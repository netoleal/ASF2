/*
Class: asf.core.config.ParametersParser
Author: Neto Leal
Created: Apr 13, 2011

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
package asf.core.config
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.viewcontrollers.ApplicationViewController;

	public class VariablesParser
	{
		public static function parse( input:String, app:ApplicationModel ):String
		{
			var variables:Array;
			var output:String = input;
			
			if( !output ) return "";
			
			variables = getVariables( output );
			
			if( variables.length > 0 )
			{
				variables.forEach( function( variable:String, index:uint, arr:Array ):void
				{
					if( variable.indexOf( "." ) != -1 )
					{
						var path:Array = variable.split( "." );
						var scope:String;
						var subvariable:String;
						
						subvariable = path.pop( );
						scope = path.pop( );
						
						output = output.split( "{" + variable + "}" ).join( ApplicationViewController.getByID( scope ).params[ subvariable ] );
					}
					else
					{
						output = output.split( "{" + variable + "}" ).join( app.params[ variable ] );
					}
				} );
			}
			
			return output;
		}
		
		private static function getVariables( value:String ):Array
		{
			var p1:int = -2;
			var p2:int = 0;
			var result:Array = new Array( );
			var tries:uint = 0;
			
			if( value == null ) return result;
			
			while( p1 != -1 && tries++ < 20 )
			{
				p1 = value.indexOf( "{", p1 + 1 );
				p2 = value.indexOf( "}", p1 );
				
				if( p1 != -1 && p2 != -1 ) result.push( value.substring( p1 + 1, p2 ) );
			}
			
			return result;
		}
	}
}