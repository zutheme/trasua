var _e_sel_perm = document.getElementsByName("sel_idperm")[0];
	console.log(_e_sel_perm);
	var _e_option_perm = _e_sel_perm.getElementsByTagName("option");
	for (var i = _e_option_perm.length - 1; i >= 0; i--) {
		if(_e_option_perm[i].value==selected_idperm){
			_e_option_perm[i].setAttribute("selected", true);
		}
	}
	var _e_sel_role = document.getElementsByName("sel_idrole")[0];
	var _e_option_role = _e_sel_role.getElementsByTagName("option");
	for (var i =  _e_option_role.length - 1; i >= 0; i--) {
		if( _e_option_role[i].value==selected_idrole){
			_e_option_role[i].setAttribute("selected", true);
		}
	}