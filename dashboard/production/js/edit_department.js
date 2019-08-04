
	var _e_sel_parent = document.getElementsByName("sel_idparent")[0];
	var _e_option_parent = _e_sel_parent.getElementsByTagName("option");
	for (var i =  _e_option_parent.length - 1; i >= 0; i--) {
		if( _e_option_parent[i].value==selected_idparent){
			_e_option_parent[i].setAttribute("selected", true);
		}
	}
