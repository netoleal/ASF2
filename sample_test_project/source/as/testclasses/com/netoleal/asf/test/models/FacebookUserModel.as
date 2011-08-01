/*
Class: com.netoleal.asf.test.models.FacebookUserModel
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
package com.netoleal.asf.test.models
{
	import asf.core.util.Sequence;
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.netoleal.asf.test.app.Globals;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FacebookUserModel extends EventDispatcher
	{
		public static const GENDER_MALE:String = "male";
		public static const GENDER_FEMALE:String = "female";
		
		private var uid:String;
		private var raw:Object;
		private var _loaded:Boolean = false;
		private var _loading:Boolean = false;
		private var loadSeq:Sequence;
		
		public function FacebookUserModel( p_uid:String, p_raw:Object = null )
		{
			super( null );
			
			uid = p_uid;
			loadSeq = new Sequence( );
			
			if( p_raw && !(p_raw is FacebookSession) )
			{
				raw = p_raw;
				_loaded = true;
			}
			
			log( uid );
		}
		
		public function get rawData( ):Object
		{
			return raw;
		}
		
		public function get loading( ):Boolean
		{
			return _loading;
		}
		
		public function get loaded( ):Boolean
		{
			return _loaded;
		}
		
		public function load( ):Sequence
		{
			loadSeq.notifyStart( );
			
			if( this.loaded )
			{
				this.dispatchComplete( );
			}
			else if( !this._loading )
			{
				this._loading = true;
				Facebook.api( "/" + uid, onLoad );
			}
			
			return loadSeq;
		}
		
		public function get profilePictureURL( ):String
		{
			var url:String = Globals.app.params.imageProxy + "http://graph.facebook.com/" + this.id + "/picture";
			return url;
		}
		
		public function get profilePictureAvatar( ):String
		{
			var url:String = Globals.app.params.imageProxy + "http://graph.facebook.com/" + this.id + "/picture";
			return url;
		}
		
		private function onLoad( userInfo:Object, error:Object ):void
		{
			this._loading = false;
			
			if( userInfo )
			{
				this._loaded = true;
				raw = userInfo;
				
				if( isNaN( Number( uid ) ) )
				{
					FacebookUserFactory.getUser( raw.id, raw );
				}
				
				this.dispatchComplete( );
			}
			else
			{
				raw = { };
				this.dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) );
			}
		}
		
		private function dispatchComplete( ):void
		{
			loadSeq.notifyComplete( );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get timeZone( ):int
		{
			if( !raw ) return 0;
			return raw.timezone;
		}
		
		public function get gender( ):String
		{
			if( !raw ) return "male";
			return raw.gender;
		}
		
		public function get verified( ):Boolean
		{
			if( !raw ) return false;
			return raw.verified;
		}
		
		public function get lastName( ):String
		{
			if( !raw ) return "";
			return raw.last_name || "";
		}
		
		public function get locale( ):String
		{
			return raw.locale
		}
		
		public function get link( ):String
		{
			return raw.link;
		}
		
		public function get updatedTime( ):String
		{
			return raw.updated_time;
		}
		
		public function get fullName( ):String
		{
			return firstName + " " + lastName;
		}
		
		public function get firstName( ):String
		{
			if( !raw ) return "";
			return raw.first_name || raw.name;
		}
		
		public function get id( ):String
		{
			return uid;//raw.id;
		}
	}
}