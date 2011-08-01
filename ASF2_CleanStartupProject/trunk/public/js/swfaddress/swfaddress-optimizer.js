/**
 * SWFAddress 2.1: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 *
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Uses code from SWFObject 2.0 - http://code.google.com/p/swfobject/
 * SWFObject is (c) 2007 Geoff Stearns, Michael Williams, and Bobby van der Sluis 
 * and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
 
SWFAddressOptimizer = new function() {

    var _hash = location.href.indexOf('#');
    var _url, _opts = {};
    
    var _checkFlash = function(version){
    
        var rv = version.toString().split('.');
        for (var i = 0; i < 3; i++)
            rv[i] = typeof rv[i] != 'undefined' ? parseInt(rv[i]) : 0;

        var pv = [0,0,0];
        var d = null;
        
        if (typeof navigator.plugins != 'undefined' && typeof navigator.plugins['Shockwave Flash'] == 'object') {
            d = navigator.plugins['Shockwave Flash'].description;
            if (d) {
                d = d.replace(/^.*\s+(\S+\s+\S+$)/, '$1');
                pv[0] = parseInt(d.replace(/^(.*)\..*$/, '$1'), 10);
                pv[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, '$1'), 10);
                pv[2] = /r/.test(d) ? parseInt(d.replace(/^.*r(.*)$/, '$1'), 10) : 0;
            }
        } else if (typeof window.ActiveXObject != 'undefined') {
            var a = null;
            var fp6Crash = false;
            try {
                a = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.7');
            } catch(e) {
                try { 
                    a = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.6');
                    pv = [6,0,21];
                    a.AllowScriptAccess = 'always';
                } catch(e) {
                    if (pv[0] == 6) {
                        fp6Crash = true;
                    }
                }
                if (!fp6Crash) {
                    try {
                        a = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
                    } catch(e) {}
                }
            }
            if (!fp6Crash && typeof a == 'object') {
                try {
                    d = a.GetVariable('$version');
                    if (d) {
                        d = d.split(' ')[1].split(',');
                        pv = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
                    }
                } catch(e) {}
            }
        }    
        
        return (pv[0] > rv[0] || (pv[0] == rv[0] && pv[1] > rv[1]) || 
            (pv[0] == rv[0] && pv[1] == rv[1] && pv[2] >= rv[2])) ? true : false;
    }
    
    var _redirect = function(swfaddress, base) {
        var value = location.href.split(location.hostname)[1].replace(base, '');
        if (swfaddress != '/' && (_hash == -1 || _hash == location.href.length - 1) && (value != '' && value != '/')) {
            var xhr;
            if (window.XMLHttpRequest) {
                xhr = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                try {
                    try {
                        xhr = new ActiveXObject('Msxml2.XMLHTTP');
                    } catch(e) {
                        xhr = new ActiveXObject('Microsoft.XMLHTTP');
                    }
                } catch(e) {}
            }
            if (xhr) {
                xhr.open('get', ((typeof base != 'undefined') ? base : '') + '/?' + swfaddress, false);                
                xhr.setRequestHeader('Content-Type', 'application/x-swfaddress');
                xhr.send('');
                eval(xhr.responseText);
            }
        }
    }
    
    var _searchScript = function(el) {
        if (el.src && /swfaddress-optimizer\.js(\?.*)?$/.test(el.src)) return el;
        for (var i = 0, l = el.childNodes.length, s; i < l; i++) {
            if (s = _searchScript(el.childNodes[i])) return s;
        }        
    }

    try {
        _url = String(_searchScript(document).src);
        var qi = _url.indexOf('?');
        if (_url && qi > -1) {
            var param, params = _url.substr(qi + 1).split('&');
            for (var i = 0, p; p = params[i]; i++) {
                param = p.split('=');
                if (/^(flash|base|swfaddress)$/.test(param[0])) {
                    _opts[param[0]] = unescape(param[1]);
                }
            }
        }
    } catch(e) {}
        
    if (typeof _opts.flash != 'undefined') {
        if (_checkFlash(_opts.flash)) {
            _redirect(_opts.swfaddress, _opts.base);
        } else if (_hash != -1) {
            location.replace(location.href.replace(/#(\/)?/, ''));
        }
    } else {
        _redirect(_opts.swfaddress, _opts.base);
    }
}