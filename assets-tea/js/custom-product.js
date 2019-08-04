var _e_c_product_size = document.getElementsByClassName("c-product-size")[0];
var _e_radio_size = _e_c_product_size.getElementsByClassName("lb_radio");
var _e_product_price = document.getElementsByClassName("c-product-price")[0];
var _e_plus_topping = document.getElementsByClassName("plus-topping")[0];
var _e_ul_plus = _e_plus_topping.getElementsByClassName("plus")[0];
var _e_product_add_cart = document.getElementsByClassName("c-product-add-cart")[0];
var _e_amount = _e_product_add_cart.getElementsByClassName("amount")[0];
for (var i = _e_radio_size.length - 1; i >= 0; i--) {
	_e_radio_size[i].addEventListener("click", change_size);
}
var _e_item_cart = _e_c_product_size.getElementsByClassName("item")[0];
var _e_idproduct_cart = _e_item_cart.getElementsByClassName("cross_idproduct")[0];
var _idproduct_cart = _e_idproduct_cart.value;
var _e_size_cart = _e_item_cart.getElementsByClassName("radio_size")[0];
var _size_cart = _e_size_cart.value;
var _e_size_name = _e_item_cart.getElementsByClassName("lb_radio")[0];
var _size_name = _e_size_name.innerHTML;
var _e_price_cart = _e_item_cart.getElementsByClassName("cross_price")[0];
var _price_cart = _e_price_cart.value;
var _amount_cart = parseInt(_e_amount.value);
var _e_src_thumb = _e_item_cart.getElementsByClassName("cross-thumb")[0];
var _src_thumb = _e_src_thumb.value;
var _e_namepro = _e_item_cart.getElementsByClassName("name-product")[0];
var _namepro = _e_namepro.value;

function change_size() {
	var _e_item = this.parentElement;
	var _e_idproduct_cart = _e_item.getElementsByClassName("cross_idproduct")[0];
	var _e_radio_size = _e_item.getElementsByClassName("radio_size")[0];
	var _e_size_name = _e_item.getElementsByClassName("lb_radio")[0];
	_size_name = _e_size_name.innerHTML;
	var _e_cross_thumb = _e_item.getElementsByClassName("cross-thumb")[0];
	_src_thumb = _e_cross_thumb.value;
	var _e_namepro = _e_item.getElementsByClassName("name-product")[0];
	_namepro = _e_namepro.value;
	_price_cart = _e_item.getElementsByClassName("cross_price")[0].value;
	_e_product_price.innerHTML = '<span class="currency">'+show_currency(_price_cart)+'</span><span class="vnd"></span>';
	_e_radio_size.checked = true;
	_size_cart = _e_radio_size.value;
	_idproduct_cart = _e_idproduct_cart.value;
}
var _e_product_topping = document.getElementsByClassName("c-product-topping")[0];
var _e_list_topping = _e_product_topping.getElementsByClassName("list-topping");
for (var i = _e_list_topping.length - 1; i >= 0; i--) {
	_e_list_topping[i].addEventListener('change', change_checkbox);
}
function change_checkbox(){
	var e_parent = this.parentElement;
	var _price = e_parent.getElementsByClassName("topping_price")[0].value;
	var item_class = "item"+this.value;
	var item = this.parentElement.getElementsByTagName("label")[0].innerHTML;
	if(this.checked) {
         var e_li = document.createElement("li");
         e_li.setAttribute("class",item_class);
         var e_span = document.createElement("span");
         e_span.setAttribute("class","vnd");
         var e_span_topping = document.createElement("span");
         e_span_topping.innerHTML = item;
	     var e_label = document.createElement("label");
	     //e_label.setAttribute("class","currency");
	     e_label.innerHTML = show_currency(_price);
     	 e_li.appendChild(e_label);
     	 e_li.appendChild(e_span);
     	 e_li.appendChild(e_span_topping);
     	 _e_ul_plus.appendChild(e_li);
    } else {
    	var e_child = _e_ul_plus.getElementsByClassName(item_class)[0];
        _e_ul_plus.removeChild(e_child);
    }
}
var _e_btn_up = _e_product_add_cart.getElementsByClassName("btn-up")[0];
var _e_btn_down = _e_product_add_cart.getElementsByClassName("btn-down")[0];
_e_btn_up.addEventListener("click",func_up);
_e_btn_down.addEventListener("click",func_down);
function func_up(){
	 _amount_cart = parseInt(_e_amount.value) + 1;
	 _e_amount.value = _amount_cart;
}
function func_down(){
	if(_amount_cart > 1){
		_amount_cart =  parseInt(_e_amount.value) - 1;
		_e_amount.value = _amount_cart;
	}
}
//addcart
var items_cookie;
var carts = [];
var total = 0;
var cart_items = [];
var item;
var order_id = 0;
var _e_btn_add_cart = _e_product_add_cart.getElementsByClassName("btn-add-cart")[0];
_e_btn_add_cart.addEventListener("click",addcart);
function addcart(){
	var _thumb_topping;
	var _price_topping = 0;
	var _idproduct_topping = 0;
	var _namepro_topping;
	var _index_int = 0;
	var _parent_id = 0;
	var _order_id = 1;
	var re_items = localStorage.getItem('l_items');
	if(!isRealValue(re_items)){
		  item = { orderid:_order_id, parent_id:_parent_id, title:_namepro,idproduct:_idproduct_cart, price_str:_price_cart, src_img:_src_thumb, quality:_amount_cart, size_name:_size_name, trash:0 };
	          cart_items[0] = item;
	          localStorage.setItem('l_items', JSON.stringify(cart_items));
	          _parent_id = _order_id;
	        }else{
	          items_cookie = JSON.parse(re_items);
	          _index_int = items_cookie.length;
	          _order_id = _index_int + 1;
	          item = { orderid:_order_id, parent_id:0, title:_namepro,idproduct:_idproduct_cart, price_str:_price_cart, src_img:_src_thumb, quality:_amount_cart, size_name:_size_name, trash:0 };
	          items_cookie[_index_int] = item;
	          localStorage.setItem('l_items', JSON.stringify(items_cookie));
	          _parent_id = _order_id;
	      }
		for (var i = _e_list_topping.length - 1; i >= 0; i--) {
			if(_e_list_topping[i].checked) {
				_idproduct_topping = _e_list_topping[i].value;
				_price_topping = _e_list_topping[i].parentElement.getElementsByClassName("topping_price")[0].value;
				_thumb_topping = _e_list_topping[i].parentElement.getElementsByClassName("topping_thumb")[0].value;
				_namepro_topping = _e_list_topping[i].parentElement.getElementsByClassName("namepro_topping")[0].value;
				re_items = localStorage.getItem('l_items');
				items_cookie = JSON.parse(re_items);
				_index_int = items_cookie.length;
	          	_order_id = _index_int + 1;
				item = { orderid:_order_id, parent_id:_parent_id, title:_namepro_topping, idproduct:_idproduct_topping, price_str:_price_topping, src_img:_thumb_topping, quality:_amount_cart, size_name:0, trash:0 };
				items_cookie[_index_int] = item;
	          	localStorage.setItem('l_items', JSON.stringify(items_cookie));
			}
		}     
	    var _l_itemts = localStorage.getItem('l_items');
	    total_items(_l_itemts);
	 	note_addcart();
}
var _e_modal_form_cart = document.getElementsByClassName("modal-cart-form")[0];
var _e_modal_cart = _e_modal_form_cart.getElementsByClassName("modal-cart")[0];
var _e_close = _e_modal_cart.getElementsByClassName("close")[0];
function note_addcart(){
	_e_modal_cart.style.display = "block";
	var _l_itemts = getCookie('l_items');
	if(!isRealValue(_l_itemts)){
		setCookie('l_items',1,3);
	}
}
_e_close.addEventListener("click",close_note_cart);
function close_note_cart(){
	_e_modal_cart.style.display = "none";
}


// function change_price_by_idproduct(_idproduct){
//     var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
//     var http = new XMLHttpRequest();
//     var url = "/teamilk/admin/producthasfile/delete";
//     var params = JSON.stringify({"idproduct":_idproduct});
//     http.open("POST", url, true);
//     http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
//     http.setRequestHeader("Accept", "application/json");
//     http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
//     var load = e_element.getElementsByClassName("loading-trash")[0];
//     load.style.display = "block";
//     http.onreadystatechange = function() {
//         if(http.readyState == 4 && http.status == 200) {
//             var myArr = JSON.parse(this.responseText);
//             if(myArr[0]=='success'){
//               load.style.display = "none";
//             }
//         }
//     }
//     http.send(params);
// }