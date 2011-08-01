/*
Class: asf.core.models.app.ApplicationModel
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
package asf.core.models.app
{
	import asf.core.config.ApplicationParameters;
	import asf.core.config.VariablesParser;
	import asf.core.loading.LoadingTypes;
	import asf.core.models.dependencies.DependenciesModel;
	import asf.core.models.dependencies.FileModel;
	import asf.core.models.dictionary.DictionariesModel;
	import asf.core.models.dictionary.DictionaryModel;
	import asf.core.models.layers.LayersModel;
	import asf.core.models.sections.SectionsModel;
	import asf.core.models.sounds.SoundsModel;
	import asf.core.models.styles.StylesModel;
	
	import flash.display.LoaderInfo;

	/**
	 * 
	 * @author neto.leal
	 * 
	 */
	public class ApplicationModel extends BaseModel
	{
		private var _params:ApplicationParameters;
		private var _parent:ApplicationModel;
		private var _layers:LayersModel;
		private var _dependencies:DependenciesModel;
		private var _loaderInfo:LoaderInfo;
		private var _dictionaries:DictionariesModel;
		private var _styles:StylesModel;
		private var _sections:SectionsModel;
		private var _sounds:SoundsModel;
		private var _metrics:FileModel;
		
		public function ApplicationModel( p_raw:XML, p_loaderInfo:LoaderInfo = null, p_parent:ApplicationModel = null )
		{
			super( p_raw );
			
			_parent = p_parent;
			_loaderInfo = p_loaderInfo;
		}
		
		/**
		 * O ID da aplicação 
		 * @return 
		 * 
		 */
		public function get id( ):String
		{
			return xml.id || xml.@id;
		}
		
		/**
		 * O modelo de dados da aplicação pai dessa aplicação
		 *  
		 * @return 
		 * 
		 */
		public function get parent( ):ApplicationModel
		{
			return _parent;
		}
		
		public function get metrics( ):FileModel
		{
			if( this.xml.hasOwnProperty( "metrics" ) && this.getParsedValue( this.xml.metrics ) != "" )
			{
				_metrics = FileModel.create( this, "$metrics_xml", this.getParsedValue( this.xml.metrics ), LoadingTypes.XML );
			}
			
			return _metrics;
		}
		
		public function get sections( ):SectionsModel
		{
			if( !_sections ) _sections = new SectionsModel( this.xml.sections, this, this._loaderInfo, this );
			return _sections;
		}
		
		public function get sounds( ):SoundsModel
		{
			if( !_sounds ) _sounds = new SoundsModel( this.xml.sounds, this );
			return _sounds;
		}
		
		public function get styles( ):StylesModel
		{
			if( !_styles ) _styles = new StylesModel( this.xml.styles, this );
			return _styles;
		}
		
		public function get layers( ):LayersModel
		{
			if( !_layers ) _layers = new LayersModel( this.xml.layers, this );
			return _layers;
		}
		
		public function get dictionaries( ):Vector.<DictionaryModel>
		{
			if( !_dictionaries ) _dictionaries = new DictionariesModel( this.xml, this );
			return _dictionaries.dicionaries;
		}
		
		public function get params( ):ApplicationParameters
		{
			if( !_params ) _params = new ApplicationParameters( this.xml, _loaderInfo, this );
			return _params;
		}
		
		public function get dependencies( ):DependenciesModel
		{
			if( !_dependencies ) _dependencies = new DependenciesModel( this.xml.files, this );
			return _dependencies;
		}
		
		public function getParsedValue( input:String ):String
		{
			return VariablesParser.parse( input, this );
		}
		
		public function refreshParams( ):ApplicationParameters
		{
			_styles = null;
			_params = null;
			return params;
		}
	}
}