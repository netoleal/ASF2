package asf.flow
{
	import asf.core.elements.Navigation;
	import asf.core.elements.Section;
	import asf.events.ApplicationEvent;
	import asf.events.DependenciesProgressEvent;
	import asf.events.FlowEvent;
	import asf.events.NavigationEvent;
	import asf.events.SectionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	[Event(name="showLoading", type="asf.events.FlowEvent")]
	[Event(name="hideLoading", type="asf.events.FlowEvent")]
	[Event(name="loadProgress", type="asf.events.DependenciesProgressEvent")]
	[Event(name="loadComplete", type="asf.events.DependenciesProgressEvent")]
	[Event(name="loadStart", type="asf.events.DependenciesProgressEvent")]
	
	public class LoadShowFlow extends AbstractFlow
	{
		private var _loadingSection:Section;
		private var ignore:Boolean;
		
		public function LoadShowFlow( p_nav:Navigation, ignoreSectionIfLoaded:Boolean = false )
		{
			super( p_nav );
			
			ignore = ignoreSectionIfLoaded;
		}
		
		public function get currentLoadingSection( ):Section
		{
			return _loadingSection;
		}

		protected override function onNavigationWillChange( event:NavigationEvent ):void
		{
			var section:Section = event.section;
			
			_loadingSection = section;
			
			section.addEventListener( SectionEvent.VIEW_OPEN_COMPLETE, onSectionOpenComplete );
			
			if( ignore && !section.isLoaded )
			{
				section.addEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionWillLoad );
				section.addEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, onSectionWillLoadComplete );
				
				section.addEventListener( DependenciesProgressEvent.LOAD_START, onSectionLoadStart );
				section.addEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );
				section.addEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onSectionLoadComplete );
			}
		}
		
		private function onSectionOpenComplete( event:Event ):void
		{
			var section:Section = event.target as Section;
			
			section.removeEventListener( DependenciesProgressEvent.LOAD_START, onSectionLoadStart );
			section.removeEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );
			section.removeEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onSectionLoadComplete );
		}
		
		private function onSectionWillLoadComplete(event:Event):void
		{
			var section:Section = event.target as Section;
			
			section.removeEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, onSectionWillLoadComplete );
			
			_loadingSection = section;
			
			if( this.hasEventListener( FlowEvent.HIDE_LOADING ) ) section.pauseLoading( );
			
			this.dispatchEvent( new FlowEvent( FlowEvent.HIDE_LOADING ) );
		}
		
		private function onSectionLoadComplete( event:DependenciesProgressEvent ):void
		{
			this.dispatchEvent( getProgressEvent( event ) );
		}
		
		private function onSectionLoadProgress(event:DependenciesProgressEvent):void
		{
			this.dispatchEvent( getProgressEvent( event ) );
		}
		
		private function onSectionLoadStart(event:DependenciesProgressEvent):void
		{
			this.dispatchEvent( getProgressEvent( event ) );
		}
		
		private function getProgressEvent( event:ProgressEvent ):DependenciesProgressEvent
		{
			return new DependenciesProgressEvent( event.type, event.bubbles, event.cancelable, event.bytesLoaded, event.bytesTotal );
		}
		
		private function onSectionWillLoad(event:Event):void
		{
			var section:Section = event.target as Section;
			
			section.removeEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionWillLoad );
			
			_loadingSection = section;
			
			if( this.hasEventListener( FlowEvent.SHOW_LOADING ) ) section.pauseLoading( );
			
			this.dispatchEvent( new FlowEvent( FlowEvent.SHOW_LOADING ) );
		}
		
		public function resumeCurrentLoading( ):void
		{
			if( _loadingSection )
			{
				_loadingSection.resumeLoading( );
				_loadingSection = null;
			}
		}
		
		public override function dispose( ):void
		{
			if( _loadingSection )
			{
				_loadingSection.pauseLoading( );
				
				_loadingSection.addEventListener( ApplicationEvent.WILL_LOAD_DEPENDENCIES, onSectionWillLoad );
				_loadingSection.addEventListener( ApplicationEvent.WILL_DISPATCH_LOAD_COMPLETE, onSectionWillLoadComplete );
				
				_loadingSection.removeEventListener( DependenciesProgressEvent.LOAD_START, onSectionLoadStart );
				_loadingSection.removeEventListener( DependenciesProgressEvent.LOAD_PROGRESS, onSectionLoadProgress );
				_loadingSection.removeEventListener( DependenciesProgressEvent.LOAD_COMPLETE, onSectionLoadComplete );
			}
			
			_loadingSection = null;
			super.dispose( );
		}
	}
}