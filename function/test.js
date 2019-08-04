function show_curency(variable) {
	var exp = "";
	var digits = (""+variable).split("");
	var count = 1;
	var str_number = [];
	for (var i = variable.length - 1; i >= 0; i--) {
		console.log(variable[i]);
		if(count % 3 ==0 ){
			str_number.push(variable[i]);
			str_number.push(".");
		}else{
			str_number.push(variable[i]);
		}
		count++;
	}
	//document.write(exp);
	console.log(str_number);
}
