/*
Class: asf.core.viewcontrollers.AbstractApplicationViewController
Author: Neto Leal
Created: Apr 13, 2011

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
package asf.core.viewcontrollers
{
	import asf.core.app.ASF;
	import asf.core.config.ApplicationParameters;
	import asf.core.elements.Layers;
	import asf.core.elements.LocalizedDictionary;
	import asf.core.elements.Navigation;
	import asf.core.elements.Section;
	import asf.core.elements.Sounds;
	import asf.core.elements.Styles;
	import asf.core.loading.DependenciesLoader;
	import asf.core.media.SoundTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.dictionary.DictionaryModel;
	import asf.core.models.sounds.SoundModel;
	import asf.core.models.styles.StyleModel;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.events.SectionEvent;
	import asf.interfaces.IAnalyticsPlugin;
	import asf.interfaces.ILoaderFactoryPlugin;
	import asf.interfaces.ILoaderPlugin;
	import asf.log.LogLevel;
	import asf.log.Logger;
	import asf.utils.XMLUtils;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event( type="asf.events.ApplicationEvent", name="configFileLoaded" )]
	[Event( type="asf.events.ApplicationEvent", name="willLoadDependencies" )]
	[Event( type="asf.events.ApplicationEvent", name="willDispatchLoadComplete" )]
	[Event( type="asf.events.ApplicationEvent", name="dependenciesUnload" )]
	[Event( type="asf.events.ApplicationEvent", name="dispose" )]
	[Event( type="asf.events.DependenciesProgressEvent", name="loadProgress" )]
	[Event( type="asf.events.DependenciesProgressEvent", name="loadComplete" )]
	[Event( type="asf.events.DependenciesProgressEvent", name="loadStart" )]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	/**
	 * 
	 * @author neto.leal
	 * 
	 */
	public class ApplicationViewController extends AbstractViewController
	{
		private static var count:uint = 0;
		protected static var instances:Object;
		
		protected var _model:ApplicationModel;
		protected var isModelLoaded:Boolean = false;
		
		private var _dependencies:DependenciesLoader;
		private var _layers:Layers;
		private var _dictionary:LocalizedDictionary;
		private var _styles:Styles;
		private var _loaderInfo:LoaderInfo;
		private var _navigation:Navigation;
		private var _sounds:Sounds;
		private var _logger:Logger;
		private var _assets:Object;
		private var _sharedObject:SharedObject;
		private var _metrics:XML;
		private var _analytics:IAnalyticsPlugin;
		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		
		private var preventFromLoadDependencies:Boolean = false;
		
		private var modelLoader:URLLoader;
		private var loader:ILoaderFactoryPlugin;
		
		private var loadingSections:Vector.<Section>;
		
		/**
		 * Construtor. Mesmos parâmetros que o ASF
		 * 
		 * @param p_view Instância do container principal onde a estrutura da aplicação deve ser criada. Pode ser qualquer objeto desde que seja um DisplayObjectContainer
		 * @param p_loader Uma instância de uma classe que implemente a interface ILoaderFactoryPlugin.
		 * @param p_id Identificação da Aplicação
		 * @param p_model Um XML estático. Você pode optar por usar o XML estático incorporado ao código ao invés de carregar o XML dinamicamente. 
		 * @param p_loaderInfo LoaderInfo para ser usado como base de onde buscar os FlashVars que servirão como base de parâmetros da aplicação
		 */
		public function ApplicationViewController( p_view:*, p_loader:ILoaderFactoryPlugin, p_id:String = "", p_model:XML = null, p_loaderInfo:LoaderInfo = null )
		{
			super( p_view );
			
			_model = new ApplicationModel( p_model, p_loaderInfo );
			_loaderInfo = p_loaderInfo;
			loader = p_loader;
			
			logLevel = LogLevel.ERROR_1;
			
			if( !instances ) instances = new Object( );
			if( p_id == "" ) p_id = "ASF_" + count;
			
			instances[ p_id ] = this;
			
			if( p_model != null )
			{
				initializeMembers( );
			}
			
			count++;
		}
		
		/**
		 * Método útil para armazenar objetos e variáveis para mais à frente resgata-los em qualquer ponto da aplicação
		 *  
		 * @param id ID de armazenamento
		 * @param asset O objeto ou variável que você quer guardar
		 * @return O próprio asset guardado
		 * 
		 */
		public function registerAsset( id:String, asset:* ):*
		{
			if( !_assets ) _assets = new Object( );
			_assets[ id ] = asset;
			
			return asset;
		}
		
		/**
		 * Retorna um asset armazenado anteriormente
		 *  
		 * @param id O ID do asset que você deseja resgatar
		 * @return O Asset guardado caso o ID seja válido
		 * @see registerAsset
		 * 
		 */
		public function requestAsset( id:String ):*
		{
			if( !_assets ) return null;
			return _assets[ id ];
		}
		
		/**
		 * Você pode usar essa propriedade para guardar objetos entre sessões do usuário. Funciona como um cookie
		 *  
		 * @return SharedObject
		 * 
		 */
		public function get sharedObject( ):SharedObject
		{
			if( !_sharedObject )
			{
				_sharedObject = SharedObject.getLocal( this.model.id );
			}
			
			return _sharedObject;
		}
		
		/**
		 * Instância do objeto de log da aplicação
		 * 
		 * @return 
		 * 
		 */
		public function get logger( ):Logger
		{
			if( !_logger ) _logger = new Logger( );
			return _logger;
		}
		
		/**
		 * Os níveis válidos são:
		 * <br><br>
		 * 0 - Não exibe nenhuma mensagem<br>
		 * 1 - Só exibe erros<br>
		 * 2 - Exibe erros e avisos<br>
		 * 3 - Exibe erros, avisos e informações<br>
		 *   
		 * @param level
		 * 
		 */
		public function set logLevel( level:int ):void
		{
			logger.level = level;
		}
		
		public function get logLevel( ):int
		{
			return logger.level;
		}
		
		/**
		 * Exibe uma mensagem no console
		 * 
		 * @param level Nível da mensagem
		 * @param args Mensagem a ser exibida
		 * 
		 */
		public function log( level:int = LogLevel.INFO_3, ... args ):String
		{
			return logger.log( args, level );
		}
		
		/**
		 * Retorna o LoaderInfo da aplicação
		 *  
		 * @return LoaderInfo instance
		 * 
		 */
		public function get loaderInfo( ):LoaderInfo
		{
			return _loaderInfo;
		}
		
		/**
		 * Retorna o objeto atual de criação de Loaders
		 *  
		 * @return 
		 * 
		 */
		public function get loaderFactory( ):ILoaderFactoryPlugin
		{
			return loader;
		}
		
		/**
		 * O container principal dessa aplicação
		 *  
		 * @return 
		 * 
		 */
		public function get container( ):Sprite
		{
			return this.viewAsSprite;
		}
		
		/**
		 * Retorna o stage, caso exista
		 *  
		 * @return 
		 * 
		 */
		public function get stage( ):Stage
		{
			return container.stage;
		}
		
		/**
		 * Retorna uma aplicação ativa. Pode ser um ASF ou uma Section
		 *  
		 * @param id O ID da aplicação desejada
		 * @return A instância da aplicação. Você pode fazer coisas como: ApplicationViewController.getByID( "secaoHome" ) as Section
		 * 
		 */
		public static function getByID( id:String ):ApplicationViewController
		{
			return instances[ id ];
		}
		
		public static function getActiveInstances( ):Vector.<ApplicationViewController>
		{
			var k:String;
			var res:Vector.<ApplicationViewController> = new Vector.<ApplicationViewController>( );
			
			for( k in instances )
			{
				res.push( instances[ k ] );
			}
			
			return res;
		}
		
		/**
		 * Carrega o XML com as configurações da aplicação 
		 * @param url A URL do arquivo XML a ser carregado. O arquivo deve seguir as especificações do Framework 
		 * 
		 */		
		public function loadModel( url:URLRequest ):void
		{
			if( !modelLoader )
			{
				modelLoader = new URLLoader( );
				
				modelLoader.addEventListener( Event.COMPLETE, handleModelComplete );
			}
			
			log( LogLevel.INFO_3, url );
			
			modelLoader.load( url );
		}
		
		private function handleModelComplete( evt:Event ):void
		{
			_model.setRawData( new XML( modelLoader.data ) );
			model.refreshParams( );
			instances[ model.id ] = this;
			
			initializeMembers( );
			
			this.dispatchEvent( new ApplicationEvent( ApplicationEvent.CONFIG_FILE_LOADED ) );
		}
		
		private function initializeMembers( ):void
		{
			var dict:DictionaryModel;
			var style:StyleModel;
			var soundModel:SoundModel;
			
			var section:Section;
			
			isModelLoaded = true;
			_dependencies = new DependenciesLoader( this.loader.create( ), this.model, this );
			
			if( this.model.metrics )
			{
				_dependencies.addFileToQueue( this.model.metrics );
			}
			
			for each( soundModel in this.model.sounds.sounds )
			{
				if( soundModel.type == SoundTypes.URL && !soundModel.isStream )
				{
					_dependencies.addFileToQueue( soundModel.file );
				}
			}
			
			for each( dict in this.model.dictionaries )
			{
				_dependencies.addFileToQueue( dict.file );
			}
			
			for each( style in this.model.styles.styles )
			{
				if( style.file )
				{
					_dependencies.addFileToQueue( style.file );
				}
			}
			
			loadingSections = new Vector.<Section>( );
			
			for each( section in this.navigation.sections )
			{
				if( section.sectionModel.loadAtStart )
				{
					section.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onDependenciesLoadProgress );
					section.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onDependenciesLoadComplete );
					
					loadingSections.push( section );
				}
			}
			
			_dependencies.addEventListener( ProgressEvent.PROGRESS, onDependenciesLoadProgress );
			_dependencies.addEventListener( Event.COMPLETE, onDependenciesLoadComplete );
			_dependencies.addEventListener( IOErrorEvent.IO_ERROR, onDependenciesIOError );
		}
		
		private function onDependenciesIOError( evt:IOErrorEvent ):void
		{
			this.log( LogLevel.ERROR_1, this.model.id, evt.text );
			this.dispatchEvent( evt );
		}
		
		/**
		 * Inicia o carregamento das dependências 
		 * 
		 */
		public function loadDependencies( ):void
		{
			var section:Section;
			
			this.dispatchEvent( new ApplicationEvent( ApplicationEvent.WILL_LOAD_DEPENDENCIES ) );
			
			if( !preventFromLoadDependencies )
			{
				for each( section in loadingSections )
				{
					section.loadDependencies( );
				}
				
				_dependencies.load( );
				
				this.dispatchEvent( new DependenciesProgressEvent( DependenciesProgressEvent.LOAD_START ) );
			}
		}
		
		/**
		 * Define o plugin de métricas
		 *  
		 * @param value
		 * 
		 */
		public function set analyticsPlugin( value:IAnalyticsPlugin ):void
		{
			this._analytics = value;
		}
		
		public function get analyticsPlugin( ):IAnalyticsPlugin
		{
			return this._analytics;
		}
		
		/**
		 * Retorna o XML de métricas carregado e definido no XML de configurações 
		 * @return 
		 * 
		 */
		public function get metrics( ):XML
		{
			if( model.metrics && !_metrics )
			{
				_metrics = this.dependencies.getXML( model.metrics.id );
			}
			
			return _metrics;
		}
		
		/**
		 * Executa o trackAnalytics no Plugin de métricas.
		 * Exemplo:<br>
		 * <br>
		 * app.trackAnalytics( app.metrics.asf.sample.home.navigate, nextSection.id );<br>
		 * <br>
		 * ou<br>
		 * <br>
		 * app.trackAnalytics( "navigate", nextSection.id<br>
		 *  <br>
		 * @param metricNode O Nó XML ou ID do nó com a métrica a ser executada
		 * @param replaces Valores para servirem de variáveis e substituírem os %s dentro da métrica
		 * @return A URI da métrica aplicada ou vazi no caso de métrica inválida
		 * 
		 */
		public function trackAnalytics( metricNode:*, ... replaces ):String
		{
			if( metricNode == null ) return "";
			
			//trace( log( LogLevel.MUTE_0, analyticsPlugin, metricNode, replaces ) );
			
			if( analyticsPlugin )
			{
				var uri:String = "";
				
				switch( true )
				{
					case metricNode is XML:
					case metricNode is XMLList:
					{
						var n:uint = 0;
						uri = XMLUtils.getNodePath( metricNode );
						
						if( String( metricNode.@uri ) != "" )
						{
							uri = metricNode.@uri;
						}
						
						break;
					}
					case metricNode is String:
					{
						metricNode = XMLUtils.findNode( metricNode, this.metrics );
						return trackAnalytics.apply( null, [ metricNode ].concat( replaces ) );  
					}
				}
				
				while( uri.indexOf( "%s" ) != -1 && n < replaces.length ) uri = uri.replace( "%s", replaces[ n++ ] );
				analyticsPlugin.track( uri );
				
				return uri;
			}
			
			return "";
		}
		
		/**
		 * Todos os sons dessa aplicação o seção 
		 * @return Sounds Instância contendo os sons
		 * 
		 */
		public function get sounds( ):Sounds
		{
			if( !_sounds ) _sounds = new Sounds( this );
			return _sounds;
		}
		
		/**
		 * O objeto de navegação dessa aplicação. Use esse objeto para fazer a troca de seções
		 * Exemplo:<br>
		 * <br>
		 * app.navigation.openSection( "home" );<br>
		 *  <br>
		 * @return Navigation instância para ser usada como manipuladora de seções ativas
		 * 
		 */
		public function get navigation( ):Navigation
		{
			if( !_navigation ) 
			{
				_navigation = new Navigation( this );
			}
			
			return _navigation;
		}
		
		/**
		 * Todas as layers dentro dessa aplicação.
		 *   
		 * @return Layers object with all created layers
		 * 
		 */
		public function get layers( ):Layers
		{
			if( !_layers ) _layers = new Layers( this.view, this.model.layers );
			return _layers;
		}
		
		/**
		 * O dicionário de textos
		 *  
		 * @return LocalizedDictionary
		 * 
		 */
		public function get dictionary( ):LocalizedDictionary
		{
			return _;
		}
		
		/**
		 * A mesma coisa que .dictionary. Apenas um atalho útil
		 *  
		 * @return 
		 * @see dictionary
		 * 
		 */
		public function get _( ):LocalizedDictionary
		{
			if( !_dictionary ) _dictionary = new LocalizedDictionary( model.dictionaries, dependencies );
			return _dictionary;
		}
		
		/**
		 * Todos os estilos da aplicação
		 *  
		 * @return Styles object
		 * @see asf.core.elements.Styles
		 * 
		 */
		public function get styles( ):Styles
		{
			if( !_styles ) _styles = new Styles( this.model.styles, this );
			return _styles;
		}
		
		protected function onDependenciesLoadProgress( evt:ProgressEvent ):void
		{
			var bLoaded:Number = dependencies.getBytesLoaded( );
			var bTotal:Number = dependencies.getBytesTotal( );
			var e:DependenciesProgressEvent;
			var section:Section;
			
			for each( section in loadingSections )
			{
				bLoaded += section.bytesLoaded;
				bTotal += section.bytesTotal;
			}
			
			this._bytesLoaded = bLoaded;
			this._bytesTotal = bTotal;
			
			e = new DependenciesProgressEvent( DependenciesProgressEvent.LOAD_PROGRESS, evt.bubbles, evt.cancelable, bLoaded, bTotal );
			this.dispatchEvent( e );
		}
		
		protected function onDependenciesLoadComplete( evt:Event ):void
		{
			log( );
			
			var wait:Boolean = false;
			var section:Section;
			var loader:ILoaderPlugin = evt.target as ILoaderPlugin;
			
			this.dispatchEvent( new DependenciesProgressEvent( DependenciesProgressEvent.LOAD_PROGRESS, evt.bubbles, evt.cancelable, dependencies.getBytesLoaded( ), dependencies.getBytesTotal( ) ) );
			
			for each( section in loadingSections )
			{
				//log( section.id, section.isLoaded );
				
				if( !section.isLoaded )
				{
					wait = true;
				}
				else
				{
					section.removeEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onDependenciesLoadComplete );
					section.removeEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onDependenciesLoadProgress );
				}
			}
			
			log( LogLevel.INFO_3, "All files loaded" );
			
			if( !wait && this.dependencies.isLoaded( ) )
			{
				loadingSections = null;
				
				if( this is ASF )
				{
					sounds.playAllAutoPlays( );
				}
				
				this.dispatchEvent( new ApplicationEvent( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE ) );
				
				if( !preventFromLoadDependencies )
				{
					this.dispatchLoadComplete( );
				}
			}
		}
		
		private function dispatchLoadComplete( ):void
		{
			log( LogLevel.INFO_3 );
			this.dispatchEvent( new DependenciesProgressEvent( DependenciesProgressEvent.LOAD_COMPLETE, false, false, dependencies.getBytesLoaded( ), dependencies.getBytesTotal( ) ) );
		}
		
		/**
		 * Use esta propriedade para ter acesso a todos os arquivos dependentes carregados para esta aplicação.
		 * Exemplo:
		 * 
		 * var image:Bitmap = app.dependencies.getImage( "wallpaper" );
		 * this.addChild( image );
		 * 
		 * @return 
		 * 
		 */
		public function get dependencies( ):ILoaderPlugin
		{
			return _dependencies != null? _dependencies.loader: null;
		}
		
		/**
		 * Retorna o Modelo de dados desta aplicação
		 *  
		 * @return 
		 * 
		 */
		public function get model( ):ApplicationModel
		{
			return _model;
		}
		
		/**
		 * Te dá acesso a todos os parâmetros da aplicação.
		 * Esses parâmetros podem ser adicionados no XML de configurações ou podem vir pela URL ou FlashVars no HTML.
		 * Para ter acesso aos parâmetros da URL da página, você precisa adicionar o swfaddress.js ao documento
		 *  
		 * @return 
		 * 
		 */
		public function get params( ):ApplicationParameters
		{
			return model.params;
		}
		
		/**
		 * bytes carregados de todas as dependências
		 *  
		 * @return 
		 * 
		 */
		public function get bytesLoaded( ):Number
		{
			return this._bytesLoaded;
		}
		
		/**
		 * bytes total das dependências
		 *  
		 * @return 
		 * 
		 */
		public function get bytesTotal( ):Number
		{
			return this._bytesTotal;
		}
		
		/**
		 * Indica se a aplicação já foi carregada ou não
		 *  
		 * @return 
		 * 
		 */
		public function get isLoaded( ):Boolean
		{
			return this._dependencies != null ? this._dependencies.isLoaded( ) && this.loadingSections == null: false;
		}
		
		/**
		 * Indica se aplicação está carregando
		 *  
		 * @return 
		 * 
		 */
		public function get isLoading( ):Boolean
		{
			return this._dependencies != null ? this._dependencies.isLoading( ): false;
		}
		
		/**
		 * Indica se o carregamento está pausado
		 *  
		 * @return 
		 * 
		 */
		public function get isLoaderPaused( ):Boolean
		{
			return this._dependencies != null ? this._dependencies.isPaused( ): false;
		}
		
		/**
		 * Pausa o carregamento das dependências 
		 * 
		 */
		public function pauseLoading( ):void
		{
			var section:Section;
			
			this.preventFromLoadDependencies = true;
			
			log( LogLevel.INFO_3, model.id );
			
			if( this._dependencies ) this._dependencies.pauseLoading( );
			if( loadingSections )
			{
				for each( section in loadingSections )
				{
					section.pauseLoading( );
				}
			}
		}
		
		/**
		 * Continua o carregamento das dependências
		 *  
		 * @param startIfNotLoading Caso o carregamento das dependências ainda não tenha sido iniciado, esse parâmetro indica se ele deve ou não iniciar.
		 * 
		 */
		public function resumeLoading( startIfNotLoading:Boolean = true ):void
		{
			var section:Section;
			
			this.preventFromLoadDependencies = false;
			
			this.log( LogLevel.INFO_3, model.id );
			
			if( startIfNotLoading && this.dependencies != null && !this.dependencies.isLoaded( ) && !this.dependencies.isLoading( ) && !this.dependencies.isPaused( ) )
			{
				loadDependencies( );
			}
			else
			{
				if( this._dependencies ) this._dependencies.resumeLoading( );
				if( loadingSections )
				{
					for each( section in loadingSections )
					{
						section.resumeLoading( );
					}
				}
			}
		}
		
		/**
		 * Libera memória ocupada por essa aplicação e descarrega as dependências 
		 * 
		 */
		public override function dispose( ):void
		{
			log( LogLevel.INFO_3, model.id );
			
			if( _navigation )
			{
				this._navigation.reset( );
			}
			
			if( _layers )
			{
				this._layers.dispose( );
				this._layers = null;
			}
			
			if( _analytics )
			{
				_analytics.dispose( );
				_analytics = null;
			}
			
			if( dependencies )
			{
				if( !( this is Section ) || !( this as Section ).sectionModel.keepDependencies )
				{
					this._bytesLoaded = 0;
					this._bytesTotal = 0;
					
					this.dispatchEvent( new ApplicationEvent( ApplicationEvent.DEPENDENCIES_UNLOAD ) );
					this.dependencies.clear( );
				}
			}
			
			if( sounds )
			{
				sounds.stopAll( );
			}
			
			super.dispose( );
			this.dispatchEvent( new ApplicationEvent( ApplicationEvent.DISPOSE ) );
		}
	}
}