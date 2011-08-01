﻿/** Class asf.utils.UTF8* I've found this code at: http://www.webtoolkit.info/actionscript-utf8.html and Just converted it to AS3*/package asf.utils {	public class UTF8 	{		public static function encode( string:String ):String 		{			var utftext:String = "";	 			for (var n:uint = 0; n < string.length; n++) {	 				var c:uint = string.charCodeAt(n);	 				if (c < 128) {					utftext += String.fromCharCode(c);				}				else if((c > 127) && (c < 2048)) {					utftext += String.fromCharCode((c >> 6) | 192);					utftext += String.fromCharCode((c & 63) | 128);				}				else {					utftext += String.fromCharCode((c >> 12) | 224);					utftext += String.fromCharCode(((c >> 6) & 63) | 128);					utftext += String.fromCharCode((c & 63) | 128);				}	 			}	 			return utftext;		}				public static function decode( utftext:String ):String		{			var string:String = "";			var i:uint = 0;			var c1:uint, c2:uint, c3:uint;			var c:uint = c1 = c2 = 0;	 			while ( i < utftext.length ) {	 				c = utftext.charCodeAt(i);	 				if (c < 128) {					string += String.fromCharCode(c);					i++;				}				else if((c > 191) && (c < 224)) {					c2 = utftext.charCodeAt(i+1);					string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));					i += 2;				}				else {					c2 = utftext.charCodeAt(i+1);					c3 = utftext.charCodeAt(i+2);					string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));					i += 3;				}			}	 			return string;		}	}}