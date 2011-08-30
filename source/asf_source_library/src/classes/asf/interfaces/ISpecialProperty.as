package asf.interfaces
{
	public interface ISpecialProperty extends IDisposable
	{
		function getValue( target:* ):Number;
		function setValue( target:*, value:Number, start:Number = 0, end:Number = 0 ):void;
	}
}