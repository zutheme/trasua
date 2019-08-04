function total_items(){
    var _e_c_cart_number = document.getElementsByClassName("c-cart-number");
    var _l_itemts = localStorage.getItem('l_items');
    if(!isRealValue(_l_itemts)){
      return false;
    }
    //var re_items = localStorage.getItem('l_items');
    var itemts = JSON.parse(_l_itemts);
    console.log(itemts);
    var _trash;
    var _parent_id;
    var _count = 0;
     for ( var index=0; index < itemts.length; index++ ) {   
     		_parent_id = itemts[index].parent_id;
     		_trash = itemts[index].trash;       
           if(_parent_id == 0 && _trash == 0){
           		_count++;
           }         
    	}
    for (var i = _e_c_cart_number.length - 1; i >= 0; i--) {
      _e_c_cart_number[i].innerHTML = _count;
    }
     
}
total_items();
function isRealValue(obj) {
  return obj && obj !== 'null' && obj !== 'undefined';
}
//set cookie object
 function deleteCookie(cookiename){
      var d = new Date();
      d.setDate(d.getDate() - 1);
      var expires = ";expires="+d;
      var name=cookiename;
      //alert(name);
      var value="";
      document.cookie = name + "=" + value + expires + "; path=/";                    
  }
function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function setCookieHours(cname,cvalue,hours) {
    var d = new Date();
    d.setTime(d.getTime() + (hours*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
var l_items = getCookie('l_items');
if(!isRealValue(l_items)){
  localStorage.removeItem("l_items");
}
//login
var _e_login_modal = document.getElementsByClassName("c-content-login-form")[0];
var _e_login_form = _e_login_modal.getElementsByClassName("login-form")[0];
// var _e_btn_login = _e_login_form.getElementsByClassName("c-btn-login")[0];
// _e_btn_login 
function login_modal(element){
    var _e_parent = element.parentElement.parentElement;
    var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
    var http = new XMLHttpRequest();
    var url = url_home+"/loginmodal";
    var _login_email = _e_parent.getElementsByClassName("login-email")[0].value;
    var _login_password = _e_parent.getElementsByClassName("login-password")[0].value;
    var _c_check = _e_parent.getElementsByClassName("c-check")[0].value;
    var params = JSON.stringify({login_email:_login_email,login_password:_login_password,c_check:_c_check});
    http.open("POST", url, true);
    http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
    http.setRequestHeader("Accept", "application/json");
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var load = _e_parent.getElementsByClassName("loading")[0];
    load.style.display = "block";
    http.onreadystatechange = function() {
        if(http.readyState == 4 && http.status == 200) {
            var myArr = JSON.parse(this.responseText);
            if(myArr['success']){
              console.log(myArr['email']);
              load.style.display = "none";
            }else{
              console.log(myArr['error']);
            }
        }
    }
    http.send(params);
}
function show_currency(variable) {
  // if(isNaN(variable)){
  //   console.log("is number");
  // }else{
  //   console.log("is string");
  // }
  var digits = (""+variable).split("");
  var count = 1;
  var str_number = [];
  var len = digits.length;
  for (var i = len - 1; i >= 0; i--) {
    if(count % 3 ==0 ){
      str_number.push(digits[i]);
      str_number.push(".");
    }else{
      str_number.push(digits[i]);
    }
    count++;
  }
  var out_str = "";
  for (var k = str_number.length - 1; k >= 0; k--) {
    out_str = out_str + str_number[k];
  }
  var k = out_str.length - 1;
  if(str_number[k]=='.'){
    out_str = out_str.substr(1, out_str.length-1);
  }
  return out_str;
}
var _e_currency = document.getElementsByClassName("currency");
var _format_current;
for (var i = _e_currency.length - 1; i >= 0; i--) {
  _format_current = _e_currency[i].innerHTML;
  _e_currency[i].innerHTML = show_currency(_format_current);
}