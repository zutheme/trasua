
var e_frm_create_post = document.getElementsByClassName("frm_post")[0];
var e_modal_frm_action = document.getElementsByClassName('modal-cus')[0];
var e_close = e_modal_frm_action.getElementsByClassName('close')[0]
// var e_btn_action = document.getElementsByClassName('btn-action');
// for (var i = e_btn_action.length - 1; i >= 0; i--) {
//     e_btn_action[i].addEventListener("click", popup_modal);
// }

function popup_modal(_idpost){
  e_frm_create_post.getElementsByClassName("idpost")[0].value = _idpost;
	e_modal_frm_action.style.display = "block";
}
e_close.onclick = function(){
     e_modal_frm_action.style.display = "none";
}

var e_btn_submit = document.getElementsByClassName('btn-submit')[0];
e_btn_submit.addEventListener("click", makepost);
function makepost(){
  var _url = document.URL;
  var _e_frm_reg = this.parentElement.parentElement.parentElement;
  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
  var _idpost = _e_frm_reg.getElementsByClassName("idpost")[0].value;
  var _body = _e_frm_reg.getElementsByClassName("body")[0].value;
  var _sel_idposttype =  _e_frm_reg.getElementsByClassName("sel_idposttype")[0].value;
  var _sel_idstatustype =  _e_frm_reg.getElementsByClassName("sel_idstatustype")[0].value;
  if(!_body){
      alert("Bạn chưa nhập nội dung");
      return false;
  }
  if (!_sel_idposttype){
    alert("Bạn chưa chọn kiểu nội dung");
    return false;
  }if (!_sel_idstatustype){
    alert("Bạn chưa chọn trạng thái");
    return false;
  }
  var http = new XMLHttpRequest();
  var url = "/marketing/admin/customerreg/interactive";
  //var obj = JSON.stringify({name:"John Rambo", email:_email});
  var params = "body="+_body+"&sel_idposttype="+_sel_idposttype+"&idpost="+_idpost+"&id_status_type="+_sel_idstatustype;
  http.open("POST", url, true);
  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
  http.setRequestHeader("Accept", "application/json");
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  var load = _e_frm_reg.getElementsByClassName("loading")[0];
  load.style.display = "block";
  http.onreadystatechange = function() {
      if(http.readyState == 4 && http.status == 200) {
          //alert(http.responseText);
          var myArr = JSON.parse(this.responseText);
          console.log(myArr);
           Object.keys(myArr).forEach(function(key) {      
            if(key=='success'){
               _e_frm_reg.getElementsByClassName('idpost')[0].value = "";
                _e_frm_reg.getElementsByClassName('body')[0].value = "";
                //_e_frm_reg.getElementsByClassName("result")[0].innerHTML = "Cảm ơn bạn "+myArr[key][0].id_exppost+"";
                _e_frm_reg.getElementsByClassName("result")[0].innerHTML = "success";
                setTimeout(function(){
                   e_modal_frm_action.style.display = "none";
                },3000);  
            }else if(key=='error'){
              _e_frm_reg.getElementsByClassName("result")[0].innerHTML = myArr.error;
            }
          });
          load.style.display = "none";    
      }
  }
  http.send(params);
} 

$(document).ready(function(){
    $('#myDatepicker1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss'
    });
    $('#myDatepicker2').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss'
    });
    // $("#myDatepicker2").on("dp.change", function(e) {
    //$("input[name='_start_date']").val(_start_date_sl);
    // });
    // $('yourpickerid').on('changeDate', function(ev){
    //     $(this).datepicker('hide');
    // });
    if(_start_date_sl&&_end_date_sl){
        $("input[name='_start_date']").val(_start_date_sl);
        $("input[name='_end_date']").val(_end_date_sl);
    }else{
      //var str_start = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" "+today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
      var today = new Date();
      var str_start = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" 00:00:00";
      var str_end = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" 23:59:59";
        $("input[name='_start_date']").val(str_start);
        $("input[name='_end_date']").val(str_end);
    }
});