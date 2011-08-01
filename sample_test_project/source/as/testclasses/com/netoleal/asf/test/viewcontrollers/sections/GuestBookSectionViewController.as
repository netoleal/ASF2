/*
Class: com.netoleal.asf.test.viewcontrollers.sections.GuestBookSectionViewController
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
package com.netoleal.asf.test.viewcontrollers.sections
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.netoleal.asf.sample.view.assets.Buffering;
	import com.netoleal.asf.test.app.ASFFacebook;
	import com.netoleal.asf.test.events.GuestBookEvent;
	import com.netoleal.asf.test.models.GuestBookModel;
	import com.netoleal.asf.test.viewcontrollers.assets.BufferingViewController;
	import com.netoleal.asf.test.viewcontrollers.sections.guestbook.AddCommentViewController;
	import com.netoleal.asf.test.viewcontrollers.sections.guestbook.CommentsViewController;
	import com.netoleal.asf.test.viewcontrollers.sections.guestbook.ConnectViewController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GuestBookSectionViewController extends AbstractSectionViewController implements ITransitionable
	{
		private var addComment:AddCommentViewController;
		private var sendCommentButton:ButtonViewController;
		private var comments:CommentsViewController;
		private var connect:ConnectViewController;
		private var buffering:BufferingViewController;
		
		private var model:GuestBookModel;
		
		public function GuestBookSectionViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
			
			ASFFacebook.appID = section.params.appID;
			
			model = new GuestBookModel( null, section.model );
			addComment = new AddCommentViewController( view.$comment, section, model );
			sendCommentButton = new ButtonViewController( view.$sendCommentButton, { over: section.application.sounds.getSoundItem( "dclick" ), click: section.application.sounds.getSoundItem( "click" ) } );
			comments = new CommentsViewController( new Sprite( ), model, p_section );
			connect = new ConnectViewController( this.view.$connect, section );
			buffering = new BufferingViewController( new Buffering( ) );
			
			model.addEventListener( GuestBookEvent.LOAD_COMMENTS_START, onLoadCommentsStart );
			model.addEventListener( GuestBookEvent.LOAD_COMMENTS_COMPLETE, onLoadCommentsComplete );
			addComment.addEventListener( Event.INIT, onLoadCommentsStart );
			
			connect.view.visible = false;
			addComment.view.visible = false;
			sendCommentButton.view.visible = false;
			
			addComment.addEventListener( Event.RESIZE, arrange );
			addComment.addEventListener( Event.CLOSE, onAddCommentClose );
			
			sendCommentButton.addEventListener( MouseEvent.CLICK, onSendCommentClick );
			
			sendCommentButton.view.$text.text = section._.writeComment;
			view.$title.$text.text = section._.title;
			
			section.layers.guestbook.addChild( view.$title );
			section.layers.guestbook.addChild( sendCommentButton.view );
			section.layers.guestbook.addChild( connect.view );
			section.layers.guestbook.addChild( addComment.view );
			section.layers.guestbook.addChild( comments.view );
			section.layers.buffering.addChild( buffering.view );
			
			arrange( null );
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			if( comments )
			{
				return comments.close( p_delay ).queue( super.close );
			}
			else
			{
				return super.close( p_delay );
			}
		}
		
		private function onLoadCommentsComplete(event:Event):void
		{
			addComment.viewAsSprite.mouseChildren = true;
			buffering.close( );
		}
		
		private function onLoadCommentsStart(event:Event):void
		{
			addComment.viewAsSprite.mouseChildren = false;
			buffering.open( );
		}
		
		private function onFacebookConnect(event:Event):void
		{
			connect.removeEventListener( Event.COMPLETE, onFacebookConnect );
			
			connect.close( ).queue( function( ):void
			{
				sendCommentButton.view.visible = true;
				addComment.view.visible = true;
				model.loadComments( );
			} );
		}
		
		private function onSendCommentClick(event:MouseEvent):void
		{
			showAddComment( );
		}
		
		private function onAddCommentClose( evt:Event ):void
		{
			fadeIn( sendCommentButton.view );
		}
		
		private function showAddComment( ):ISequence
		{
			fadeOut( sendCommentButton.view );
			return addComment.open( );
		}
		
		private function arrange(event:Event):void
		{
			sendCommentButton.view.y = addComment.view.y + addComment.height + 10;
			
			comments.view.y = sendCommentButton.view.y + sendCommentButton.view.height + 5;
			comments.view.x = sendCommentButton.view.x;
		}
		
		public override function open(p_delay:uint=0):ISequence
		{
			return super.open( p_delay ).queue( initFacebook );
		}
		
		private function initFacebook( ):ISequence
		{
			buffering.open( );
			
			return ASFFacebook.getInstance( ).init( ).queue( onInit );
		}
		
		private function onInit( ):ISequence
		{
			if( ASFFacebook.getInstance( ).isUserLoggedIn( ) )
			{
				sendCommentButton.view.visible = true;
				addComment.view.visible = true;
				model.loadComments( );
			}
			else
			{
				sendCommentButton.view.visible = false;
				connect.open( );
				connect.addEventListener( Event.COMPLETE, onFacebookConnect );
			}
			
			return buffering.close( );
		}
		
		public override function dispose( ):void
		{
			section.layers.guestbook.removeChild( view.$title );
			section.layers.guestbook.removeChild( sendCommentButton.view );
			section.layers.guestbook.removeChild( connect.view );
			section.layers.guestbook.removeChild( addComment.view );
			section.layers.guestbook.removeChild( comments.view );
			section.layers.buffering.removeChild( buffering.view );
			
			sendCommentButton.dispose( );
			addComment.dispose( );
			comments.dispose( );
			buffering.dispose( );
			connect.dispose( );
		}
	}
}