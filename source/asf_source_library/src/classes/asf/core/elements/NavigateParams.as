/*
Class: asf.core.elements.NavigateParams
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
	import asf.core.elements.Section;
	import asf.core.viewcontrollers.ApplicationViewController;
	
	import flash.display.Sprite;
	
	public class NavigateParams
	{
		/**
		 * String contendo o ID da seção a ser aberta
		 */
		public var sectionID:String = "";
		
		/**
		 * Objeto Section da seção a ser aberta
		 */
		public var section:Section = null;
		
		/**
		 * Caso o parâmetro "closeCurrentBeforeOpen" seja "false" e este seja "true", o framework carregará a próxima seção e só em seguida irá fechar a(s) anterior(es) para então abrir a próxima. Caso os dois sejam "false", nenhuma seção será fechada pela navegação.
		 */
		public var setAsCurrent:Boolean = true;
		
		/**
		 * Fecha ou não as seções atuais antes de carregar e abrir a próxima seção
		 */
		public var closeCurrentBeforeOpen:Boolean = true; 
		
		/**
		 * Caso true, não afeta o histórico da navegação
		 */
		public var preserveHistory:Boolean = false;
		
		/**
		 * Vector contendo as seções que devem ser fechadas após a seção ser aberta
		 */
		public var sectionsToCloseAfter:Vector.<Section>;
		
		/**
		 * O mesmo que o parâmetro extraArguments do método Navigation.openSection
		 */
		public var extraArguments:Array;
		
		/**
		 * ID ou Section da subseção a ser aberta dentro da seção.
		 */
		public var withSubSection:*;
		
		/**
		 * Uma Sprite para ser usada como container. Esse parâmetro sobrescreve a layer da seção configurada no XML. Essa substituição é temporária, ela dura enquanto a seção estiver ativa.
		 */
		public var container:Sprite = null;
		
		public static function fillTransitionParams(params:*, sectionTransition:NavigateParams, app:ApplicationViewController):NavigateParams
		{
			var props:Array = [ "sectionID", "section", "setAsCurrent", "closeCurrentBeforeOpen", 
				"preserveHistory", "sectionsToCloseAfter", "extraArguments", "withSubSection", "container" ];
			var prop:String;
			var section:Section;
			
			switch( true )
			{
				case params is String:
				{
					section = app.navigation.getSectionByID( params );
					sectionTransition.section = section;
					break;
				}
				case params is Section:
				{
					section = params;
					sectionTransition.section = section;
					break;
				}
				case params is NavigateParams: 
				{
					if( ( params as NavigateParams ).section == null && ( params as NavigateParams ).sectionID != "" )
					{
						params.section = app.navigation.getSectionByID( params.sectionID );
					}
					for each( prop in props ) sectionTransition[ prop ] = params[ prop ];
					
					break;
				}
				default:
				{
					for each( prop in props )
					{
						if( ( params as Object ).hasOwnProperty( prop ) )
						{
							sectionTransition[ prop ] = params[ prop ];
						}
					}
					
					if( ( params as Object ).hasOwnProperty( "section" ) && !sectionTransition.section )
					{
						sectionTransition.section = params.section;
					}
					else if( ( params as Object ).hasOwnProperty( "sectionID" ) && !sectionTransition.section )
					{
						sectionTransition.section = app.navigation.getSectionByID( params.sectionID );
					}
				}
			}
			
			return sectionTransition;
		}
	}
}