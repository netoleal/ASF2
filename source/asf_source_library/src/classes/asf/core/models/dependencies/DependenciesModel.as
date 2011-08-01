/*
Class: asf.core.models.dependencies.DependenciesModel
Author: Neto Leal
Created: Apr 18, 2011

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
package asf.core.models.dependencies
{
	import asf.core.config.ConditionalParser;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;
	import asf.core.models.app.CondicionalBlockModel;

	public class DependenciesModel extends BaseAppModel
	{
		private var _files:Vector.<FileModel>;
		
		public function DependenciesModel( p_raw:*, p_app:ApplicationModel )
		{
			super( p_raw, p_app );
		}
		
		public function get externalSourceURL( ):String
		{
			return app.getParsedValue( raw.@src );
		}
		
		public function get hasFilesToLoad( ):Boolean
		{
			return files.length > 0 || externalSourceURL != "";
		}
		
		public function get files( ):Vector.<FileModel>
		{
			if( !_files )
			{
				var children:XMLList = xml.children( );
				
				_files = new Vector.<FileModel>( );
				
				pushChildren( children );
			}
			
			return _files;
		}
		
		private function pushChildren( children:XMLList ):void
		{
			var file:FileModel;
			var child:XML;
			var block:CondicionalBlockModel;
			var subChildren:*;
			
			for each( child in children )
			{
				if( String( child.name( ) ) == "if" )
				{
					block = new CondicionalBlockModel( child );
					subChildren = ConditionalParser.parse( block, app );
					
					if( subChildren )
					{
						pushChildren( subChildren );
					}
				}
				else
				{
					file = new FileModel( child, app );
					_files.push( file );
				}
			}
		}
	}
}