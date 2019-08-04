function func_up(element){
	var _e_parent_item = element.parentElement.parentElement;
	var _e_parent_topping = _e_parent_item.parentElement.parentElement.getElementsByClassName("cart-list-topping")[0];	
	var _e_order_topping = _e_parent_topping.getElementsByClassName("order-topping");
	var _ordertopping = 0;
	var _e_item_qlty = _e_parent_item.getElementsByClassName("c-item-qlty")[0];
	var _item_qlty = parseInt(_e_item_qlty.value) + 1;
	_e_item_qlty.value = _item_qlty;
	var _e_order = _e_parent_item.getElementsByClassName("order")[0];
	var _order = parseInt(_e_order.value);
	var re_items = localStorage.getItem('l_items');
	var itemts = JSON.parse(re_items);
	itemts[_order].quality = _item_qlty;
	for (var i = _e_order_topping.length - 1; i >= 0; i--) {
		_ordertopping = parseInt(_e_order_topping[i].value);
		itemts[_ordertopping].quality = _item_qlty;
	}
	var temp_items = itemts;
	//console.log(temp_items);
	localStorage.removeItem("l_items");
	localStorage.setItem('l_items', JSON.stringify(temp_items));
	listitem();
}
function func_down(element){
	var _e_parent_item = element.parentElement.parentElement;
	var _e_item_qlty = _e_parent_item.getElementsByClassName("c-item-qlty")[0];
	var _item_qlty = parseInt(_e_item_qlty.value);
	var _e_parent_topping = _e_parent_item.parentElement.parentElement.getElementsByClassName("cart-list-topping")[0];	
	var _e_order_topping = _e_parent_topping.getElementsByClassName("order-topping");
	var _ordertopping = 0;
	if(_item_qlty > 1){
		_item_qlty =  parseInt(_e_item_qlty.value) - 1;
		_e_item_qlty.value = _item_qlty;
		var _e_order = _e_parent_item.getElementsByClassName("order")[0];
		var _order = parseInt(_e_order.value);
		var re_items = localStorage.getItem('l_items');
		var itemts = JSON.parse(re_items);
		itemts[_order].quality = _item_qlty;
		for (var i = _e_order_topping.length - 1; i >= 0; i--) {
			_ordertopping = parseInt(_e_order_topping[i].value);
			itemts[_ordertopping].quality = _item_qlty;
		}
		var temp_items = itemts;
		//console.log(temp_items);
		localStorage.removeItem("l_items");
		localStorage.setItem('l_items', JSON.stringify(temp_items));
		listitem();
	}
}
function remove_item(element){
	var _e_parent_item = element.parentElement.parentElement;
	var _e_order = _e_parent_item.getElementsByClassName("order")[0];
	var _order = parseInt(_e_order.value);
	var re_items = localStorage.getItem('l_items');
	var itemts = JSON.parse(re_items);
	itemts[_order].trash = 1;
	var temp_items = itemts;
	localStorage.removeItem("l_items");
	localStorage.setItem('l_items', JSON.stringify(temp_items));
	listitem();
	total_items();
	load_items();
}
function listitem() {
	var _e_div1='';var _e_div2='';var _e_div3='';var _e_div4='';var show_all='';
	var _all_items = document.getElementsByClassName("all-items")[0];
	var _e_shop_cart_page = document.getElementsByClassName("c-shop-cart-page-1")[0];
	//_e_shop_cart_page.innerHTML ="";
	_e_div1 = '<div class="row c-cart-table-title">'
	+'<div class="col-md-2 c-cart-image">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Hình ảnh</h3>'
	+'</div>'
	+'<div class="col-md-4 c-cart-desc">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Mô tả</h3>'
	+'</div>'
	+'<div class="col-md-1 c-cart-ref">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Size</h3>'
	+'</div>'
	+'<div class="col-md-1 c-cart-qty">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Số lượng</h3>'
	+'</div>'
	+'<div class="col-md-2 c-cart-price">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Đơn giá</h3>'
	+'</div>'
	+'<div class="col-md-1 c-cart-total">'
	+	'<h3 class="c-font-uppercase c-font-bold c-font-16 c-font-grey-2">Tổng cộng</h3>'
	+'</div>'
	+'<div class="col-md-1 c-cart-remove"></div>'
	+'</div>';
	//document.write(_e_div1);
	var re_items = localStorage.getItem('l_items');
	var itemts = JSON.parse(re_items);
	var _unit_price = 0;var _sub_total = 0; var _sub_unit_qly = 0;
	//console.log(itemts);
	var _trash;var _parent_id;var _count = 0;var _orderid=0;var _quality = 0;var _idproduct = 0;var _ul = '';
	for ( var index=0; index < itemts.length; index++ ) {   
			_parent_id = itemts[index].parent_id;
			_trash = itemts[index].trash;       
	   if(_parent_id == 0 && _trash == 0){
	   		_idproduct = itemts[index].idproduct;
	   		_orderid = itemts[index].orderid;
	   		_quality = parseInt(itemts[index].quality);
	   		_unit_price = parseInt(itemts[index].price_str);
	   		_ul = '<ul class="cart-list-topping">';
	       	for ( var i=0; i < itemts.length; i++ ) {
	     		_parent_id = itemts[i].parent_id;
	     		_trash = itemts[i].trash;
	     		if(_parent_id ==_orderid && _trash == 0){
	     			_unit_price = _unit_price + parseInt(itemts[i].price_str);
	     			_ul = _ul + '<li><input type="hidden" class="order-topping" name="order-topping" value="'+i+'">';
	     			_ul = _ul + '<label>'+ show_currency(itemts[i].price_str) +'<span class="vnd"></span>'+ itemts[i].title +'</label>&nbsp;&nbsp;<a href="javascript:void(0);" class="trash" onclick="remove_topping(this);">x</a></li>';
	     		}
	 		}
	 		_sub_unit_qly = _unit_price*_quality;
	 		_sub_total = _sub_total + _sub_unit_qly;
	 		_ul = _ul;	    	
		    _e_div2 = _e_div2 +'<div class="row c-cart-table-row">'
			+'<h2 class="c-font-uppercase c-font-bold c-theme-bg c-font-white c-cart-item-title c-cart-item-first">'+itemts[index].title+'</h2>'
			+'<div class="col-md-2 col-sm-3 col-xs-5 c-cart-image">'
			+'<img src="'+itemts[index].src_img+'">'
			+'</div>'
			+'<div class="col-md-4 col-sm-9 col-xs-7 c-cart-desc">'
			+	'<h3><a href="'+_url_show+_idproduct+'" class="c-font-bold c-theme-link c-font-22 c-font-dark">'+itemts[index].title+'</a></h3>'
			+	_ul
			+'</div>'
			+'<div class="col-md-1 col-sm-3 col-xs-6 c-cart-ref">'
			+	'<p class="c-cart-sub-title c-theme-font c-font-uppercase c-font-bold">SIZE</p>'
			+	'<p>'+itemts[index].size_name+'</p>'
			+'</div>'
			+'<div class="col-md-1 col-sm-3 col-xs-6 c-cart-qty">'
			+	'<p class="c-cart-sub-title c-theme-font c-font-uppercase c-font-bold">SL</p>'
			+	'<div class="c-input-group c-spinner">'
			+		'<input type="hidden" class="order" value="'+index+'"/>'
			+	    '<input type="text" class="form-control c-item-qlty" value="'+_quality+'">'
			+	    '<div class="c-input-group-btn-vertical">'
			+	    	'<button class="btn btn-default btn-up" type="button" onclick="func_up(this)"><i class="fa fa-caret-up"></i></button>'
			+	    	'<button class="btn btn-default btn-down" type="button" onclick="func_down(this)"><i class="fa fa-caret-down"></i></button>'
			+	    '</div>'
			+	'</div>'
			+'</div>'
			+'<div class="col-md-2 col-sm-3 col-xs-6 c-cart-price">'
			+	'<p class="c-cart-sub-title c-theme-font c-font-uppercase c-font-bold">Đơn giá</p>'
			+	'<p class="c-cart-price c-font-bold">'+show_currency(_unit_price)+'<span class="vnd"></span></p>'
			+'</div>'
			+'<div class="col-md-1 col-sm-3 col-xs-6 c-cart-total">'
			+	'<p class="c-cart-sub-title c-theme-font c-font-uppercase c-font-bold">Tổng cộng</p>'
			+	'<p class="c-cart-price c-font-bold">'+show_currency(_sub_unit_qly)+'<span class="vnd"></span></p>'
			+'</div>'
			+'<div class="col-md-1 col-sm-12 c-cart-remove">'
			+	'<a href="#" class="c-theme-link c-cart-remove-desktop" onclick="remove_item(this)">×</a>'
			+	'<a href="#" class="c-cart-remove-mobile btn c-btn c-btn-md c-btn-square c-btn-red c-btn-border-1x c-font-uppercase" onclick="remove_item(this)">Xóa</a>'
			+'</div>'
		+'</div>';
			  }         
		}
		_e_div3 = '<div class="row">'
				+'<div class="c-cart-subtotal-row c-margin-t-20">'
				+	'<div class="col-md-2 col-md-offset-9 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+		'<h3 class="c-font-uppercase c-font-bold c-right c-font-16 c-font-grey-2">Tổng</h3>'
				+	'</div>'
				+	'<div class="col-md-1 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+		'<h3 class="c-font-bold c-font-16">'+show_currency(_sub_total)+'<span class="vnd"></span></h3>'
				+	'</div>'
				+'</div>'
				+'</div>'
				+'<div class="row">'
				+	'<div class="c-cart-subtotal-row">'
				+		'<div class="col-md-2 col-md-offset-9 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+			'<h3 class="c-font-uppercase c-font-bold c-right c-font-16 c-font-grey-2">Phí vận chuyển</h3>'
				+		'</div>'
				+		'<div class="col-md-1 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+			'<h3 class="c-font-bold c-font-16">0.000<span class="vnd"></span></h3>'
				+		'</div>'
				+	'</div>'
				+'</div>'
				+'<div class="row">'
				+	'<div class="c-cart-subtotal-row">'
				+		'<div class="col-md-2 col-md-offset-9 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+			'<h3 class="c-font-uppercase c-font-bold c-right c-font-16 c-font-grey-2">Tổng cộng</h3>'
				+		'</div>'
				+		'<div class="col-md-1 col-sm-6 col-xs-6 c-cart-subtotal-border">'
				+			'<h3 class="c-font-bold c-font-16">'+show_currency(_sub_total)+'<span class="vnd"></span></h3>'
				+		'</div>'
				+	'</div>'
				+'</div>'
			;
		_e_div4 ='<div class="c-cart-buttons">'
				+'	<a href="'+url_home+'" class="btn c-btn btn-lg c-btn-red c-btn-square c-font-white c-font-bold c-font-uppercase c-cart-float-l">Tiếp tục mua</a>'
				+	'<a href="'+_url_check_out+'"  class="btn c-btn btn-lg c-theme-btn c-btn-square c-font-white c-font-bold c-font-uppercase c-cart-float-r">Thanh toán</a>'
				+'</div>';
			    show_all = _e_div1 + _e_div2 + _e_div3 +_e_div4;
			    _e_shop_cart_page.innerHTML = show_all;
	}
	function remove_topping(element){
		var _e_parent_top = element.parentElement;
		var _e_parent_toping = _e_parent_top.getElementsByClassName("order-topping")[0];
		var _order_topping =  _e_parent_toping.value;
		var re_items = localStorage.getItem('l_items');
		var itemts = JSON.parse(re_items);
		itemts[_order_topping].trash = 1;
		var temp_items = itemts;
		localStorage.removeItem("l_items");
		localStorage.setItem('l_items', JSON.stringify(temp_items));
		listitem();
		total_items();
	}
function check_list_items(){
	var re_items = localStorage.getItem('l_items');
	if(!isRealValue(re_items)) return false;
	var itemts = JSON.parse(re_items);
	//console.log(itemts);
	var _trash;var _parent_id;var _count = 0;var _orderid=0;
	for ( var index=0; index < itemts.length; index++ ) {   
			_parent_id = itemts[index].parent_id;
			_trash = itemts[index].trash;       
	   		if(_parent_id == 0 && _trash == 0) return true;
	}
	return false;
}
var _e_modal_form_nocart = document.getElementsByClassName("modal-nocart-form")[0];
var _e_modal_nocart = _e_modal_form_nocart.getElementsByClassName("modal-nocart")[0];
var _e_close_nocart = _e_modal_nocart.getElementsByClassName("close")[0];
function load_items(){
	if(check_list_items()){
		listitem();
	}else{
		note_nocart();
	}
}
load_items();
function note_nocart(){
	_e_modal_nocart.style.display = "block";
}
_e_close_nocart.addEventListener("click",close_note_nocart);
function close_note_nocart(){
	_e_modal_nocart.style.display = "none";
}