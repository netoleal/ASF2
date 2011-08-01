/*
Class: asf.core.config.ConditionalParser
Author: Neto Leal
Created: Apr 15, 2011

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
	import asf.core.models.app.CondicionalBlockModel;
	
	import com.adobe.utils.StringUtil;
	
	public class ConditionalParser
	{
		public static function parse( input:CondicionalBlockModel, model:ApplicationModel ):*
		{
			if( parseBlock( input.condition, model ) )
			{
				if( input.then is String )
				{
					return model.getParsedValue( input.then );
				}
				else if( input.then is CondicionalBlockModel )
				{
					return parse( input.then as CondicionalBlockModel, model );
				}
				else
				{
					return input.then;
				}
			}
			else
			{
				if( input.elseStatement is String )
				{
					return model.getParsedValue( input.elseStatement );
				}
				else if( input.elseStatement is CondicionalBlockModel )
				{
					return parse( input.elseStatement as CondicionalBlockModel, model );
				}
				else
				{
					return input.elseStatement;
				}
			}
			
			return "";
		}
		
		public static function parseBlock( input:String, model:ApplicationModel ):Boolean
		{
			input = StringUtil.trim( input );
			input = model.getParsedValue( input );
			
			if( input.indexOf( "lt;")  != -1 ) input = input.split( "lt;"  ).join( "<"  );
			if( input.indexOf( "gt;")  != -1 ) input = input.split( "gt;"  ).join( ">"  );
			if( input.indexOf( "gte;") != -1 ) input = input.split( "gte;" ).join( ">=" );
			if( input.indexOf( "lte;") != -1 ) input = input.split( "lte;" ).join( "<=" );
			
			if( input.indexOf( "(" ) != -1 )
			{
				var n:int = 0, ia:int, ib:int, block:String;
				
				while( n < input.length )
				{
					if( input.charAt( n ) == "(" )
					{
						ia = input.indexOf( "(", n + 1 );
						ib = input.indexOf( ")", n );
						
						if( ib < ia || ( ia == -1 && ib != -1 ) )
						{
							block = input.substring( n + 1, ib );
							input = input.substring( 0, n ) + parseBlock( block, model ) + input.substr( n + block.length );
							n = -1;
						}
					}
					
					n++;
				}
				
				return parseBlock( input, model );
				
			}
			else
			{
				input = input.split( "&&" ).join( "&" );
				input = input.split( "||" ).join( "|" );
				input = input.split( "==" ).join( "=" );
				
				var expressions:Array;
				var expression:String;
				var result:Boolean;
				
				var members:Array;
				var member:String;
				
				if( input.indexOf( "|" ) != -1 )
				{
					expressions = input.split( "|" );
					result = false;
					
					for each( expression in expressions )
					{
						result = result || parseBlock( expression, model );
					}
					
					return result;
				}
				else if( input.indexOf( "&" ) != -1 )
				{
					expressions = input.split( "&" );
					result = true;
					
					for each( expression in expressions )
					{
						result = result && parseBlock( expression, model );
					}
					
					return result;
				}
				else
				{
					var operators:Array = [ "=", "!=", ">", "<", "<=", ">=" ];
					var op:String;
					
					for each( op in operators )
					{
						if( input.indexOf( op ) != -1 )
						{
							members = input.split( op, 2 );
							result = evalOperation( members[ 0 ], members[ 1 ], op, model );
							
							return result;
							
							break;
						}
					}
					
					if( input.charAt( 0 ) == "!" )
					{
						result = input.substr( 1 ) == "true";
						result = !result;
					}
					else
					{
						result = input == "true";
					}
					
					return result;
				}
			}
			
			return true;
		}
		
		private static function evalOperation( a:String, b:String, op:String, model:ApplicationModel ):Boolean
		{
			var result:Boolean = false;
			
			a = StringUtil.trim( a );
			b = StringUtil.trim( b );
			
			a = StringUtil.trim( removeQuotes( a.split( "\"" ).join( "'" ) ) );
			b = StringUtil.trim( removeQuotes( b.split( "\"" ).join( "'" ) ) );
			
			a = model.getParsedValue( a );
			b = model.getParsedValue( b );
			
			switch( op )
			{
				case "<": case ">": case ">=": case "<=":
				{
					switch( op )
					{
						case ">": 
							result = a > b; 
							break;
						case "<": 
							result =  a < b; 
							break;
						case ">=": 
							result =  a >= b; 
							break;
						case "<=": 
							result =  a <= b; 
							break;
					}
					break;
				}
				
				case "==": case "=":
				{
					result = String( a ) == String( b ); 
					break;
				}
				
				case "!=": 
					result = String( a ) != String( b ); 
					break;
			}
			
			return result;
		}
		
		private static function removeQuotes( input:String ):String
		{
			if( input.charAt( 0 ) == "'" ) input = input.substr( 1 );
			if( input.charAt( input.length - 1 ) == "'" ) input = input.substr( 0, input.length - 1 );
			return input;
		}
	}
}