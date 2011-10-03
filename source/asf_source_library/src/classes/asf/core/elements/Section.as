/*
Class: asf.core.elements.Section
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
	import asf.core.app.ASF;
	import asf.core.models.sections.SectionModel;
	import asf.core.models.sections.SectionType;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.events.SectionEvent;
	import asf.events.SequenceEvent;
	import asf.interfaces.IAnalyticsPlugin;
	import asf.interfaces.ISectionView;
	import asf.interfaces.ISequence;
	import asf.log.LogLevel;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	[Event( name="viewOpenComplete", type="asf.events.SectionEvent" )]
	[Event( name="close", type="asf.events.SectionEvent" )]
	
	/**
	 * Essa classe é a representação funcional do nó "section" do XML de configurações.
	 * Ela também é considerada uma aplicação
	 *  
	 * @author neto.leal
	 * 
	 */
	public class Section extends ApplicationViewController
	{
		private var _app:ApplicationViewController;
		private var _transitionSubSection:Section;
		private var _openSequence:Sequence;
		
		public var alterLayer:Sprite;
		
		/**
		 * Construtor. Você normalmente não vai nunca precisar criar instâncias dessa classe. O Framework faz todo o trabalho de ler o XML e criar as seções preenchendo-as com os modelos certos e tratando de tudo. Entretando você vai precisar usá-la para ter acesso a todos os recursos de uma seção como dependências, estilos, sons, navegação etc
		 *  
		 * @param p_view View da seção. Normalmente esse parâmetro inicia nulo e só depois é preenchido
		 * @param p_model Modelo de dados da seção
		 * @param p_parentApplication Seção ou Aplicação pai dessa seção.
		 * 
		 */
		public function Section( p_view:*, p_model:SectionModel, p_parentApplication:ApplicationViewController )
		{
			_app = p_parentApplication;
			
			super( p_view, _app.loaderFactory, p_model.id, p_model.getRawData( ), _app.loaderInfo );
			
			_openSequence = new Sequence( );
			this._model = p_model;
		}
		
		/**
		 * Fecha a seção dentro da navegação da applicação/seção pai
		 *  
		 * @return Objeto Sequence 
		 * 
		 */
		public function close( ):Sequence
		{
			return this.application.navigation.closeSection( this );
		}
		
		/**
		 * Retorna a seção ou aplicação pai dessa seção.
		 *  
		 * @return 
		 * 
		 */
		public function get application( ):ApplicationViewController
		{
			return _app;
		}
		
		/**
		 * Retorna a aplicação principal. A pai de todas
		 *  
		 * @return 
		 * 
		 */
		public function get mainApplication( ):ASF
		{
			var p:ApplicationViewController = this;
			
			while( p is Section )
			{
				p = ( p as Section ).application;
			}
			
			return p as ASF;
		}
		
		/**
		 * Retorna a layer da aplicação pai dessa seção onde essa seção deve ser adicionada
		 *  
		 * @return 
		 * 
		 */
		public function get layer( ):Sprite
		{
			if( alterLayer ) return alterLayer;
			return sectionModel.layerName != ""? this.application.layers.getLayer( sectionModel.layerName ): this.application.navigation.sectionsLayer;
		}
		
		/**
		 * Executa a rotina de abertura da View da seção
		 *  
		 * @param withSubSection Caso informado, já inicia a seção com uma subseção aberta. Este parâmetro recebe um ID ou um objeto Section da subseção
		 * @param extraArgs Parâmetros extras a serem passados para a view no init
		 * @return 
		 * 
		 */
		public function openView( withSubSection:* = "", ... extraArgs ):Sequence
		{
			var Klass:Class = getDefinitionByName( this.sectionModel.viewClassName ) as Class;
			var view:ISectionView = new Klass( ) as ISectionView;
			var openTrans:Sequence;
			
			_openSequence.notifyStart( );
			
			_transitionSubSection = null;
			
			log( LogLevel.INFO_3, id, withSubSection );
			
			if( withSubSection != "" )
			{
				if( withSubSection is String ) _transitionSubSection = this.navigation.getSectionByID( withSubSection );
				else if( withSubSection is Section ) _transitionSubSection = withSubSection;
			}
			
			this.setView( view );
			this.layer.addChild( view as DisplayObject );
			
			view.init.apply( null, [ this ].concat( extraArgs ) );
			
			openTrans = view.open( ) as Sequence;
			
			if( openTrans && !openTrans.completed )
			{
				openTrans.addEventListener( SequenceEvent.TRANSITION_COMPLETE, dispatchViewOpen );
			}
			else
			{
				dispatchViewOpen( null );
			}
			
			return _openSequence;
		}
		
		private function dispatchViewOpen( evt:SequenceEvent ):void
		{
			if( evt ) ( evt.target as Sequence ).removeEventListener( SequenceEvent.TRANSITION_COMPLETE, dispatchViewOpen );
			
			log( LogLevel.INFO_3, id );
			
			this.dispatchEvent( new SectionEvent( SectionEvent.VIEW_OPEN_COMPLETE ) );
			
			if( _transitionSubSection )
			{
				var subSection:Section = this.navigation.openSection( _transitionSubSection );
				if( subSection )
				{
					subSection.addEventListener( SectionEvent.VIEW_OPEN_COMPLETE, onSubSectionViewOpen );
				}
				else
				{
					_openSequence.notifyComplete( );
				}
			}
			else
			{
				_openSequence.notifyComplete( );
			}
		}
		
		private function onSubSectionViewOpen(event:Event):void
		{
			_openSequence.notifyComplete( );
			_transitionSubSection = null;
		}
		
		/**
		 * Retorna se a seção está ou não atualmente aberta 
		 * @return 
		 * 
		 */
		public function get isActive( ):Boolean
		{
			return this.application.navigation.currentActiveSections.indexOf( this ) != -1;
		}
		
		/**
		 * Retorna o modelo de dados da seção
		 *  
		 * @return 
		 * 
		 */
		public function get sectionModel( ):SectionModel
		{
			return this._model as SectionModel;
		}
		
		/**
		 * ID da seção
		 *  
		 * @return 
		 * 
		 */
		public function get id( ):String
		{
			return sectionModel.id;
		}
		
		/**
		 * Stage principal da aplicação
		 *  
		 * @return 
		 * 
		 */
		public override function get stage():Stage
		{
			return mainApplication.container.stage;
		}
		
		public override function get analyticsPlugin():IAnalyticsPlugin
		{
			return mainApplication.analyticsPlugin;
		}
		
		/**
		 * Indica se está ou não carregada
		 *  
		 * @return 
		 * 
		 */
		public override function get isLoaded():Boolean
		{
			if( this.sectionModel.type != SectionType.DEFAULT ) return true;
			return super.isLoaded;
		}
		
		/**
		 * Libera memória usada por esta seção e descarrega as dependências 
		 * 
		 */
		public override function dispose( ):void
		{
			if( this.view )
			{
				( this.view as ISectionView ).dispose( );
			}
			
			if( !this.sectionModel.keepDependencies )
			{
				this.dependencies.clear( );
			}
			
			alterLayer = null;
			
			super.dispose( );
		}
		
		public override function toString( ):String
		{
			return "[Section '" + this.id + "']";
		}
	}
}