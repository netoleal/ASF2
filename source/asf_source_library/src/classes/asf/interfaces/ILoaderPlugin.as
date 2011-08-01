/*
Interface: asf.interfaces.ILoaderPlugin
Author: Neto Leal
Created: Apr 18, 2011

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

package asf.interfaces
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.dependencies.FileModel;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public interface ILoaderPlugin extends IEventDispatcher
	{
		function addToQueue( p_file:FileModel ):void;
		function startQueue( p_maxConnections:uint = 0 ):void;
		function setApp( p_app:ApplicationModel ):void;
		function getApp( ):ApplicationModel;
		
		function pause( ):void;
		function resume( ):void;
		function clear( ):void;
		function dispose( ):void;
		
		function getFile( idOrURL:String ):*;
		function getMP3( idOrURL:String ):Sound;
		function getImageData( idOrURL:String ):BitmapData;
		function getImage( idOrURL:String ):Bitmap;
		function getSWF( idOrURL:String ):*;
		function getByteArray( idOrURL:String ):ByteArray;
		function getXML( idOrURL:String ):XML;
		function getVideo( idOrURL:String ):NetStream;
		
		function hasItem( idOrURL:String ):Boolean;
		
		function getTotalItems( ):uint;
		function getItemsLoaded( ):uint;
		function getBytesTotal( ):Number;
		function getBytesLoaded( ):Number;
		
		function isLoaded( ):Boolean;
		function isLoading( ):Boolean;
		function isPaused( ):Boolean;
	}
}