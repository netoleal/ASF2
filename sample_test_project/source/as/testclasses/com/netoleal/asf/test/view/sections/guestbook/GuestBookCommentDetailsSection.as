/*
Class: com.netoleal.asf.test.view.sections.guestbook.GuestBookCommentDetailsSection
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
package com.netoleal.asf.test.view.sections.guestbook
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.interfaces.ISectionView;
	import asf.interfaces.ISequence;
	
	import com.netoleal.asf.sample.view.assets.GuestBookCommentDetails;
	import com.netoleal.asf.test.loaders.CachedImageLoader;
	import com.netoleal.asf.test.models.GuestBookCommentModel;
	import com.netoleal.asf.test.viewcontrollers.sections.guestbook.CommentItemViewController;
	
	import flash.events.MouseEvent;
	
	public class GuestBookCommentDetailsSection extends GuestBookCommentDetails implements ISectionView
	{
		private var seq:Sequence;
		private var userImage:CachedImageLoader;
		private var back:ButtonViewController;
		private var section:Section;
		
		public function GuestBookCommentDetailsSection()
		{
			super();
			seq = new Sequence( );
		}
		
		public function init(p_section:Section, ...parameters):void
		{
			var model:GuestBookCommentModel = parameters[ 0 ];
			section = p_section;
			
			back = new ButtonViewController( this.$back );
			back.view.$text.text = this.section.application._.back; 
			
			model.fromUser.load( ).queue( showInfo, model );
			
			alpha = 0;
			visible = false;
			
			back.addEventListener( MouseEvent.CLICK, onBackClick );
		}
		
		private function onBackClick(event:MouseEvent):void
		{
			section.application.navigation.closeSection( section );
		}
		
		private function showInfo( model:GuestBookCommentModel ):void
		{
			userImage = new CachedImageLoader( );
			
			userImage.x = this.$photo.x;
			userImage.y = this.$photo.y;
			
			userImage.mask = this.$photo;
			
			addChild( userImage );
			
			userImage.load( model.fromUser.profilePictureURL, false, true );
			
			this.$name.text = model.fromUser.fullName;
			this.$date.text = [ model.time.getDate( ), model.time.getMonth( ) + 1, model.time.getFullYear( ) ].join( "/" );
			this.$text.text = model.text;
			
		}
		
		public function open(p_delay:uint=0):ISequence
		{
			seq.notifyStart( );
			fadeIn( this, 333, p_delay ).queue( seq.notifyComplete );
			return seq;
		}
		
		public function close(p_delay:uint=0):ISequence
		{
			log( p_delay );
			
			seq.notifyStart( );
			fadeOut( this, 333, p_delay ).queue( seq.notifyComplete );
			return seq;
		}
		
		public function dispose():void
		{
			if( userImage ) userImage.dispose( );
			back.dispose( );
			back = null;
		}
	}
}