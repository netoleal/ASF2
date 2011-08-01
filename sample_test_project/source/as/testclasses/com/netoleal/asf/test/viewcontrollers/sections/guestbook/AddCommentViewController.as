/*
Class: com.netoleal.asf.test.viewcontrollers.sections.guestbook.AddCommentViewController
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
package com.netoleal.asf.test.viewcontrollers.sections.guestbook
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ButtonViewController;
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ISequence;
	import asf.utils.ScrollRect;
	
	import br.pedromoraes.btween.shortcuts.tween;
	
	import com.netoleal.asf.test.app.ASFFacebook;
	import com.netoleal.asf.test.models.GuestBookModel;
	import com.netoleal.asf.test.viewcontrollers.sections.AbstractSectionViewController;
	import com.robertpenner.easing.circ.easeOutCirc;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="resize", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="init", type="flash.events.Event")]
	
	public class AddCommentViewController extends AbstractSectionViewController
	{
		private var rect:ScrollRect;
		private var sendButton:ButtonViewController;
		private var closeButton:ButtonViewController;
		private var model:GuestBookModel;
		
		public function AddCommentViewController(p_view:*, p_section:Section, p_model:GuestBookModel )
		{
			super(p_view, p_section);
			
			model = p_model;
			view.alpha = 1;
			view.visible = true;
			
			sendButton = new ButtonViewController( view.$postButton, { over: section.application.sounds.getSoundItem( "dclick" ), click: section.application.sounds.getSoundItem( "click" ) } );
			closeButton = new ButtonViewController( view.$close );
			
			closeButton.addEventListener( MouseEvent.CLICK, closeClick );
			sendButton.addEventListener( MouseEvent.CLICK, sendClick );
			
			view.$postButton.$text.text = section._.send;
			view.$description.text = section._.description;
			
			rect = new ScrollRect( view, 0, 0, view.width, view.height );
			rect.y = rect.height;
		}
		
		private function sendClick(event:MouseEvent):void
		{
			log( );
			this.dispatchEvent( new Event( Event.INIT ) );
			ASFFacebook.getInstance( ).loginUser( ).queue( postComment );
		}
		
		private function postComment( ):void
		{
			log( );
			model.addComment( this.view.$commentText.text, true ).queue( onPostCommentComplete );
		}
		
		private function onPostCommentComplete():void
		{
			log( );
			close( );
		}
		
		private function closeClick( evt:MouseEvent ):void
		{
			close( );
		}
		
		public function set rectY( value:Number ):void
		{
			rect.y = value;
			this.dispatchEvent( new Event( Event.RESIZE ) );
		}
		
		public function get height( ):Number
		{
			return view.height - rect.y;
		}
		
		public function get rectY( ):Number
		{
			return rect.y;
		}
		
		public override function open(p_delay:uint=0):ISequence
		{
			view.$commentText.text = "";
			
			transition.notifyStart( );
			tween( 333, easeOutCirc, p_delay ).start( { target: this, rectY: 0 } ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			tween( 333, easeOutCirc, p_delay ).start( { target: this, rectY: rect.height } ).queue( transition.notifyComplete );
			
			this.dispatchEvent( new Event( Event.CLOSE ) );
			
			return transition;
		}
	}
}