/*
Class: asf.core.models.sections.SectionsModel
Author: Neto Leal
Created: Apr 25, 2011

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
package asf.core.models.sections
{
	import flash.display.LoaderInfo;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;

	public class SectionsModel extends BaseAppModel
	{
		private var loaderInfo:LoaderInfo;
		private var parent:ApplicationModel;
		private var _sections:Vector.<SectionModel>;
		
		public function SectionsModel(p_raw:*, p_app:ApplicationModel, p_loaderInfo:LoaderInfo=null, p_parent:ApplicationModel=null)
		{
			super(p_raw, p_app);
			
			loaderInfo = p_loaderInfo;
			parent = p_parent;
		}
		
		public function get sections( ):Vector.<SectionModel>
		{
			if( !_sections )
			{
				var sectionRaw:XML;
				var children:XMLList;
				
				_sections = new Vector.<SectionModel>( );
				
				try
				{
					children = xml.section;
				}
				catch( e:Error )
				{
					children = null;
				}
				
				for each( sectionRaw in children )
				{
					_sections.push( new SectionModel( sectionRaw, loaderInfo, parent ) );
				}
			}
			
			return _sections;
		}
		
		public function get layerName( ):String
		{
			return app.getParsedValue( raw.@layer || raw.layer );
		}
	}
}