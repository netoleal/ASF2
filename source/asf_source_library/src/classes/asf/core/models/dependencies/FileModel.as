/*
Class: asf.core.models.dependencies.FileModel
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
	import asf.core.loading.LoadingTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseModel;
	import asf.core.models.app.CondicionalBlockModel;

	public class FileModel extends BaseModel
	{
		private var app:ApplicationModel;
		
		public static function create( app:ApplicationModel, id:String, url:String, type:String, weight:uint = 0, priority:uint = 0 ):FileModel
		{
			var raw:XML = <file/>;
			
			raw.@id = id;
			raw.@type = type;
			raw.@weight = weight;
			raw.@priority = priority;
			
			raw.setChildren( url );
			
			return new FileModel( raw, app );
		}
		
		public function FileModel( p_raw:*, p_app:ApplicationModel )
		{
			super( p_raw );
			app = p_app;
		}
		
		public function get url( ):String
		{
			if( String( xml.@url ) != "" )
			{
				return app.getParsedValue( xml.@url );
			}
			
			if( xml.hasComplexContent( ) && xml.hasOwnProperty( "if" ) )
			{
				return ConditionalParser.parse( new CondicionalBlockModel( xml[ "if" ] ), app );
			}
			else
			{
				return app.getParsedValue( String( xml.text( ) ) );
			}
		}
		
		public function get type( ):String
		{
			var types:Object = new Object( );
			var extension:String;
			var type:String = app.getParsedValue( xml.@type || xml.type );
			var guessType:String;
			
			types[ LoadingTypes.IMAGE ] = "jpg,jpeg,png,gif";
			types[ LoadingTypes.SOUND ] = "mp3";
			types[ LoadingTypes.VIDEO ] = "flv,f4v,mp4,mov";
			types[ LoadingTypes.TXT ] = "txt,js";
			types[ LoadingTypes.XML ] = "xml";
			types[ LoadingTypes.SWF ] = "swf";
			
			if( type == null || type == "" )
			{
				extension = String( url.split( "." ).pop( ) ).toLowerCase( );
				for( guessType in types )
				{
					if( types[ guessType ].indexOf( extension ) != -1 )
					{
						type = guessType;
						break;
					}
				}
			}
			
			return type;
		}
		
		public function get weight( ):int
		{
			return parseInt( app.getParsedValue( xml.@weight || xml.weight || "0" ) );
		}
		
		public function get priority( ):int
		{
			return parseInt( app.getParsedValue( xml.@priority || xml.priority || "0" ) );
		}
		
		public function get id( ):String
		{
			return app.getParsedValue( xml.@id || xml.id );
		}
	}
}