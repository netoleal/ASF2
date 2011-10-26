/*
Class: asf.core.config.ApplicationParameters
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
package asf.core.config
{
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.CondicionalBlockModel;
	import asf.utils.URLUtils;

	import flash.display.LoaderInfo;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class ApplicationParameters extends Proxy
	{
		private var raw:XML;
		private var loaderInfoParams:Object;
		
		private var app:ApplicationModel;
		
		private var _defaults:Object;
		private var _overrides:Object;
		
		public function ApplicationParameters( p_raw:XML, p_loaderInfo:LoaderInfo, p_appModel:ApplicationModel )
		{
			raw = p_raw;
			loaderInfoParams = p_loaderInfo.parameters;
			app = p_appModel;
			
			_defaults = new Object( );
			_overrides = new Object( );
		}
		
		/**
		 * Propriedade usada para armazenar valores padrão aos parâmetros para quando o parâmetro não existe nem no loaderInfo nem no XML de configurações e nem na URL também (SWFAddress requerido para parâmetros pela URL)
		 * @return 
		 * 
		 */
		public function get defaults( ):Object
		{
			return _defaults;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return getParam( name );
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_overrides[ name ] = value;
		}
		
		/**
		 * Resgata um parâmetro que pode estar na URL, FlashVars ou no XML de configurações. Caso não esteja em nenhum desses locais, ele será procurado na propriedade "defaults"
		 *  
		 * @param name
		 * @return O valor do parâmetro
		 * 
		 */
		public function getParam( name:String ):*
		{
			var value:String;
			
			value = getParsed( _overrides[ name ] );
			value = value || URLUtils.getQueryStringParam( name );
			value = value || getParsed( loaderInfoParams[ name ] );
			
			if( !value || value == "" )
			{
				if( raw && raw.hasOwnProperty( "params" ) )
				{
					if( ( raw.params[ name ] as XMLList ).hasComplexContent( ) )
					{
						value = ConditionalParser.parse( new CondicionalBlockModel( raw.params[ name ][ "if" ] ), app );
					}
					else value = getParsed( raw.params[ name ] );
				}
			}
			
			value = value || getParsed( _defaults[ name ] );
			value = value || "";
			
			return value;
		}
		
		private function getParsed( input:String ):String
		{
			if( !input ) return null;
			return VariablesParser.parse( input, app );
		}
	}
}