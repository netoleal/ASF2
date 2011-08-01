package ca.turbulent.media.events
{
	import flash.events.Event;

	public class PyroEvent extends Event
	{
		public static const BANDWIDTH_CHECKED				:String 			= "bandwidthCheckedEvent";
		public static const BUFFER_EMPTY					:String				= "bufferEmptiedEvent";
		public static const BUFFER_TIME_ADJUSTED			:String 			= "bufferTimeAdjusted";
		public static const BUFFER_FULL						:String				= "bufferFullEvent";
		public static const BUFFER_FLUSH					:String				= "bufferFlushEvent";
		public static const CLOSE_CAPTIONS_UPDATE			:String 			= "closeCaptionUpdate";	
		public static const COMPLETED						:String				= "completed";
		public static const DISCONNECTED					:String				= "streamDisconnectedEvent";
		public static const INSUFFICIENT_BANDWIDTH			:String				= "insufficientBandwidthEvent";
		public static const METADATA_RECEIVED				:String				= "metadataReceivedEvent";
		public static const MUTED							:String				= "mutedEvent";
		public static const NEW_STREAM_INIT					:String				= "newStreamInitEvent";
		public static const PAUSED							:String				= "streamPausedEvent";
		public static const SEEKED							:String				= "streamSeekedEvent";	
		public static const SIZE_UPDATE						:String				= "sizeChangedEvent";
		public static const STARTED							:String				= "streamStartedEvent";
		public static const STOPPED							:String				= "streamStoppedEvent";
		public static const UNMUTED							:String				= "unmutedEvent";
		public static const UNPAUSED						:String				= "unpausedEvent";
		public static const URL_PARSED						:String 			= "urlParsedEvent";
		public static const VOLUME_UPDATE					:String				= "volumeUpdate";
		public static const XMP_DATA_RECEIVED				:String 			= "XMPDataReceived";
		
		public var eventType								:String				= "";
		
		public function PyroEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			eventType = type;
		}
		
		override public function clone():Event { return new PyroEvent(this.type, false, false); }
		
	}
}