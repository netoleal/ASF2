/*
Class: com.netoleal.asf.test.viewcontrollers.sections.feed.FeedPostViewController
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
package com.netoleal.asf.test.viewcontrollers.sections.feed
{
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ISequence;
	import asf.interfaces.ITransitionable;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.asf.test.models.FacebookFeedModel;
	import com.netoleal.asf.test.models.FacebookFeedPostModel;
	import com.netoleal.asf.test.models.FacebookUserModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	
	public class FeedPostViewController extends TransitionableViewController implements ITransitionable
	{
		private var model:FacebookFeedPostModel;
		private var user:FacebookUserModel;
		
		public function FeedPostViewController(p_view:*, p_model:FacebookFeedPostModel)
		{
			super(p_view);
			model = p_model;
			
			user = model.fromUser;
			
			view.$title.autoSize = TextFieldAutoSize.LEFT;
			view.$text.autoSize = TextFieldAutoSize.LEFT;
			
			view.$title.text = p_model.fromName;
			view.$text.text = p_model.message || "";
			
			view.$text.y = view.$title.y + view.$title.height;
			view.$bg.height = view.$text.y + view.$text.height;
			
			view.alpha = 0;
			
			view.mouseChildren = false;
			
			user.load( );
			
			if( user.loaded )
			{
				setEvents( );
			}
			else
			{
				user.addEventListener( Event.COMPLETE, setEvents );
			}
		}
		
		private function setEvents(event:Event = null):void
		{
			view.buttonMode = true;
			view.addEventListener( MouseEvent.CLICK, click );
		}
		
		private function click( evt:MouseEvent ):void
		{
			navigateToURL( new URLRequest( model.fromUser.link ), "_blank" );
		}
		
		public override function open(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			fadeIn( view, 333, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function close(p_delay:uint=0):ISequence
		{
			transition.notifyStart( );
			fadeOut( view, 333, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function dispose():void
		{
			super.dispose( );
		}
	}
}