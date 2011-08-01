/*
Class: asf.core.elements.SectionsCloser
Author: Neto Leal
Created: Apr 28, 2011

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
	import asf.core.util.Sequence;
	import asf.events.SectionEvent;
	import asf.events.SequenceEvent;
	import asf.interfaces.ISectionView;
	import asf.log.LogLevel;
	import asf.utils.Delay;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	internal class SectionsCloser extends Sequence
	{
		private var sections:Vector.<Section>;
		private var sectionsInOrder:Vector.<Section>;
		private var order:Array;
		private var parallel:Boolean;
		private var delays:Vector.<uint>;
		private var transitions:Dictionary;
		
		private var closedCount:uint = 0;
		private var closeIndex:uint = 0;
		
		public function SectionsCloser( p_sections:Vector.<Section>, p_order:Array = null, p_parallel:Boolean = true, p_delays:Vector.<uint> = null )
		{
			super( );
			
			transitions = new Dictionary( );
			
			sections = p_sections;
			order = p_order || new Array( );
			parallel = p_parallel;
			delays = p_delays || new Vector.<uint>( sections.length );
		}
		
		public function execute( ):void
		{
			var ids:Array = new Array( );
			var id:String, n:uint = 0, i:int;
			var section:Section;
			var sectionsCopy:Vector.<Section> = sections.concat( );
			var trans:Sequence;
			
			sectionsInOrder = new Vector.<Section>( );
			
			if( sections.length == 0 )
			{
				completeAll( );
				return;
			}
			
			for each( section in sectionsCopy ) ids.push( section.id );
			
			while( order.length > 0 )
			{
				id = order.shift( );
				i = ids.indexOf( id );
				
				if( i != -1 )
				{
					ids.splice( i, 1 );
					sectionsInOrder.push( sectionsCopy[ i ] );
					sectionsCopy.splice( i, 1 );
				}
			}
			
			sectionsInOrder = sectionsInOrder.concat( sectionsCopy );
			
			closeIndex = 0;
			n = 0;
			
			for each( section in sectionsInOrder )
			{
				delays[ n ] = delays[ n ] || 0;
				
				if( parallel )
				{
					Delay.execute( closeSection, delays[ n ], section );
				}
				else
				{
					closeNextSection( );
					break;
				}
				
				n++;
			}
			
			this.notifyStart( );
		}
		
		private function closeNextSection( evt:SequenceEvent = null ):void
		{
			var trans:Sequence;
			
			if( evt )
			{
				trans = evt.target as Sequence;
				trans.removeEventListener( SequenceEvent.TRANSITION_COMPLETE, closeNextSection );
			}
			
			if( closeIndex < sectionsInOrder.length )
			{
				var section:Section = sectionsInOrder[ closeIndex++ ];
				trans = closeSection( section );
				
				if( trans && !trans.completed )
				{
					trans.addEventListener( SequenceEvent.TRANSITION_COMPLETE, closeNextSection );
				}
				else
				{
					closeNextSection( );
				}
			}
		}
		
		private function closeSection( section:Section ):Sequence
		{
			var trans:Sequence;
			var sectionTrans:NavigateParams;
			
			sectionTrans = new NavigateParams( );
			sectionTrans.section = section;
			
			if( section.navigation.currentActiveSections.length > 0 && !section.sectionModel.ignoreChildren )
			{
				trans = section.navigation.closeAllActiveSections( );
				if( trans && !trans.completed )
				{
					transitions[ trans ] = sectionTrans;
					trans.addEventListener( SequenceEvent.TRANSITION_COMPLETE, completeSubSectionCloseTransition );
				}
				else
				{
					completeSubSectionCloseTransition( null, sectionTrans );
				}
			}
			else
			{
				section.log( LogLevel.INFO_3, "Closing section: " + section.id );
				
				trans = ( section.view as ISectionView ).close( ) as Sequence;
				
				if( trans && !trans.completed )
				{
					transitions[ trans ] = sectionTrans;
					trans.addEventListener( SequenceEvent.TRANSITION_COMPLETE, completeSectionCloseTransition );
				}
				else
				{
					completeSectionCloseTransition( null, sectionTrans );
				}
			}
			
			return trans;
		}
		
		private function completeSubSectionCloseTransition( evt:SequenceEvent = null, sectionTrans:NavigateParams = null ):void
		{
			var section:Section;
			var trans:Sequence;
			
			if( evt )
			{
				trans = evt.target as Sequence;
				trans.removeEventListener( SequenceEvent.TRANSITION_COMPLETE, completeSubSectionCloseTransition );
				sectionTrans = transitions[ trans ];
				
				transitions[ trans ] = null;
				delete transitions[ trans ];
			}
			
			section = sectionTrans.section;
			closeSection( section );
		}
		
		private function completeSectionCloseTransition( evt:SequenceEvent = null, sectionTrans:NavigateParams = null ):void
		{
			var section:Section;
			var trans:Sequence;
			
			if( evt )
			{
				trans = evt.target as Sequence;
				trans.removeEventListener( SequenceEvent.TRANSITION_COMPLETE, completeSectionCloseTransition );
				
				sectionTrans = transitions[ trans ];
				
				transitions[ trans ] = null;
				delete transitions[ trans ];
			}
			
			section = sectionTrans.section;
			section.dispatchEvent( new SectionEvent( SectionEvent.CLOSE ) );
			
			section.log( LogLevel.INFO_3, "Section: '" + section.id + "' closed");
			
			if( section.navigation.currentActiveSections.length > 0 )
			{
				disposeSubSections( section );
			}
			
			var view:DisplayObject = section.view;
			var layer:Sprite = section.layer;
			
			section.dispose( );
			layer.removeChild( view );
			
			layer = null;
			view = null;
			
			closedCount++;
			
			if( closedCount == sections.length )
			{
				completeAll( );
			}
		}
		
		private function disposeSubSections( section:Section ):void
		{
			var subsection:Section;
			
			for each( subsection in section.navigation.currentActiveSections )
			{
				if( subsection.navigation.currentActiveSections.length > 0 )
				{
					disposeSubSections( subsection );
				}
				
				subsection.dispose( );
			}
		}
		
		private function completeAll( ):void
		{
			sections = null;
			this.notifyComplete( );
		}
	}
}