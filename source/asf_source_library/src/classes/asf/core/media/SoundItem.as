package asf.core.media
{
	import asf.core.models.sounds.SoundModel;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.events.SoundItemEvent;
	import asf.log.LogLevel;
	import asf.fx.SimpleTween;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	[Event( name="complete", type="asf.events.SoundItemEvent" )]
	[Event( name="start", type="asf.events.SoundItemEvent" )]
	[Event( name="allChannelsComplete", type="asf.events.SoundItemEvent" )]
	
	public class SoundItem extends EventDispatcher
	{
		private var _model:SoundModel;
		private var app:ApplicationViewController;
		private var source:Sound;
		private var channel:SoundChannel;
		private var channels:Vector.<SoundChannel>;
		private var transform:SoundTransform;
		private var fadeInTween:SimpleTween;
		
		private var leftPosition:Number = 0;
		
		public function SoundItem( p_model:SoundModel, p_app:ApplicationViewController )
		{
			super( null );
			
			_model = p_model;
			app = p_app;
			channels = new Vector.<SoundChannel>( );
			
			transform = new SoundTransform( model.volume, model.pan );
			fadeInTween = new SimpleTween( );
			
			init( );
		}
		
		/**
		 * Volume do som 
		 * @param value
		 * 
		 */
		public function set volume( value:Number ):void
		{
			transform.volume = value;
			soundTransform = transform;
		}
		
		/**
		 * Volume do som 
		 * @param value
		 * 
		 */
		public function get volume( ):Number
		{
			return transform.volume;
		}
		
		/**
		 * Objeto SoundTransform do som 
		 * @param value
		 * 
		 */
		public function set soundTransform( value:SoundTransform ):void
		{
			var channel:SoundChannel;
			
			transform = value;
			
			for each( channel in channels )
			{
				channel.soundTransform = transform;
			}
		}
		
		/**
		 * Objeto SoundTransform do som 
		 * @param value
		 * 
		 */
		public function get soundTransform( ):SoundTransform
		{
			return transform;
		}
		
		private function init( ):void
		{
			if( source ) return;
			
			try
			{
				switch( model.type )
				{
					case SoundTypes.EMBED:
					{
						var K:Class = getDefinitionByName( model.source ) as Class;
						source = new K( ) as Sound;
						break;
					}
					default:
					{
						if( !model.isStream )
						{
							source = app.dependencies.getMP3( model.id );
						}
					}
				}
			}
			catch( e:Error )
			{
				source = null;
				app.log( LogLevel.ERROR_1, "No file or embed source for: " + model.source + " : " + model.id + " | " + e );
			}
		}
		
		/**
		 * Retorna o Model de dados do som. 
		 * @return 
		 * 
		 */
		public function get model( ):SoundModel
		{
			return _model;
		}
		
		/**
		 * Executa o som de acordo com as regras definidas no XML de configurações 
		 * @param fromBeginning
		 * @return 
		 * 
		 */
		public function play( fromBeginning:Boolean = false ):SoundChannel
		{
			init( );
			
			app.log( LogLevel.INFO_3,  model.id );
			
			if( model.ignoreIfPlaying && this.channels.length > 0 ) return this.channels[ 0 ];
			if( !model.allowMultipleChannels ) stopAll( );
			
			if( fromBeginning ) leftPosition = 0;
			if( source )
			{
				channel = source.play( leftPosition, model.loops, soundTransform );
			}
			else if( model.isStream )
			{
				source = new Sound( );
				source.load( new URLRequest( model.source ) );
				
				channel = source.play( leftPosition, model.loops, soundTransform );
			}
			
			if( channel )
			{
				if( channels.length == 0 )
				{
					var e:SoundItemEvent = new SoundItemEvent( SoundItemEvent.START );
					e.channel = channel;
					
					this.dispatchEvent( e );
				}
				
				channel.addEventListener( Event.SOUND_COMPLETE, onChannelSoundComplete );
				channels.push( channel );
				
				if( model.fadeInTime > 0 )
				{
					volume = 0;
					fadeInTween.make( this, { volume: model.volume }, model.fadeInTime );
				}
			}
			
			return channel;
		}
		
		private function onChannelSoundComplete( evt:Event ):void
		{
			var chan:SoundChannel = evt.target as SoundChannel;
			var e:SoundItemEvent = new SoundItemEvent( SoundItemEvent.COMPLETE );
			
			e.channel = chan;
			
			stopChannel( chan );
			
			this.dispatchEvent( e );
			
			if( channels.length == 0 )
			{
				this.dispatchEvent( new SoundItemEvent( SoundItemEvent.ALL_CHANNELS_COMPLETE ) );
			}
		}
		
		/**
		 * Para todas as instâncias desse som que estiverem em execução 
		 * 
		 */
		public function stop( ):void
		{
			stopAll( );
		}
		
		/**
		 * Para uma instância de som  
		 * @param p_channel O Channel a ser parado
		 * 
		 */
		public function stopChannel( p_channel:SoundChannel ):void
		{
			var i:int = channels.indexOf( p_channel );
			
			p_channel.removeEventListener( Event.SOUND_COMPLETE, onChannelSoundComplete );
			
			p_channel.stop( );
			
			if( i >= 0 )
			{
				channels.splice( i, 1 );
			}
			
			if( p_channel == channel )
			{
				channel = null;
			}
		}
		
		/**
		 * Para todos os sons. Mesmo que 'stop' 
		 * 
		 */
		public function stopAll( ):void
		{
			if( fadeInTween.running )
			{
				fadeInTween.stop( );
			}
			
			while( channels.length > 0 ) stopChannel( channels[ 0 ] );
		}
	}
}