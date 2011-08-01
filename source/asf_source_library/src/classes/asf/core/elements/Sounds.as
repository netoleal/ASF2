package asf.core.elements
{
	import asf.core.media.SoundItem;
	import asf.core.models.sounds.SoundModel;
	import asf.core.models.sounds.SoundsModel;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.events.SoundEvent;
	import asf.events.SoundItemEvent;
	import asf.log.LogLevel;
	
	import flash.events.EventDispatcher;
	
	public class Sounds extends EventDispatcher
	{
		private var app:ApplicationViewController;
		private var model:SoundsModel;
		private var _items:Vector.<SoundItem>;
		public var _activeItems:Vector.<SoundItem>;
		
		private var ids:Object;
		
		public function Sounds( p_app:ApplicationViewController )
		{
			super( null );
			
			app = p_app;
			model = app.model.sounds;
			_activeItems = new Vector.<SoundItem>( );

			init( );
		}
		
		private function init( ):void
		{
			var itemModel:SoundModel;
			var item:SoundItem;
			
			_items = new Vector.<SoundItem>( );
			ids = new Object( );
			
			for each( itemModel in model.sounds )
			{
				item = new SoundItem( itemModel, app );
				
				item.addEventListener( SoundItemEvent.COMPLETE, onItemComplete );
				item.addEventListener( SoundItemEvent.START, onItemStart );
				item.addEventListener( SoundItemEvent.ALL_CHANNELS_COMPLETE, onItemAllChannelsComplete );
				
				_items.push( item );
				ids[ itemModel.id ] = item;
			}
		}
		
		private function onItemStart( evt:SoundItemEvent ):void
		{
			var item:SoundItem = evt.target as SoundItem;
			var e:SoundEvent = new SoundEvent( SoundEvent.ITEM_START );
			
			e.item = item;
			
			_activeItems.push( item );
			
			this.dispatchEvent( e );
		}
		
		private function onItemComplete( evt:SoundItemEvent ):void
		{
			var item:SoundItem = evt.target as SoundItem;
			var e:SoundEvent = new SoundEvent( SoundEvent.ITEM_COMPLETE );
			
			e.item = item;
			
			playNextFor( item );
			
			this.dispatchEvent( e );
		}
		
		private function onItemAllChannelsComplete( evt:SoundItemEvent ):void
		{
			var item:SoundItem = evt.target as SoundItem;
			var e:SoundEvent = new SoundEvent( SoundEvent.ITEM_ALL_CHANNELS_COMPLETE );
			var i:int = _activeItems.indexOf( i );
			
			e.item = item;
			
			if( i != -1 )
			{
				_activeItems.splice( i, 1 );
			}
			
			this.dispatchEvent( e );
		}
		
		public function get currentActiveItems( ):Vector.<SoundItem>
		{
			return _activeItems;
		}
		
		private function playNextFor( current:SoundItem ):void
		{
			var nextItems:Vector.<SoundItem> = getNextAutoPlay( current );
			var item:SoundItem;
			
			for each( item in nextItems )
			{
				item.play( true );
			}
		}
		
		private function getNextAutoPlay( current:SoundItem ):Vector.<SoundItem>
		{
			var currentId:String = current.model.id;
			var item:SoundItem;
			var res:Vector.<SoundItem> = new Vector.<SoundItem>( );
			
			for each( item in _items )
			{
				if( item.model.autoPlay == currentId )
				{
					res.push( item );
				}
			}
			
			return res;
		}
		
		public function playAllAutoPlays( ):void
		{
			var item:SoundItem;
			
			app.log( LogLevel.INFO_3, _items? _items.length: 0 );
			
			for each( item in _items )
			{
				if( item.model.autoPlay == "true" )
				{
					play( item.model.id );
				}
			}
		}
		
		public function play( id:String ):SoundItem
		{
			var item:SoundItem = getSoundItem( id );
			
			app.log( LogLevel.INFO_3, id );
			
			if( item )
			{
				item.play( true );
			}
			
			return item;
		}
		
		public function stop( id:String ):SoundItem
		{
			var item:SoundItem = getSoundItem( id );
			var i:int;
			
			if( item )
			{
				log( LogLevel.INFO_3, item.model.id ); 
					
				i = _activeItems.indexOf( item );
				if( i != -1 )
				{
					_activeItems.splice( i, 1 );
				}
				
				item.stopAll( );
			}
			
			return item;
		}
		
		public function getSoundItem( id:String ):SoundItem
		{
			return ids[ id ];
		}
		
		public function stopAll( ):void
		{
			var item:SoundItem;
			
			for each( item in _items )
			{
				item.stopAll( );
			}
			
			_activeItems = new Vector.<SoundItem>( );
		}
	}
}