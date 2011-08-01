/*
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

package asf.core.models.sounds
{
	import asf.core.loading.LoadingTypes;
	import asf.core.models.app.ApplicationModel;
	import asf.core.models.app.BaseAppModel;
	import asf.core.models.dependencies.FileModel;

	public class SoundModel extends BaseAppModel
	{
		private var _file:FileModel;
		
		public function SoundModel(p_raw:*, p_app:ApplicationModel)
		{
			super(p_raw, p_app);
		}
		
		public function get id( ):String
		{
			return app.getParsedValue( xml.@id );
		}
		
		public function get type( ):String
		{
			return app.getParsedValue( xml.@type || "url" );
		}
		
		public function get volume( ):Number
		{
			return parseFloat( app.getParsedValue( xml.@volume || "1" ) );
		}
		
		public function get fadeInTime( ):int
		{
			return parseInt( app.getParsedValue( xml.@fadeIn || "0" ) );
		}
		
		public function get autoPlay( ):String
		{
			return app.getParsedValue( xml.@autoPlay || "false" );
		}
		
		public function get isAutoPlay( ):Boolean
		{
			return autoPlay == "true";
		}
		
		public function get loops( ):uint
		{
			return parseInt( app.getParsedValue( xml.@loops || "0" ) );
		}
		
		public function get isStream( ):Boolean
		{
			return app.getParsedValue( xml.@stream ) == "true";
		}
		
		public function get ignoreIfPlaying( ):Boolean
		{
			return app.getParsedValue( xml.@ignoreIfPlaying ) == "true";
		}
		
		public function get pan( ):Number
		{
			return parseFloat( app.getParsedValue( xml.@pan || "0" ) );
		}
		
		public function get allowMultipleChannels( ):Boolean
		{
			return app.getParsedValue( xml.@allowMultipleChannels ) == "true";
		}
		
		public function get source( ):String
		{
			return app.getParsedValue( String( xml.text( ) ) );
		}
		
		public function get file( ):FileModel
		{
			if( !_file )
			{
				_file = FileModel.create( app, this.id, this.source, LoadingTypes.SOUND );
			}
			
			return _file;
		}
	}
}