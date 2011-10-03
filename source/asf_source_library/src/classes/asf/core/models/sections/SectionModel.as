/*
Class: asf.core.models.sections.SectionModel
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
	import asf.core.models.app.ApplicationModel;
	
	import flash.display.LoaderInfo;
	
	public class SectionModel extends ApplicationModel
	{
		public function SectionModel(p_raw:XML, p_loaderInfo:LoaderInfo=null, p_parent:ApplicationModel=null)
		{
			super(p_raw, p_loaderInfo, p_parent);
		}
		
		public function get viewClassName( ):String
		{
			return this.getParsedValue( raw.@viewClass || raw.viewClass );
		}
		
		public function get layerName( ):String
		{
			return this.getParsedValue( raw.@layer || raw.layer );
		}
		
		public function get loadAtStart( ):Boolean
		{
			return this.getParsedValue( raw.@loadAtStart || raw.loadAtStart ) == "true";
		}
		
		public function get closeOnNavigate( ):Boolean
		{
			return this.getParsedValue( raw.@closeOnNavigate || raw.closeOnNavigate ) != "false";
		}
		
		public function get closeCurrentBeforeOpen( ):Boolean
		{
			return this.getParsedValue( raw.@closeCurrentBeforeOpen || raw.closeCurrentBeforeOpen ) != "false";
		}
		
		public function get autoSubSection( ):String
		{
			return this.getParsedValue( raw.@autoSubSection || raw.autoSubSection );
		}
		
		public function get setAsCurrent( ):Boolean
		{
			return this.getParsedValue( raw.@setAsCurrent || raw.setAsCurrent ) != "false";
		}
		
		public function get keepDependencies( ):Boolean
		{
			return this.getParsedValue( raw.@keepDependencies || raw.keepDependencies ) == "true";
		}
		
		public function get ignoreChildren( ):Boolean
		{
			return this.getParsedValue( raw.@ignoreChildren || raw.ignoreChildren ) == "true";
		}
		
		public function get type( ):String
		{
			return this.getParsedValue( raw.@type || raw.type || SectionType.DEFAULT );
		}
		
		public function get href( ):String
		{
			return this.getParsedValue( raw.@href || raw.href );
		}
		
		public function get target( ):String
		{
			return this.getParsedValue( raw.@target || raw.target || ( type == SectionType.JAVASRIPT? "_self": "_blank" ) );
		}
		
		public function get method( ):String
		{
			return this.getParsedValue( raw.@method || raw.method );
		}
	}
}