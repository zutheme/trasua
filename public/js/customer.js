
var e_frm_create_post = document.getElementsByClassName("frm_post")[0];
var e_modal_frm_action = document.getElementsByClassName('modal-cus')[0];
var e_close = e_modal_frm_action.getElementsByClassName('close')[0]
var e_btn_action = document.getElementsByClassName('btn-action');

for (var i = e_btn_action.length - 1; i >= 0; i--) {
    e_btn_action[i].addEventListener("click", popup_modal);
}
function popup_modal(){
	e_modal_frm_action.style.display = "block";
}
e_close.onclick = function(){
     e_modal_frm_action.style.display = "none";
}

// $(document).ready(function(){
//         $.ajaxSetup({
//             headers: {
//                 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
//             }
//         });
//         $(".btn-submit").click(function(e){
//             e.preventDefault();
//             var _title = $("input[name=title]").val();
//             var _body = $("textarea[name=body]").val();
//             var _url = $("input[name=url]").val();
//             var _sel_idposttype = $('select[name=sel_idposttype]').val();
//             var _sel_idcategory = $('select[name=sel_idcategory]').val();
//             $.ajax({
//                type:'POST',
//                url:'svpost/makepost',
//                data:{title:_title, body:_body,sel_idposttype:_sel_idposttype,sel_idcategory:_sel_idcategory},
//                success:function(data){
//                   //alert(data.success);
//                   if(data.id_svpost > 0){
//                     e_modal_frm_action.style.display = "none";
//                   }
//                }
//             });
//     	   });
// });
var e_btn_submit = document.getElementsByClassName('btn-submit')[0];
e_btn_submit.addEventListener("click", makepost);
function makepost(){
  var _url = document.URL;
  var _e_frm_reg = this.parentElement.parentElement.parentElement;
  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
  var _title = _e_frm_reg.getElementsByClassName("title").value;
  var _body = _e_frm_reg.getElementsByClassName("body").value;
  var _url = _e_frm_reg.getElementsByClassName("url").value;
  var _sel_idposttype =  _e_frm_reg.getElementsByClassName("sel_idposttype").value;
  var _sel_idcategory = _e_frm_reg.getElementsByClassName("sel_idcategory").value;
  var http = new XMLHttpRequest();
  var url = "svpost/makepost";
  //var obj = JSON.stringify({name:"John Rambo", email:_email});
  //var params = "action=hatazu_plug_register_customer&email="+obj;
  var params = "title="+_title+"&body="+_body+"&url="+_url+"&sel_idposttype="+_sel_idposttype+"&sel_idcategory="+_sel_idcategory;
  // //Send the proper header information along with the request
  http.open("POST", url, true);
  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
  //http.setRequestHeader("Accept", "application/json");
  //http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  var load = _e_frm_reg.getElementsByClassName("loading")[0];
  //load.style.display = "block";
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
