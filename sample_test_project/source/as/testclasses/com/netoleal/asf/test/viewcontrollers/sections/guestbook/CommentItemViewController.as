/*
Class: com.netoleal.asf.test.viewcontrollers.sections.guestbook.CommentItemViewController
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
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.core.viewcontrollers.ShowHideViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.test.loaders.CachedImageLoader;
	import com.netoleal.asf.test.models.GuestBookCommentModel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CommentItemViewController extends ButtonViewController implements ITransitionable
	{
		private var model:GuestBookCommentModel;
		private var seq:Sequence;
		private var userImage:CachedImageLoader;
		
		public function CommentItemViewController( p_view:MovieClip, p_model:GuestBookCommentModel )
		{
			super(p_view);
			
			model = p_model;
			
			alpha = 0;
			visible = false;
			seq = new Sequence( );
			
			model.fromUser.load( );
			
			userImage = new CachedImageLoader( );
			userImage.addEventListener( Event.COMPLETE, onUserImageLoaded );
			userImage.load( model.fromUser.profilePictureURL, false, true );
		}
		
		public function getModel( ):GuestBookCommentModel
		{
			return model;
		}
		
		private function onUserImageLoaded(event:Event):void
		{
			userImage.x = view.$photo.x;
			userImage.y = view.$photo.y;
			
			userImage.mask = view.$photo;
			
			view.addChild( userImage );
		}
		
		/**
		 * Open Method 
		 * @param p_delay Time to wait
		 * @return Sequence object
		 * 
		 */
		public function open(p_delay:uint=0):ISequence
		{
			seq.notifyStart( );
			fadeIn( this.view, 333, p_delay ).queue( seq.notifyComplete );
			return seq;
		}
		
		public function close(p_delay:uint=0):ISequence
		{
			log( p_delay );
			
			seq.notifyStart( );
			fadeOut( this.view, 333, p_delay ).queue( seq.notifyComplete );
			return seq;
		}
	}
}