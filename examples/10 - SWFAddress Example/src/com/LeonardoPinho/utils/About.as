package com.LeonardoPinho.utils
{
	public final class About
	{
		public static function info(pName:String, date:String, developer:String):void
		{
			trace("/** \n" +
				"* Main page of "+pName+"\n" +
				"* Date: "+date+"\n" +
				"* Flash Developer: "+developer+" \n" +
				"*/");
		}
	}
}