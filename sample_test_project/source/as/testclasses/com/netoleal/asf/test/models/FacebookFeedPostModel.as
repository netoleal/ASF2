/*
Class: com.netoleal.asf.test.models.FacebookFeedPostModel
Author: Neto Leal
Created: May 20, 2011

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
	
	public class FacebookFeedPostModel extends BaseModel
	{
		public function FacebookFeedPostModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get message( ):String
		{
			return raw.message;
		}
		
		public function get fromName( ):String
		{
			return raw.from.name
		}
		
		public function get fromUser( ):FacebookUserModel
		{
			return FacebookUserFactory.getUser( raw.from.id );
		}
	}
}
/*
{
	"likes":{
		"data":[
			{"name":"Victor Potasso","id":"1512995838"}
		],"count":1},
	"actions":[
		{"name":"Comment", "link":"http://www.facebook.com/130690740338842/posts/124927514253829"},
		{"name":"Like","link":"http://www.facebook.com/130690740338842/posts/124927514253829"}
	],
	"type":"link",
	"id":"130690740338842_124927514253829",
	"to":{
		"data":[
			{"name":"Neto Leal","id":"667065344"}
		]
	},
	"privacy":{"value":"EVERYONE","description":"Everyone"},
	"icon":"http://static.ak.fbcdn.net/rsrc.php/v1/yD/r/aS8ecmYRys0.gif",
	"updated_time":"2011-05-20T13:36:19+0000",
	"caption":"asdevs.groups.adobe.com",
	"from":{"name":"ASF Framework","id":"130690740338842","category":"Software"},
	"message":"Próxima terça, 24/05, Neto Leal fará uma palestra online para apresentar o Framework ASF. A participação é grátis e aberta a todos. Se você é #dev e curte #flash #as3, você tem que participar!","link":"http://asdevs.groups.adobe.com/index.cfm?event=post.display&postid=36444",
	"created_time":"2011-05-20T13:36:19+0000",
	"name":"Apresentando o framework ASF 2.0 . Adobe Groups"
}
*/