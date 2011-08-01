/*
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

package asf.core.models.sounds
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;

	public class SoundsModel extends BaseAppModel
	{
		private var _items:Vector.<SoundModel>;
		private var ids:Object;
		
		public function SoundsModel(p_raw:*, p_app:ApplicationModel)
		{
			super(p_raw, p_app);
			
			ids = new Object( );
		}
		
		public function get sounds( ):Vector.<SoundModel>
		{
			if( !_items )
			{
				var soundRaw:XML;
				var children:XMLList;
				var sound:SoundModel;
				
				try
				{
					children = xml.sound;
				}
				catch( e:Error )
				{
					children = null;
				}
				
				_items = new Vector.<SoundModel>( );
				
				for each( soundRaw in children )
				{
					sound = new SoundModel( soundRaw, this.app );
					_items.push( sound );
					
					ids[ sound.id ] = sound;
				}
			}
			
			return _items;
		}
		
		public function getSoundById( id:String ):SoundModel
		{
			return ids[ id ];
		}
	}
}