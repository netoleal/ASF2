/**
 * SWFAddress 2.3: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @class Utility class that provides event helpers.
 * @static
 * @ignore
 * @author Rostislav Hristov <http://www.asual.com> 
 * @author Diego Perini <http://javascript.nwbox.com>
 */
asual.util.Events = new function() {

    var DOM_LOADED = 'DOMContentLoaded', 
        STOP = 'onstop',
        _w = window,
        _d = document,
        _cache = [],
        _util = asual.util,
        _browser = _util.Browser,
        _msie = _browser.isMSIE(),
        _safari = _browser.isSafari();
    
    /**
     * The string representation of this class.
     * @return {String}
     * @static
     */
    this.toString = function() {
        return '[class Events]';
    };
    
    /**
     * Adds an event listener to an object.
     * @param {Object} obj The object that provides events.
     * @param {String} type The type of the event.
     * @param {Function} listener The event listener function.
     * @return {void}
     * @static
     */
    this.addListener = function(obj, type, listener) {
        _cache.push({o: obj, t: type, l: listener});
        if (!(type == DOM_LOADED && (_msie || _safari))) {
            if (obj.addEventListener)
                obj.addEventListener(type, listener, false);
            else if (obj.attachEvent)
                obj.attachEvent('on' + type, listener);
        }
    };

    /**
     * Removes an event listener from an object.
     * @param {Object} obj The object that provides events.
     * @param {String} type The type of the event.
     * @param {Function} listener The event listener function.
     * @return {void}     
     * @static
     */
    this.removeListener = function(obj, type, listener) {
        for (var i = 0, e; e = _cache[i]; i++) {
            if (e.o == obj && e.t == type && e.l == listener) {
                _cache.splice(i, 1);
                break;
            }
        }
        if (!(type == DOM_LOADED && (_msie || _safari))) {
            if (obj.removeEventListener)
                obj.removeEventListener(type, listener, false);
            else if (obj.detachEvent)
                obj.detachEvent('on' + type, listener);
        }
    };

    var _unload = function() {
        for (var i = 0, evt; evt = _cache[i]; i++) {
            if (evt.t != DOM_LOADED)
                _util.Events.removeListener(evt.o, evt.t, evt.l);
        }
    };
    
    var _unloadFix = function() {
        if (_d.readyState == 'interactive') {
            function stop() {
                _d.detachEvent(STOP, stop);
                _unload();
            };
            _d.attachEvent(STOP, stop);
            _w.setTimeout(function() {
                _d.detachEvent(STOP, stop);
            }, 0);
        }
    };

    if (_msie || _safari) {
        (function (){
            try {
                if ((_msie && _d.body) || !/loaded|complete/.test(_d.readyState))
                    _d.documentElement.doScroll('left');
            } catch(e) {
                return setTimeout(arguments.callee, 0);
            }
            for (var i = 0, e; e = _cache[i]; i++)
                if (e.t == DOM_LOADED) e.l.call(null);
        })();
    }
    
    if (_msie)
        _w.attachEvent('onbeforeunload', _unloadFix);

    this.addListener(_w, 'unload', _unload);
}