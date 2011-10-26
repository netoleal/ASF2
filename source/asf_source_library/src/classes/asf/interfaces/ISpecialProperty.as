package asf.interfaces
{
	public interface ISpecialProperty extends IDisposable
	{
		/**
		 * Retorna o valor da propriedade personalizada 
		 * @param target
		 * @return 
		 * 
		 */
		function getValue( target:* ):Number;
		
		/**
		 * Define novo valor para a propriedade personalizada
		 * 
		 * @param target Objeto que vai sofrer a alteração da propriedade
		 * @param value Novo valor para a propriedade
		 * @param start Valor de início da propriedade dentro da interpolação
		 * @param end Valor final da propriedade dentro da interpolação
		 * 
		 */
		function setValue( target:*, value:Number, start:Number = 0, end:Number = 0 ):void;
	}
}