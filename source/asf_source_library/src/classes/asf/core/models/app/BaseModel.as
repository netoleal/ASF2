/*
Class: asf.core.models.app.BaseModel
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
package asf.core.models.app
{
	import com.adobe.serialization.json.JSONDecoder;

	import flash.events.EventDispatcher;
	
	public class BaseModel extends EventDispatcher
	{
		private var _raw:*;
		private var _rawJSON:Object;
		
		public function BaseModel( p_raw:* )
		{
			super( null );
			_raw = p_raw;
		}
		
		public function setRawData( p_raw:* ):void
		{
			_raw = p_raw;
		}
		
		public function getRawData( ):*
		{
			return _raw;
		}
		
		protected function get xml( ):XML
		{
			var res:XML;
			
			try
			{
				res = XML( _raw );
			}
			catch( e:Error )
			{
				res = <empty />;
			}
			
			return res;
		}
		
		protected function get json( ):Object
		{
			if( _raw is String )
			{
				if( !_rawJSON ) _rawJSON = new JSONDecoder( _raw ).getValue( );
				return _rawJSON;
			}
			
			return _raw as Object;
		}
		
		protected function get raw( ):*
		{
			return _raw;
		}
	}
}