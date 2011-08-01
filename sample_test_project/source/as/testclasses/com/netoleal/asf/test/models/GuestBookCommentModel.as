/*
Class: com.netoleal.asf.test.models.GuestBookCommentModel
Author: Neto Leal
Created: May 16, 2011

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
	import asf.core.models.app.BaseModel;
	
	public class GuestBookCommentModel extends BaseModel
	{
		public function GuestBookCommentModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function get fromID( ):String
		{
			return raw.fromid;
		}
		
		public function get text( ):String
		{
			return raw.text;
		}
		
		public function get time( ):Date
		{
			return new Date( raw.time * 1000 );
		}
		
		public function get objectID( ):String
		{
			return raw.object_id;
		}
		
		public function get fromUser( ):FacebookUserModel
		{
			return FacebookUserFactory.getUser( this.fromID );
		}
	}
}