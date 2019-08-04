
var e_frm_create_post = document.getElementsByClassName("frm_create_post")[0];
//var dropdown =  document.getElementsByClassName("cus-drop");
var objArray = [];
function post_type(id, name) {
    this.id = id;
    this.name = name;
}
for (var i = dropdown.length - 1; i >= 0; i--) {
  var d = dropdown[i].addEventListener("change",myFunction);
}

function findObjectByKey(array, key, value) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return array[i];
        }
    }
    return null;
}

function myFunction() {
    var x = this.selectedIndex;
    var y = this.options;
    var pa = this.parentElement.parentElement.parentElement;
    var val = y[x].index;
    var txt = y[x].text;
    pa.getElementsByClassName("id_post_type")[0].value = val;
}
//var result = findObjectByKey(objArray, 'id', _id_post_type);
// var val_href = result['name'];
// //console.log(val_href);
// if(val_href){
// 	 //e_frm_create_post.getElementsByClassName("id_post_type")[0].value = val_href;
// 	 e_frm_create_post.getElementsByClassName("selected")[0].innerHTML = val_href;
// }

//var regex = /#/gi;
//var val = a_val.replace(regex, '');

var e_modal_frm_action = document.getElementsByClassName('modal-cus')[0];
var e_close = e_modal_frm_action.getElementsByClassName('close')[0]
var e_btn_action = document.getElementsByClassName('btn-action');
//console.log(e_btn_action);
for (var i = e_btn_action.length - 1; i >= 0; i--) {
    e_btn_action[i].addEventListener("click", popup_modal);
}
function popup_modal(){
	e_modal_frm_action.style.display = "block";
}
e_close.onclick = function(){
     e_modal_frm_action.style.display = "none";
}

$(document).ready(function(){
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });
        $(".btn-submit").click(function(e){
            e.preventDefault();
            var _title = $("input[name=title]").val();
            var _body = $("textarea[name=body]").val();
            var _url = $("input[name=url]").val();
            var _sel_idposttype = $('select[name=sel_idposttype]').val();
            var _sel_idcategory = $('select[name=sel_idcategory]').val();
            $.ajax({
               type:'POST',
               url:'svpost/makepost',
               data:{title:_title, body:_body,sel_idposttype:_sel_idposttype,sel_idcategory:_sel_idcategory},
               success:function(data){
                  //alert(data.success);
                  if(data.id_svpost > 0){
                    e_modal_frm_action.style.display = "none";
                  }
               }
            });
    	   });
});
var e_btn_submit = document.getElementsByClassName('btn-submit')[0];
e_btn_submit.addEventListener("click", makepost);
function makepost(){
  var _e_frm_reg = modalreg.getElementsByClassName('frm_create_post')[0];
  var _modal = modalreg.getElementsByClassName('modal')[0];
  var _url = document.URL;
  var _e_frm_reg = this.parentElement.parentElement;
  //console.log(_e_frm_reg);
  var _fullname = _e_frm_reg.getElementsByClassName('fullname')[0].value;
  //console.log(_fullname);
  var _phone = _e_frm_reg.getElementsByClassName('phone')[0].value;
  var _email = _e_frm_reg.getElementsByClassName('email')[0].value;
  
  var http = new XMLHttpRequest();
  var url = "http://api.thammyvienthienkhue.vn/api/svcustomers";
  //var obj = JSON.stringify({name:"John Rambo", email:_email});
  //var params = "action=hatazu_plug_register_customer&email="+obj;
  var params = "firstname="+_fullname+"&mobile="+_phone+"&email="+_email+"&address="+_address+"&job="+_job;
  http.open("POST", url, true);
  // //Send the proper header information along with the request
  http.setRequestHeader("Accept", "application/json");
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  var load = _e_frm_reg.getElementsByClassName("loading")[0];
  load.style.display = "block";
  http.onreadystatechange = function() {
      if(http.readyState == 4 && http.status == 200) {
          //alert(http.responseText);
           var myArr = JSON.parse(this.responseText);
          console.log(myArr);       
      }
  }
  
  http.send(params);
} 
//end request
function sel_category(element) {
      var x = this.selectedIndex;
      var y = this.options;
      var pa = this.parentElement.parentElement.parentElement;
      var val = y[x].index;
      var txt = y[x].text;
      pa.getElementsByClassName(element)[0].value = val;
}