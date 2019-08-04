   $(document).ready(function(){
 $('.delete_form').on('submit', function(){
  if(confirm("Are you sure you want to delete it?")){
   return true;
  }
  else {
   return false;
  }
 });
   
	$("#myDatepicker2").on("dp.change",function (e) {
	       fn_change_hidden();
	});
});
function inverse_format_mysql(_string_time){
	var convert="";
	var _split_time = _string_time.split(" ");
	_string_time = _split_time[0];
	_string_time = _string_time.split("-");
	convert = _string_time[2]+"-"+_string_time[1]+"-"+_string_time[0];
	return convert;
}
function convert_time_format_mysql(_string_time){
	var convert="";
	var _split_time = _string_time.split(" ");
	_string_time = _split_time[0];
	_string_time = _string_time.split("-");
	convert = _string_time[2]+"-"+_string_time[1]+"-"+_string_time[0];
	return convert;
}
var convert_str = convert_time_format_mysql(birthday);
var _e_birthday = document.getElementsByName("birthday")[0];
var _e_hidden_birthday = document.getElementsByName("_birthday")[0];
if(_e_birthday){
	_e_birthday.value = convert_str;
	_e_birthday.addEventListener("change", fn_change_hidden);
}
function fn_change_hidden(){
	var string_input = _e_birthday.value;
	string_input = inverse_format_mysql(string_input);
	_e_hidden_birthday.value = string_input;
}
