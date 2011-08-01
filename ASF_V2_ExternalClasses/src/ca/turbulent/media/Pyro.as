/*
Disclaimer for Eric Poirier's ca.turbulent.media.Pyro's license:

TERMS OF USE - PYRO

Open source under the BSD License.

Copyright © 2007-2009 Eric Poirier [Nibman] 
Copyright © 2008-2009 Turbulent Media inc. 
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package ca.turbulent.media
{
	import ca.turbulent.media.events.*;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.*;

	
	/**
	* Pyro
	* Version 1.2.1
	*
	*  @author Eric Poirier 2008-2009, e@gronour.com || epoirier@turbulent.ca || nibman@gmail.com
	*	http://gronour.com 	
	*	http://agit8.turubulent.ca 
	*   http://turbulent.ca 
	*   
	*  	@description 
	* 	ABOUT PYRO flash video control API.
	*  	Methods set for handling and displaying video files thru the Flash player.
	* 	Regroups progressive and rtmp streams handling by using a common, simple and direct AS3 API.
	* 	
	* 	Works and tested for flashPlayer 9,1,1,5 up to 10,0,12,36 . Should logically work for all 
	* 	flashPlayer 10 versions too. 
	*         
	* 	Not a complete media player, Pyro bundles core functionalities of standard flash video 
	* 	players and leaves out design aspects to you.
	*	Pyro is a flash.display.Sprite class extension.    
	*  
	* 	Pyro proprietary events are located in the ca.turbulent.media.events package.  
	*	
	*	Pyro's static properties use a prefix based naming scheme for tighter code completion in 
	* 	most code editors.
	*   
	*	@usage 
	*	Using Pyro is quick and easy. Here is a simple exemple.  
	*	Meant to work in a Flash player context (AS projects or Flash IDE projects):
	* 	1. Create a Pyro instance, insert width and height as dimension arguments,
	*	the 3rd paramater here is the stageEventMechanics mode you wish to use. In most regular flash uses, you will not 
	* 	need to touch this, and the defaut 'allOn' value is passed (Pyro.STAGE_EVENT_MECHANICS_ALL_ON). 
	* 	Then and add your pyro instance to the child list, as follows:   
	* 	<code>
	*	var pyroInstance:Pyro = new Pyro(320, 240);
	* 	addChild(pyroInstance);
	* 	</code>
	*	
	*   2.Once your Pyro instance is created, understanding how the play method behaves is crucial. 
	*
	* 	<code>
	* 	// Connects to a file and starts streaming it as a regular progressive download.
	*	pyroInstance.play("http://epoirier.developers.turbulent.ca/pyro/sharedmedias/videos/gratton.flv"); 
	*	
	* 	// Connects to a file thru a middleware script and starts streaming.
	*	pyroInstance.play("http://epoirier.developers.turbulent.ca/pyro/sharedmedias/videos/gratton.flv?start=34.454");          	    
	*	
	* 	// Connects to an rtmp server and starts streaming. 
	*	pyroInstance.play("rtmp://epoirier.developers.turbulent.ca/pyro/sharedmedias/gratton.mp4"); 
	*
	*	// resumes from a paused status 	 
	*	pyroInstance.play(); </code>	
	* 	You can call up a new stream at anytime.
	* 	Pyro takes care of resetting, closing and clearing all required necessary variables, parameters and assets. 
	* 	As shown above, calling the play method without arguments acts as the usual play method 
	*	and resumes the stream if it has been paused or stopped.      
	*  	
	* 	3.Creating visual states and stream progress related visuals is easy. 
	*   I've put together a few exemples that will get anyone with minimal actionscript 3 knowledge started quickly.
	* 
	* @tiptext	Pyro
	* 	@playerversion Flash 9.1.1.5
	*	to 
	* 	@playerversion Flash 10.0.12.36	 	  
	* 
	* */
	
	public class Pyro extends Sprite
	{
		/* VIDEO ALIGNMENT RELATED CONSTANTS START HERE */
		/**
		* Used as hAlignMode property value. -->> pyroInstance.hAlignMode = Pyro.ALIGN_HORIZONTAL_CENTER ['center']
		* Forces the Video class instance to align horizontally to the center of pyro's physical canvas if it is 
		* smaller than the specified width. 
		* @see #ALIGN_HORIZONTAL_LEFT
		* @see #ALIGN_HORIZONTAL_RIGHT 
		* @see #hAlignMode 
		**/ 	
		public static const ALIGN_HORIZONTAL_CENTER				:String				= "center";
		
		/**
		* Used as hAlignMode property value. -->> pyroInstance.hAlignMode = Pyro.ALIGN_HORIZONTAL_LEFT ['left']
		* Forces the Video class instance to align horizontally to the left of pyro's physical canvas if it is 
		* smaller than the specified width. 
		* @see #ALIGN_HORIZONTAL_CENTER
		* @see #ALIGN_HORIZONTAL_RIGHT 
		* @see #hAlignMode 
		**/	
		public static const ALIGN_HORIZONTAL_LEFT				:String				= "left";
		
		/**
		* Used as hAlignMode property value. -->> pyroInstance.hAlignMode = Pyro.ALIGN_HORIZONTAL_RIGHT ['right']
		* Forces the Video class instance to align horizontally to the right of pyro's physical canvas if it is 
		* smaller than the specified width. 
		* @see #ALIGN_HORIZONTAL_LEFT
		* @see #ALIGN_HORIZONTAL_CENTER 
		* @see #hAlignMode 
		**/
		public static const ALIGN_HORIZONTAL_RIGHT				:String				= "right";
		
		/**
		* Used as vAlignMode property value. -->> pyroInstance.vAlignMode = Pyro.ALIGN_VERTICAL_BOTTOM ['bottom']
		* Forces the Video class instance to align vertically to the right of pyro's physical canvas if it is 
		* smaller than the specified height. 
		* @see #ALIGN_VERTICAL_TOP
		* @see #ALIGN_VERTICAL_CENTER 
		* @see #vAlignMode 
		**/
		public static const ALIGN_VERTICAL_BOTTOM				:String				= "bottom";
		
		/**
		* Used as vAlignMode property value. -->> pyroInstance.vAlignMode = Pyro.ALIGN_VERTICAL_TOP ['top']
		* Forces the Video class instance to align vertically to the center of pyro's physical canvas if it is
		* smaller than the specified height. 
		* @see #ALIGN_VERTICAL_CENTER
		* @see #ALIGN_VERTICAL_BOTTOM 
		* @see #vAlignMode 
		**/
		public static const ALIGN_VERTICAL_TOP					:String 			= "top";
		
		/**
		* Used as vAlignMode property value. -->> pyroInstance.vAlignMode = Pyro.ALIGN_VERTICAL_CENTER ['center'] 
		* Forces the Video class instance to align vertically to the center of pyro's physical canvas if it is 
		* smaller than the specified height. 
		* @see #ALIGN_VERTICAL_TOP
		* @see #ALIGN_VERTICAL_BOTTOM 
		* @see #vAlignMode 
		**/
		public static const ALIGN_VERTICAL_CENTER				:String 			= "center";
		/* VIDEO ALIGNMENT RELATED CONSTANTS END HERE */
		
		
		/* BUFFERING MODE RELATED CONSTANTS START HERE */
		/**
		* Used as bufferingMode property value. -->> pyroInstance.bufferingMode = Pyro.BUFFFERING_MODE_SINGLE_TRESHOLD ['single']. 
		* Sets the targetted pyro instance to use a single linear buffertime value. 
		* Use bufferTime only when bufferingMode == Pyro.BUFFERING_MODE_SINGLE_TRESHOLD.     
		* @see #bufferTime
		* @see #bufferingMode
		* @see #BUFFERING_MODE_DUAL_TRESHOLD
		* @see #DUAL_TRESHOLD_STATE_START
		* @see #DUAL_TRESHOLD_STATE_STREAMING  
		**/		
		public static const BUFFERING_MODE_SINGLE_TRESHOLD		:String				= "single";
		
		/**
		* Used as bufferingMode property value. -->> pyroInstance.bufferingMode = Pyro.BUFFERING_MODE_DUAL_TRESHOLD. ['dual'] 
		* Sets the targetted pyro instance to use a dual treshold buffertime strategy. 
		* Functions well with high speed and medium speed connections and usually has very minimal impact 
		* on slower connections.
		*  
		* This method works by toggling pyro's netStream bufferTime between 2 values. 
		* The first value is meant to be small and the latter one has to be significantly higher.
		*  
		* When the stream initally starts buffering, the lowest value is pushed as bufferTime. Once the buffer is full, the 
		* bufferTime then gets toggled with the highest value. Therefore attempting to prevent buffering hiccups. 
		*
		* Whenever the buffer reaches its emptied state, the lowest value is pushed back in and the whole dual cycle restarts.
		*   
		* Using bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD renders pyroInstance.bufferTime useless.     
		* @see #bufferingMode
		* @see #BUFFERING_MODE_SINGLE_TRESHOLD
		* @see #DUAL_TRESHOLD_STATE_START
		* @see #DUAL_TRESHOLD_STATE_STREAMING  
		**/		
		public static const BUFFERING_MODE_DUAL_TRESHOLD		:String 			= "dual";
		/* BUFFERING MODE RELATED CONSTANTS ENDS HERE */
		
		
		/* CONNECTION SPEED READ-ONLY RELATED CONSTANTS START HERE */
		/**
		* Used as connectionSpeed read-only property value. --> connectionSpeed == Pyro.CONNECTION_SPEED_LOW ['low'] 
		* when client is on lowBandwidth connection approximately 56 k connections and lower. 
		* Relevant only if pyroInstance.checkBandwidth == true and pyroInstance.bandwidthCheckDone == true.  
		* @see #CONNECTION_SPEED_MEDIUM
		* @see #CONNECTION_SPEED_HIGH 
		* @see #connectionSpeed 
		* @see #checkBandwidth
		* @see #bandwidthCheckDone
		**/
		public static const CONNECTION_SPEED_LOW				:String				= "low";
		
		/**
		* Used as connectionSpeed read-only property value. --> connectionSpeed == Pyro.CONNECTION_SPEED_MEDIUM ['medium'] 
		* connectionSpeed == Pyro.CONNECTION_SPEED_MEDIUM when client is on regular DSL and limited cable connections.
		* Relevant only if pyroInstance.checkBandwidth == true and pyroInstance.bandwidthCheckDone == true.
		* @see #CONNECTION_SPEED_LOW
		* @see #CONNECTION_SPEED_HIGH 
		* @see #connectionSpeed
		* @see #checkBandwidth
		* @see #bandwidthCheckDone 
		**/
		public static const CONNECTION_SPEED_MEDIUM				:String				= "medium";
		
		/**
		* Used as connectionSpeed read-only property value. --> connectionSpeed == Pyro.CONNECTION_SPEED_LOW ['low'] 
		* connectionSpeed == Pyro.CONNECTION_SPEED_LOW when client is on 56kbs and lower connections.
		* Relevant only if pyroInstance.checkBandwidth == true and pyroInstance.bandwidthCheckDone == true.
		* @see #CONNECTION_SPEED_MEDIUM
		* @see #CONNECTION_SPEED_HIGH 
		* @see #connectionSpeed
		* @see #checkBandwidth
		* @see #bandwidthCheckDone 
		**/
		public static const CONNECTION_SPEED_HIGH				:String				= "high";
		/* CONNECTION SPEED READ-ONLY RELATED CONSTANTS END HERE */
		
		
		/* DUAL TRESHOLD STATES READ-ONLY RELATED CONSTANTS START HERE */
		/**
		* Lowest dualTresholdState read-only property value.
		* Mainly used internally. When dualTresholdState == Pyro.DUAL_TRESHOLD_STATE_START, the bufferTime is currently equals 
		* to the lowest value of the current BufferTimeTable instance, usually when the netStream is connecting or 
		* when the netStream buffer is emptied.    
		* @see #DUAL_TRESHOLD_STATE_STREAMING
		* @see #BUFFERING_MODE_DUAL_TRESHOLD
		* @see #highSpeedBufferTable 
		* @see #mediumSpeedBufferTable
		* @see #lowSpeedBufferTable
		**/
		public static const DUAL_TRESHOLD_STATE_START			:String 			= "start";
		
		/**
		* Highest dualTresholdState read-only property value.
		* Mainly used internally. When dualTresholdState == Pyro.DUAL_TRESHOLD_STATE_STREAMING, 
		* the bufferTime is currently equals to the highest value of the current BufferTimeTable instance, 
		* usually when the netStream has started playing or when the netStream buffer is full.    
		* @see #DUAL_TRESHOLD_STATE_START
		* @see #BUFFERING_MODE_DUAL_TRESHOLD
		* @see #highSpeedBufferTable 
		* @see #mediumSpeedBufferTable
		* @see #lowSpeedBufferTable
		**/
		public static const DUAL_TRESHOLD_STATE_STREAMING		:String 			= "streaming";
		/* DUAL TRESHOLD STATES READ-ONLY RELATED CONSTANTS ENDS HERE */
		
		
		/* FULLSCREEN MODE RELATED CONSTANTS START HERE */			
		/**
		* Used as fullscreenMode property value. -->> pyroInstance.fullscreenMode = Pyro.FS_MODE_HARDWARE ['hardwareMode'] 
		* Forces pyro to use hardware acceleration when fullscreen mode is toggled-in.
		* If system has no video encoding possibilities, fullscreenMode is resetted to default FS_MODE_SOFTWARE.		
		* @see #FS_MODE_SOFTWARE
		* @see #toggleFullScreen
		* @see #fullscreenRectangle 
		**/
		public static const FS_MODE_HARDWARE					:String				= "hardwareMode";
		
		/**
		* Used as fullscreenMode property value. -->> pyroInstance.fullscreenMode = Pyro.FS_MODE_SOFTWARE ['softwareMode']. 
		* Forces pyro to use software rendering when fullscreen mode is toggled-in.
		* @see #FS_MODE_HARDWARE
		* @see #toggleFullScreen
		* @see #fullscreenRectangle 
		**/
		public static const FS_MODE_SOFTWARE					:String				= "softwareMode";
		/* FULLSCREEN MODE RELATED CONSTANTS ENDS HERE */
		
		/* FMS 3.5 NETCONNECTION PROXY TYPE RELATED CONSTANTS STARTS HERE */
		/**
		* FMS 3.5  
		* Used as the proxyType property value. -->> pyroInstance.proxyType = Pyro.PROXY_TYPE_NONE ['none'].
		* Toggles the current netConnection's proxyType property with the 'none' value.
		* Relevant only when streamType == STREAM_TYPE_TRUE_STREAM && pyroInstance.serverType != Pyro.SERVER_TYPE_UNDER_FMS_3_5 
		* && pyroInstance.serverType != SERVER_TYPE_NONE. 
		* @see #PROXY_TYPE_HTTP
		* @see #PROXY_TYPE_CONNECT
		* @see #PROXY_TYPE_BEST  
		* @see #proxyType 
		* @see #streamType
		* @see #serverType
		**/
		public static const PROXY_TYPE_NONE						:String 			= "none";
		
		/**
		* FMS 3.5  
		* Used as the proxyType property value. -->> pyroInstance.proxyType = Pyro.PROXY_TYPE_HTTP ['HTTP'].
		* Toggles the current netConnection's proxyType property with the 'HTTP' value.
		* Relevant only when streamType == STREAM_TYPE_TRUE_STREAM && pyroInstance.serverType != Pyro.SERVER_TYPE_UNDER_FMS_3_5 
		* && pyroInstance.serverType != SERVER_TYPE_NONE. 
		* @see #PROXY_TYPE_NONE
		* @see #PROXY_TYPE_CONNECT
		* @see #PROXY_TYPE_BEST  
		* @see #proxyType 
		* @see #streamType
		* @see #serverType
		**/
		public static const PROXY_TYPE_HTTP						:String				= "HTTP";
		
		/**
		* FMS 3.5  
		* Used as the proxyType property value. -->> pyroInstance.proxyType = Pyro.PROXY_TYPE_CONNECT ['CONNECT'].
		* Toggles the current netConnection's proxyType property with the 'CONNECT' value.
		* Relevant only when streamType == STREAM_TYPE_TRUE_STREAM && pyroInstance.serverType != Pyro.SERVER_TYPE_UNDER_FMS_3_5 
		* && pyroInstance.serverType != SERVER_TYPE_NONE. 
		* @see #PROXY_TYPE_NONE
		* @see #PROXY_TYPE_HTTP
		* @see #PROXY_TYPE_BEST  
		* @see #proxyType 
		* @see #streamType
		* @see #serverType
		**/
		public static const PROXY_TYPE_CONNECT					:String				= "CONNECT"
		
		/**
		* FMS 3.5  
		* Used as the proxyType property value. -->> pyroInstance.proxyType = Pyro.PROXY_TYPE_BEST ['BEST'].
		* Toggles the current netConnection's proxyType property with the 'BEST' value.
		* Relevant only when streamType == STREAM_TYPE_TRUE_STREAM && pyroInstance.serverType != Pyro.SERVER_TYPE_UNDER_FMS_3_5 
		* && pyroInstance.serverType != SERVER_TYPE_NONE. 
		* @see #PROXY_TYPE_NONE
		* @see #PROXY_TYPE_HTTP
		* @see #PROXY_TYPE_CONNECT  
		* @see #proxyType 
		* @see #streamType
		* @see #serverType
		**/
		public static const PROXY_TYPE_BEST						:String				= "best";
		/* FMS 3.5 NETCONNECTION PROXY TYPE RELATED CONSTANTS ENDS HERE */
		
		
		/* SERVER TYPE RELATED CONSTANTS STARTS HERE, 
		AS FUTURE RELEASES OF FMS ARE RELEASED THIS CONSTANT FAMILY WILL GET APPENDED WITH OTHER VALUES */
		
		/**
		* Used as serverType property value. -->> pyroInstance.serverType = Pyro.SERVER_TYPE_UNDER_FMS_3_5 ['serverTypeUnderFMS_3_5'].
		* Especially related to how urls get parsed when streaming over rtmp feeds with servers under FMS 3.5, or with RED 5 Instances.
		*    
		* When serverType == Pyro.SERVER_TYPE_UNDER_FMS_3_5, a pyroInstance.play('rtmp://domain.tv/collection/Holla/films/1000_VI53462000.mp4'); 
		* results in a netConnection.connect call to 'rtmp://domain.tv/collection/Holla', 
		* and in a netStream.play method fetching at something like 'mp4:films/1000_VI53462000.mp4'.
		 * 
		* When in this serverType setting, use 'forceMP4Extension' to toggle :mp4 prefix casting  
		* and 'streamNameHasExtension' to toggle file extension presence.     	 
		* @see #SERVER_TYPE_LATEST
		* @see #SERVER_TYPE_NONE
		* @see #forceMP4Extension
		* @see #streamNameHasExtension    
		* @see #serverType
		* @see #streamType  
		**/
		public static const SERVER_TYPE_UNDER_FMS_3_5			:String 			= "serverTypeUnderFMS_3_5";
		
		/**
		* Used as serverType property value. -->> pyroInstance.serverType = Pyro.SERVER_TYPE_LATEST ['serverTypeLatest'].
		* Especially related to how urls get parsed when streaming over rtmp feeds with servers over FMS 3.5.
		*     
		* When serverType == Pyro.SERVER_TYPE_LATEST, a pyroInstance.play('rtmp://domain.tv/collection/Holla/films/1000_VI53462000.mp4'); 
		* result in a netConnection.connect call to 'rtmp://domain.tv/collection', 
		* and in a netStream.play method fetching at something like 'mp4:Holla/films/1000_VI53462000.mp4'.
		*
		* With SERVER_TYPE_LATEST,   
		* :mp4 file type prefixing and file type extension are always on for MPG4 related types and always absent with .flv types.
		*  
		* Toggling the directFileType to false will force SERVER_TYPE_LATEST URL parsing to act like its SERVER_TYPE_UNDER_FMS_3_5 counterpart 
		* for its netConnection.connect and netStream.play arguments.     	 
		* @see #SERVER_TYPE_LATEST
		* @see #SERVER_TYPE_NONE
		* @see #forceMP4Extension
		* @see #streamNameHasExtension    
		* @see #serverType
		* @see #streamType
		* @see #useDirectFilePath   
		**/
		public static const SERVER_TYPE_LATEST					:String 			= "serverTypeLatest";
	
		public static const SERVER_TYPE_NONE					:String				= "serverTypeNone";
		/* SERVER TYPE RELATED CONSTANTS ENDS HERE */
		
		
		/* STAGE EVENTS MECHANICS RELATED CONSTANTS STARTS HERE */
		/**
		* Used as stageEventMechanics property value. -->> pyroInstance.stageEventMechanics = Pyro.STAGE_EVENTS_MECHANICS_ALL_ON ['allOn'].
		* Toggles if the current Pyro instance is initialized and closed thru Event.ADDED_TO_STAGE and Event.REMOVED_FROM_STAGE events.
		* Also forces subscription to FullScreenEvent.FULL_SCREEN event.
		* Default value, used in regular AS3 Flash projects. Also waits on stage dimensions presence before initializing (Firefox flash player
		* has latency issues with stage dimensions and caching, this seems to prevent it so far) .       	 
		* @see #STAGE_EVENTS_MECHANICS_ALL_OFF
		* @see #STAGE_EVENTS_MECHANICS_ONLY_FS
		* @see #stageEventMechanics
		**/
		public static const STAGE_EVENTS_MECHANICS_ALL_ON		:String				= "allOn";
		
		/**
		* Used as stageEventMechanics property value. -->> pyroInstance.stageEventMechanics = Pyro.STAGE_EVENTS_MECHANICS_ALL_OFF ['allOff'].
		* Automatically bypasses every reference to the Stage so that you get no errors dispatched when dealing with Flex Apps or 
		* ThirdParty frameworks that dont rely on Stage or natural AS3 DisplayObjects structure.      	 
		* @see #STAGE_EVENTS_MECHANICS_ALL_ON
		* @see #STAGE_EVENTS_MECHANICS_ONLY_FS
		* @see #stageEventMechanics
		**/
		public static const STAGE_EVENTS_MECHANICS_ALL_OFF		:String				= "allOff"
		
		/**
		* Used as stageEventMechanics property value. -->> pyroInstance.stageEventMechanics = Pyro.STAGE_EVENTS_MECHANICS_ONLY_FS ['onlyFullscreen'].
		* Automatically bypasses every reference to the Stage so that you get no errors dispatched when dealing with Flex Apps or 
		* ThirdParty frameworks that dont rely on Stage or natural AS3 DisplayObjects structure.
		* However, it forces internal subscription to FullScreenEvent.FULL_SCREEN event.        	 
		* @see #STAGE_EVENTS_MECHANICS_ALL_ON
		* @see #STAGE_EVENTS_MECHANICS_ALL_OFF
		* @see #stageEventMechanics
		**/
		public static const STAGE_EVENTS_MECHANICS_ONLY_FS		:String 			= "onlyFullscreen"; 
		/* STAGE EVENTS MECHANICS RELATED CONSTANTS ENDS HERE */
		
		
		/* STATUS RELATED CONSTANTS STARTS HERE */
		/**
		* Pyro's status gets set to STATUS_CLOSED ['statusClosed'] when the close method is called and the active netStream is closed.
		* Monitoring the STATUS_CLOSED can be quite hazardous since it gets called everytime a new stream is queried.     
	 	* @see #status
		**/
		public static const STATUS_CLOSED						:String 			= "statusClosed";
		
		/**
		* TO BE DEPRECATED IN FUTURE RELEASES.
		* USE PYROEVENT.COMPLETE EVENT 
		* Pyro's status gets set to STATUS_COMPLETED ['statusCompleted'] when the stream reaches its end 
		* and is used internally to prevent hazardous double dispatching of the PyroEvent.COMPLETE Event.
		* Monitoring the completion of streams thru this status is now rendered obsolete, using the PyroEvent.COMPLETE Event 
		* is considered best practice. 
	 	* @see #status
		**/
		public static const STATUS_COMPLETED					:String				= "statusCompleted";
		
		/**
		* Pyro's status gets set to STATUS_CONNECTING ['statusConnecting'] when the play method is called with a new url. 
		* This status remains until the stream starts playing or a connection related error is dispatched.  
	 	* @see #status
		**/
		public static const STATUS_CONNECTING					:String 			= "statusConnecting";
		
		/**
		* Pyro's status gets set to STATUS_INITIALIZING ['statusInitializing'] when your Pyro instance is first instanciate.
		* This status remains until the player is ready to receive connections (STATUS_READY).  
	 	* @see #STATUS_READY
	 	* @see #status
		**/
		public static const STATUS_INITIALIZING					:String 			= "statusInitializing"
		
		/**
		* Pyro's status gets set to STATUS_PENDING ['statusPending'] when in buffering, idle and obviously as the pending states. 
		* Its an all in one 'waiting' status. 
		* @see #STATUS_PLAYING
		* @see #STATUS_PAUSED
		* @see #STATUS_STOPPED    
	 	* @see #status
		**/
		public static const STATUS_PENDING						:String				= "statusPending";
		
		/**
		* Pyro's status gets set to STATUS_PLAYING ['statusPlaying'] when the stream starts playing.
		* @see #STATUS_PAUSED
		* @see #STATUS_PENDING
		* @see #STATUS_STOPPED    
	 	* @see #status
		**/
		public static const STATUS_PLAYING						:String				= "statusPlaying";
		
		/**
		* Pyro's status gets set to STATUS_PAUSED ['statusPaused'] when the stream gets paused.
		* 
		* @see #STATUS_PLAYING
		* @see #STATUS_PENDING
		* @see #STATUS_STOPPED    
	 	* @see #status
		**/
		public static const STATUS_PAUSED						:String				= "statusPaused";
		
		/**
		* Pyro's status gets set to STATUS_READY ['statusReady'] when your Pyro instance has successfully been initialized,
		* and is 'physically fit' to start streaming videos.   
		* @see #STATUS_INITIALIZING
	 	* @see #status
		**/
		public static const STATUS_READY						:String 			= "statusReady";
		
		/**
		* Pyro's status gets set to STATUS_STOPPED ['statusStopped'] when Pyro's stop method is called. 
		* 		
		* @see #STATUS_PLAYING
		* @see #STATUS_PAUSED
		* @see #STATUS_PENDING    
	 	* @see #status
		**/
		public static const STATUS_STOPPED						:String				= "statusStopped";
		/* STATUS RELATED CONSTANTS ENDS HERE */
		
		
		/* SCALE MODE RELATED CONSTANTS STARTS HERE */
		/**
		* Used as scaleMode property value. -->> pyroInstance.scaleMode = Pyro.SCALE_MODE_HEIGHT_BASED ['heightBasedScale']) 
		* Sets the videoHeight as base factor for resizing while maintainAspectRatio is set to true.
		* Usually proper to 4:3 ratios. 
		* @see #SCALE_MODE_WIDTH_BASED
		* @see #maintainAspectRatio 
		* @see #forceResize
		* @see #scaleMode 
		**/
		public static const SCALE_MODE_HEIGHT_BASED				:String				= "heightBasedScale";
		
		/**
		* Used as scaleMode property value. -->> pyroInstance.scaleMode = Pyro.SCALE_MODE_WIDTH_BASED ['widthBasedScale']) 
		* Sets the videoWidth as base factor for resizing while maintainAspectRatio is set to true.
		* Usually proper to 16:9 ratios. 
		* @see #SCALE_MODE_HEIGHT_BASED
		* @see #maintainAspectRatio 
	 	* @see #forceResize
		* @see #scaleMode 
		**/	
		public static const SCALE_MODE_WIDTH_BASED				:String				= "widthBasedScale";
		
		/**
		* Used as scaleMode property value. -->> pyroInstance.scaleMode = Pyro.SCALE_MODE_NO_SCALE ['noScale']) 
		* Ignores canvas rescaling and ratios once metadata sizes are received.
		* @see #SCALE_MODE_HEIGHT_BASED
		* @see #SCALE_MODE_WIDTH_BASED
		* @see #maintainAspectRatio 
	 	* @see #forceResize
		* @see #scaleMode 
		**/	
		public static const SCALE_MODE_NO_SCALE					:String				= "noScale";	
		/* SCALE MODE RELATED CONSTANTS ENDS HERE */
		
		
		/* STREAM TYPE RELATED CONSTANTS STARTS HERE */
		/**
		* Used as streamType read-only property value. -->> if (pyroInstance.streamType == Pyro.STREAM_TYPE_PROGRESSIVE ['progressive']) 
		* Indicates the current playing stream is beeing read as regular progressive http (https) download. 
		* @see #STREAM_TYPE_TRUE_STREAM
		* @see #STREAM_TYPE_PROXIED_PROGRESSIVE
		* @see #streamType 
		**/			
		public static const STREAM_TYPE_PROGRESSIVE				:String				= "progressive";
		
		/**
		* Used as streamType read-only property value. -->> if (pyroInstance.streamType == Pyro.STREAM_TYPE_PROXIED_PROGRESSIVE ['proxiedProgressive']) 
		* Indicates the current playing stream is beeing read as a simulated stream (proxied or handled by a middleware script 
		* such as python, php, etc...), usually delivered thru http or https. 
		* @see #STREAM_TYPE_TRUE_STREAM
		* @see #STREAM_TYPE_PROGRESSIVE
		* @see #streamType 
		* @see #timeOffset
		**/
		public static const STREAM_TYPE_PROXIED_PROGRESSIVE		:String				= "proxiedProgressive";
		
		/**
		* Used as streamType read-only property value. -->> if (pyroInstance.streamType == Pyro.STREAM_TYPE_TRUE_STREAM ['streamed']) 
		* Indicates the current playing stream is beeing read as a true stream (either rtmp, rtmps, etc...) delivered by a streaming server. 
		* @see #STREAM_TYPE_PROGRESSIVE
		* @see #STREAM_TYPE_PROXIED_PROGRESSIVE
		* @see #streamType 
		**/
		public static const STREAM_TYPE_TRUE_STREAM				:String				= "streamed";
		/* STREAM TYPE RELATED CONSTANTS ENDS HERE */
		
		
		/* PYRO VERSION CONSTANT */
		/**
		*	Indicates main pyro version beeing used. 
		*/		
		public static const VERSION								:String 			= "1.2.1";
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		/**
		* Toggles automatic video alignment when resizing occurs. 
		* Defaults to true.
		* @see #vAlignMode
		* @see #hAlignMode 
		* @see #resize 
	 	* @see #align 
		**/	
		public var autoAlign									:Boolean			= true;
		
		/**
		* Toggles video automatic start when a new stream is called. If set to true, video will start playing when buffer is sufficient. 
		* Defaults to true.
		* @see #play
		**/
		public var autoPlay										:Boolean			= true;
		
		/**
		* Toggles automatic bufferTime readjustement if the video is playing and keeps on buffering. Works in a cascading pattern. 
		* Defaults to true.
		* @see #checkBandwidth
		* @see #bandwidthCheckDone
		* @see #bufferingMode  
		* @see #bufferTime 
		**/
		public var autoAdjustBufferTime							:Boolean			= true;
		
		/**
		* Toggles automatic resizing to metadata dimension tags values. 
		* Occurs only when metadata specifies width and height. 
		* If width and height are not encoded in the metadata, video is kept at specified size. 
		* Defaults to false.  
		* @see #metadata
		* @see #resize
		* @see #align
		* @see #hAlignMode
		* @see #vAlignMode
		* @see #scaleMode     
		**/
		public var autoSize										:Boolean			= false;
		
		/**
		* Stores if bandwitdth check was executed. Bandwidth check is executed only if checkBandwidth is set to true. 
		* Defaults to false.    
		* @see #checkBandwidth
		* @see #autoAdjustBufferTime
		* @see #bufferingMode  
		**/
		public var bandwidthCheckDone							:Boolean			= false;
		
		/**
		* Toggles if Pyro events bubble. 
		* Defaults to false.
		* @see #cancelableEvents
		**/
		public var bubbleEvents									:Boolean 			= false;
		
		/**
		* Toggles if Pyro events are cancelable. 
		* Defaults to false. 
		* @see #bubbleEvents
		**/
		public var cancelableEvents								:Boolean			= false;
		
		/**
		* Toggles Pyro's local event listeners assignation captureEvent property. 
		* Defaults to false.
		* @see #eventsPriority
		* @see #useWeakReferences   
		**/
		public var captureEvents								:Boolean			= false;
		
		/**
		* Toggles if pyro's built-in checkBandwidth occurs.  
		* Stores its result in connectionSpeed property.  
		* Defaults to true.
		* Will also adjust bufferTime if autoAdjustBuferTime is set to true.
		* @see #connectionSpeed 
		* @see #bandwidthCheckDone
		* @see #autoAdjustBuferTime
		* @see #buffertTime 
		* @see #bufferingMode 
		**/
		public var checkBandwidth								:Boolean			= true;	
		
		/**
		* Sets Pyro's local event listeners assignation eventPriority property. 
		* Defaults to 0.
		* @see #cancelableEvents
		* @see #useWeakReferences    
		**/
		public var eventsPriority								:Number				= 0;
		
		/**
		* Toggles mp4 encoded files to be called with the streamName formatted as -->> mp4:['file'] when streaming thru RTMP. 
		* Defaults to true. 
		* Leave out to true for yor pyro instance to take any possible format.  
		* Possible mp4 encoded formats are: '.mp4', ".mov", ".aac", ".3gp" and ".m4a".
		* PROPERTY IGNORED WHEN serverType == Pyro.SERVER_TYPE_LATEST, SINCE IT MUST BE THERE ALL THE TIME.
		* @see #serverType
		* @see #streamNameHasExtension
		* @see #useDirectFilePath         
		*/
		public var forceMP4Extension							:Boolean 			= true;
		
		/**
		 * Toggles automatic kill when instance is removed from stage. 
		 * Added so that if set to false our pyro instance doesnt get deleted when removed from parent.
		 */		
		public var killOnRemoval								:Boolean			= true;
		
		/**
		* Toggles if video keeps proportions on each resize. Ratio is based on original sizes if encoded in video's metadata. 
		* If not, ratio is based on specified size (requiredWidth, requiredHeight) defined on instanciation. 
		* Defaults to true
		*  
		* @see #checkForSize
		* @see #resize 
		* @see #scaleMode
		* @see #width
		* @see #height
		*/
		public var maintainAspectRatio							:Boolean			= true;
		
		
		/**
		* Sets Pyro's local event listeners assignation weakeReference property. 
		* Defaults to true.
		* @see #cancelableEvents
		* @see #eventsPriority  
		**/
		public var useWeakReferences							:Boolean			= true;
		
		
		/**
		 * Toggles if RTMP streams are called with dot [.] and extension name ['flv', 'mp4' etc..] inside the url.
		 * Defaults to true.
		 * @see #forceMP4Extension
		 * @see #useDirectFilePath
		 * @see serverType
		*/		
		public var streamNameHasExtension						:Boolean			= true;		
		
		/**
		 * Toggles if application name prepends the fileName when streaming thru RTMP. 
		 * Defaults to true, and usually should not be changed.
		 * @see #streamNameHasExtension
		 * @see #forceMP4Extension
		*/	
		public var useDirectFilePath							:Boolean			= true;	
			
		// public var useVolumeCookie							:Boolean		= true;		
		
		
		 	
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		//
		
		protected var _audioDataRate							:Number 			= 64;
		protected var _bufferTime								:Number 			= 2;
		protected var _bufferEmptiedOccurences					:Number 			= 0;	
		protected var _bufferingMode							:String				= Pyro.BUFFERING_MODE_SINGLE_TRESHOLD;
		protected var _bufferEmptiedMaxOccurences				:Number 			= 2;				
		protected var _dualStartBufferTime						:Number 			= 1;
		protected var _dualStreamBufferTime						:Number				= 15;
		protected var _clientInfos								:ClientInfos		= new ClientInfos();
		protected var _connectionSpeed							:String;
		protected var _cookie									:SharedObject;
		protected var _cuePoints								:Array				= new Array();
		protected var _deblocking								:Number 
		protected var _duration									:Number				= 0;
		protected var _dualTresholdState						:String 			= Pyro.DUAL_TRESHOLD_STATE_START;
		protected var _fullscreenRectangle						:Rectangle;
		protected var _fullscreenMode							:String				= Pyro.FS_MODE_SOFTWARE;
		protected var _hasCloseCaptions							:Boolean			= false;
		protected var _highSpeedBufferTable						:BufferTimeTable	= new BufferTimeTable(1, 2, 10);
		protected var _metadata									:Object				= new Object();
		protected var _hAlignMode								:String 			= Pyro.ALIGN_HORIZONTAL_CENTER;
		protected var _lowSpeedBufferTable						:BufferTimeTable	= new BufferTimeTable(3, 3, 20);
		protected var _mediumSpeedBufferTable					:BufferTimeTable	= new BufferTimeTable(10, 10, 16);
		protected var _metadataCheckOver						:Boolean			= false;
		protected var _metadataReceived							:Boolean			= false;
		protected var _muted									:Boolean			= false;
		protected var _nConnection								:NetConnection;
		protected var _nConnectionClient						:NetConnectionClient;
		protected var _nStream									:NetStream;
		protected var _proxyType								:String 			= Pyro.PROXY_TYPE_BEST;
		protected var _requestedWidth							:Number				= 0;
		protected var _requestedHeight							:Number				= 0;
		protected var _ready									:Boolean 			= false;
		protected var _scaleMode								:String				= Pyro.SCALE_MODE_WIDTH_BASED;	
		protected var _serverType								:String 			= Pyro.SERVER_TYPE_UNDER_FMS_3_5;
		protected var _smoothing								:Boolean			= false;
		protected var _stageEventMechanics						:String				= Pyro.STAGE_EVENTS_MECHANICS_ALL_ON;
		protected var _src										:String				= "";
		protected var _status									:String				= Pyro.STATUS_INITIALIZING;
		protected var _streamType								:String				= Pyro.STREAM_TYPE_PROGRESSIVE;
		protected var _timeOffset								:Number				= 0;
		protected var _urlDetails								:URLDetails;
		protected var _vAlignMode								:String				= Pyro.ALIGN_VERTICAL_CENTER;
		protected var _video									:Video;
		protected var _videoDataRate							:Number				= 300;
		protected var _volume									:Number				= 1;
		protected var _XMPDataReceived							:Boolean			= false;
		protected var _XMPDataProxy								:XMPProxy;
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		protected var checkSizeTimer							:Timer;
		protected var checkSizeFrequency						:Number 			= 50;
		protected var connectionReady							:Boolean			= false;
						
		protected var defaultVideoWidth							:Number				= 340;
		protected var defaultVideoHeight						:Number				= 280;
		protected var delayedPlayTimer							:Timer				= new Timer(100, 0);
		protected var dying										:Boolean			= false;
		protected var firstRun									:Boolean 			= true;
		protected var flushed									:Boolean			= false;
		protected var fullscreenMemoryObject					:Object				= new Object();
		protected var initTimer									:Timer				= new Timer(10, 1);
		protected var metadataCheckTimer						:Timer;	
		protected var metadataCheckFrequency					:Number				= 12000;
		protected var delayedPlay								:Boolean			= false;						
		protected var hasCompleted								:Boolean			= false;
		protected var isPaused									:Boolean			= false; 
		protected var playerRectangle							:Rectangle;
		protected var startTime									:Number;
		protected var stopped									:Boolean			= false;
		protected var temporarySizesOn							:Boolean			= false;
		protected var videoPropsValid							:Boolean			= false;
		protected var videoRectangle							:Rectangle;
		protected var volumeCache								:Number 			= 1;
		protected var waitingForMetaData						:Boolean 			= false;
		
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 ---------------------------CONSTRUCT------------------------------------------------------------ >>
		*/
		
		/**
		 * 
		 * @param _width -->> Pyro instance canvas width.
		 * @param _height -->> Pyro instance canvas height. 
		 * 
		 * Calling a new Pyro Instance only requires _width and _height as arguments if your video is meant 
		 * to be boxed-in a restrained canvas. 
		 * 
		 * Leaving _width parameter empty or null automatically sets autoSize to true and automatically 
		 * sets _requested sizes to defaults sizes (_defVideoWidth, _defVideoHeight). 
		 * This means that pyro will wait for metadata dimension tag values for setting width and height, 
		 * and in the case of absent metadata dimension tags, will set width and height with internal defaul values (320x240). 
		 * 
		 * Requires another stageEvtMechanics value if your Pyro instance is meant to play outside of standard natural flash context. 
		 * Otherwise, 'allOn' is passed as default.   
		 * */					
		public function Pyro(_width:Number=undefined, _height:Number=undefined, stageEvtMechanics:String="allOn")
		{
			super();
			setStatus(Pyro.STATUS_INITIALIZING);
			if (isNaN(_width)) autoSize = true;
			_requestedWidth = !isNaN(_width) && _width > 0 ? _width : defaultVideoWidth;
			_requestedHeight = !isNaN(_height) && _height > 0 ? _height : defaultVideoHeight;
			
			playerRectangle = new Rectangle(0, 0, _requestedWidth, _requestedHeight);
			
			checkSizeTimer = new Timer(checkSizeFrequency, 0);
			metadataCheckTimer = new Timer(metadataCheckFrequency, 1);
			
			delayedPlayTimer.addEventListener(TimerEvent.TIMER, checkReadiness, captureEvents, eventsPriority, useWeakReferences);
			metadataCheckTimer.addEventListener(TimerEvent.TIMER_COMPLETE, metadataCheckDone, captureEvents, eventsPriority, useWeakReferences);
			
			checkSizeTimer.addEventListener(TimerEvent.TIMER, checkForSize, captureEvents, eventsPriority, useWeakReferences);
			
			stageEventMechanics = stageEvtMechanics;
			
			if (stageEventMechanics == Pyro.STAGE_EVENTS_MECHANICS_ALL_ON)
			{		
				addEventListener(Event.ADDED_TO_STAGE, addedToStage, captureEvents, eventsPriority, useWeakReferences);
				addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, captureEvents, eventsPriority, useWeakReferences);				
			}
			else
			{
				initialize();
			}
			
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									INITIALIZATION	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		
		protected function addedToStage(evt:Event):void
		{
			if (this.hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			startInitTimer();
		}
		
		protected function startInitTimer():void
		{
			if (initTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
				initTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, initTimerDone);
				
			initTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initTimerDone, captureEvents, eventsPriority, useWeakReferences);
			initTimer.start();
		}
		
		protected function initTimerDone(evt:TimerEvent):void
		{
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
				initialize();
			else
				startInitTimer();
		}
		
		protected function initialize():void
		{
			if (initTimer.running) initTimer.stop();
			
			if (initTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) initTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, initTimerDone);
			
			if (stageEventMechanics != Pyro.STAGE_EVENTS_MECHANICS_ALL_OFF) 
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullscreenHandler, captureEvents, eventsPriority, useWeakReferences);
			
			if (_video && contains(_video)) removeChild(_video);
			_video = new Video(_requestedWidth, _requestedHeight);	
			addChild(_video);
			
			if (autoSize) _video.visible = false;
			_ready = true;
			setStatus(Pyro.STATUS_READY);
		}
		
		
		protected function checkReadiness(evt:TimerEvent):void
		{
			if (_ready)
			{
				if (delayedPlayTimer.running)
					delayedPlayTimer.stop();
					
				if (delayedPlayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) delayedPlayTimer.removeEventListener(TimerEvent.TIMER, checkReadiness);
				play(_src);
			}	
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									DEATH and KILLING PROCESSES	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		protected function removedFromStage(evt:Event):void
		{
			if (killOnRemoval)
			{
				if (!dying)
					kill(); 
			}
		}
		
		public function kill():void
		{
			if (dying)
				return;
			
			dying = true;
			close();
			if (_video && contains(_video)) removeChild(_video);
			if (checkSizeTimer.running) checkSizeTimer.stop();
			if (metadataCheckTimer.running) metadataCheckTimer.stop();	
			if (delayedPlayTimer.running) delayedPlayTimer.stop();
			removeEventListeners();
			dying = false;
		}
		
		protected function removeEventListeners():void
		{
			if (stageEventMechanics != Pyro.STAGE_EVENTS_MECHANICS_ALL_OFF)
			{
				if (stage.hasEventListener(FullScreenEvent.FULL_SCREEN)) stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullscreenHandler); 
  				if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				if (hasEventListener(Event.REMOVED_FROM_STAGE)) removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			}	
				
			if (initTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) initTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, initTimerDone);
  			
  			if (hasEventListener(PyroEvent.SIZE_UPDATE)) removeEventListener(PyroEvent.SIZE_UPDATE, sizeChanged);
  			
			clearPipelineListeners(_nConnection);
			clearPipelineListeners(_nStream);
			
			if (delayedPlayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) delayedPlayTimer.removeEventListener(TimerEvent.TIMER, checkReadiness);
			if (metadataCheckTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) metadataCheckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, metadataCheckDone);
		}
		
		protected function clearPipelineListeners(pipeline:*):void
		{
			if (pipeline is NetConnection)
			{
				try
				{
					if (_nConnection.hasEventListener(NetStatusEvent.NET_STATUS)) _nConnection.removeEventListener(NetStatusEvent.NET_STATUS, onConnStatus);
					if (_nConnection.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) _nConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					if (_nConnection.hasEventListener(IOErrorEvent.IO_ERROR)) _nConnection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	  				if (_nConnection.hasEventListener(AsyncErrorEvent.ASYNC_ERROR)) _nConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				}
				catch(err:Error)
				{
					;
				}
			}	
			else if (pipeline is NetStream)
			{
				try
				{
					if (_nStream.hasEventListener(NetStatusEvent.NET_STATUS)) _nStream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
					if (_nStream.hasEventListener(IOErrorEvent.IO_ERROR)) _nStream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	  				if (_nStream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR)) _nStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);	
				}
				catch(err:Error)
				{
					;
				}
			}	
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									  WORKFLOW	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		/**  
		* @param fileURL
		* The play(url:String=null). Use the play() method to either connect to new streams by giving a URL(string) as argument, 
		* or to resume a paused stream by leaving out any arguments.
		*/		
		public function play(fileURL:String=null):void
		{
			if (!ready)
			{
				_src = fileURL;
				delayedPlayTimer.start();
				return;
			}
			
			resetInternalState();
			if (fileURL == null || fileURL == "")
			{
				if (connectionReady)
				{
					if (status == Pyro.STATUS_PAUSED || status == Pyro.STATUS_STOPPED)
					{
						setStatus(Pyro.STATUS_PLAYING);
						_nStream.togglePause();	
						dispatchEvent(new PyroEvent(PyroEvent.UNPAUSED, bubbleEvents, cancelableEvents));			
					}
				}
			}	
			else
			{	
				var localDetails:URLDetails = new URLDetails(fileURL, useDirectFilePath, forceMP4Extension, streamNameHasExtension, serverType);
					
				if (connectionReady)
				{
					if(urlDetails != null && localDetails.protocol != null)
					{
						if ((localDetails.streamName != urlDetails.streamName))
						{	
							setStatus(Pyro.STATUS_CONNECTING);
							_timeOffset = 0;
							connectionReady = false;
							reset(); 
							_src = fileURL;
							delayedPlay = true;
							this.initConnection(_src);
							return;
						}
					}
					
					_timeOffset = localDetails.startTime >=0 ? localDetails.startTime : 0;
					
					reset();
					_nStream.play(fileURL);
					if (!autoPlay && this.timeOffset == 0) 
					{
						if (metadataReceived)
						{
							seek(0);
							pause(); 
						}
						else
						{
							waitingForMetaData = true;
						}	
					}
				}	
				else
				{
					reset();
					setStatus(Pyro.STATUS_CONNECTING);
					_timeOffset = localDetails.startTime >=0 ? localDetails.startTime : 0;
					_src = fileURL;
					delayedPlay = true;
					this.initConnection(_src);
				}
			}			
		}
		
		protected function initConnection(urlString:String):void
		{
			this.setStatus(Pyro.STATUS_PENDING);
			
			close();
			_urlDetails = new URLDetails(urlString, useDirectFilePath, forceMP4Extension, streamNameHasExtension, serverType);
			this.dispatchEvent(new PyroEvent(PyroEvent.URL_PARSED, bubbleEvents, cancelableEvents));
			
			if (_nConnection)
			{
				_nConnection.close();
				_nConnection = null;
				clearPipelineListeners(_nConnection);
			}	
			
			_nConnection = new NetConnection();
			if (_urlDetails.isRTMP) 
			{
				_nConnection.proxyType = _proxyType;
				_nConnectionClient = new NetConnectionClient(this);
				_nConnection.client = _nConnectionClient;
			}
				
			_nConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnStatus, captureEvents, eventsPriority, useWeakReferences);
        	_nConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, captureEvents, eventsPriority, useWeakReferences);
        	_nConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, captureEvents, eventsPriority, useWeakReferences);
        	_nConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, captureEvents, eventsPriority, useWeakReferences);
        		
			switch (urlDetails.protocol)
			{
				case "http:/":
				case "https:/":
				case "httpd:/":
				case undefined:
				default:
				
				if (urlDetails.startTime >= 0)
					_streamType = Pyro.STREAM_TYPE_PROXIED_PROGRESSIVE; 
				else
					_streamType = Pyro.STREAM_TYPE_PROGRESSIVE;
				break;
				
				case "rtmp:/":
				case "rtmps:/":
				case "rtmpt:/":
				case "rtmpe:/":
				case "rtmpte:/":
				case "rtmfp:/":
				_streamType = Pyro.STREAM_TYPE_TRUE_STREAM;
				
				break;		
			}
			
			setupConnection();
			dispatchEvent(new PyroEvent(PyroEvent.NEW_STREAM_INIT, bubbleEvents, cancelableEvents));
		}
		 
		protected function setupConnection():void
		{
			switch(streamType)
			{
				case Pyro.STREAM_TYPE_PROGRESSIVE:
				_timeOffset = 0;
				_nConnection.connect(null); 
				break;
				
				case Pyro.STREAM_TYPE_PROXIED_PROGRESSIVE:
				_timeOffset = urlDetails.startTime;
				_nConnection.connect(null); 
				break;
				
				case Pyro.STREAM_TYPE_TRUE_STREAM:
				_timeOffset = 0;
				_nConnection.connect(urlDetails.nConnURL); 
				break;
				
			}
		}
		
		protected function onConnStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code) 
            {
            	case "NetConnection.Call.Prohibited":
            	case "NetConnection.Call.BadVersion":
            	case "NetConnection.Call.Failed":
            	case "NetConnection.Connect.AppShutdown":
            	case "NetConnection.Connect.Closed":
            	case "NetConnection.Connect.Failed":
            	case "NetConnection.Connect.Rejected":
            	case "NetConnection.Connect.InvalidApp":
            	dispatchEvent(new ErrorEvent(ErrorEvent.CONNECTION_ERROR, evt.info.code, bubbleEvents, cancelableEvents));
            	break;
            	
                case "NetConnection.Connect.Success":
                setupStream();
                break;
            }
		}
		
		protected function setupStream():void
		{

			clearNetStream();
				
			_nStream = new NetStream(_nConnection);
			_nStream.client = this;
			
			if (bufferingMode == Pyro.BUFFERING_MODE_SINGLE_TRESHOLD)
				_nStream.bufferTime = _bufferTime;
			else
				_nStream.bufferTime = _dualStartBufferTime;	
				
			_video.attachNetStream(_nStream);
			_video.smoothing = _smoothing;
			if (_deblocking) _video.deblocking = _deblocking;
			_nStream.soundTransform	= new SoundTransform(_volume, 0);
        	_nStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus, captureEvents, eventsPriority, useWeakReferences);
        	_nStream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, captureEvents, eventsPriority, useWeakReferences);
       	 	_nStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, captureEvents, eventsPriority, useWeakReferences);
       	 	connectionReady = true;
       	 	
       	 	if (delayedPlay) 
       	 	{
       	 		reset();
       	 		
       	 		switch (streamType)
       	 		{
       	 			case Pyro.STREAM_TYPE_PROGRESSIVE:
       	 			default:
       	 			play(urlDetails.rawURL);
       	 			adjustSize();
       	 			break;
       	 			
       	 			case Pyro.STREAM_TYPE_TRUE_STREAM:
       	 			play(urlDetails.streamName);
       	 			adjustSize(); 
       	 			break;
       	 		}
       	 		
       	 	}
       	 	
       	 	if (this.hasEventListener(PyroEvent.SIZE_UPDATE))
       	 		this.removeEventListener(PyroEvent.SIZE_UPDATE, sizeChanged);
       	 			
       	 	this.addEventListener(PyroEvent.SIZE_UPDATE, sizeChanged, captureEvents, eventsPriority, useWeakReferences);
		}
		
		protected function onStreamStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code) 
            {
	        	case "NetStream.Pause.Notify":
		        	if (_status != Pyro.STATUS_PAUSED) 
		        	{ 	
		        		dispatchEvent(new PyroEvent(PyroEvent.PAUSED, bubbleEvents, cancelableEvents));
		        		setStatus(Pyro.STATUS_PAUSED);	
			       	}
            	break;
            	
                case "NetStream.Buffer.Empty":
	                if (autoAdjustBufferTime)
	                {
	                	if (_bufferEmptiedOccurences >= bufferEmptiedMaxOccurences)
	                	{
	                		switch (connectionSpeed)
	                		{
	                			case Pyro.CONNECTION_SPEED_HIGH:
		                			_connectionSpeed = Pyro.CONNECTION_SPEED_MEDIUM;
		                			adjustBufferTimes(_mediumSpeedBufferTable);
		                			_bufferEmptiedOccurences = 0;
		                			this.dispatchEvent(new PyroEvent(PyroEvent.BUFFER_TIME_ADJUSTED, bubbleEvents, cancelableEvents));	
	                			break;
	                			
	                			case Pyro.CONNECTION_SPEED_MEDIUM:
		                			_connectionSpeed = Pyro.CONNECTION_SPEED_LOW;
		                			adjustBufferTimes(_lowSpeedBufferTable);
		                			_bufferEmptiedOccurences = 0;	
		                			this.dispatchEvent(new PyroEvent(PyroEvent.BUFFER_TIME_ADJUSTED, bubbleEvents, cancelableEvents));
	                			break;
	                			
	                			case Pyro.CONNECTION_SPEED_LOW:
		                			_bufferEmptiedOccurences = 0;
		                			_lowSpeedBufferTable.singleTresholdBufferTime += _lowSpeedBufferTable.singleTresholdBufferTime*.1;
		                			_lowSpeedBufferTable.dualTresholdStartBufferTime += _lowSpeedBufferTable.dualTresholdStartBufferTime*.1;
		                			this.dispatchEvent(new PyroEvent(PyroEvent.INSUFFICIENT_BANDWIDTH, bubbleEvents, cancelableEvents));	
	                			break;
	                		}
	                	}
	                	else
	                	{
	                		_bufferEmptiedOccurences++;
	                	}
	                	
	                	
	         	  	}
	                
	                if (this.bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD)
	                	this._nStream.bufferTime = this._dualStartBufferTime;
	                	    	
					dispatchEvent(new PyroEvent(PyroEvent.BUFFER_EMPTY, bubbleEvents, cancelableEvents));
               	break;
                
                case "NetStream.Buffer.Full":
               	if (firstRun)
           		{
           			if (autoPlay)
           			{
           				this.setStatus(Pyro.STATUS_PLAYING);
           				firstRun = false;
           			}	
           		}
               	
               	dispatchEvent(new PyroEvent(PyroEvent.BUFFER_FULL, bubbleEvents, cancelableEvents));
               
               	var currentBufferTable:BufferTimeTable;
               	if (checkBandwidth && !bandwidthCheckDone) 
               	{	
               		
               		var userBandwidth:Number;
	               	var connTime:Number = getTimer() - startTime;
	             	userBandwidth = (bufferLength * (streamDataRate) / (connTime/1000));
	             		
               		/* var connTime:Number = getTimer() - startTime;
               		var userBandwidth:Number = ((1000 * _nStream.bytesLoaded) / connTime) / 1024;
               	
               		var buffer:Number = getBandwidth(_duration, streamDataRate, userBandwidth); */
               	
               		
               		if (userBandwidth <= 60)
					{
						_connectionSpeed = Pyro.CONNECTION_SPEED_LOW;
						currentBufferTable = _lowSpeedBufferTable;
						bufferEmptiedMaxOccurences = 3;
					} 
					else
					{
						if (userBandwidth > 60 && userBandwidth <= 120)
						{
							bufferEmptiedMaxOccurences = 2;
							currentBufferTable = _mediumSpeedBufferTable;
							_connectionSpeed = Pyro.CONNECTION_SPEED_MEDIUM;	
						}
						else if (userBandwidth > 120)
						{
							bufferEmptiedMaxOccurences = 1;
							currentBufferTable = _highSpeedBufferTable;
							_connectionSpeed = Pyro.CONNECTION_SPEED_HIGH;
						}
					}
					
					if (autoAdjustBufferTime)
						adjustBufferTimes(currentBufferTable);
					
					
               		dispatchEvent(new PyroEvent(PyroEvent.BANDWIDTH_CHECKED, bubbleEvents, cancelableEvents));
               		bandwidthCheckDone = true;
               	}
               	
               	if (this.bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD)
               		 _nStream.bufferTime = _dualStartBufferTime;
               		    
               	break;
                
                case "NetStream.Buffer.Flush":
                flushed = true;
				dispatchEvent(new PyroEvent(PyroEvent.BUFFER_FLUSH, bubbleEvents, cancelableEvents));
				break;
				
                case "NetStream.Play.Complete":
                
                if (status != Pyro.STATUS_COMPLETED)
                {
	                dispatchEvent(new PyroEvent(PyroEvent.COMPLETED, bubbleEvents, cancelableEvents));
	                _status = Pyro.STATUS_COMPLETED;
                }
               	break;
                
                case "NetStream.Play.Reset":
                break;
                
                case "NetStream.Play.Start":
             
               	if(autoPlay) 
               	{ 
               		setStatus(Pyro.STATUS_PLAYING); 
               	}
               
                startTime = getTimer();
                adjustSize();
                
                dispatchEvent(new PyroEvent(PyroEvent.STARTED, bubbleEvents, cancelableEvents));
                break;
                
                case "NetStream.Play.Stop":
                stopped = true;
                adjustSize();
                dispatchEvent(new PyroEvent(PyroEvent.STOPPED, bubbleEvents, cancelableEvents));
                break;
                              
                case "NetStream.Seek.Notify":
                if (status != Pyro.STATUS_STOPPED) { dispatchEvent(new PyroEvent(PyroEvent.SEEKED, bubbleEvents, cancelableEvents)); }
                break;

               	case "NetStream.Play.StreamNotFound":
               	setStatus(Pyro.STATUS_STOPPED);
               	dispatchEvent(new ErrorEvent(ErrorEvent.FILE_NOT_FOUND_ERROR, evt.info.code, bubbleEvents, cancelableEvents));
               	break;
               	
               	case "NetStream.Unpause.Notify":
                dispatchEvent(new PyroEvent(PyroEvent.UNPAUSED, bubbleEvents, cancelableEvents));
                break;
               	
               	case "NetStream.Play.NoSupportedTrackFound":
               	case "NetStream.Seek.Failed":
               	case "NetStream.Failed":
               	case "NetStream.Play.Failed":
               	case "NetStream.Play.FileStructureInvalid":
				case "NetStream.Play.InsufficientBW":
               	case "NetStream.Publish.BadName":
               	case "NetStream.Record.Failed":
               	dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, evt.info.code, bubbleEvents, cancelableEvents));
				break;	
					
				case "NetStream.Play.Switch":
               	break;
                	
               	case "NetStream.Publish.Idle":
                case "NetStream.Publish.Start":
                case "NetStream.Unpublish.Success":
                case "NetStream.Play.UnpublishNotify":
                case "NetStream.Play.UnpublishNotify":
               	case "NetStream.Record.Start":
               	case "NetStream.Record.NoAccess":
                case "NetStream.Record.Stop":
				break;
            }
            
            if(flushed && stopped)
            {
        		resetInternalState();
        		dispatchEvent(new PyroEvent(PyroEvent.COMPLETED, bubbleEvents, cancelableEvents));
            }
		}
		
		protected function adjustBufferTimes(timeTable:BufferTimeTable):void
		{
			this.bufferTime = timeTable.singleTresholdBufferTime;
			this.dualStartBufferTime = timeTable.dualTresholdStartBufferTime;
			this.dualStreamBufferTime = timeTable.dualTresholdStreamBufferTime;
		}
		/*
		 * 	NetStream, NetConnection, connection and NetStream.client related methods.  
		*/
		
		protected function asyncErrorHandler(evt:AsyncErrorEvent):void 
		{
			reset(); 
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, "ASYNC_ERROR", bubbleEvents, cancelableEvents)); 
		}
		
		protected function ioErrorHandler(evt:IOErrorEvent):void 
		{ 
			reset();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, "IO_ERROR", bubbleEvents, cancelableEvents)); 
		}
		
		/**
		 * 
		 *
		 * DO NOT CALL onCuePoint, IT IS KEPT PUBLIC TO PREVENT ERROR DISPATCHING BY THE NETSTREAM. 
		 * WILL BE DEPRECATED IN FUTURE RELEASES. WILL BE IMPLEMENTED THRU A NETSTREAM CLIENT HELPER CLASS, MUCH LIKE THE NEW PYRO'S
		 * BUILT IN NETCONNECTION CLIENT.
		 * The onCuePoint method is called internally when the netStream comes accross buil-in metadata cuePoints.
		 * Acts as an EventProxy and broadcasts a CuePointEvent. 
		 */		
		public function onCuePoint(infoObject:Object):void
		{
			dispatchEvent(new CuePointEvent(CuePointEvent.CUE_POINT_RECEIVED, infoObject, bubbleEvents, cancelableEvents));
		}
		
		/**
		 * 
		 * DO NOT CALL onMetaData, IT IS KEPT PUBLIC TO PREVENT ERROR DISPATCHING BY THE NETSTREAM. 
		 * WILL BE DEPRECATED IN FUTURE RELEASES. WILL BE IMPLEMENTED THRU A NETSTREAM CLIENT HELPER CLASS, MUCH LIKE THE NEW PYRO'S
		 * BUILT IN NETCONNECTION CLIENT.
		 * The onMetaData method is called internally when the netStream first comes accross buil-in metadata required tags..
		 * Acts as an EventProxy and broadcasts a PyroEvent.METADATA_RECEIVED event.
		 * @see #metadata
		 */		
		public function onMetaData(info:Object, ...rest):void
		{
			if (waitingForMetaData)
			{
				waitingForMetaData = false;
				seek(0)
				pause();	
			}
			
			if (!autoPlay && !_metadataReceived)
				seek(0);
				
			_metadataReceived = true;
			_metadata = info;	
			if (rest) { _metadata['rest'] = rest; }
			if (info['duration']) { _duration = Number(info['duration']); }
			if (info['cuePoints']) { _cuePoints = info['cuePoints']; } 
			if (info['audiodatarate']) { _audioDataRate = Number(info['audiodatarate']); }
			if (info['videodatarate']) { _videoDataRate = Number(info['videodatarate']); }
			
			dispatchEvent(new PyroEvent(PyroEvent.METADATA_RECEIVED, bubbleEvents, cancelableEvents));
		}
		
		/**
		 * 
		 * @param textData
		 * DO NOT CALL onTextData, IT IS KEPT PUBLIC TO PREVENT ERROR DISPATCHING BY THE NETSTREAM. 
		 * WILL BE DEPRECATED IN FUTURE RELEASES. WILL BE IMPLEMENTED THRU A NETSTREAM CLIENT HELPER CLASS, MUCH LIKE THE NEW PYRO'S
		 * BUILT IN NETCONNECTION CLIENT.
		 * The onTextData method is called internally when the netStream comes accross built in textData, usually used for close-captionning.
		 * Acts as an EventProxy and broadcasts a TextDataEvent event.  
		 */			
		public function onTextData(textData:Object):void 
		{
			dispatchEvent(new TextDataEvent(TextDataEvent.TEXT_DATA_RECEIVED, textData, bubbleEvents, cancelableEvents));
		}
		
		
		public function onXMPData(infoObject:Object):void 
        { 
        	this._XMPDataProxy = new XMPProxy(infoObject);
        	_XMPDataReceived = true;
			dispatchEvent(new PyroEvent(PyroEvent.XMP_DATA_RECEIVED, bubbleEvents, cancelableEvents));
        }
		
		public function onImageData(imageData:Object):void
		{
			dispatchEvent(new ImageDataEvent(ImageDataEvent.IMAGE_DATA_RECEIVED, imageData, bubbleEvents, cancelableEvents));
		}
		
		
		/**
		 * 
		 * DO NOT CALL onTransition, IT IS KEPT PUBLIC TO PREVENT ERROR DISPATCHING BY THE NETSTREAM. 
		 * WILL BE DEPRECATED IN FUTURE RELEASES. WILL BE IMPLEMENTED THRU A NETSTREAM CLIENT HELPER CLASS, MUCH LIKE THE NEW PYRO'S
		 * BUILT IN NETCONNECTION CLIENT.
		 */			
		public function onTransition(args:*, ...rest):void { }
		
		protected function securityErrorHandler(evt:SecurityErrorEvent):void { dispatchEvent(new ErrorEvent(ErrorEvent.SECURITY_ERROR, "SECURITY_ERROR", bubbleEvents, cancelableEvents)); }
		
		protected function clearNetStream():void
		{
			if (_nStream)
			{
				_nStream.soundTransform	= null;
				clearPipelineListeners(_nStream);
				_nStream.close();
				_nStream = null;
			}
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									metadata CHECK	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		protected function metadataCheckDone(evt:TimerEvent):void { _metadataCheckOver = true; }
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									SIZE HANDLING	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		protected function adjustSize():void
		{	
			if (autoSize || (!autoSize && maintainAspectRatio))
			{
				if (!metadataReceived)
       	 		{
       	 			_video.visible = false;
       	 			if (!checkSizeTimer.running) 
       	 			{
       	 				if (this._src != null && this._src != "")
       	 				{
       	 					checkSizeTimer.start();
       	 					metadataCheckTimer.start();
       	 				}
       	 			}
       	 		}	
       	 		else
				{
					videoPropsValid = true;
					forceResize(metadata['width'], metadata['height'], maintainAspectRatio, scaleMode);		
				}
			}
			else
			{
				forceResize(_requestedWidth, _requestedHeight, maintainAspectRatio, scaleMode);
			}
		
		}
		
		/**
		 * 
		 * Call the align method whenever you need the video to be aligned. 
		 * Pyro's video alignment works along with the hAlignMode and vAlignMode properties.
		 *  
		 * Used internally by the player, but granting access to this method allows realignments if 
		 * alignModes property values are updated at runtime.   
		 * 
		 * @see #hAlignMode
		 * @see #vAlignMode
		 * @see #ALIGN_HORIZONTAL_CENTER
		 * @see #ALIGN_HORIZONTAL_RIGHT
		 * @see #ALIGN_HORIZONTAL_RIGHT
		 * @see #ALIGN_VERTICAL_CENTER
		 * @see #ALIGN_VERTICAL_BOTTOM
		 * @see #ALIGN_VERTICAL_TOP
		 * 
		 */		
		public function align(e:*=null):void
		{
			if (videoWidth <= _requestedWidth)
			{
				
				switch (hAlignMode)
				{
					case Pyro.ALIGN_HORIZONTAL_CENTER:
					default:
					_video.x = ((_requestedWidth/2) - (video.width/2));
					
					break;
					
					case Pyro.ALIGN_HORIZONTAL_RIGHT:
					_video.x = (_requestedWidth - video.width);
					break;
					
					case Pyro.ALIGN_HORIZONTAL_LEFT:
					_video.x = 0;
					break;	
				}
			}
			
			if (videoHeight <= _requestedHeight)
			{
				switch (vAlignMode)
				{
					case Pyro.ALIGN_VERTICAL_CENTER:
					default:
					_video.y = ((_requestedHeight/2)-(video.height/2));
					break;
					
					case Pyro.ALIGN_VERTICAL_BOTTOM:
					_video.y = (_requestedHeight - video.height);
					break;
					
					case Pyro.ALIGN_VERTICAL_TOP:
					_video.y = 0;
					break;
					
				}
			}
		}
	
		protected function checkForSize(evt:TimerEvent):void
		{
			if (metadataReceived)
			{
				if (metadata['width'] && metadata['height'])
				{
					forceResize(Number(metadata['width']), Number(metadata['height']), maintainAspectRatio, scaleMode);
					checkSizeTimer.stop();
					metadataCheckTimer.stop();
					_metadataCheckOver = false;
				}
				else
				{		
					temporarySizesOn = true;
					forceResize(_requestedWidth, _requestedHeight, maintainAspectRatio, scaleMode);
					metadataCheckTimer.stop();
					_metadataCheckOver = false;
				}					 
			}
			else
			{
				if (metadataCheckOver)
				{
					forceResize(_requestedWidth, _requestedHeight, maintainAspectRatio, scaleMode);
					checkSizeTimer.stop();
					metadataCheckTimer.stop();
					_metadataCheckOver = false;
					play();
				}
			}	
		} 
		
		protected function forceResize(w:Number, h:Number, aspectRatio:Boolean, sMode:String):void
		{
			
			var localWidth:Number = w;
			var localHeight:Number = h;
			var scaleFactor:Number;
			
			var tWidth:Number;
			var tHeight:Number;
			
			if (checkSizeTimer.running) 
				checkSizeTimer.stop();
		
			if (metadataCheckOver)
			{
				if(metadataCheckTimer.running)
					metadataCheckTimer.stop();
			}
				
		
			if (autoSize && !temporarySizesOn || (!autoSize && aspectRatio) || (!autoSize && sMode==Pyro.SCALE_MODE_NO_SCALE))
			{
				if (_metadata['width'])   
				{	
					localWidth = Number(_metadata['width']);
					localHeight = Number(_metadata['height']);
				}
			}				
			
			if (autoSize || sMode == Pyro.SCALE_MODE_NO_SCALE)
			{
				if (metadataReceived)
				{
					_video.width = localWidth;
					_video.height = localHeight;
					dispatchEvent(new PyroEvent(PyroEvent.SIZE_UPDATE, this.bubbleEvents, this.cancelableEvents));
					if (autoAlign) { align(); }
					_video.visible = true;
					// return;
				}
			}	
				
			switch (sMode)
			{
				case Pyro.SCALE_MODE_WIDTH_BASED:
				default:
				if (aspectRatio)
				{
					if (metadataReceived)
					{	
						tWidth = _requestedWidth;
						tHeight = (localHeight * tWidth / localWidth);
						
						if (tHeight > _requestedHeight)
						{
							tHeight = _requestedHeight;
							tWidth = (localWidth * tHeight / localHeight);
						}
						_video.width = tWidth;
						_video.height = tHeight;
					}		
				}
				else
				{
					_video.width = _requestedWidth;
					_video.height = _requestedHeight;
				}
				break;
				
				
						
				case Pyro.SCALE_MODE_HEIGHT_BASED:
				if (aspectRatio)
				{
					if (metadataReceived)
					{	
						tHeight = _requestedHeight;
						tWidth = (localWidth * tHeight / localHeight);
						
						if (tWidth > _requestedWidth)
						{
							tWidth = _requestedWidth;
							tHeight = (localHeight * tWidth / localWidth);
						}
						_video.width = tWidth;
						_video.height = tHeight;
					}
				}	
				else
				{
					_video.width = _requestedWidth;
					_video.height = _requestedHeight;
				}		
				break;
				
				case Pyro.SCALE_MODE_NO_SCALE:
				break;
			}
			
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_UPDATE, bubbleEvents, cancelableEvents));
			if (autoAlign) { align(); }
			_video.visible = true;
		}
		
		/**
		 * Resizes pyro instance properly. Using this method is considered best practice to optimize resizing execution. 
		 * Use desired width and height as arguments.
		 * Width and height properties are still available and simply repoints to the resize method. 
		 * Ensures the video gets resized and realigned properly, depending on sizing and alignments settings used.       
		 * @param w
		 * @param h
		 * 
		 * @see #width
		 * @see #height
		 * @see #hAlignMode
		 * @see #vAlignMode
		 * @see #scaleMode
		 * @see #align
		 */		
		public function resize(w:Number=undefined, h:Number=undefined):void 
		{
			if (!ready)
			{
				this._requestedWidth = w;
				this._requestedHeight = h;	
				return;
			}
			
			if ( (w == _video.width && h == _video.height)) 
			{
				return;
			}
			else
			{
				var dWidth:Number = _requestedWidth ? _requestedWidth : defaultVideoWidth;  
				_requestedWidth = !isNaN(w) && w > 0 ? w : dWidth;
				
				var forcedHeight:Number;
				
				if (isNaN(h))
				{
					if (Number(_metadata['width']))
					{ 
						_requestedHeight = Number(_metadata['height']);
					}
					else
					{
						var dHeight:Number = _requestedHeight ? _requestedHeight : defaultVideoHeight;
						_requestedHeight = dHeight;
					}	
				}
				else
				{
					_requestedHeight = h;
				}	
				
				adjustSize();	
			} 
		}
		
		/**
		 * 
		 * DO NOT CALL THIS METHOD. 
		 * STRICTLY FOR INTERNAL USE. 
		 * KEPT PUBLIC TO PREVENT ERROR DISPATCHING. 
		 * 
		 */		
		public function fullscreenHandler(evt:*=null):void
		{
			try 
			{
				if (stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					if (fullscreenMode == Pyro.FS_MODE_HARDWARE)
					{
						// smoothing = fullscreenMemoryObject.smoothing;
						// deblocking = fullscreenMemoryObject.deblocking;
						// _video.width = fullscreenMemoryObject.width;
						// _video.height = fullscreenMemoryObject.height;
					}
				}
			}
			catch(err:Error)
			{
				
			}	
		}
		
		/**
		 * 
		 * DO NOT CALL THIS METHOD. 
		 * STRICTLY FOR INTERNAL USE. 
		 * KEPT PUBLIC TO PREVENT ERROR DISPATCHING. 
		 */		
		public function sizeChanged(evt:PyroEvent):void
		{
			videoRectangle = new Rectangle(this.x+this._video.x, this.y+this._video.y, this._video.width, this._video.height);
			playerRectangle = new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									  PUBLIC CONTROLS
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		/**
		 * 
		 * The close method kills all netStreamm netConenction and video actions, statuses and listeners. 
		 * Call this method only if stageMechanics are not set to Pyro.STAGE_EVENTS_MECHANICS_ALL_ON and 
		 * your Pyro instance gets removed from its nesting childList.
		 * Sets pyro's status to Pyro.STATUS_CLOSED and dispatches the appropirate StatusUpdateEvent.
		 * @see #stop
		 */			
		public function close():void
		{
			try
			{
				_nStream.pause();
				_nStream.seek(0);	
				_video.clear();
				_nStream.close();
				setStatus(Pyro.STATUS_CLOSED);
				this.clearPipelineListeners(_nConnection);
				this.clearPipelineListeners(_nStream);
				this.removeChild(_video)
				clearNetStream();
				this.addChild(_video);
			} 
			catch(e:Error) 
			{
				;
			}
		}
		
		/**
		 * Use this method to mute your Pyro instance's volume. 
		 * Caches the volume level prior to muting.
		 * @see #unmute
		 * @see #toggleMute
		 * @see #volume
		*/		
		public function mute():void 
		{ 
			_muted = true;
			volumeCache = volume;
			volume = 0; 
			this.dispatchEvent(new PyroEvent(PyroEvent.MUTED, bubbleEvents, cancelableEvents));
		}
		
		/**
		* Use this method to unmute your Pyro instance's volume to the level it was prior to muting. 
		* @see #mute
		* @see #toggleMute
		* @see #volume
		*/		
		public function unmute():void
		{
			if (_muted)
			{
				_muted = false;
				volume = volumeCache;
				this.dispatchEvent(new PyroEvent(PyroEvent.UNMUTED, bubbleEvents, cancelableEvents));
			}	
			
		}
		
		/**
		 * Pauses the stream,
		 * sets the status to Pyro.PAUSED_STATUS and dispatches a StatusUpdateEvent.
		 * Also dispatches a PyroEvent.PAUSED event.
		 * @see #play
		 * @see #togglePause
		 * 
		 */	
		public function pause():void 
		{ 
			try
			{
				setStatus(Pyro.STATUS_PAUSED);
				_nStream.pause(); 
				dispatchEvent(new PyroEvent(PyroEvent.PAUSED, bubbleEvents, cancelableEvents));
			}
			catch(err:Error)
			{
				
			}
		}	
		
		/**
		 * @param offset
		 * The seek method sets the playhead to desired time if possible. 
		 * Be aware that files served as regular progressive downloads can not be seeked beyond their buffered zone. 
		 * If successfull, a PyroEvent.SEEKED event is dispatched thru the netStream netStatus event handler.
		 */		
		public function seek(offset:Number):void 
		{ 
			_nStream.seek(offset); 
			
		}
		
		/**
		 * This method acts as regular VCR - DVR stop action. 
		 * Pauses the stream and seeks back to 0. 
		 * Sets the status to Pyro.STATUS_STOPPED and dispatches the appropriate StatusUpdateEvent.
		 * 
		 * 
		*/	
		public function stop():void 
		{
			setStatus(Pyro.STATUS_STOPPED);
			_nStream.pause();
			_nStream.seek(0);
		}
		
		/**
		* Toggles volume muting.   
		* If volume is muted, it gets unmuted.
		* If volume is not muted it gets muted. 
		* @see #volume
		* @see #mute
		* @see #unmute
		*
		*/
		public function toggleMute():void
		{
			_muted ? unmute() : mute();
		}
		
		/**
		 * Toggles stream pausing and resuming by calling internally the current netStream togglePause method.
		 * If stream is paused, it is resumed. 
		 * If stream is playing, it is paused.
		*/
		public function togglePause():void 
		{ 
			switch (_status)
			{
				case Pyro.STATUS_PAUSED:
				setStatus(Pyro.STATUS_PLAYING);
				dispatchEvent(new PyroEvent(PyroEvent.UNPAUSED, bubbleEvents, cancelableEvents));
				_nStream.togglePause();	
				break;
				
				case Pyro.STATUS_PLAYING:
				setStatus(Pyro.STATUS_PAUSED);
				dispatchEvent(new PyroEvent(PyroEvent.PAUSED, bubbleEvents, cancelableEvents));
				_nStream.togglePause();	
				break;		
			}
		}
		
		/**
		 * Toggles flash player state in between fullscreen and normal size. 
		 * toggleFullScreen does not resize the video nor any ui asset dynamically in FS_MODE_SOFTWARE mode.
		 * Using the Pyro.FS_MODE_HARDWARE is disabled for the moment, as we are working on a solid concept to prevent 
		 * Error dispatching. Will be fixed soon.
		 * @see #fullscreenMode
		 * @see #FS_MODE_HARDWARE
		 * @see #FS_MODE_SOFTWARE
		 * 
		*/
		public function toggleFullScreen(e:*=null):void
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				if (fullscreenMode == Pyro.FS_MODE_HARDWARE)
				{
					// fullscreenMemoryObject = {smoothing:_video.smoothing, deblocking:_video.deblocking, height:_video.height, width:_video.width};
					smoothing = false;
					deblocking = 0;
					// stage.fullScreenSourceRect = fullscreenRectangle;		
				}		
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}	
		}
		
		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									  PUBLIC ACCESSORS
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		/**
		 *
		 * @return 
		 * The audioDataRate in current netStream. 
		 * Defaults to 64 to prevent internal errors. 
		 * @see #videoDataRate
		 * */		
		public function get audioDataRate():Number { return this._audioDataRate; }
		
		
		/**
		 * 
		 * @return 
		 * The current netStream's bufferLength. 
		 */		
		public function get bufferLength():Number { return _nStream.bufferLength; }
		
		
		/**
		 * 
		 * @param bt
		 * Sets pyro's internal netStream's bufferTime. 
		 * Is significant only if bufferingMode == Pyro.BUFFERING_MODE_SINGLE_TRESHOLD 
		 * @see #bufferingMode 
		 * @see #BUFFERING_MODE_SINGLE_TRESHOLD
		 * @see #BUFFERING_MODE_DUAL_TRESHOLD
		 */		
		public function set bufferTime(bt:Number):void 
		{ 
			_bufferTime = bt;
			if (_nStream != null && bufferingMode == Pyro.BUFFERING_MODE_SINGLE_TRESHOLD)
				_nStream.bufferTime = bt; 
		}
		/**
		 * 
		 * @return 
		 * Pyro's Pyro.BUFFERING_MODE_SINGLE_TRESHOLD's bufferTime.
		 */		
		public function get bufferTime():Number { return _bufferTime; }
		
		
		/**
		 * 
		 * @return 
		 * The internal bufferingMode, either Pyro.BUFFERING_MODE_DUAL_TRESHOLD or Pyro.BUFFERING_MODE_SINGLE_TRESHOLD.
		 * @see #BUFFERING_MODE_SINGLE_TRESHOLD
		 * @see #BUFFERING_MODE_DUAL_TRESHOLD
		 * @see #bufferEmptiedMaxOccurences
		 */		
		public function get bufferingMode():String { return _bufferingMode; }
		/**
		 * 
		 * @param bm
		 * The internal bufferingMode currently in use.
		 * Defaults to Pyro.BUFFERING_MODE_DUAL_TRESHOLD
		 */		
		public function set bufferingMode(bm:String):void
		{
			switch(bm)
			{
				case Pyro.BUFFERING_MODE_DUAL_TRESHOLD:
				case Pyro.BUFFERING_MODE_SINGLE_TRESHOLD:
				_bufferingMode = bm;
				break;
			
				default:
				_bufferingMode = Pyro.BUFFERING_MODE_DUAL_TRESHOLD;
				break;
			}
		}
		
		/**
		 * 
		 * @return 
		 * The maximum of buffer emtpty netStream events received by Pyro before attempting to switch to a lower BufferTimeTable, 
		 * If the lowest table is already reached, a PyroEvent.INSUFFICIENT_BANDWIDTH is broadcasted. 
		 * Only used when bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD
		 * @see #bufferingMode
		 * @see #BUFFERING_MODE_SINGLE_TRESHOLD
		 * @see #BUFFERING_MODE_DUAL_TRESHOLD 
		 * 
		 */		
		public function get bufferEmptiedMaxOccurences():Number { return this._bufferEmptiedMaxOccurences; }
		/**
		 * 
		 * @param occurenceCount
		 * Sets the maximum occurences for the current Pyro instance.
		 */		
		public function set bufferEmptiedMaxOccurences(occurenceCount:Number):void 
		{
			if (occurenceCount < 0)
			{
				_bufferEmptiedMaxOccurences = 1;
			}
			else if (occurenceCount > 10)
			{
				_bufferEmptiedMaxOccurences = 10;
			}
			else
			{
				_bufferEmptiedMaxOccurences = occurenceCount;
			}		
		}
		
		
		/**
		 * 
		 * @return 
		 * The amount of bytes loaded in of the currentStream. 
		 * @see #bytesTotal
		 * @see #loadRatio
		 */		
		public function get bytesLoaded():Number 
		{ 
			if (_nStream != null)
			{
				if (_nStream.bytesLoaded)
					return _nStream.bytesLoaded;
				else
					return 0;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 
		 * @return 
		 * The current stream total amount of bytes. 
		 * @see #bytesLoaded
		 * @see #loadRatio
		 */	
		public function get bytesTotal():Number
		{
			if (_nStream != null)
			{
				if (_nStream.bytesTotal)
					return _nStream.bytesTotal;
				else
					return 0;
			}
			else
			{
				return 0;
			}
		}
		
		
		/**
		 * 
		 * @return 
		 * IN DEVELOPMENT
		 * An instance of the internal helper class ClientInfos. This mainly holds System.capabilities properties. 
		 * 
		 */		
		public function get clientInfos():ClientInfos { return _clientInfos; }
		
		
		/**
		 * 
		 * @return 
		 * The current connection speed pyro has tried to detect. 
		 * @see #CONNECTION_SPEED_LOW
		 * @see #CONNECTION_SPEED_MEDIUM
		 * @see #CONNECTION_SPEED_HIGH 
		 */		
		public function get connectionSpeed():String { return _connectionSpeed; }
		
		/**
		 * 
		 * @return 
		 * The raw cuePoints Array loaded in thru the NetStream's metadata. Empty if no cue points are present in metadata. 
		 */		
		public function get cuePoints():Array { return _cuePoints; }
		
		
		/**
		 * 
		 * @return 
		 * IN DEVELOPMENT
		 * The Rectangle class instance used if fullscreeMode == Pyro.FS_MODE_HARDWARE.
		 * @see #fullscreenMode
		 * @see #FS_MODE_HARDWARE
		 * @see #FS_MODE_SOFTWARE 
		 */		
		public function get currentStageRect():Rectangle { return new Rectangle(this.x, this.y, this.height, this.width); }
		
		/**
		 * 
		 * @param deb
		 * Sets video deblocking with value. Use property values specified by Adobe.
		 */		
		public function set deblocking(deb:int):void 
		{ 
			_deblocking = deb;
			
			if (ready)
				_video.deblocking = deb;
		}
		/**
		 * 
		 * @return 
		 * The video deblocking value currently in use.
		 */		
		public function get deblocking():int { return _video.deblocking; }
		
		/**
		 * 
		 * @param bt
		 * Sets dualStartBufferTime when bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD. 
		 * The dualStartBufferTime is set as bufferTimer whenever a stream is started and every time the buffer is emptied.
		 * Gets overriden by the dualStreamBufferTime value when buffer is filled. 
		 * Also gets overriden whenever a BufferTimeTable switch occurs.
		 * @see #bufferingMode
		 * @see #bufferTime
 		 * @see #dualStreamBufferTime
		 * @see #dualTresholdState
		 * @see #BUFFERING_MODE_DUAL_TRESHOLD 
		 * @see #BUFFERING_MODE_SINGLE_TRESHOLD
		 * 
		 */		
		public function set dualStartBufferTime(bt:Number):void
		{
			this._dualStartBufferTime = bt;
			if (_nStream != null && bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD)
			{
				if (_dualTresholdState == Pyro.DUAL_TRESHOLD_STATE_START)
					_nStream.bufferTime = bt;
			}
		}
		/**
		 * 
		 * @return 
		 * The current dualStartBufferTime.
		 */		
		public function get dualStartBufferTime():Number { return _dualStartBufferTime; }
		
		/**
		 * 
		 * @param bt
		 * Sets dualStreamBufferTime when bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD. 
		 * The dualStreamBufferTime is set as bufferTimer whenever the buffer is full.
		 * Gets overriden by the dualStartBufferTime value when buffer is emptied or stream is resetted. 
		 * Also gets overriden whenever a BufferTimeTable switch occurs.
		 * @see #bufferingMode
		 * @see #bufferTime
		 * @see #dualTresholdState
 		 * @see #dualStartBufferTime
		 * @see #BUFFERING_MODE_DUAL_TRESHOLD 
		 * @see #BUFFERING_MODE_SINGLE_TRESHOLD
		 */		
		public function set dualStreamBufferTime(bt:Number):void
		{
			_dualStreamBufferTime = bt;
			if (_nStream != null && bufferingMode == Pyro.BUFFERING_MODE_DUAL_TRESHOLD)
			{
				if (_dualTresholdState == Pyro.DUAL_TRESHOLD_STATE_STREAMING)
					_nStream.bufferTime = bt;
			}
		}
		/**
		 * @return 
		 * The current dualStreamBufferTime
		 */		
		public function get dualStreamBufferTime():Number { return _dualStartBufferTime; }
		
		/**
		 * 
		 * @return 
		 * The dualTresholdState can hold two possible values and is pertinent only 
		 * if bufferingMode == Pyro,BUFFERING_MODE_DUAL_TRESHOLD
		 * Indicates what bufferTime value is used form the current BufferTimeTable. 
		 * Either Pyro.DUAL_TRESHOLD_STATE_STREAMING orPyro.DUAL_TRESHOLD_STATE_START. 
		 */		
		public function get dualTresholdState():String { return _dualTresholdState; }
		
		/**
		 * 
		 * @return 
		 * The current stream duration in seconds. 
		 * @see #formattedDuration
		 * @see #time
		 * @see #timeRemaining
		 * @see #formattedTime
		 * @see #formattedTimeRemaining
		 */		
		public function get duration():Number { return _duration; }
		
		/**
		 * 
		 * @return 
		 * The current stream duration formatted in HH:MM:SS format.
		 * @see #duration
		 * @see #formattedTime
		 * @see #time
		 * @see #formattedTimeRemaining
		 * @see #timeRemaining
		 * */		
		public function get formattedDuration():String { return formatTime(_duration); }
		
		/**
		 * 
		 * @return 
		 * The current stream time remaining formatted in HH:MM:SS format.
		 * @see #duration
		 * @see #formattedTime
		 * @see #time
		 * @see #formattedDuration
		 * @see #timeRemaining
		 * */		
		public function get formattedTimeRemaining():String { return formatTime(timeRemaining); }
		
		/**
		 * 
		 * @return 
		 * The current stream time formatted in HH:MM:SS format.
		 * @see #duration
		 * @see #formattedTimeRemaining
		 * @see #time
		 * @see #formattedDuration
		 * @see #timeRemaining
		 * */		
		public function get formattedTime():String 
		{
			if (_nStream != null)
			{
				if (_nStream.time)
					return formatTime(_nStream.time+this.timeOffset);
				else
					return formatTime(0);
			}
			else
			{
				return formatTime(0);
			}	 
		}
		
		/**
		 * 
		 * @param fsMode
		 * Toggles what fullscreenMode is beeing used by the current Pyro instance for fullscreen display.
		 * Two possible values, Pyro.FS_MODE_SOFTWARE or Pyro.FS_MODE_HARDWARE
	 	 * @see #fullscreenRectangle		 
		 * @see #FS_MODE_SOFTWARE
		 * @see #FS_MODE_HARDWARE
		 */		
		public function set fullscreenMode(fsMode:String):void
		{
			switch (fsMode)
			{
				case Pyro.FS_MODE_SOFTWARE:
				default:
				_fullscreenMode = Pyro.FS_MODE_SOFTWARE;
				break;
				
				case Pyro.FS_MODE_HARDWARE:
				_fullscreenMode = Pyro.FS_MODE_HARDWARE; 
				if (Capabilities.hasVideoEncoder)
				{
					_fullscreenMode = Pyro.FS_MODE_HARDWARE; 
				}		
				else
				{
					_fullscreenMode = Pyro.FS_MODE_SOFTWARE;
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * The current fullscreenMode beeing used in the targetted Pyro instance.
		 */		
		public function get fullscreenMode():String { return _fullscreenMode; }
		
		/**
		 * 
		 * @return 
		 * The fullscreen Rectangle instance that defines the displayed region when 
		 * fullscreenMode == Pyro.FS_MODE_HARDWARE
		 * @see #FS_MODE_SOFTWARE
		 * @see #FS_MODE_HARDWARE
		 */		
		public function get fullscreenRectangle():Rectangle 
		{ 
			if (_fullscreenRectangle)
			{
				return _fullscreenRectangle;
			}
			else
			{
				return this.videoRectangle;
			}
		}
		/**
		 * 
		 * @param rect
		 * Defines the fullscreen Rectangle instance for Pyro.FS_MODE_HARDWARE's fullscreenMode. 
		 */		
		public function set fullscreenRectangle(rect:Rectangle):void { _fullscreenRectangle = rect; }
		
		/**
		 * Sets the horizontal alignment mode. Possible values are:
		 * ALIGN_HORIZONTAL_LEFT -->> Aligns video (snapes to) to the left. 
		 * ALIGN_HORIZONTAL_CENTER -->> Aligns video to the center with equal gaps on both sides.
		 * ALIGN_HORIZONTAL_RIGHT -->> Aligns video (snaps to) to the right.
		 * 
		 * Horizontal alignments occurs only if video object is displayed at a smaller size than the specified (requiredWidth) width 
		 * defined on instanciation. 
		 * Defaults to to ALIGN_HORIZONTAL_CENTER.   
		 * @see #ALIGN_HORIZONTAL_LEFT
		 * @see #ALIGN_HORIZONTAL_CENTER
		 * @see #ALIGN_HORIZONTAL_RIGHT
		 * @see align
		*/		
		public function set hAlignMode(hAlign:String):void
		{
			switch(hAlign)
			{
				case Pyro.ALIGN_HORIZONTAL_CENTER:
				case Pyro.ALIGN_HORIZONTAL_LEFT:
				case Pyro.ALIGN_HORIZONTAL_RIGHT:
				_hAlignMode = hAlign;
				break;
			
				default:
				_hAlignMode = Pyro.ALIGN_HORIZONTAL_CENTER;
				break	
			}
		}
		public function get hAlignMode():String { return _hAlignMode; }
		
			
		public function get highSpeedBufferTable():Array { return [_highSpeedBufferTable.singleTresholdBufferTime, _highSpeedBufferTable.dualTresholdStartBufferTime, _highSpeedBufferTable.dualTresholdStreamBufferTime] ; }
		public function set highSpeedBufferTable(btValues:Array):void
		{
			var singleBTValue:Number = btValues[0] is Number || btValues[0] is uint || btValues[0] is int ? Number(btValues[0]) : 1;
			var dualBTValue:Number = btValues[1] is Number || btValues[1] is uint || btValues[1] is int ? Number(btValues[1]) : 2;
			var dualHighBTValue:Number = btValues[2] is Number || btValues[2] is uint || btValues[2] is int ? Number(btValues[2]) : 15;	
			_highSpeedBufferTable = new BufferTimeTable(singleBTValue, dualBTValue, dualHighBTValue);
		}
		
		/**
		 * 
		 * @return 
		 * The current stream's loaded bytes ratio for progressives and a time+bufferLength on duration proportion for rtmps. 
		 * Based on 1. 0 beeing not loaded at all. 1 is fully loaded.
		 * Usefull for visual progressBars, combined with or tied to scaleX or scaleY, 
		 * @see #bytesLoaded
		 * @see #progressRatio 
		 */		
		public function get loadRatio():Number 
		{
			if (_nStream != null)
			{
				if (this.streamType == Pyro.STREAM_TYPE_PROGRESSIVE || this.streamType == Pyro.STREAM_TYPE_PROXIED_PROGRESSIVE)
				{
					if (_nStream.bytesLoaded && _nStream.bytesTotal)
						return _nStream.bytesLoaded / _nStream.bytesTotal; 
					else
						return 0;
				}
				else
				{
					return ((time+bufferLength) / duration);		
				}
			}	
			else
			{
				return 0;
			}	 
		}
		
		public function get lowSpeedBufferTable():Array { return [_lowSpeedBufferTable.singleTresholdBufferTime, _lowSpeedBufferTable.dualTresholdStartBufferTime, _lowSpeedBufferTable.dualTresholdStreamBufferTime] ; }
		public function set lowSpeedBufferTable(btValues:Array):void
		{
			var singleBTValue:Number = btValues[0] is Number || btValues[0] is uint || btValues[0] is int ? Number(btValues[0]) : 12;
			var dualBTValue:Number = btValues[1] is Number || btValues[1] is uint || btValues[1] is int ? Number(btValues[1]) : 12;
			var dualHighBTValue:Number = btValues[2] is Number || btValues[2] is uint || btValues[2] is int ? Number(btValues[2]) : 30;	
			_lowSpeedBufferTable = new BufferTimeTable(singleBTValue, dualBTValue, dualHighBTValue);
		}
		
		
		public function get mediumSpeedBufferTable():Array { return [_mediumSpeedBufferTable.singleTresholdBufferTime, _mediumSpeedBufferTable.dualTresholdStartBufferTime, _mediumSpeedBufferTable.dualTresholdStreamBufferTime] ; }
		public function set mediumSpeedBufferTable(btValues:Array):void
		{
			var singleBTValue:Number = btValues[0] is Number || btValues[0] is uint || btValues[0] is int ? Number(btValues[0]) : 8;
			var dualBTValue:Number = btValues[1] is Number || btValues[1] is uint || btValues[1] is int ? Number(btValues[1]) : 8;
			var dualHighBTValue:Number = btValues[2] is Number || btValues[2] is uint || btValues[2] is int ? Number(btValues[2]) : 16;	
			_mediumSpeedBufferTable = new BufferTimeTable(singleBTValue, dualBTValue, dualHighBTValue);
		}
		
		/**
		 * 
		 * @return 
		 * The raw metadata Object received from the netStram thru the metadataEvent.
		 * @see #metadataReceived
		 * @see #metadataCheckOver
		 */		 
		public function get metadata():Object { return _metadata; }
		
		/**
		 * 
		 * @return 
		 * If the metadata has been received yet.
		 * @see #metadata
		 * @see #metadataCheckOver 
		 */		
		public function get metadataReceived():Boolean { return _metadataReceived; }
		
		/**
		 * 
		 * @return 
		 * If the loop based metadata check is over. 
		 * @see #metadata
		 * @see #metadataReceived 
		 */	
		public function get metadataCheckOver():Boolean { return _metadataCheckOver; }
		
		/**
		 * 
		 * @return 
		 * If the volume is muted at the moment.
		 * @see #mute
		 * @see #toggleMute
		 * @see #unmute
		 * @see #volume
		 */		
		public function get muted():Boolean { return _muted; }

		/**
		 * 
		 * @return 
		 * A reference to the current NetConnection instance.
		 * @see #netStream
		 */		
		public function get netConnection():NetConnection  { return _nConnection; }
		
		/**
		 * 
		 * @return 
		 * A reference to the current NetStream instance.
		 * @see #netConnection
		 */		
		public function get netStream():NetStream { return _nStream; }
		
		/**
		 * 
		 * @param urlString
		 * @return 
		 * An object representation of the helper Class URLDetails used for parsing urls.
		 * Properties are:
		 * isRelative			:Boolean;
		 * isRTMP				:Boolean;
		 * appName				:String;
		 * rawURL				:String;
		 * startTime			:Number;
		 * protocol				:String;
		 * nConnURL				:String;
		 * serverName			:String;
		 * streamName			:String;
		 * portNumber			:String;
		 * wrappedURL			:String; 
		 */		
		public function getParsedURLObject(urlString:String):Object
		{
			return URLDetails.parseURL(urlString, useDirectFilePath, forceMP4Extension, streamNameHasExtension, serverType);
		}
		
		/**
		 * 
		 * @return 
		 * The current stream's progress based on 1.
		 * 0 beeing stream start and, 
		 * 1 beeing stream end, or duration, as you wish to see it. 
		 * Usefull for visual progressBars, combined with or tied to scaleX or scaleY, 
		 * @see #bytesLoaded
		 * @see #progressRatio 
		 */			
		public function get progressRatio():Number 
		{ 
			if (_nStream != null)
			{
				if (_nStream.time && _duration)
					return ((_nStream.time+_timeOffset) / _duration); 
				else
					return 0;
			}
			else
			{
				return 0;
			}
		} 
		
		/**
		 * 
		 * @return 
		 * FMS 3.5
		 * The proxy type beeing tied to the NetConnection instance beeing used. 
		 */		
		public function get proxyType():String 
		{ 
			if (_nConnection.connectedProxyType)
				return _nConnection.connectedProxyType;
			else
				return _proxyType;
		}
		
		/**
		 * 
		 * @param pt
		 * FMS 3.5
		 * Sets the proxyType used by the NetConnection instance. 
		 * Holds the same value Adobe documents.  
		 */					
		public function set proxyType(pt:String):void
		{
			switch(pt)
			{
				case Pyro.PROXY_TYPE_BEST:
				case Pyro.PROXY_TYPE_CONNECT:
				case Pyro.PROXY_TYPE_HTTP:
				case Pyro.PROXY_TYPE_NONE:
				_proxyType = pt;
				break;
				
				default:
				_proxyType = Pyro.PROXY_TYPE_BEST;
				break;
			}
		}
		
		/**
		 * 
		 * @return 
		 * An Object containing many raw time infos.
		 * Properties are:
		 * time				:Number
		 * duration			:Number
		 * progressRatio	:Number
		 * timeRemaining	:Number
		 * @see #time
		 * @see #duration
		 * @see #timeRemaining
		 * @see #progressRatio
		 */		
		public function get rawTimeInfo():Object
		{
			return {time:this._nStream.time, duration:this._duration, progressRatio:_nStream.time / this._duration, timeRemaining:this._duration-_nStream.time}; 
		}
		
		/**
		 * 
		 * @return 
		 * If Pyro instance is ready to receive stream urls to fetch.
		 * @see #status
		 * @see #STATUS_READY
		 */		
		public function get ready():Boolean { return _ready; }
		
		/**
		 * 
		 * @return 
		 * The scale mode in use.
		 */		
		public function get scaleMode():String { return _scaleMode; }	
		/**
		 * Sets Pyro's main scaling parameter. The scale mode is usefull if videos are either to be shown to fill 
		 * horizontal(16:9) or vertical(4:3) space. 
		 * Recalculated on each resize.
		 * Only taken in consideration if maintainAspectRatio is set to true. 
		 * @usage For exemple, if your video space is meant to always fill as  much horizontal space as possible, 
		 * the SCALE_MODE_WIDTH_BASED needs to be used. 
		 * The contrary is true with SCALE_MODE_HEIGHT_BASED.
		 * Possible values are Pyro.SCALE_MODE_WIDTH_BASED, Pyro.SCALE_MODE_HEIGHT_BASED and Pyro.NO_SCALE
		 * Defaults to Pyro.SCALE_MODE_WIDTH_BASED.
		 * @see #maintainAspectRatio
		 * @see #resize 
		 * @see #hAlignMode
		 * @see #vAlignMode
		 * @see #align
		 *  
		*/	
		public function set scaleMode(sm:String):void
		{
			switch (sm)
			{
				case Pyro.SCALE_MODE_HEIGHT_BASED:
				case Pyro.SCALE_MODE_NO_SCALE:
				case Pyro.SCALE_MODE_WIDTH_BASED:
				_scaleMode = sm;
				break;
				
				default:
				_scaleMode = Pyro.SCALE_MODE_WIDTH_BASED;
				break;
			}
		}
		
		/**
		 * 
		 * @return 
		 * The serverType beeing used. 
		 * @see #SERVER_TYPE_LATEST
		 * @see #SERVER_TYPE_UNDER_FMS_3_5
		 * @see #SERVER_TYPE_NONE  
		 */		
		public function get serverType():String { return _serverType; }
		/**
		 * 
		 * @param st
		 * Use serverType properties to specify from what FMS server version RTMP streams are delivered. 
		 * Used to toggle how URLs requested are parsed, and to toggle FMS3.5 only features.
		 */		
		public function set serverType(st:String):void
		{
			switch (st)
			{
				case Pyro.SERVER_TYPE_LATEST:
				case Pyro.SERVER_TYPE_NONE:
				case Pyro.SERVER_TYPE_UNDER_FMS_3_5:
				_serverType = st;
				break;
				
				default:
				_serverType = Pyro.SERVER_TYPE_LATEST;
				break;
			}
		}
		
		/**
		 * 
		 * @param sm
		 * Sets smoothing deployed on Pyro instance video. 
		 * @see #video
		 */		
		public function set smoothing(sm:Boolean):void 
		{ 	
			this._smoothing = sm;
			
			if (ready)
				_video.smoothing = sm; 
		}
		/**
		 * 
		 * @return 
		 * Is smoothing on or not.
		 */		
		public function get smoothing():Boolean { return _video.smoothing; }
		
		/**
		 * 
		 * @return 
		 * The raw url requested.
		 */		
		public function get source():String { return _src; }
		
		/**
		 * 
		 * @return 
		 * The stageEventMechanics beeing used.
		 * @see #STAGE_EVENTS_MECHANICS_ALL_OFF
		 * @see #STAGE_EVENTS_MECHANICS_ALL_ON
		 * @see #STAGE_EVENTS_MECHANICS_ONLY_FS
		 */		
		public function get stageEventMechanics():String { return _stageEventMechanics; }
		
		/**
		 * 
		 * @param stageMechs
		 * Sets the stageEventMechanics.
		 */		
		public function set stageEventMechanics(stageMechs:String):void
		{
			switch (stageMechs)
			{
				case Pyro.STAGE_EVENTS_MECHANICS_ALL_OFF:
				case Pyro.STAGE_EVENTS_MECHANICS_ALL_ON:
				case Pyro.STAGE_EVENTS_MECHANICS_ONLY_FS:
				_stageEventMechanics = stageMechs;
				break;
				
				default:
				_stageEventMechanics = Pyro.STAGE_EVENTS_MECHANICS_ALL_ON;
				break;
			}			
		}
		
		/**
		 * 
		 * @return 
		 * The sum of audioDataRate and videoDataRate 
		 * @see #audioDataRate
		 * @see #videoDataRate
		 */		
		public function get streamDataRate():Number { return (_audioDataRate + _videoDataRate); }
		
		/**
		 * 
		 * @return 
		 * The current netStream type. 
		 * 3 stream types possible.		 
		 * @see #STREAM_TYPE_PROXIED_PROGRESSIVE
		 * @see #STREAM_TYPE_TRUE_STREAM
		 * @see #STREAM_TYPE_PROGRESSIVE
		 */	
		public function get streamType():String { return _streamType; }
		
		/**
		 * 
		 * @return 
		 * The current pyro status. 
		 * @see #STATUS_CLOSED
		 * @see #STATUS_CONNECTING
		 * @see #STATUS_INITIALIZING
		 * @see #STATUS_PAUSED
		 * @see #STATUS_PENDING
		 * @see #STATUS_PLAYING
		 * @see #STATUS_READY
		 * @see #STATUS_STOPPED
		 */		
		public function get status():String { return _status; }
		
		/**
		 * 
		 * @return 
		 * Current time in seconds.
		 * @see #formattedTime
		 * @see #duration
		 */		
		public function get time():Number 
		{ 
			if (_nStream != null)
			{
				if (_nStream.time)
					return (Number(_nStream.time)+Number(this.timeOffset)); 
				else
					return 0;
			}
			else
			{
				return 0;
			}
		}
		
		public function get timeOffset():Number { return _timeOffset; }
		
		/**
		 * 
		 * @return 
		 * Time left to currently playing stream in seconds.
		 * @see #time
		 * @see formattedTimeRemaining
		 */		
		public function get timeRemaining():Number 
		{ 
			if (_nStream != null)
			{
				if (_nStream.time && _duration)
					return (_duration - ( Number(_nStream.time)+Number(_timeOffset)) );
				else
					return 0;
			}
			else
			{
				return 0;
			}  
		}
		
		public function get urlDetails():URLDetails { return _urlDetails; }
		
		/**
		 * Sets the vertical alignment mode. Possible values are:
		 * ALIGN_VERTICAL_TOP -->> Aligns video (snaps to) to the top. 
		 * ALIGN_VERTICAL_CENTER -->> Aligns video to the center with equal gaps on top and bottom.
		 * ALIGN_VERTICAL_BOTTOM -->> Aligns video (snaps to) to the bottom.
		 * 
		 * Vertical alignments occurs only if video object is displayed at a smaller size than the specified (requiredHeight) height defined on instanciation. Defaults to ALIGN_VERTICAL_CENTER.   
		 * @see #ALIGN_VERTICAL_TOP
		 * @see #ALIGN_VERTICAL_CENTER
		 * @see #ALIGN_VERTICAL_BOTTOM
		 * @see align
		*/	
		public function set vAlignMode(vAlign:String):void
		{
			switch(vAlign)
			{
				case Pyro.ALIGN_VERTICAL_BOTTOM:
				case Pyro.ALIGN_VERTICAL_CENTER:
				case Pyro.ALIGN_VERTICAL_TOP:
				_vAlignMode = vAlign;
				break;
			
				default:
				_vAlignMode = Pyro.ALIGN_VERTICAL_CENTER;
				break	
			}
		}
		public function get vAlignMode():String { return _vAlignMode; }
		
		/**
		 * 
		 * @return 
		 * Pyro Instance current video Class Instance
		 */		
		public function get video():Video { return _video; }			
		
		
		/**
		 * 
		 * @return 
		 * Current stream's video dataRate.
		 * @see #audioDataRate
		 * @see #streamDataRate
		 */		
		public function get videoDataRate():Number { return this._videoDataRate; }
		
		/**
		 * 
		 * @return 
		 * Pyro Instance physical video height
		 * @see #video
		 * @see #videoWidth
		 * @see #height  
		 */		
		public function get videoHeight():Number { return _video.height; }
		
		/**
		 * 
		 * @return 
		 * Pyro Instance physical video width
		 * @see #video
		 * @see #videoHeight
		 * @see #width  
		 */		
		public function get videoWidth():Number { return _video.width; }			
		
		/**
		 * 
		 * @param vol
		 * Sets volume. 
		 * @see #mute
		 * @see #toggleMute
		 * @see #unmute()
		 */		
		public function set volume(vol:Number):void 
		{ 
			_volume = vol;
			if (connectionReady) { _nStream.soundTransform = new SoundTransform(vol, 0); }
			this.dispatchEvent(new PyroEvent(PyroEvent.VOLUME_UPDATE, bubbleEvents, cancelableEvents));
		}
		/**
		 * 
		 * @return 
		 * The current volume value.
		 */		
		public function get volume():Number { return _volume; }
		
		public function get XMPDataProxy():XMPProxy { return this._XMPDataProxy; }
		public function get XMPDataReceived():Boolean { return this._XMPDataReceived; }
		public function get XMPDataCuePoints():Array { return this._XMPDataProxy.cuePoints; }
		
		override public function get width():Number { return _requestedWidth; }
		override public function set width(w:Number):void { resize(w, _requestedHeight); }
		override public function get height():Number { return _requestedHeight; }
		override public function set height(h:Number):void { resize(_requestedWidth, h); }

		

		/*
		 ------------------------------------------------------------------------------------------------ >>
		 									  INTERNAL STUFF	
		 ------------------------------------------------------------------------------------------------ >>
		*/
		
		public function formatTime(timeCue:Number):String
		{
			var minutes:String = String(Math.floor(timeCue / 60)).length > 1 ? String(Math.floor(timeCue / 60)) : "0"+String(Math.floor(timeCue / 60));
			var seconds:String = String(Math.floor(timeCue%60)).length > 1 ? String(Math.floor(timeCue%60)) : "0"+String(Math.floor(timeCue%60));
			return minutes + ":"+ seconds;
		}
		
		protected function getBandwidth(flvLength:Number, flvBitrate:Number, bandwidth:Number):Number
		{	
			
			// À revoir, pour le moment je bypass ça en estimant le bandwidth. 
			var bt		:Number;
			var padding	:Number = 6;
			
			flvBitrate > bandwidth ? bt = Math.ceil(flvLength - flvLength/(flvBitrate/bandwidth)) : bt = 0;	
			bt += padding;
			
			if(bt > 30) bt = 20;
			
			return bt;
		}
		
		
		protected function reset():void
		{
			resetInternalState();
			
			hasCompleted		= false;
			_duration			= 0;
			_metadata			= new Object();
			_metadataReceived	= false;
		}
		
		protected function resetInternalState():void
		{
			flushed = stopped = false;
		}
		
		protected function setStatus(st:String):void
		{
			_status = st;
			dispatchEvent(new StatusUpdateEvent(StatusUpdateEvent.STATUS_UPDATE, _status, bubbleEvents, cancelableEvents));
		}
		
		
	}
}

import ca.turbulent.media.Pyro;

internal class URLDetails
{
	
	public var info					:Object = new Object();
	public var isRelative			:Boolean = false;
	public var isRTMP				:Boolean = false;
	public var appName				:String = "";
	public var rawURL				:String = "";
	public var startTime			:Number = 0;
	public var protocol				:String = "";
	public var nConnURL				:String = "";
	public var serverName			:String = "";
	public var streamName			:String = "";
	public var portNumber			:String = ""; 
	public var wrappedURL			:String = "";
	public var extraParams			:Object = new Object();
	
	public function URLDetails(url:String, useDirectFilePath:Boolean=false, forceMP4Extension:Boolean=true, hasExtension:Boolean=true, serverType:String="serverTypeUnderFMS_3_5"):void
	{
        
        rawURL 				= url;												
        info 				= URLDetails.parseURL(url, useDirectFilePath, forceMP4Extension, hasExtension, serverType);
        appName 			= info.appName;
        protocol 			= info.protocol;			
        serverName 			= info.serverName; 
        isRelative			= info.isRelative;
        isRTMP				= info.isRTMP; 
        portNumber			= info.portNumber;
        wrappedURL			= info.wrappedURL;
        streamName			= info.streamName;
        startTime			= info.extraParams.startTime;
        extraParams			= info.extraParams;
        nConnURL			= protocol + ((serverName == null) ? "" : "/" + serverName + ((portNumber == null) ? "" : (":" + portNumber)) + "/") + ((wrappedURL == null) ? "" : wrappedURL + "/") + appName;
        
	}
	
	public static function parseURL(url:String, useDirectFilePath:Boolean=false, forceMP4Extension:Boolean=true, hasExtension:Boolean=true, FMSServerType:String="serverTypeUnderFMS_3_5"):Object 
	{ 
		var parseResults:Object = new Object();
		
		var serverType:String = FMSServerType;
		 
		parseResults.extraParams = URLDetails.getExtraURLParams(url);
		
		var p:Object = parseResults.extraParams;
		
		if (p.version && p.version != "")
		{
			if (p.version == Pyro.SERVER_TYPE_UNDER_FMS_3_5 || p.version == Pyro.SERVER_TYPE_LATEST || p.version==Pyro.SERVER_TYPE_NONE)
			{
				serverType = p.version;
			}
			else if (p.version == "FMS35" || p.version.toLowerCase() == "latest" || p.version.toLowerCase() == "FMS_35")
			{
				serverType = Pyro.SERVER_TYPE_LATEST;
			}
			else if (p.version == "FMSUNDER35" || p.version == "FMS_UNDER_35")
			{
				serverType = Pyro.SERVER_TYPE_UNDER_FMS_3_5;
			}
		}
		
		if (p.serverType && p.serverType != "")
		{
			if (p.serverType == Pyro.SERVER_TYPE_UNDER_FMS_3_5 || p.serverType == Pyro.SERVER_TYPE_LATEST || p.serverType==Pyro.SERVER_TYPE_NONE)
			{
				serverType = p.serverType;
			}
			else if (p.serverType == "FMS35" || p.serverType.toLowerCase() == "latest" || p.serverType.toLowerCase() == "FMS_35")
			{
				serverType = Pyro.SERVER_TYPE_LATEST;
			}
			else if (p.serverType == "FMSUNDER35" || p.serverType == "FMS_UNDER_35")
			{
				serverType = Pyro.SERVER_TYPE_UNDER_FMS_3_5;
			}
		}
		
		if (url.indexOf("?") > 0)
		{
			var tempURL:String = url.substring(0, url.indexOf("?"));
			var hasArguments:Boolean = false;
			var args:String = "";
			for (var e:String in p)
			{
				if (e != "serverType" && e != "version" && (e == "startTime" && Number(p[e]) >= 0))
				{
					if (hasArguments) 
						args+="&"; 
					 else
					 	args += "?";
					 	
					hasArguments = true;
					args+= (e+"="+p[e]);
				}
			}
			
			tempURL += args;
			url = tempURL;
		}
		
		var startIndex:int = 0;
		var endIndex:int = url.indexOf(":/", startIndex);

		if (endIndex >= 0) 
		{
			endIndex += 2;
			parseResults.protocol = url.slice(startIndex, endIndex).toLowerCase();
			parseResults.isRelative = false;
		} 
		else 
		{
			parseResults.isRelative = true;
		}
				
		if (parseResults.protocol != null && (parseResults.protocol == "rtmp:/" ||
															parseResults.protocol == "rtmpt:/" ||
															parseResults.protocol == "rtmps:/" ||
															parseResults.protocol == "rtmpe:/" ||
															parseResults.protocol == "rtmpte:/" ||
															parseResults.protocol == "rtmfp:/")) 
		{
			parseResults.isRTMP = true;
			startIndex = endIndex;
	
			if (url.charAt(startIndex) == '/') 
			{
				startIndex++;
				// get server (and maybe port)
				var colonIndex:int = url.indexOf(":", startIndex);
				var slashIndex:int = url.indexOf("/", startIndex);
				if (slashIndex < 0) 
				{
					if (colonIndex < 0) 
					{
						parseResults.serverName = url.slice(startIndex);
					} 
					else 
					{
						endIndex = colonIndex;
						parseResults.portNumber = url.slice(startIndex, endIndex);
						startIndex = endIndex + 1;
						parseResults.serverName = url.slice(startIndex);
					}
					return parseResults;
				}
						
				if (colonIndex >= 0 && colonIndex < slashIndex) 
				{
					endIndex = colonIndex;
					parseResults.serverName = url.slice(startIndex, endIndex);
					startIndex = endIndex + 1;
					endIndex = slashIndex;
					parseResults.portNumber = url.slice(startIndex, endIndex);
				} 
				else 
				{
					endIndex = slashIndex;
					parseResults.serverName = url.slice(startIndex, endIndex);
				}
				
				startIndex = endIndex + 1;
			}
	
			// handle wrapped RTMP servers bit recursively, if it is there
			if (url.charAt(startIndex) == '?') 
			{
				var subURL:String = url.slice(startIndex + 1);
				var subParseResults:Object = parseURL(subURL);
				if (subParseResults.protocol == null || !subParseResults.isRTMP) 
				{
					// throw new VideoError(VideoError.INVALID_SOURCE, url);
				}
				
				parseResults.wrappedURL = "?";
				parseResults.wrappedURL += subParseResults.protocol;
				if (subParseResults.serverName != null) 
				{
					parseResults.wrappedURL += "/";
					parseResults.wrappedURL +=  subParseResults.serverName;
				}
						
				if (subParseResults.portNumber != null) 
				{
					parseResults.wrappedURL += ":" + subParseResults.portNumber;
				}
				
				if (subParseResults.wrappedURL != null) 
				{
					parseResults.wrappedURL += "/";
					parseResults.wrappedURL +=  subParseResults.wrappedURL;
				}
				
				parseResults.appName = subParseResults.appName;
				parseResults.streamName = subParseResults.streamName;
				return parseResults;
			}
					
			// get application name
			endIndex = url.indexOf("/", startIndex);
			if (endIndex < 0) 
			{
				parseResults.appName = url.slice(startIndex);
				return parseResults;
			}
			
			parseResults.appName = url.slice(startIndex, endIndex);
			startIndex = endIndex + 1;
	
			// check for instance name to be added to application name
			endIndex = url.indexOf("/", startIndex);
			if (endIndex < 0) 
			{
				parseResults.streamName = url.slice(startIndex);
				// strip off .flv if included
				if (parseResults.streamName.slice(-4).toLowerCase() == ".flv") 
					parseResults.streamName = parseResults.streamName.slice(0, -4);
				
				return parseResults;
			}
			
			parseResults.appName += "/";
			parseResults.appName += url.slice(startIndex, endIndex);
			startIndex = endIndex + 1;
						
			// get flv name
			parseResults.streamName = url.slice(startIndex);

			if (serverType == Pyro.SERVER_TYPE_LATEST && useDirectFilePath)
			{
				var namePrefix:String = "";
				var appSplitted:Array = parseResults.appName.split("/");
				for (var i:Number=1; i<appSplitted.length; i++)
				{
					namePrefix = namePrefix += "/"+appSplitted[i];
				}
				
				parseResults.streamName = namePrefix + "/"+parseResults.streamName;
				parseResults.appName = appSplitted[0]+"/";
			}
			
			var sName:String = parseResults.streamName;
			var ext:String = sName.substr(-4).toLowerCase();
			
			// strip off .flv if included	
			if (ext == ".flv") 
			{
				parseResults.streamName = parseResults.streamName.slice(0, -4);
			}
			else if (ext == '.mp4' || ext == ".mov" || ext == ".aac" || ext == ".m4a" || ext == ".3gp" || ext == ".f4v")
			{
				if (serverType == Pyro.SERVER_TYPE_LATEST)
				{
					parseResults.streamName = 'mp4:'+sName;
				}
				else
				{
					if (forceMP4Extension)
					{
						if (hasExtension)
							parseResults.streamName = 'mp4:'+sName;
						else
							parseResults.streamName = 'mp4:'+sName.slice(0, -4);
					}
					else
					{
						if (hasExtension)
							parseResults.streamName = sName;
						else
							parseResults.streamName = sName.slice(0, -4);
					}
				}
			}		
		} 
		else 
		{
			// is http, just return the full url received as streamName
			parseResults.isRTMP = false;
			parseResults.streamName = url;
			parseResults.appName = "";
			parseResults.serverName = ""; 
        	parseResults.isRTMP	= false; 
        	parseResults.wrappedURL	= "";
			parseResults.nConnURL = "";
			parseResults.extraParams = p;
			parseResults.startTime =  p['startTime'];
			
		}	
		return parseResults;
	}
	
	public static function getExtraURLParams(url:String):Object
	{
		var parsedParams:Object = new Object();
		parsedParams['startTime'] = -1;
		
		var parsedArray:Array = new Array();
		
		var paramString:String = "";
		var startIndex:Number = url.indexOf("?");
		
		if (startIndex > 0)
		{
			paramString = url.substring(startIndex+1);
			parsedArray = paramString.split("&");
			var valuePair:Array;
			
			if (parsedArray.length > 0)
			{
				for (var i:Number=0; i<parsedArray.length; ++i)
				{
					valuePair = parsedArray[i].split("=");
					parsedParams[valuePair[0]] = valuePair[1];
				}
			}
			else
			{
				valuePair = paramString.split("=");
				parsedParams[valuePair[0]] = valuePair[1];
			}
			
			parsedParams['startTime'] = Number(parsedParams['startTime']);
			
		}
		
		return parsedParams;
	}
}
	
	

internal class BufferTimeTable
{
	public var singleTresholdBufferTime					:Number;
	public var dualTresholdStartBufferTime				:Number;
	public var dualTresholdStreamBufferTime				:Number;			
	
	public function BufferTimeTable(singleBufferTime:Number=2, dualStartBufferTime:Number=2, dualStreamBufferTime:Number=15):void
	{
		singleTresholdBufferTime = singleBufferTime;
		dualTresholdStartBufferTime = dualStartBufferTime;
		dualTresholdStreamBufferTime = dualStreamBufferTime;
	}		 
}

import flash.system.Capabilities;

internal class ClientInfos
{
	public var flashPlayerVersion		:String = Capabilities.version;
	public var majorVersion				:String = Capabilities.version.split(",")[0].substring(4);
	public var minorVersion				:String = Capabilities.version.split(",")[1];
	public var build					:String = Capabilities.version.split(",")[2];
	public var internalBuild			:String = Capabilities.version.split(",")[3];
	public var os						:String = Capabilities.os;
	public var screenResX				:Number = Capabilities.screenResolutionX;
	public var screenResY				:Number = Capabilities.screenResolutionY;
	public var screenDPI				:Number = Capabilities.screenDPI;
	public var screenColor				:String = Capabilities.screenColor;
	
	public function ClientInfos():void {}
}

import flash.net.NetConnection;
import ca.turbulent.media.Pyro;

internal class NetConnectionClient
{
	public var pyro				:Pyro;
	public var nConnectionBW	:Number = 0;
	public var payload			:Number = 0;
	
	public function NetConnectionClient(owner:Pyro):void { pyro = owner; } 
	public function close():void {}
	
	public function onBWDone(... rest):void
	{
		if (rest.length > 0) nConnectionBW = rest[0];
	}
	
	public function onBWCheck(... rest):void
	{
		++ payload; 
	}
	
	public function onDVRSubscribe(... rest):void
	{
		
	}			
}

import ca.turbulent.media.Pyro;
internal class XMPProxy
{
	public var rawXMP			:Object;
	public var rawXMPXML		:XML;
	
	public var numCuePoints		:int = 0;
	public var cuePoints		:Array = new Array();
	public var cueFrameRate		:Number = 0;
	
	public var xmpDM			:Namespace = new Namespace("http://ns.adobe.com/xmp/1.0/DynamicMedia/");
	public var rdf				:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#");  
	
	public function XMPProxy(XMPData:Object):void
	{
		rawXMP = XMPData;
		rawXMPXML = new XML(XMPData.data);

        var frameRateString:String = rawXMPXML..xmpDM::Tracks..rdf::Description.@xmpDM::frameRate;
        cueFrameRate = Number(frameRateString.substr(1, frameRateString.length));
 
        var cuePointXMLList:XMLList = rawXMPXML..xmpDM::markers.rdf::Seq.rdf::li;
        numCuePoints = cuePointXMLList.length();
        
        for (var i:int=0; i<numCuePoints; i++) 
        { 
        	var cueXML:XML = cuePointXMLList[i];
        	cuePoints.push({name:cueXML.@xmpDM::name, type:cueXML.@xmpDM::cuePointType, time:cueXML.@xmpDM::startTime/cueFrameRate});
        } 
	}	
}