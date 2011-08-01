/*
Class: com.netoleal.asf.test.viewcontrollers.sections.FacebookFeedSectionViewController
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
package com.netoleal.asf.test.viewcontrollers.sections
{
	import asf.core.elements.Section;
	import asf.interfaces.ITransitionable;
	
	import com.netoleal.asf.sample.view.assets.FeedPost;
	import com.netoleal.asf.test.models.FacebookFeedModel;
	import com.netoleal.asf.test.models.FacebookFeedPostModel;
	import com.netoleal.asf.test.viewcontrollers.sections.feed.FeedPostViewController;
	
	public class FacebookFeedSectionViewController extends AbstractSectionViewController implements ITransitionable
	{
		private var model:FacebookFeedModel;
		
		public function FacebookFeedSectionViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
			
			model = new FacebookFeedModel( p_section );
			model.loadPosts( ).queue( showPosts );
		}
		
		private function showPosts():void
		{
			var item:FeedPostViewController;
			var n:uint = 0;
			var h:Number = 0;
			var itemModel:FacebookFeedPostModel;
			var max:int = parseInt( section.params.maxPosts );
			
			for each( itemModel in model.posts )
			{
				item = new FeedPostViewController( new FeedPost( ), itemModel );
				item.view.y = h;
				
				h += item.view.height + 2;
				
				view.addChild( item.view );
				item.open( n * 100 );
				n++;
				
				if( n == max ) break;
			}
		}
	}
}