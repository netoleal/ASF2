package asf.interfaces
{
	public interface ISpecialProperty extends IDisposable
	{
		function getValue( target:* ):Number;
		function setValue( target:*, value:Number ):void;
	}
}