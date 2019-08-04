var _e_order_list = document.getElementsByClassName("list_order")[0];
function sub_order_list() {
	var _e_sub1='<li class="row c-margin-b-15">'
	+'<div class="col-md-6 c-font-20"><h2>Sản phẩm</h2></div>'
	+'<div class="col-md-6 c-font-20"><h2>Tổng cộng</h2></div>'
	+'</li>'
	+'<li class="row c-border-bottom"></li>';
	var re_items = localStorage.getItem('l_items');
	var itemts = JSON.parse(re_items);
	var _unit_price = 0;var _sub_total = 0; var _sub_unit_qly = 0;var _price = 0;
	console.log(itemts);
	var _trash;var _title;var _parent_id;var _count = 0;var _orderid=0;var _quality = 0;var _idproduct = 0;var _e_li = '';var list_order_product="";
	for ( var index=0; index < itemts.length; index++ ) {   
			_parent_id = itemts[index].parent_id;
			_trash = itemts[index].trash;       
	   if(_parent_id == 0 && _trash == 0){
	   		_title = itemts[index].title;
	   		_idproduct = itemts[index].idproduct;
	   		_orderid = itemts[index].orderid;
	   		_quality = parseInt(itemts[index].quality);
	   		_unit_price = parseInt(itemts[index].price_str);
	   		list_order_product = [{ idproduct:_idproduct, parent_id:_parent_id, quality:_quality }];
	   		  _e_li = _e_li + '<li class="row c-margin-b-15 c-margin-t-15">';
	   		  _e_li = _e_li + '<input type="hidden" name="l_idproduct[]" value="'+_idproduct+'">';
			  _e_li = _e_li + '<input type="hidden" name="l_parent_id[]" value="0">';
			  _e_li = _e_li + '<input type="hidden" name="l_quality[]" value="'+_quality+'">';
			  _e_li = _e_li + '<input type="hidden" name="l_unit_price[]" value="'+_unit_price+'">';
	       	for ( var i=0; i < itemts.length; i++ ) {  
	     		_parent_id = itemts[i].parent_id;
	     		_trash = itemts[i].trash;
	     		if(_parent_id ==_orderid && _trash == 0){
	     			_cross_title = itemts[i].title;
			   		_cross_idproduct = itemts[i].idproduct;
			   		_cross_orderid = itemts[i].orderid;
			   		_cross_quality = parseInt(itemts[i].quality);
			   		_cross_price = parseInt(itemts[i].price_str);
	     			_e_li = _e_li + '<input type="hidden" name="l_idproduct[]" value="'+_cross_idproduct+'">';
					_e_li = _e_li + '<input type="hidden" name="l_parent_id[]" value="'+_idproduct+'">';
					_e_li = _e_li + '<input type="hidden" name="l_quality[]" value="'+_cross_quality+'">';
					_e_li = _e_li + '<input type="hidden" name="l_unit_price[]" value="'+_cross_price+'">';
			   		_unit_price = _unit_price + parseInt(itemts[i].price_str); 			
	     		}
	 		}
	 		_sub_unit_qly = _unit_price*_quality;
	 		_sub_total = _sub_total + _sub_unit_qly;
	 		_e_li = _e_li + '<div class="col-md-6 c-font-20"><a href="'+_url_show+_idproduct+'" class="c-theme-link">'+_title+' x '+_quality+'</a></div>';
	     	_e_li = _e_li + '<div class="col-md-6 c-font-20">';
 			_e_li = _e_li + '<p class="">'+show_currency(_sub_unit_qly)+'<span class="vnd"></span></p>';
 			_e_li = _e_li + '</div>';
	 		_e_li = _e_li + '</li>';
	 	}
	}
	
	var _e_sub3 = '<li class="row c-margin-b-15 c-margin-t-15">'
	+'<div class="col-md-6 c-font-20">Tổng</div>'
	+'<div class="col-md-6 c-font-20">'
	+	'<p class=""><span class="c-subtotal">'+show_currency(_sub_total)+'</span><span class="vnd"></span></p>'
	+'</div>'
	+'</li>';
	var _e_sub4='<li class="row c-border-top c-margin-b-15"></li>'
	+'<li class="row">'
	+	'<div class="col-md-6 c-font-20">Phí vận chuyển</div>'
	+	'<div class="col-md-6">'
	+		'<div class="c-radio-list c-shipping-calculator">'
	+			'<div class="c-radio">'
	+				'<p class="c-shipping-price c-font-bold c-font-20">0.000<span class="vnd"></span></p>'
	+			'</div>'
	+		'</div>'
	+	'</div>'
	+'</li>'
	+'<li class="row c-margin-b-15 c-margin-t-15">'
	+	'<div class="col-md-6 c-font-20">'
	+		'<p class="c-font-30">Tổng cộng</p>'
	+	'</div>'
	+	'<div class="col-md-6 c-font-20">'
	+		'<p class="c-font-bold c-font-30"><span class="c-shipping-total">'+show_currency(_sub_total)+'</span><span class="vnd"></span></p>'
	+	'</div>'
	+'</li>';
	var list_json = JSON.stringify(list_order_product);
	console.log(list_json);
	var _e_sub5 = '<input type="hidden" name="order_listproduct" value="'+list_order_product+'">'
	_e_order_list.innerHTML ="";
	var _html_order_list = _e_sub1 + _e_li + _e_sub3 + _e_sub4 + _e_sub5;
	_e_order_list.innerHTML = _html_order_list;
}
sub_order_list();
								