var _e_menu_home = document.getElementsByClassName("menu-home")[0].getElementsByClassName("c-theme-nav")[0];
//var _e_li = _e_menu_home.getElementsByTagName('li');
var _e_hidden_menu = document.getElementsByClassName("hidden-menu")[0];
var _e_li_hidden = _e_hidden_menu.getElementsByTagName('li');
for (var i = _e_li_hidden.length - 1; i >= 0; i--) {
	_e_menu_home.appendChild(_e_li_hidden[i]);
}