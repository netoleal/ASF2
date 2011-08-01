package ca.turbulent.media.events
{
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ImageDataEvent extends Event
	{
		public static const IMAGE_DATA_RECEIVED		:String = "imageDataReceived";
		public var image							:Sprite;
		public var imageloader						:Loader = new Loader();
		public var imageByteArray					:ByteArray;
			
		public function ImageDataEvent(type:String, imageData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			imageloader.loadBytes(imageData.data);
			imageByteArray = imageData.data;
			image = new Sprite();
			image.addChild(imageloader);
		}

	
	}
}