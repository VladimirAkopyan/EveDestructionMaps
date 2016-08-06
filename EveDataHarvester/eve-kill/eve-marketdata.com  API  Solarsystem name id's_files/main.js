// debug functions
function Debug(val) {
// to use:  put this in somewhere on the page:
// <div id="debug" class="debug">&nbsp;</div>

	// show one debug message, at the top
	if (typeof(debug) != 'undefined') {
		if (debug) {
			innerhtml_append('debug', '<li>'+val+'</li>', true);
		}
	}
}



// ajax
function ajax_execute(target, method) {
	// make the call and execute whatever it returns
	Debug('ajax_execute(target='+target+', method='+method+')');
	ajax2(target, method, true);
}
function ajax_get(target, method) {
	// make the call and return the results, forces it to be synchronous
	Debug('ajax_get(target='+target+', method='+method+')');
	return ajax2(target, method, false);
}

function ajax2(target, method, execute) {
	var oajax;
	if (typeof method == 'undefined') {
		method = 'GET';
	}
	if (window.XMLHttpRequest) {
		oajax = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		oajax = new ActiveXObject('Microsoft.XMLHTTP');
	} else {
		alert('Unable to set up ajax');
	}
	if (execute == true) {
		oajax.open(method, target, true);
		oajax.onreadystatechange = function() {
			if (oajax.readyState == 4) {
//if (oajax.responseText != '') { alert(oajax.responseText); }
				try {
					eval(oajax.responseText);
				} catch(e) {
					alert('ajax error on:\n\n'+oajax.responseText+'\n\n'+e);
				}
			}
		}
		oajax.send(null);
	} else {
//		alert('sync');
		oajax.open(method, target, false);
		oajax.send(null);
		return oajax.responseText;
	}
	return true;
}



/////////////////////////
// some UI shortcuts
/////////////////////////
function id_exists(id) {
//	var divs = document.getElementsByTagName('div');
	if (document.getElementById(id)) {
		return true;
	} else {
		return false;
	}
}
function show_by_id(id) {
	if (id_exists(id)) {
		document.getElementById(id).style.display = 'inline';
	} else {
		Debug('show: div does not exist: '+id);
	}
}
function hide_by_id(id) {
	if (id_exists(id)) {
		document.getElementById(id).style.display = 'none';
	} else {
		Debug('hide: div does not exist: '+id);
	}
}
function innerhtml(id, val) {
	if (typeof val == 'undefined') {
		return document.getElementById(id).innerHTML;
	} else {
		if (id_exists(id)) {
			document.getElementById(id).innerHTML = val;
		}
	}
}
function innerhtml_append(id, val, at_top) { // adds a message to the user's history
	if (id_exists(id)) {
		if (at_top == true) {
			document.getElementById(id).innerHTML = ''+val+document.getElementById(id).innerHTML;
		} else {
			document.getElementById(id).innerHTML += ''+val;
		}
	}
}
function value2(id, val) {
	if (typeof val == 'undefined') {
		return document.getElementById(id).value;
	} else {
		if (id_exists(id)) {
			document.getElementById(id).value = val;
		}
	}
}
function scrollbottom(id) { // scrolls to the bottom of a div
	document.getElementById(id).scrollTop = document.getElementById(id).scrollHeight;
}
function bgcolor(id, color) {
	document.getElementById(id).style.backgroundColor = color;
}




/*
// todo: this doesn't work in the IGB if it's in the include file?
function setcookie2(name, value, exp_seconds, path, domain, secure) {
	var cookie_string = name+"="+escape(value);

	if (exp_seconds) {
		var today   = new Date();
		var expires = new Date();
		expires.setTime(today.getTime() + exp_seconds);
		cookie_string += "; expires="+expires.toGMTString();
	}

	if (path) {
		cookie_string += "; path="+escape(path);
	}

	if (domain) {
		cookie_string += "; domain="+escape(domain);
	}

	if (secure) {
		cookie_string += "; secure";
	}

	document.cookie = cookie_string;
}
*/






/* from php.js */
function number_format(number,decimals,dec_point,thousands_sep){number=(number+'').replace(/[^0-9+\-Ee.]/g,'');var n=!isFinite(+number)?0:+number,prec=!isFinite(+decimals)?0:Math.abs(decimals),sep=(typeof thousands_sep==='undefined')?',':thousands_sep,dec=(typeof dec_point==='undefined')?'.':dec_point,s='',toFixedFix=function(n,prec){var k=Math.pow(10,prec);return''+Math.round(n*k)/k;};s=(prec?toFixedFix(n,prec):''+Math.round(n)).split('.');if(s[0].length>3){s[0]=s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g,sep);}if((s[1]||'').length<prec){s[1]=s[1]||'';s[1]+=new Array(prec-s[1].length+1).join('0');}return s.join(dec);}
