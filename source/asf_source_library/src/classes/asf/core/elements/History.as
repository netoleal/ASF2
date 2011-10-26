/*
Class: asf.core.elements.History
Author: Neto Leal
Created: May 2, 2011

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
package asf.core.elements
{
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.events.HistoryEvent;
	
	import flash.events.EventDispatcher;

	public class History extends EventDispatcher
	{
		private var app:ApplicationViewController;
		private var states:Vector.<HistoryState>;
		private var index:uint = 0;
		
		public function History( p_app:ApplicationViewController )
		{
			app = p_app;
			states = new Vector.<HistoryState>( );
		}
		
		/**
		 * Volta um passo no histórico
		 *  
		 * @param recursive
		 * 
		 */
		public function back( recursive:Boolean = false ):void
		{
			if( recursive )
			{
				var subsection:Section;
				var subHasBack:Boolean = false;
				
				for each( subsection in app.navigation.currentActiveSections )
				{
					if( subsection.navigation.history.canGoBack( ) )
					{
						subHasBack = true;
						subsection.navigation.history.back( recursive );
					}
				}
				
				if( subHasBack ) return;
			}
			
			if( canGoBack( ) )
			{
				applyState( --index );
			}
		}
		
		/**
		 * Avança um passo no histórico
		 *  
		 * @param recursive
		 * 
		 */
		public function foward( recursive:Boolean = false ):void
		{
			if( recursive )
			{
				var subsection:Section;
				var subHasBack:Boolean = false;
				
				for each( subsection in app.navigation.currentActiveSections )
				{
					if( subsection.navigation.history.canGoFoward( ) )
					{
						subHasBack = true;
						subsection.navigation.history.foward( recursive );
					}
				}
				
				if( subHasBack ) return;
			}
			
			if( canGoFoward( ) )
			{
				applyState( ++index );
			}
		}
		
		private function applyState( p_index:uint ):void
		{
			var state:HistoryState;
			var section:Section;
			var stateSections:Vector.<Section>;
			var id:String;
			var sectionsToClose:Vector.<Section> = new Vector.<Section>( );
			
			index = p_index;
			
			state = states[ index ];
			
			stateSections = new Vector.<Section>( );
			
			for each( section in app.navigation.currentActiveSections )
			{
				if( state.activeSectionsIds.indexOf( section.id ) == -1 )
				{
					sectionsToClose.push( section );
				}
			}
			
			app.navigation.closeSections( sectionsToClose );
			
			for each( id in state.activeSectionsIds )
			{
				section = app.navigation.getSectionByID( id );
				stateSections.push( section );
				
				if( app.navigation.currentActiveSections.indexOf( section ) == -1 )
				{
					var params:NavigateParams = new NavigateParams( );
					
					params.section = section;
					params.setAsCurrent = state.currentSectionId == section.id;
					params.closeCurrentBeforeOpen = false;
					params.preserveHistory = true;
					params.extraArguments = state.extraArguments;
					
					app.navigation.openSection.apply( null, [ params ].concat( state.extraArguments ) );
				}
			}
			
			this.dispatchEvent( new HistoryEvent( HistoryEvent.CHANGE ) );
		}
		
		/**
		 * Método interno usado pela Navigation para registrar os passos do histórico
		 *  
		 * @param sections
		 * @param currentSectionId
		 * @param extraArguments
		 * 
		 */
		public function pushState( sections:Vector.<Section>, currentSectionId:String, extraArguments:Array ):void
		{
			states.push( new HistoryState( sections, currentSectionId, extraArguments ) );
			index = states.length - 1;
			
			this.dispatchEvent( new HistoryEvent( HistoryEvent.NEW_STATE ) );
		}
		
		/**
		 * Índice atual de navegação do histórico
		 *  
		 * @return 
		 * 
		 */
		public function get currentIndex( ):uint
		{
			return this.index;
		}
		
		public function get currentStates( ):Vector.<HistoryState>
		{
			return states;
		}
		
		/**
		 * Checa se é possível voltar no histórico
		 *  
		 * @return 
		 * 
		 */
		public function canGoBack( ):Boolean
		{
			return index > 0;
		}
		
		/**
		 * Checa se é possível avançar no histórico
		 *  
		 * @return 
		 * 
		 */
		public function canGoFoward( ):Boolean
		{
			return index < states.length - 1;
		}
		
		/**
		 * Corta o histórico na posição atual. Também método de uso interno pela Navigation 
		 * 
		 */
		public function cut( ):void
		{
			states.splice( index, Math.max( 0, states.length - index - 1 ) );
		}
	}
}