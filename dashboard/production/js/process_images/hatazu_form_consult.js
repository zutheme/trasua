function extractHostname(url) {

    var hostname;

    //find & remove protocol (http, ftp, etc.) and get hostname

    if (url.indexOf("//") > -1) {

        hostname = url.split('/')[2];

    }

    else {

        hostname = url.split('/')[0];

    }

    //find & remove port number

    hostname = hostname.split(':')[0];

    //find & remove "?"

    hostname = hostname.split('?')[0];

    return hostname;

}

// To address those who want the "root domain," use this function:

function extractRootDomain(url) {

    var domain = extractHostname(url),

        splitArr = domain.split('.'),

        arrLen = splitArr.length;

    //extracting the root domain here

    //if there is a subdomain 

    if (arrLen > 2) {

        domain = splitArr[arrLen - 2] + '.' + splitArr[arrLen - 1];

        //check to see if it's using a Country Code Top Level Domain (ccTLD) (i.e. ".me.uk")

        if (splitArr[arrLen - 2].length == 2 && splitArr[arrLen - 1].length == 2) {

            //this is using a ccTLD

            domain = splitArr[arrLen - 3] + '.' + domain;

        }

    }

    return domain;

}

//test object

function isEmpty(obj) {

    for(var key in obj) {

        if(obj.hasOwnProperty(key))

            return false;

    }

    return true;

}

function reach_object(obj_message){

  for (var key in obj_message) {

      // skip loop if the property is from prototype

      if (!obj_message.hasOwnProperty(key)) continue;

      var obj = obj_message[key];

      for (var prop in obj) {

          // skip loop if the property is from prototype

          if(!obj.hasOwnProperty(prop)) continue;

          // your code

          console.log(prop + " = " + obj[prop]);

      }

  }

}

//end object

 function isRealValues(obj)

  {

   return obj && obj !== 'null' && obj !== 'undefined';

  }



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
function strip(html)
{
   var tmp = document.createElement("DIV");
   tmp.innerHTML = html;
   return tmp.textContent || tmp.innerText || "";
}
var _e_info_form = document.getElementsByClassName('modal-consultant-form')[0];

var _e_info_form_consult = _e_info_form.getElementsByClassName('modal-consult')[0];

var _e_info_form_info = _e_info_form_consult.getElementsByClassName('frm-info')[0];



var _e_load = _e_info_form_info.getElementsByClassName('loading')[0];

var _e_result = _e_info_form_info.getElementsByClassName('result')[0];

//consultant

var _e_consultant_form = document.getElementsByClassName('frm-register')[0];

var e_btn_reg_consult = _e_consultant_form.getElementsByClassName('btn-reg-survey')[0];

e_btn_reg_consult.addEventListener("click", reg_consultant);

function reg_consultant(){

  _e_load.style.display = "block";

  _e_info_form_consult.style.display = "block";

  var _url = document.URL; 

  var _host = extractHostname(_url);
  console.log(_host);
  var _e_fullname = _e_consultant_form.getElementsByClassName('fullname')[0];

  var _e_phone = _e_consultant_form.getElementsByClassName('phone')[0];

  //var _e_email = _e_consultant_form.getElementsByClassName('email')[0];

  var _e_address = _e_consultant_form.getElementsByClassName('address')[0];

  var _e_txtdate = _e_consultant_form.getElementsByClassName('_birthday')[0];

  var _e_job = _e_consultant_form.getElementsByClassName('job')[0];

  //var _e_facebook = _e_consultant_form.getElementsByClassName('facebook')[0];

  var _e_height = _e_consultant_form.getElementsByClassName('height')[0];
   var _e_weight = _e_consultant_form.getElementsByClassName('weight')[0];
  //sub register

  //var _e_txtbung = _e_consultant_form.getElementsByClassName('txtbung')[0];

  //var _e_txtbaptay = _e_consultant_form.getElementsByClassName('txtbaptay')[0];

  //var _e_txteo = _e_consultant_form.getElementsByClassName('txteo')[0];

  //var _e_txtdui = _e_consultant_form.getElementsByClassName('txtdui')[0];

  //check

  var _e_radio_usedto = _e_consultant_form.getElementsByClassName('i2')[0];

  var items = document.getElementsByName('usedto');

    var _selectedUsedto="";

    for(var i=0; i<items.length; i++){

      if(items[i].type=='radio' && items[i].checked==true)

        _selectedUsedto=items[i].value;

    }



  var _e_txtvisao = document.getElementsByName("txtvisao")[0];

  var _e_txtcauchuyen = document.getElementsByName("txtcauchuyen")[0];

  var _e_txtmongmuon = document.getElementsByName("txtmongmuon")[0];

  //images

  var _e_file_canvas1 = document.getElementsByName("file_canvas1")[0];

  var _e_file_canvas2 = document.getElementsByName("file_canvas2")[0];

  var _e_file_canvas3 = document.getElementsByName("file_canvas3")[0];



  var _fullname = _e_fullname.value;

  var _phone = _e_phone.value;

  //var _email = _e_email.value;
  var _email = "";
  var _address = _e_address.value;

  var _txtdate = _e_txtdate.value;

  var _job = _e_job.value;

  //var _facebook = _e_facebook.value;
  var _facebook = "";
  var _height = _e_height.value;
  var _weight = _e_weight.value;

  //sub register

  //var _txtbung = _e_txtbung.value;

  //var _txtbaptay = _e_txtbaptay.value;

  //var _txteo = _e_txteo.value;

  //var _txtdui = _e_txtdui.value;

  var _txtvisao = _e_txtvisao.value;

  //right

   var _txtcauchuyen = _e_txtcauchuyen.value;

   var _txtmongmuon = _e_txtmongmuon.value;

   var _file_canvas1 = _e_file_canvas1.value;

   var _file_canvas2 = _e_file_canvas2.value;

   var _file_canvas3 = _e_file_canvas3.value;



   var item_txtss = document.getElementsByName('txtss');

    var _selected_txtss="";

    for(var i=0; i<item_txtss.length; i++){

      if(item_txtss[i].type=='radio' && item_txtss[i].checked==true)

        _selected_txtss+=item_txtss[i].value;

    }

    var _e_txtck = document.getElementsByName('txtck')[0];

    var _txtck = _e_txtck.checked;

   console.log(_height+","+_weight );

   if (!_txtck) {

      alert("tick vào nút cam kết đồng ý các điều khoản của cuộc thi");

      return false;

   }

  

  if(!_phone){

      _e_phone.style.borderColor = "red";

     //_e_phone.innerHTML = "Vui lòng nhập số điện thoại";

      return false;

  }

  if(!_fullname){

      _e_fullname.style.borderColor = "red";

      //_e_fullname.innerHTML = "Vui lòng nhập họ tên";

      return false;

  }



 //body 
  var _content = "";
 //encodeURIComponent("Hi everybody<br />Whats'up.");
 //_content = htmlEntities(_content);
  //_content = strip(_content);
  var _reg_url = _url.replace(/[&]/g, ';');

  var _namecat = _host;

  var _body = _content;

  var _typepost = "game";

  var _firstname = _fullname;
  console.log(_firstname);

  var _mobile = _phone;

  var _name_status_type = "request";

  //if(!isRealValues(gbdataURL)){

    //gbdataURL="";

  //}

  var http = new XMLHttpRequest();

  //var url = "https://thammyvienthienkhue.com.vn/api/customer/consultant";

  var url = "http://api.thammyvienthienkhue.com.vn/api/customer/game";

  var params = JSON.stringify({firstname: _firstname, mobile: _mobile, email:_email ,address:_address, namecat: _namecat, body:_body, typepost:_typepost, name_status_type:_name_status_type, job:_job, birthday:_txtdate, facebook:_facebook,

    file_canvas1:_file_canvas1, file_canvas2:_file_canvas2, file_canvas3:_file_canvas3, height:_height, weight:_weight, selectedUsedto:_selectedUsedto, txtvisao:_txtvisao, txtcauchuyen:_txtcauchuyen, txtmongmuon:_txtmongmuon, selected_txtss:_selected_txtss });

  //var params = "firstname="+_fullname+"&mobile="+_phone+"&email="+_email+"&address="+_address+"&job="+_url+","+_host+","+depart_selected;

  http.open("POST", url, true);

  //console.log(params);

  //Send the proper header information along with the request

  http.setRequestHeader("Accept", "application/json");

  http.withCredentials = true;

  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");



  http.onreadystatechange = function() {

      if(http.readyState == 4 && http.status == 200) {

           var myArr = JSON.parse(this.responseText);

           console.log(myArr);      

           

           Object.keys(myArr).forEach(function(key) {      

            if(key=='success'){

              _e_fullname.value="";

              _e_phone.value="";

              //_e_email.value="";

              _e_address.value="";

              _e_txtdate.value="";

              _e_job.value="";

                //_e_consultant_form.getElementsByClassName('address')[0].value = "";

                //_e_consultant_form.getElementsByClassName("result")[0].innerHTML = "Cảm ơn bạn "+myArr.firstname+" đã tham gia<br>";

                //var myCanvas = document.getElementById('my_canvas_id');

                //var ctx = myCanvas.getContext('2d');

                //ctx.clearRect(0, 0, myCanvas.width, myCanvas.height);

                //myCanvas.setAttribute("height", "0px");

				        //myCanvas.setAttribute("width", "0px");

                _e_load.style.display = "none";

                 _e_result.innerHTML="<h2 class='success'>Chúc mừng bạn đã tham gia thành công</h2>";

                 setTimeout(function(){

                    _e_result.innerHTML="";

                    _e_info_form_consult.style.display = "none";

                 },6000);  

            }else if(key=='error'){

              _e_result.innerHTML=myArr.error;

            }

          });

          _e_load.style.display = "none";      

      }

  }

  http.send(params);

}

