/*
Class: asf.core.elements.Navigation
Author: Neto Leal
Created: Apr 25, 2011

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
	import asf.core.models.sections.SectionModel;
	import asf.core.models.sections.SectionType;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.events.DependenciesProgressEvent;
	import asf.events.NavigationEvent;
	import asf.events.SectionEvent;
	import asf.events.SequenceEvent;
	import asf.log.LogLevel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	[Event( name="change", type="asf.events.NavigationEvent" )]
	
	public class Navigation extends EventDispatcher
	{
		private var app:ApplicationViewController;
		private var openedSections:Vector.<Section>;
		
		private var ids:Object;
		private var arIds:Vector.<String>;
		private var dictTransitions:Dictionary;
		private var lastChangeSection:Section;
		
		private var _history:History;
		
		private var _sections:Vector.<Section>;
		private var _currentSection:Section;
		
		public function Navigation( p_app:ApplicationViewController )
		{
			super( null );
			
			app = p_app;
			
			ids = new Object( );
			arIds = new Vector.<String>( );
			_history = new History( app );
			
			if( app is Section ) _history.pushState( currentActiveSections, "", [ ] );
		}
		
		public function get history( ):History
		{
			return _history;
		}
		
		public function get lastOpenedSection( ):Section
		{
			if( currentActiveSections.length == 0 )
			{
				return null;
			}
			
			return currentActiveSections[ currentActiveSections.length - 1 ];
		}
		
		public function get sections( ):Vector.<Section>
		{
			if( !_sections )
			{
				var sectionModel:SectionModel;
				var section:Section;
				
				_sections = new Vector.<Section>( );
				
				for each( sectionModel in app.model.sections.sections )
				{
					section = new Section( null, sectionModel, app );
					
					ids[ section.id ] = section;
					arIds.push( section.id );
					_sections.push( section );
					
				}
			}
			
			return _sections;
		}
		
		public function get sectionsLayer( ):Sprite
		{
			if( app.model.sections.layerName != "" )
			{
				return app.layers.getLayer( app.model.sections.layerName );
			}
			
			return app.container;
		}
		
		public function get currentActiveSections( ):Vector.<Section>
		{
			if( !openedSections ) openedSections = new Vector.<Section>( );
			return openedSections;
		}
		
		public function closeSection( p_section:* ):Sequence
		{
			var section:Section = p_section is Section? p_section: getSectionByID( p_section );
			var closer:SectionsCloser;
			var i:int;
			
			app.log( LogLevel.INFO_3 );
			
			if( section )
			{
				i = openedSections.indexOf( section );
				if( i != -1 )
				{
					var temp:Vector.<Section>;
					
					temp = new Vector.<Section>( );
					temp.push( section );
					closer = new SectionsCloser( temp );
					
					app.log( LogLevel.INFO_3, "Removing section '" + section.id + "' from active list" ); 
					
					openedSections.splice( i, 1 );
					
					closer.execute( );
					
					return closer;
				}
			}
			
			return null;
		}
		
		public function closeAllActiveSections( p_order:Array = null, p_parallel:Boolean = true, p_delays:Vector.<uint> = null ):Sequence
		{
			var sectionsToClose:Vector.<Section> = new Vector.<Section>( );
			var section:Section;
			
			app.log( LogLevel.INFO_3 );
			
			for each( section in currentActiveSections )
			{
				if( section.sectionModel.closeOnNavigate )
				{
					sectionsToClose.push( section );
				}
			}
			
			return closeSections( sectionsToClose, p_order, p_parallel, p_delays );
		}
		
		public function closeSections( p_sections:Vector.<Section>, p_order:Array = null, p_parallel:Boolean = true, p_delays:Vector.<uint> = null ):Sequence
		{
			var sectionsToClose:Vector.<Section> = new Vector.<Section>( );
			var closer:SectionsCloser;
			var section:Section;
			
			p_sections = p_sections.concat( );
			
			app.log( LogLevel.INFO_3, p_sections );
			
			for each( section in p_sections )
			{
				if( openedSections.indexOf( section ) != -1 )
				{
					sectionsToClose.push( section );
				}
			}
			
			closer = new SectionsCloser( sectionsToClose.concat( ), p_order, p_parallel, p_delays );
			subtractSectionsFromOpened( sectionsToClose );
			
			closer.execute( );
			
			return closer;
		}
		
		private function subtractSectionsFromOpened( sectionsToSubtract:Vector.<Section> ):void
		{
			var i:int;
			
			if( !openedSections ) openedSections = new Vector.<Section>( );
			
			while( openedSections.length > 0 && sectionsToSubtract.length > 0 )
			{
				i = openedSections.indexOf( sectionsToSubtract.shift( ) );
				
				if( i != -1 )
				{
					openedSections.splice( i, 1 );
				}
			}
		}
		
		private function spliceOpenedSection( section:Section ):void
		{
			var i:int = openedSections.indexOf( section );
			
			if( i != -1 )
			{
				openedSections.splice( i, 1 );
			}
		}
		
		public function get sectionsIDs( ):Vector.<String>
		{
			return new Vector.<String>( ).concat( arIds );
		}
		
		public function getSectionByID( p_id:String ):Section
		{
			if( !ids ) return null;
			return ids[ p_id ];
		}
		
		public function getCurrentSection( ):Section
		{
			return _currentSection;
		}
		
		//TODO: tratar melhor os params
		public function openSection( params:*, ... extraArguments ):Section
		{
			app.log( LogLevel.INFO_3, params );
			
			var sectionTransition:NavigateParams = new NavigateParams( );
			var section:Section;
			
			sectionTransition = NavigateParams.fillTransitionParams( params, sectionTransition, this.app );
			
			section = sectionTransition.section;
			sectionTransition.extraArguments = sectionTransition.extraArguments || extraArguments;
			
			if( !section ) 
			{
				return null;
			}
			
			section.alterLayer = sectionTransition.container;
			
			if( !openedSections ) openedSections = new Vector.<Section>( );
			if( openedSections.indexOf( section ) != -1 ) return section;
			
			app.log( LogLevel.INFO_3, section.id, extraArguments );
			
			if( sectionTransition.setAsCurrent ) sectionTransition.sectionsToCloseAfter = new Vector.<Section>( ).concat( currentActiveSections );
			
			if( !dictTransitions ) dictTransitions = new Dictionary( );
			
			dictTransitions[ section ] = sectionTransition;
			
			if( section.sectionModel.type == SectionType.DEFAULT && section.mainApplication.lockStageDuringTransitions )
			{
				section.mainApplication.container.stage.mouseChildren = false;
				section.addEventListener( SectionEvent.VIEW_OPEN_COMPLETE, onSectionViewOpen );
			}
			
			if( section.sectionModel.type == SectionType.DEFAULT ) dispatchChange( section );
			else
			{
				dictTransitions[ section ] = null;
				delete dictTransitions[ section ];
			}
			
			if( section.sectionModel.type == SectionType.DEFAULT && sectionTransition.closeCurrentBeforeOpen && hasSectionsToCloseOnNavigate( ) )
			{
				doCloseCurrentSection( sectionTransition );
				return section;
			}
			else
			{
				app.log( LogLevel.INFO_3, "Going to load section '" + section.id + "'" );
				
				doLoadSection( section );
				if( section.sectionModel.type.toLowerCase( ) != SectionType.DEFAULT )
				{
					return section;
				}
			}
			
			app.log( LogLevel.INFO_3, "Pushing section to active sections: " + section.id );
			openedSections.push( section );
			
			if( !sectionTransition.preserveHistory )
			{
				history.cut( );
				history.pushState( openedSections, this._currentSection? this._currentSection.id: "", extraArguments );
			}
			
			return section;
		}
		
		private function dispatchChange( toSection:Section ):void
		{
			var e:NavigationEvent = new NavigationEvent( NavigationEvent.CHANGE );
			
			if( toSection != lastChangeSection )
			{
				app.log( LogLevel.INFO_3, "Changing to: " + toSection.id );
				
				e.section = toSection;
				lastChangeSection = toSection;
				
				this.dispatchEvent( e );
			}
		}
		
		private function onSectionViewOpen( evt:SectionEvent ):void
		{
			var section:Section = evt.target as Section;
			section.removeEventListener( SectionEvent.VIEW_OPEN_COMPLETE, onSectionViewOpen );
			
			section.mainApplication.container.stage.mouseChildren = true;
		}
		
		public function hasOpenedSections( ):Boolean
		{
			return currentActiveSections.length > 0;
		}
		
		public function hasSectionsToCloseOnNavigate( ):Boolean
		{
			if( hasOpenedSections( ) )
			{
				var section:Section;
				
				for each( section in currentActiveSections )
				{
					if( section.sectionModel.closeOnNavigate ) return true;
				}
				
				return false;
			}
			
			return false;
		}
		
		private function doCloseCurrentSection( sectionTransition:NavigateParams = null ):void
		{
			var trans:Sequence;
			
			app.log( LogLevel.INFO_3 );
			
			trans = closeAllActiveSections( );
			
			if( trans && !trans.completed )
			{
				dictTransitions[ trans ] = sectionTransition;
				trans.addEventListener( SequenceEvent.TRANSITION_COMPLETE, handleCloseCurrentComplete );
			}
			else
			{
				handleCloseCurrentComplete( null, sectionTransition );
			}
		}
		
		private function handleCloseCurrentComplete( evt:SequenceEvent = null, sectionTransition:NavigateParams = null ):void
		{
			var trans:Sequence;
			
			if( evt )
			{
				trans = evt.target as Sequence;
				trans.removeEventListener( SequenceEvent.TRANSITION_COMPLETE, handleCloseCurrentComplete );
				
				sectionTransition = dictTransitions[ trans ];
				dictTransitions[ trans ] = null;
				delete dictTransitions[ trans ];
			}
			
			app.log( LogLevel.INFO_3, evt, sectionTransition );
			
			openSection.apply( null, [ sectionTransition ].concat( sectionTransition.extraArguments ) );
		}
		
		private function doLoadSection( section:Section ):void
		{
			app.log( LogLevel.INFO_3 );
			
			if( !section.isLoaded )
			{
				section.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, handleSectionLoadComplete );
				section.loadDependencies( );
			}
			else
			{
				doOpenSection( section );
			}
		}
		
		private function handleSectionLoadComplete( evt:Event ):void
		{
			var section:Section = evt.target as Section;
			var sectionTrans:NavigateParams = this.dictTransitions[ section ];
			
			section.removeEventListener( DependenciesProgressEvent.LOAD_COMPLETE, handleSectionLoadComplete );
			doOpenSection( section );
		}
		
		private function doOpenSection( section:Section ):void
		{
			app.log( LogLevel.INFO_3,  "Opening section '" + section.id + "'" );
			
			if( section.sectionModel.type == SectionType.URL )
			{
				navigateToURL( new URLRequest( section.sectionModel.href ), section.sectionModel.target );
				return;
			}
			else if( section.sectionModel.type == SectionType.JAVASRIPT )
			{
				navigateToURL( new URLRequest( "javascript:" + section.sectionModel.method ), section.sectionModel.target );
				return;
			}
			
			var sectionTransition:NavigateParams = dictTransitions[ section ];
			var sectionsToClose:Vector.<Section>;
			var sectionToClose:Section;
			
			delete dictTransitions[ section ];
			
			if( sectionTransition.setAsCurrent && !sectionTransition.closeCurrentBeforeOpen )
			{
				sectionsToClose = new Vector.<Section>( );
				
				for each( sectionToClose in currentActiveSections )
				{
					if( section != sectionToClose )
					{
						sectionsToClose.push( sectionToClose );
					}
				}
			}
			
			if( sectionsToClose && sectionsToClose.length > 0 )
			{
				this.closeSections( sectionsToClose ).queue( function( ):void
				{
					section.sounds.playAllAutoPlays( );
					section.openView.apply( null, [ sectionTransition.withSubSection ].concat( sectionTransition.extraArguments ) );
				} );
			}
			else
			{
				section.sounds.playAllAutoPlays( );
				section.openView.apply( null, [ sectionTransition.withSubSection ].concat( sectionTransition.extraArguments ) );
			}
			
			sectionsToClose = null;
		}
		
		public function dispose( ):void
		{
			var section:Section;
			
			app.log( LogLevel.INFO_3, app.model.id );
			
			for each( section in sections )
			{
				section.dispose( );
			}
			
			_sections = null;
		}
		
		public function reset( ):void
		{
			openedSections = new Vector.<Section>( );
			_currentSection = null;
		}
	}
}