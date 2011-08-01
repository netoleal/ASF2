/*
Class: asf.core.models.dictionary.LocalesModel
Author: Neto Leal
Created: Apr 19, 2011

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
package asf.core.models.dictionary
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;

	public class DictionariesModel extends BaseAppModel
	{
		private var _dictionaries:Vector.<DictionaryModel>;
		
		public function DictionariesModel( p_raw:*, p_app:ApplicationModel )
		{
			super( p_raw, p_app );
		}
		
		public function get dicionaries( ):Vector.<DictionaryModel>
		{
			if( !_dictionaries )
			{
				var list:XMLList = xml.localization;
				var rawDict:XML;
				var dict:DictionaryModel;
				
				_dictionaries = new Vector.<DictionaryModel>( );
				
				for each( rawDict in list )
				{
					dict = new DictionaryModel( rawDict, app );
					if( dict.file.url != "" ) _dictionaries.push( dict );
				}
			}
			
			return _dictionaries;
		}
	}
}