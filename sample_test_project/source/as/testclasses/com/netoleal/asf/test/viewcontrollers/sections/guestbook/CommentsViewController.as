/*
Class: com.netoleal.asf.test.viewcontrollers.sections.guestbook.CommentsViewController
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
package com.netoleal.asf.test.viewcontrollers.sections.guestbook
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.events.SectionEvent;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	import asf.utils.Delay;
	
	import com.netoleal.asf.sample.view.assets.GuestBookCommentItem;
	import com.netoleal.asf.test.events.GuestBookEvent;
	import com.netoleal.asf.test.models.GuestBookCommentModel;
	import com.netoleal.asf.test.models.GuestBookModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import hype.extended.layout.GridLayout;
	
	public class CommentsViewController extends TransitionableViewController implements ITransitionable
	{
		private var model:GuestBookModel;
		private var comments:Vector.<CommentItemViewController>;
		private var section:Section;
		
		public function CommentsViewController(p_view:*, p_model:GuestBookModel, p_section:Section)
		{
			super(p_view);
			model = p_model;
			section = p_section;
			
			model.addEventListener( GuestBookEvent.LOAD_COMMENTS_COMPLETE, refreshComments );
		}
		
		private function refreshComments(event:GuestBookEvent):void
		{
			unmountComments( ).queue( mountComments );
		}
		
		public function mountComments( ):ISequence
		{
			var seq:ISequence;
			var comment:CommentItemViewController;
			var commentModel:GuestBookCommentModel;
			var cols:int = parseInt( section.params.cols );
			var rows:int = parseInt( section.params.rows );
			var layout:GridLayout = new GridLayout( 0, 0, 66, 66, cols );
			var delay:uint = 50;
			var n:uint = 0;
			var max:uint = cols * rows;
			
			comments = new Vector.<CommentItemViewController>( );
			
			viewAsSprite.mouseChildren = true;
			
			for each( commentModel in model.getComments( ) )
			{
				comment = new CommentItemViewController( new GuestBookCommentItem( ), commentModel );
				comment.addEventListener( MouseEvent.CLICK, onCommentClick );
				
				layout.applyLayout( comment.view );
				
				view.addChild( comment.view );
				comments.push( comment );
				
				seq = comment.open( n * delay );
				n++;
				if( n == max ) break;
			}
			
			if( !seq )
			{
				seq = new Sequence( );
				seq.notifyComplete( );
			}
			
			return seq;
		}
		
		private function onCommentClick(event:MouseEvent):void
		{
			var item:CommentItemViewController = event.target as CommentItemViewController;
			
			this.view.mouseChildren = false;
			
			var section:Section = section.navigation.openSection( "details", item.getModel( ) );
			section.addEventListener( SectionEvent.CLOSE, onDetailsClose ); 
		}
		
		private function onDetailsClose(event:SectionEvent):void
		{
			if( this.view ) this.view.mouseChildren = true;
		}
		
		public override function close( delay:uint = 0 ):ISequence
		{
			return Delay.execute( unmountComments, delay );
		}
		
		public function unmountComments( ):ISequence
		{
			var seq:ISequence;
			var comment:CommentItemViewController;
			var n:int = 0;
			var delay:int = 50;
			
			viewAsSprite.mouseChildren = false;
			
			for each( comment in comments )
			{
				seq = comment.close( n * delay )
						.queue( view.removeChild, comment.view )
							.queue( comment.dispose );
				
				comment.removeEventListener( MouseEvent.CLICK, onCommentClick );
				comment = null;
				n++;
			}
			
			if( !seq )
			{
				seq = new Sequence( );
				seq.notifyComplete( );
			}
			
			return seq;
		}
	}
}