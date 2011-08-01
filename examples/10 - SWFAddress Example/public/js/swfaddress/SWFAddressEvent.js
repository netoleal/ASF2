/**
 * SWFAddress 2.3: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * Creates a new SWFAddressEvent event.
 * @class Event class for SWFAddressEvent.
 * @param {String} type Type of the event.
 * @author Rostislav Hristov <http://www.asual.com>
 */
var SWFAddressEvent = function(type) {
    
    /**
     * The string representation of this object.
     * @return {String}
     * @ignore
     */
    this.toString = function() {
        return '[object SWFAddressEvent]';
    };
    
    /**
     * The type of this event.
     * @type String
     */
    this.type = type;

    /**
     * The target of this event.
     * @type Function
     */
    this.target = [SWFAddress][0];

    /**
     * The value of this event.
     * @type String
     */
    this.value = SWFAddress.getValue();

    /**
     * The path of this event.
     * @type String
     */
    this.path = SWFAddress.getPath();
    
    /**
     * The folders in the deep linking path of this event.
     * @type Array
     */
    this.pathNames = SWFAddress.getPathNames();

    /**
     * The parameters of this event.
     * @type Object
     */
    this.parameters = {};

    var _parameterNames = SWFAddress.getParameterNames();
    for (var i = 0, l = _parameterNames.length; i < l; i++)
        this.parameters[_parameterNames[i]] = SWFAddress.getParameter(_parameterNames[i]);
    
    /**
     * The parameters names of this event.
     * @type Array     
     */
    this.parameterNames = _parameterNames;

}

/**
 * Init event.
 * @type String
 * @memberOf SWFAddressEvent
 * @static
 */
SWFAddressEvent.INIT = 'init';

/**
 * Change event.
 * @type String
 * @memberOf SWFAddressEvent
 * @static 
 */
SWFAddressEvent.CHANGE = 'change';