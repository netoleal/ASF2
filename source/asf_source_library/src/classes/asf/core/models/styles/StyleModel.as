/*
Class: asf.core.models.styles.StyleModel
Author: Neto Leal
Created: Apr 20, 2011

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
package asf.core.models.styles
{
	import asf.core.loading.LoadingTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;
	import asf.core.models.dependencies.FileModel;

	public class StyleModel extends BaseAppModel
	{
		private var _file:FileModel;
		
		public function StyleModel(p_raw:*, p_app:ApplicationModel )
		{
			super(p_raw, p_app);
		}
		
		public function get id( ):String
		{
			return String( xml.@id || xml.name( ) );
		}
		
		public function get file( ):FileModel
		{
			if( !_file && String( xml.@src ) != "" )
			{
				_file = FileModel.create( app, id, xml.@src, LoadingTypes.TXT );
			}
			
			return _file;
		}
		
		public function get cssText( ):String
		{
			return String( xml.text( ) );
		}
	}
}