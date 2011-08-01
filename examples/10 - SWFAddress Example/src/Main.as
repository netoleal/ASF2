package 
{
	import asf.core.app.ASF;
	import asf.core.elements.Section;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.events.NavigationEvent;
	import asf.plugins.loadermax.LoaderMaxFactoryPlugin;
	import asf.utils.Align;
	import asf.view.BaseLoaderApplication;
	
	import com.LeonardoPinho.events.ResultEvents;
	import com.LeonardoPinho.asf.events.AppEvent;

	import com.projeto.Loading;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import projectPages.view.IndexView;
	import projectPages.viewControllers.PreloadViewController;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF")]
	public class Main extends BaseLoaderApplication
	{
		private var _preload:PreloadViewController;
		
		public function Main()
		{
			super( new LoaderMaxFactoryPlugin( ) );
						
			//preload
			_preload = new PreloadViewController( new Loading( ) );
			
			app.params.defaults.config = "../xml/application.xml";
			
			loadApplicationConfigFile( new URLRequest( app.params.config ) );
			
			app.navigation.addEventListener( NavigationEvent.CHANGE, onAppNavigationChange );
			
			this.addChild( app.view );			
			
		}
		
		protected override function appConfigFileLoaded(event:Event):void
		{
			app.layers.loading.addChild( _preload.view );				
		}
		
		protected override function appWillDispatchLoadComplete(event:Event):void
		{
			_preload.animateOut( );
		}
		
		protected override function appWillLoadDependencies(event:Event):void
		{
					
		}
		
		protected override function appLoadComplete(event:DependenciesProgressEvent):void
		{
			_preload.animateOut( );
		}
		
		protected override function appLoadProgress(event:DependenciesProgressEvent):void
		{
			_preload.setProgress( event.bytesLoaded / event.bytesTotal );
		}
		
		protected override function appLoadStart(event:DependenciesProgressEvent):void
		{
			_preload.setProgress( 0 );
			_preload.animateIn( );
		}
		
		private function onAppNavigationChange( evt:NavigationEvent ):void
		{
			var section:Section = evt.section;
			section.addEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionLoad );
			
			if (section.id != "indexSection" && section.id != "navSection") 
			{
				//log(section.id);
				app.dispatchEvent(new ResultEvents(AppEvent.CURRENT_SECTION, false, false, section.id ));
			}			
		}
		
		protected function onSectionLoad(event:ApplicationEvent):void
		{
			var section:Section = event.target as Section;
			
			section.removeEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionLoad );
			
			section.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, appLoadProgress );
			section.addEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, appWillDispatchLoadComplete );
			
			section.pauseLoading( );
			
			_preload.setProgress( 0 );
			_preload.animateIn( ).queue( section.resumeLoading );
			
		}
	}
}