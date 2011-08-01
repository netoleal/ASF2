/**
 * SWFAddress 2.3: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @class Utility class that provides detailed browser information.
 * @static
 * @ignore
 * @author Rostislav Hristov <http://www.asual.com>
 */
asual.util.Browser = new function() {
    
    var _agent = navigator.userAgent.toLowerCase(),
        _safari = /webkit/.test(_agent),
        _opera = /opera/.test(_agent),
        _msie = /msie/.test(_agent) && !/opera/.test(_agent),
        _mozilla = /mozilla/.test(_agent) && !/(compatible|webkit)/.test(_agent),
        _version = parseFloat(_msie ? _agent.substr(_agent.indexOf('msie') + 4) : 
            (_agent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [0,'0'])[1]);
        
    /**
     * The string representation of this class.
     * @return {String}
     * @static
     */
    this.toString = function() {
        return '[class Browser]';
    };
    
    /**
     * Detects the version of the browser.
     * @return {Number}
     * @static
     */
    this.getVersion = function() {
        return _version;
    };

    /**
     * Detects if the browser is Internet Explorer.
     * @return {Boolean}
     * @static
     */
    this.isMSIE = function() {
        return _msie;
    };

    /**
     * Detects if the browser is Safari.
     * @return {Boolean}
     * @static
     */
    this.isSafari = function() {
        return _safari;
    };

    /**
     * Detects if the browser is Opera.
     * @return {Boolean}
     * @static
     */
    this.isOpera = function() {
        return _opera;
    };

    /**
     * Detects if the browser is Mozilla.
     * @return {Boolean}
     * @static
     */
    this.isMozilla = function() {
        return _mozilla;
    };
}