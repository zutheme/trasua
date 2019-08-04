function show_currency(variable) {
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