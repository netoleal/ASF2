/*
Class: com.netoleal.asf.test..models.GalleryModel
Author: Neto Leal
Created: May 14, 2011

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
package com.netoleal.asf.test.models
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;
	
	public class GalleryModel extends BaseAppModel
	{
		private var _images:Vector.<GalleryImageModel>;
		
		public function GalleryModel(p_raw:*, p_app:ApplicationModel)
		{
			super(p_raw, p_app);
		}
		
		public function get images( ):Vector.<GalleryImageModel>
		{
			if( !_images )
			{
				var imgRaw:XML;
				
				_images = new Vector.<GalleryImageModel>( );
				
				for each( imgRaw in xml.image )
				{
					_images.push( new GalleryImageModel( imgRaw, app, this ) );
				}
			}
			
			return _images;
		}
		
		public function get baseDir( ):String
		{
			return parse( xml.@baseDir );
		}
		
		public function get thumbsDir( ):String
		{
			return baseDir + parse( xml.@thumbs );
		}
		
		public function get imagesDir( ):String
		{
			return baseDir + parse( xml.@images );
		}
	}
}