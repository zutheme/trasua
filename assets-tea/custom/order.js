var _e_btn_cart = document.getElementsByClassName("btn-cart");
for (var i = _e_btn_cart.length - 1; i >= 0; i--) {
	_e_btn_cart[i].addEventListener("click", AddCart);
}
function AddCart(){
	  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
	  var http = new XMLHttpRequest();
	  var url = "/teamilk/addcart";
	  var _e_cart = this.parentElement;
	  var _idproduct = _e_cart.getElementsByClassName("idproduct")[0].value; 
	  var _namestore = "order";
	  var params = JSON.stringify({"idproduct":_idproduct,"namestore":_namestore});
	  http.open("POST", url, true);
	  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
	  http.setRequestHeader("Accept", "application/json");
	  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	  var load = document.getElementsByClassName("loading")[0];
	  load.style.display = "block";
	  http.onreadystatechange = function() {
	      if(http.readyState == 4 && http.status == 200) {
	          var myArr = JSON.parse(this.responseText);
	          console.log(myArr);
	          load.style.display = "none";
	      }
	  }
	  http.send(params);
}