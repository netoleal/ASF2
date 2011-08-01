/*
Class: asf.core.models.app.CondicionalBlockModel
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
package asf.core.models.app
{

	public class CondicionalBlockModel extends BaseModel
	{
		public function CondicionalBlockModel( p_raw:* )
		{
			super( p_raw );
		}
		
		public function get condition( ):String
		{
			return xml.@condition || xml.condition;
		}
		
		public function get then( ):*
		{
			if( !xml.hasComplexContent( ) ) return String( xml.text( ) );
			return getContent( "then" );
		}
		
		public function get elseStatement( ):*
		{
			if( xml.hasOwnProperty( "else" ) ) return getContent( "else" );
			return null;
		}
		
		private function getContent( tag:String ):*
		{
			if( xml.hasOwnProperty( tag ) )
			{
				if( !( xml[ tag ] as XMLList ).hasComplexContent( ) ) return String( xml[ tag ].text( ) );
				else if( xml[ tag ].hasOwnProperty( "if") ) return new CondicionalBlockModel( xml[ tag ][ "if" ] );
				else return xml[ tag ];
			}
			
			return xml.children( );
		}
	}
}