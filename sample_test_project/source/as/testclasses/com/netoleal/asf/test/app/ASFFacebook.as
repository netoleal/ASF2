/*
Class: com.netoleal.asf.test.app.ASFFacebook
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
package com.netoleal.asf.test.app
{
	import asf.core.util.Sequence;
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.netoleal.asf.test.models.FacebookUserFactory;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ASFFacebook extends EventDispatcher
	{
		public static var appID:String;
		private static var instance:ASFFacebook;
		
		private var initTrans:Sequence;
		private var loginTrans:Sequence;
		private var loadUserTrans:Sequence;
		
		private var initialized:Boolean;
		
		private var session:FacebookSession;
		
		public function ASFFacebook( enforcer:FBEnforcer )
		{
			super( null );
			
			initTrans = new Sequence( );
			loginTrans = new Sequence( );
			loadUserTrans = new Sequence( );
		}
		
		public function init( ):Sequence
		{
			log( );
			
			initTrans.notifyStart( );
			
			if( initialized )
			{
				initTrans.notifyComplete( );
			}
			else
			{
				Facebook.init( appID, onInit );
			}
			
			initialized = true;
			
			return initTrans;
		}
		
		private function onInit( p_session:Object, error:Object ):void
		{
			log( p_session, error );
			
			if( p_session && p_session.uid != null )
			{
				loadCurrentUser( ).queue( initTrans.notifyComplete );
			}
			else
			{
				initTrans.notifyComplete( );
			}
		}
		
		private function loadCurrentUser():Sequence
		{
			log( );
			
			loadUserTrans.notifyStart( );
			
			var session:FacebookSession = Facebook.getSession( );
			
			if( session.uid != null )
			{
				FacebookUserFactory.getUser( "me" ).load( ).queue( loadUserTrans.notifyComplete );
			}
			else
			{
				loadUserTrans.notifyComplete( );
			}
			
			return loadUserTrans;
		}
		
		public function loginUser( ):Sequence
		{
			log( );
			var session:FacebookSession = Facebook.getSession( );
			
			loginTrans.notifyStart( );
			
			try
			{
				if( session && session.uid != null && session.uid != "" )
				{
					loadCurrentUser( ).queue( loginTrans.notifyComplete );
					return loginTrans;
				}
			}
			catch( e:Error ){ }
			
			Facebook.login( onUserLogin, { perms: Globals.app.navigation.lastOpenedSection.navigation.getSectionByID( "guestbook" ).params.permissions } );
			
			return loginTrans;
		}
		
		private function onUserLogin( userInfo:Object, error:Object ):void
		{
			log( userInfo, error );
			
			if( userInfo )
			{
				//FacebookUserFactory.getUser( Facebook.getSession( ).uid, userInfo );
			}
			
			loadCurrentUser( ).queue( loginTrans.notifyComplete );
		}
		
		public function isUserLoggedIn( ):Boolean
		{
			return FacebookUserFactory.getUser( "me" ).loaded;
		}
		
		public static function getInstance( ):ASFFacebook
		{
			if( !instance ) instance = new ASFFacebook( new FBEnforcer( ) );
			return instance;
		}
	}
}

internal class FBEnforcer{ }