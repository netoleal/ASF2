/*
Class: asf.core.app.ASF
Author: Neto Leal
Created: Apr 14, 2011

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

-source-path ./classes
-doc-sources .
-output ../docs
-library-path ./swc
-main-title "ASF Framework - Documentation"
-window-title "ASF Framework - Documentation"

*/
package asf.core.app
{
	import asf.core.elements.Section;
	import asf.core.models.app.ASFModel;
	import asf.core.viewcontrollers.ApplicationViewController;
	import asf.debug.DebugPanel;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.interfaces.ILoaderFactoryPlugin;
	import asf.interfaces.IMainController;
	import asf.log.LogLevel;
	
	import com.flashdynamix.utils.SWFProfiler;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * Classe principal do Framework.
	 * Exemplo de utilização:
	 * 
	 * <pre>
	 * 
	 * app = new ASF( new Sprite( ), root.loaderInfo, new LoaderMaxFactoryPlugin( ) );
	 * 
	 * app.addEventListener( DependenciesProgressEvent.LOAD_START, onLoadStart );
	 * app.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onLoadProgress );
	 * app.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onLoadComplete );
	 * 
	 * app.params.defaults.config = "../xml/application.xml";
	 * 
	 * app.loadModel( new URLRequest( app.params.config ) );
	 * addChild( app.view );
	 * </pre>
	 * 
	 * @author neto.leal
	 * 
	 */
	public class ASF extends ApplicationViewController
	{
		private var _mainController:IMainController;
		private var _debugPanel:DebugPanel;
		
		/**
		 * Construtor do Framework. Esta classe representa a Applicação principal do projeto.
		 * Basicamente, esta é a representação funcional do arquivo XML de configurações
		 *  
		 * @param p_view Instância do container principal onde a estrutura da aplicação deve ser criada. Pode ser qualquer objeto desde que seja um DisplayObjectContainer
		 * @param p_loaderInfo LoaderInfo para ser usado como base de onde buscar os FlashVars que servirão como base de parâmetros da aplicação
		 * @param p_loader Uma instância de uma classe que implemente a interface ILoaderFactoryPlugin.
		 * @param p_id Identificação da Aplicação
		 * @param p_model Um XML estático. Você pode optar por usar o XML estático incorporado ao código ao invés de carregar o XML dinamicamente. 
		 * 
		 */
		public function ASF( p_view:*, p_loaderInfo:LoaderInfo, p_loader:ILoaderFactoryPlugin, p_id:String = "", p_model:XML=null )
		{
			super( p_view, p_loader, p_id, p_model, p_loaderInfo );	
			this._model = new ASFModel( p_model, p_loaderInfo, null );
			
			this.addEventListener( ApplicationEvent.CONFIG_FILE_LOADED, onConfigLoaded );
			this.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onDependenciesLoaded );
			
			if( isModelLoaded ) onConfigLoaded( null );
		}
		
		/**
		 * Executa depois que todas as dependências são carregadas.
		 * Nesse momento o Framework tenta executar o método "init" no MainController caso este seja informado no XML de configurações 
		 * @param event
		 * 
		 */
		private function onDependenciesLoaded(event:Event):void
		{
			if( ( this.model as ASFModel ).mainControllerClass )
			{
				_mainController = new ( this.model as ASFModel ).mainControllerClass( );
				_mainController.init( this );
			}
		}
		
		/**
		 * Referência ao IMainController informado no XML de configurações.
		 * Você só poderá utilizar essa instância após o carregamento das dependências.
		 *  
		 * @return IMainController 
		 * 
		 */
		public function get mainController( ):IMainController
		{
			return _mainController;
		}
		
		private function onConfigLoaded( evt:ApplicationEvent ):void
		{
			log( LogLevel.INFO_3 );
			
			this.loadDependencies( );
			
			mountContextMenu( );
			mountDebugPanel( );
		}
		
		private function mountDebugPanel( ):void
		{
			if( this.params.debug == "true" )
			{
				_debugPanel = new DebugPanel( this );
				
				if( container.stage )
				{
					addDebugPanel( );
				}
				else
				{
					container.addEventListener( Event.ADDED_TO_STAGE, addDebugPanel );
				}
			}
		}
		
		public function get debugPanel( ):DebugPanel
		{
			return _debugPanel;
		}
		
		private function addDebugPanel( evt:Event = null ):void
		{
			container.removeEventListener( Event.ADDED_TO_STAGE, addDebugPanel );
			container.stage.addChild( _debugPanel );
		}
		
		/**
		 * Define se a aplicação deve ou não bloquear interações do usuário durante a transição das seções
		 */
		public function get lockStageDuringTransitions( ):Boolean
		{
			return params.lockStageDuringTransitions == "true";
		}
		
		/**
		 * Retorna uma instância ativa de ASF.
		 *   
		 * @param id O ID da aplicação desejada
		 * @return Uma instância caso o ID seja válido
		 * 
		 */
		public static function getByID( id:String ):ASF
		{
			return ApplicationViewController.getByID( id ) as ASF;
		}
		
		public static function getActiveInstances( ):Vector.<ASF>
		{
			var k:String;
			var res:Vector.<ASF> = new Vector.<ASF>( );
			
			for( k in instances )
			{
				if( instances[ k ] is ASF ) res.push( instances[ k ] );
			}
			
			return res;
		}
		
		private function mountContextMenu( ):void
		{
			var context:ContextMenu = new ContextMenu( );
			
			if( this.params.hideContextMenuBuiltIn == "true" )
			{
				context.hideBuiltInItems( );
			}
			
			if( this.params.showContextMenu == "true" )
			{
				var item:ContextMenuItem;
				var section:Section;
				var customItems:Array = new Array( );
				
				log( LogLevel.INFO_3 );
				
				for each( section in this.navigation.sections )
				{
					item = new ContextMenuItem( section.id );
					
					log( LogLevel.INFO_3, section.id );
					
					customItems.push( item );
				}
				
				context.customItems = customItems;
			}
			
			this.container.contextMenu = context;
		}
	}
}