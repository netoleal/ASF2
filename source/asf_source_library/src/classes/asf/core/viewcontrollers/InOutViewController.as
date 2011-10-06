/*
 * Class asf.core.controllers.InOutController
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 11:50:55 AM
 *
 **/
package asf.core.viewcontrollers
{
	import asf.core.util.Sequence;
	import asf.events.InOutEvent;
	import asf.interfaces.ISequence;
	import asf.utils.Delay;
	import asf.utils.TimelineInOutLabels;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	[Event( type="asf.events.InOutEvent", name="inStart" )]
	[Event( type="asf.events.InOutEvent", name="inEnd" )]
	[Event( type="asf.events.InOutEvent", name="outStart" )]
	[Event( type="asf.events.InOutEvent", name="outEnd" )]
	
	/**
	 * Essa classe é útil para usar MovieClips com transições de "entrada" e "saída" baseadas em Timeline.
	 * 
	 * <pre>
	 * 
	 * var headerController:InOutViewController = new InOutViewController( new HeaderMC( ) );
	 * 
	 * this.addChild( headerController.view ); 
	 * header.animateIn( true ); //ou animateOut para "sair"
	 * </pre>
	 * 
	 * O InOutViewController funciona da seguinte forma:
	 * No exemplo acima, HeaderMC é um MovieClip exportado em um SWC. Para integrar ele corretamente com o InOutViewController, você deve criar a animação na timeline dele da forma como quiser e, para integrar, você define "labels" nos frames da timeline para marcar os estados. O InOutViewController procura por labels específicos para conseguir identificar sua animação. São eles:
	 * 
	 * <ul>
	 * <li>in Início da animação de entrada</li>
	 * <li>inEnd Fim da animação de entrada</li>
	 * <li>out Início da animação de saída</li>
	 * <li>outEnd Fim da animação de saída</li>
	 * <li>inOut Entrada e saída no modo avança/retrocede</li>
	 * </ul>
	 *  
	 * @param p_view
	 * @param p_useFade
	 * 
	 */
	public class InOutViewController extends TimelineViewController
	{
		
		protected var transition:Sequence;
		
		private var _target:MovieClip;
		
		private var sh:ShowHideViewController;
		private var isIn:Boolean = false;
		private var useFade:Boolean;
		
		public function InOutViewController( p_view:MovieClip, p_useFade:Boolean = true )
		{
			//log( p_target );
			
			super( p_view );
			
			transition = new Sequence( );
			
			useFade = p_useFade;
			_target = p_view;
			
			//target.stop( );
			target.gotoAndStop( 1 );
			
			//log( target.name, labels );
			
			if( !hasLabels && !hasInOutLabel && useFade )
			{
				sh = new ShowHideViewController( target, false );
			}
		}
		
		/**
		 * Quando o método animateIn é chamado, o InOutViewController controla a timeline do MovieClip target de forma com que ele execute o trecho da timeline entre os labels "in" e "inEnd". O mesmo acontece com o "animateOut" e os frames "out" e "outEnd"
		 * @param preventRepetition
		 * @return 
		 * 
		 */
		public function animateIn( preventRepetition:Boolean = false ):ISequence
		{
			//log( this.target, this.target.name );
			
			transition.notifyStart( );
			
			if( this.hasManualLabel ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			if( preventRepetition && isIn ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			isIn = true;
			
			this.dispatchEvent( new InOutEvent( InOutEvent.IN_START ) );
			
			if( sh )
			{
				sh.setVisible( true ).queue( dispatchAnimateInComplete );
			}
			else
			{
				if( hasLabels )
				{
					timeline.gotoAndStop( TimelineInOutLabels.IN );
					
					if( getFrameNumberForLabel( TimelineInOutLabels.IN_END ) != -1 )
					{
						timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.IN_END ) );
						timeline.onReach = dispatchAnimateInComplete;
					}
				}
				else if( hasInOutLabel )
				{
					timeline.stop( );
					timeline.animateToFrame( timeline.totalframes );
					timeline.onReach = dispatchAnimateInComplete;
				}
			}
			
			return transition.queue( Delay.start, 0 );
		}
		
		public function animateOut( preventRepetition:Boolean = false ):ISequence
		{
			transition.notifyStart( );
			
			
			if( this.hasManualLabel ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			if( preventRepetition && !isIn )
			{
				transition.notifyComplete( );
				return transition;
			}
			
			isIn = false;
			
			this.dispatchEvent( new InOutEvent( InOutEvent.OUT_START ) );
			
			if( sh )
			{
				sh.setVisible( false ).queue( dispatchAnimateOutComplete );
			}
			else
			{
				if( hasLabels )
				{
					timeline.gotoAndStop( TimelineInOutLabels.OUT );
					
					if( getFrameNumberForLabel( TimelineInOutLabels.OUT_END ) != -1 )
					{
						timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.OUT_END ) );
						timeline.onReach = dispatchAnimateOutComplete;
					}
				}
				else if( hasInOutLabel )
				{
					timeline.stop( );
					timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.IN_OUT ) );
					timeline.onReach = dispatchAnimateOutComplete;
				}
			}
			
			return transition.queue( Delay.start, 0 );
		}
		
		private function dispatchAnimateInComplete( ... a ):void
		{
			timeline.onReach = null;
			transition.notifyComplete( );
			dispatchEvent( new InOutEvent( InOutEvent.IN_END ) );
		}
		
		private function dispatchAnimateOutComplete( ... a ):void
		{
			timeline.onReach = null;
			transition.notifyComplete( );
			dispatchEvent( new InOutEvent( InOutEvent.OUT_END ) );
		}
		
		protected function get hasManualLabel( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.MANUAL ) != -1;
		}
		
		protected function get hasLabels( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.IN ) != -1 && labels.indexOf( TimelineInOutLabels.OUT ) != -1;
		}
		
		protected function get hasInOutLabel( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.IN_OUT ) != -1;
		}
		
		
		
		public function get target( ):MovieClip
		{
			return _target;
		}
		
		public override function dispose( ):void
		{
			stop( );
			super.dispose( );
			
			_target = null;
		}
	}
}