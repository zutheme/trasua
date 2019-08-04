var _e_modal_cross_form = document.getElementsByClassName("modal-cross-form")[0];
var _e_modal_cross = _e_modal_cross_form.getElementsByClassName("modal-cross")[0];
var _e_close = _e_modal_cross.getElementsByClassName("close")[0];
function cross_product(){
	_e_modal_cross.style.display = "block";
}
_e_close.addEventListener("click", close_cross);
function close_cross(){
	_e_modal_cross.style.display = "none";
}
