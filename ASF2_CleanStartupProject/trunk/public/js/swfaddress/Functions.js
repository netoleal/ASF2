/**
 * SWFAddress 2.3: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @class Utility class that provides function helpers.
 * @static
 * @ignore
 * @author Rostislav Hristov <http://www.asual.com> 
 */
asual.util.Functions = new function() {

    /**
     * The string representation of this class.
     * @return {String}
     * @static
     */
    this.toString = function() {
        return '[class Functions]';
    };
    
    /**
     * Binds the execution of a function to a specified scope
     * @param {Function} method Reference to the function 
     * @param {Object} object The scope in which the method will be executed
     * @param {Object} param Optional parameters to be passed to the function 
     * @return Binded function
     * @type Function
     * @static     
     */
    this.bind = function(method, object, param) {
        for (var i = 2, p, arr = []; p = arguments[i]; i++)
            arr.push(p);
        return function() {
            return method.apply(object, arr);
        }
    };
}