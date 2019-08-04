var _e_sel_role = document.getElementsByName("sel_idrole")[0];
	var _e_option_role = _e_sel_role.getElementsByTagName("option");
	for (var i = _e_option_role.length - 1; i >= 0; i--) {
		if(_e_option_role[i].value==selected_idrole){
			_e_option_role[i].setAttribute("selected", true);
		}
	}
	var _e_sel_touser = document.getElementsByName("sel_touser")[0];
	var _e_option_touser = _e_sel_touser.getElementsByTagName("option");
	for (var i =  _e_option_touser.length - 1; i >= 0; i--) {
		if( _e_option_touser[i].value==selected_toiduser){
			_e_option_touser[i].setAttribute("selected", true);
		}
	}