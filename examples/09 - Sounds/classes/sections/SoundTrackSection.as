﻿package sections{	import asf.core.elements.Section;	import asf.core.util.Sequence;	import asf.interfaces.ISectionView;	import asf.view.UIView;	import view.SoundTrackSectionView;	import asf.core.viewcontrollers.InOutViewController;	import flash.display.Bitmap;	import ui.ButtonPlayStop;	import flash.events.MouseEvent;		public class SoundTrackSection extends SoundTrackSectionView implements ISectionView	{		private var controller:InOutViewController;		private var section:Section;		private var img:Bitmap;				private var bt:ButtonPlayStop;		private var isPlaying:Boolean;				public function SoundTrackSection( )		{			controller = new InOutViewController( this );			bt = new ButtonPlayStop( $bt.$button );						bt.showStop( );		}				public function init(p_section:Section, ...parameters):void		{			section = p_section;			isPlaying = section.sounds.getSoundItem( "track" ).model.isAutoPlay;						if( isPlaying ) bt.showStop( );			else bt.showPlay( );						bt.addEventListener( MouseEvent.CLICK, onButtonClick );		}				private function onButtonClick( evt:MouseEvent ):void		{			if( isPlaying )			{				section.sounds.stop( "track" );				isPlaying = false;				bt.showPlay( );			}			else			{				section.sounds.play( "track" );				isPlaying = true;				bt.showStop( );			}		}				public function open(p_delay:uint=0):Sequence		{			return controller.animateIn( );		}				public function close(p_delay:uint=0):Sequence		{			return controller.animateOut( );		}				public function dispose():void		{			controller.dispose( );			controller = null;		}	}}