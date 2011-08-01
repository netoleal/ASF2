/*
Class: com.netoleal.asf.test.models.GuestBookModel
Author: Neto Leal
Created: May 15, 2011

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
	import asf.core.util.Sequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.asf.test.events.GuestBookEvent;
	
	[Event(name="loadCommentsStart", type="com.netoleal.asf.test.events.GuestBookEvent")]
	[Event(name="loadCommentsComplete", type="com.netoleal.asf.test.events.GuestBookEvent")]
	
	public class GuestBookModel extends BaseAppModel
	{
		private var addCommentSeq:Sequence;
		private var loadCommentSeq:Sequence;
		
		private var _comments:Vector.<GuestBookCommentModel>;
		
		private var comments:Object;
		
		public function GuestBookModel(p_raw:*, p_app:ApplicationModel)
		{
			super(p_raw, p_app);
			
			addCommentSeq = new Sequence( );
			loadCommentSeq = new Sequence( );
		}
		
		public function addComment( comment:String, addToWall:Boolean = false ):Sequence
		{
			addCommentSeq.notifyStart( );
			
			Facebook.callRestAPI( "comments.add", onAddComment, { text: comment, xid: app.params.xid } );
			
			if( addToWall )
			{
				Facebook.postData( "/" + FacebookUserFactory.getUser( "me" ).id + "/feed", function( ):void{ }, 
				{
					message: comment,
					name: app.params.linkName,
					caption: app.params.linkCaption,
					link: app.params.feedLink
				} );
			}
			
			return addCommentSeq;
		}
		
		private function onAddComment( result:Object, error:Object ):void
		{
			log( result );
			loadComments( ).queue( addCommentSeq.notifyComplete );
		}
		
		public function loadComments( ):Sequence
		{
			loadCommentSeq.notifyStart( );
			Facebook.callRestAPI( "comments.get", onLoadComments, { xid: app.params.xid, access_token: Facebook.getSession( ).accessToken } );
			
			this.dispatchEvent( new GuestBookEvent( GuestBookEvent.LOAD_COMMENTS_START ) );
			
			return loadCommentSeq;
		}
		
		private function onLoadComments( result:Object, error:Object ):void
		{
			comments = result;
			_comments = null;
			
			this.dispatchEvent( new GuestBookEvent( GuestBookEvent.LOAD_COMMENTS_COMPLETE ) );
			
			loadCommentSeq.notifyComplete( );
		}
		
		public function getComments( ):Vector.<GuestBookCommentModel>
		{
			if( !_comments )
			{
				var comment:GuestBookCommentModel;
				var commentRaw:Object;
				
				_comments = new Vector.<GuestBookCommentModel>( );
				
				for each( commentRaw in comments )
				{
					_comments.push( new GuestBookCommentModel( commentRaw ) );
				}
			}
			
			return _comments;
		}
	}
}