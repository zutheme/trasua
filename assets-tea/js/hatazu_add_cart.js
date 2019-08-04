//pick up
var items_cookie;
var carts = [];
var total = 0;
var cart_items = [];
(function( $ ) {
  "use strict";    
  // javascript code here. i.e.: $(document).ready( function(){} );   
  //   $(".nav-tabs a").click(function(event){
  //     $(this).tab('show');
  //     event.preventDefault();
  // }); 
  var badge = $("#add-cart").find(".shopping-cart-header");
  var badge_menu = $("ul.navbar-right").find("li").find("span.badge");
//load item
  setTimeout(function(){ loaditems(); }, 3000);
  function loaditems(){
      var re_items = localStorage.getItem('l_items');
      if(isRealValue(re_items)){
        var items_cookie = JSON.parse(re_items);
        var amount = items_cookie.length;
        if(amount==0) {
          return false;
        }
        badge.find("span.badge").html(amount);
        badge_menu.html(amount);
        var list = document.getElementsByClassName("shopping-cart-items")[0];
        while (list.hasChildNodes()) {   
            list.removeChild(list.firstChild);
        }
        list_items(items_cookie,0);
        panel_left();
      }
  }
  $("#cart").on("click", function(event) {
    event.preventDefault();
    //$(".shopping-cart").fadeToggle( "fast");
    panel_left();
    loaditems();
  });
  var content = $(".product-details").find(".thumbnail");
  var curent = content.find("input.product-details-qty").val();
  curent = parseInt(curent);
  content.find("button.btn-minus").click(function(){
      if(curent >1 ){
        curent = curent -1;
        content.find("input.product-details-qty").val(curent);
        content.find("input._quality").val(curent);
      }
      
  });
  content.find("button.btn-plus").click(function(){
       curent = curent +1;
       content.find(".product-details-qty").val(curent);
       content.find(".product-details-qty").val(curent);
       content.find("input._quality").val(curent);
  });
   $("a.btn-add").click(function(event){
       event.preventDefault();
       var parent = $(this).parent().parent();
       //console.log(parent);
       var title = parent.find("input._title").val();
       var src_img = parent.find("input._src").val(); 
       var idproduct = parent.find("input._idproduct").val();
       var price_str = parent.find("input._price").val();
       var _quality = parent.find("input._quality").val();
       price_str = price_str*_quality;
       //quality
       var item = {titles:title,idproduct:idproduct, price_str:price_str, src_img:src_img, quality:_quality};     
       add_item(item);
   }); 
  })(jQuery);
function add_item(item){
      if(!isRealValue(item)){
        return false;
      }  
      var re_items = localStorage.getItem('l_items');
      if(!isRealValue(re_items)){
        cart_items[0] = item;
        localStorage.setItem('l_items', JSON.stringify(cart_items));
        items_cookie = localStorage.getItem('l_items');
        list_items(items_cookie,0);
      }else{
        items_cookie = JSON.parse(re_items);
        var _index_int = items_cookie.length;
        items_cookie[_index_int] = item;
        localStorage.setItem('l_items', JSON.stringify(items_cookie));
        items_cookie = localStorage.getItem('l_items');
        list_items(items_cookie,_index_int);
      }       
        total_items();
        panel_left();
}
function isRealValue(obj)
{
  return obj && obj !== 'null' && obj !== 'undefined';
}
 function list_items(_l_itemts,_index){
    if(!isRealValue(_l_itemts)){
      return false;
    }
    var re_items = localStorage.getItem('l_items');
    var itemts = JSON.parse(re_items);
     var _index_int = parseInt(_index);
     for ( var index=_index_int; index<itemts.length; index++ ) {
                  //begin create element               
                     if(!isRealValue(itemts[index])){
                       continue;
                     }
                    var _idproduct = itemts[index].idproduct;              
                    var sec_class = "col-sm-12 index"+index;
                    var section = document.createElement("section");
                    section.setAttribute("class", sec_class);    
                    //set atribute class
                    var art_img = document.createElement("article");     
                    art_img.setAttribute("class", "col-sm-4 col-xs-4");
                    //create dom img
                    var get_src = itemts[index].src_img; 
                    var ele_img = document.createElement("img");                             
                    ele_img.setAttribute("src",get_src); 
                    art_img.appendChild(ele_img);        
                    section.appendChild(art_img);
                    //description
                    var art_dec = document.createElement("article");     
                    art_dec.setAttribute("class", "col-sm-8 col-xs-8");
                    //idproduct
                    var _id_product = itemts[index].idproduct; 
                    var _e_id_product = document.createElement("input");
                    _e_id_product.setAttribute("type", "hidden");
                    _e_id_product.setAttribute("class", "idproduct");
                    _e_id_product.setAttribute("value", _id_product);
                    art_dec.appendChild(_e_id_product);
                    //item-name
                    var titles = itemts[index].titles; 
                    var spandec1 = document.createElement("span");
                    spandec1.setAttribute("class", "item-name");
                    spandec1.innerHTML=titles;
                    art_dec.appendChild(spandec1);
                    //item-price
                    var price_str = itemts[index].price_str;
                    price_str = parseFloat(price_str).toFixed(3);
                    //console.log("price_str="+price_str);
                    var item_price = document.createElement("span");
                    item_price.setAttribute("class", "item-price");
                    
                    //price
                     var span_price = document.createElement("span");
                    span_price.setAttribute("class", "_price");
                    span_price.innerHTML=price_str;
                    item_price.appendChild(span_price);
                    
                    //unit
                    var span_unit = document.createElement("span");
                    span_unit.setAttribute("class", "unit");
                    span_unit.innerHTML="đ";
                    item_price.appendChild(span_unit);
                    //append price and unit
                    art_dec.appendChild(item_price);
                    //item-quantity
                    var item_quantity = document.createElement("span");
                    item_quantity.setAttribute("class", "item-quantity");
                    //label
                    var lbsl = document.createElement("span");
                    lbsl.innerHTML="Số lượng: ";
                    //append price and unit
                    item_quantity.appendChild(lbsl);
                    //button btn-minus
                    var button_quality = document.createElement("button");
                   
                    button_quality.setAttribute("onClick", 'minus(this)');                 
                    button_quality.setAttribute("class", "btn-minus");
                    //glyphicon-menu-left
                    var btn_left = document.createElement("span");
                    btn_left.setAttribute("class", "glyphicon glyphicon-minus");
                    button_quality.appendChild(btn_left);
                    //button to 
                    item_quantity.appendChild(button_quality);
                    //rate price
                    var rate_price = document.createElement("input");
                    rate_price.setAttribute("type", "hidden");
                    rate_price.setAttribute("class", "rate_price");
                    rate_price.setAttribute("value", price_str);
                    item_quantity.appendChild(rate_price);
                    //input
                    var input_qua = document.createElement("input"); 
                     // input_qua.addEventListener('change', function(){
                     //     change(this);
                     // });
                    var _quality = itemts[index].quality;
                    if(!Valid_number(_quality)){
                      _quality = 1;
                    }
                    input_qua.setAttribute("class", "qua"); 
                    input_qua.setAttribute("value", _quality);
                    input_qua.setAttribute("onchange", 'change(this)');               
                    input_qua.setAttribute("class", "qua");                   
                    
                    item_quantity.appendChild(input_qua);
                    //onkey up
                    input_qua.setAttribute("onkeyup", 'keyup(this)');                                 
                    item_quantity.appendChild(input_qua);
                    //button right
                    var button_right = document.createElement("button");
                    //button_right.setAttribute("onClick", 'plus(\'' + this + '\')');
                    button_right.setAttribute("onClick", 'plus(this)');
                    button_right.setAttribute("class", "btn-plus");
                    //glyphicon-menu-left
                    var span_right = document.createElement("span");
                    span_right.setAttribute("class", "glyphicon glyphicon-plus");
                    button_right.appendChild(span_right);
                    //append button item quality
                    item_quantity.appendChild(button_right);
                    //button trash
                    //<span onclick="this.parentElement.style.display = 'none';" class="closebtn">&times;</span>
                    var button_trash = document.createElement("button");
                    //button_trash.setAttribute("onClick", 'trash(\'' + index + '\')');
                    button_trash.setAttribute("onClick", 'trash(this,\'' + index + '\')');
                    button_trash.setAttribute("class", "btn-trash");
                    //glyphicon-menu-trash
                    var span_trash = document.createElement("span");
                    span_trash.setAttribute("class", "glyphicon glyphicon-trash");
                    button_trash.appendChild(span_trash);
                    //append button item quality
                    item_quantity.appendChild(button_trash);
                    //all append item-quality
                     art_dec.appendChild(item_quantity);
                    //apend all
                    section.appendChild(art_dec);
                  //end creat element
                    document.getElementsByClassName("shopping-cart-items")[0].appendChild(section);
              }    
}
function Valid_number(mobile) {
        var pattern = /^[0-9]*$/gm;
        if (pattern.test(mobile)) {
            return true;
        }       
        return false;
    }
function change_elemnet(element){
  var item = element.parentElement;
  var _e_rate = item.getElementsByClassName('rate_price')[0];
  var rate = _e_rate.value;
  var rate = rate.replace(".", "");
  var _rate = parseInt(rate);
  var _e_quality = item.getElementsByClassName('qua')[0];
  var str_quality = _e_quality.value;
  //alert(str_quality);
  if(!Valid_number(str_quality)){
    _e_quality.value = 1;
    //alert("no number");
    return false;
  }
  var _quality = parseInt(str_quality);
  if(_quality < 1){
    _e_quality.value = 1;
    return false;
  }else{
    _e_quality.value = _quality;
    //total
    var total = _quality*_rate;
    var parent_price = item.parentElement;
    var _price = parent_price.getElementsByClassName('item-price')[0];
    _price.getElementsByClassName('_price')[0].innerHTML=total;
    total_items();
  }  
}
//key up
function keyup(element){
  change_elemnet(element);
}
function change(element){
  change_elemnet(element);
}
function plus(element){
  var item = element.parentElement;
  var _e_rate = item.getElementsByClassName('rate_price')[0];
  var rate = _e_rate.value;
  //var rate = rate.replace(".", "");
  var _rate = parseFloat(rate);
  
  var _e_quality = item.getElementsByClassName('qua')[0];
  var _quality = parseInt(_e_quality.value);
 
  _quality = _quality +1;
  _e_quality.value = _quality;
//total
  var total = _quality*_rate;
  total = parseFloat(total).toFixed(3);
  //console.log("_rate="+_rate+",*_quality"+_quality+",total="+total);
  var parent_price = item.parentElement;
  var _price = parent_price.getElementsByClassName('item-price')[0];
  _price.getElementsByClassName('_price')[0].innerHTML=total;
  total_items();
  total_order();
}
function minus(element){
  var item = element.parentElement;
  var _e_rate = item.getElementsByClassName('rate_price')[0];
  var rate = _e_rate.value;
  //var rate = rate.replace(".", "");
  var _rate = parseFloat(rate);
  var _e_quality = item.getElementsByClassName('qua')[0];
  var _quality = parseFloat(_e_quality.value);
  if(_quality > 1) {
    _quality = _quality - 1;
   _e_quality.value = _quality;
    //total
    var total = _quality*_rate;
    total = parseFloat(total).toFixed(3);
    var parent_price = item.parentElement;
    var _price = parent_price.getElementsByClassName('item-price')[0];
    _price.getElementsByClassName('_price')[0].innerHTML=total;
  }
  total_items();
}
function trash(element,index){
    var item = element.parentNode.parentNode.parentNode;
    item.parentNode.removeChild(item);
    var _index = parseInt(index);
    var re_items = localStorage.getItem('l_items');
    var itemts = JSON.parse(re_items);
    itemts[_index] = null;
    var carts = [];
    var i = 0;
    for ( var index=0; index<itemts.length; index++ ) {
          //begin create element                 
          if(isRealValue(itemts[index])){
             carts[i] = itemts[index];
             i++;
          }
         
      }
    localStorage.setItem('l_items', JSON.stringify(carts));
    total_items();
}
//total items
setTimeout(function(){ total_items(); }, 3000);
//var order = [];
function total_items(){
  total = 0;
  var _e_items = document.getElementsByClassName("shopping-cart-items")[0];
  var _section = _e_items.getElementsByClassName("col-sm-12");
  //init item
  var item = {};
  var newcarts = []; 
  for (var i = 0; i< _section.length; i++){
     var img = _section[i].childNodes[0].childNodes[0].src;
     var desc = _section[i].childNodes[1];
     var _idproduct = _section[i].childNodes[1].childNodes[0].value;
     //console.log(_idproduct);
     var _name = desc.getElementsByClassName("item-name")[0].innerHTML;
     var _price = desc.getElementsByClassName("item-price")[0].getElementsByClassName("_price")[0].innerHTML;
     var _quality = desc.getElementsByClassName("item-quantity")[0].getElementsByClassName("qua")[0].value;
     //_price = _price.replace(".", "");
     //_price = parseInt(_price);
     //console.log(_price);
     _price = parseFloat(_price);
     total = total + _price;
     //insert item to list object
     item = {titles:_name,idproduct:_idproduct, price_str:_price, src_img:img, quality:_quality};
     newcarts[i] = item; 
  }
  total = parseFloat(total).toFixed(3);
  var _e_total_cart = document.getElementsByClassName("shopping-cart-header")[0];
  _e_total_cart.getElementsByClassName("badge")[0].innerHTML=_section.length;
  var _cart_total = _e_total_cart.getElementsByClassName("shopping-cart-total")[0];
  var _e_total = _cart_total.getElementsByClassName("main-color-text")[0];
  var _total = _e_total.getElementsByClassName("total")[0].innerHTML=total;
   //console.log(carts);
  //set cookie    
   deleteCookie('item-cart');
   setCookieObject('item-cart',newcarts,1); 
   total_order();
}

function getCookieObject(_name_cookie) {
    var result = document.cookie.match(new RegExp(_name_cookie + '=([^;]+)'));
    result && (result = JSON.parse(result[1]));
    return result;
}
function bake_cookie(name, value) {
  var cookie = [name, '=', JSON.stringify(value), '; domain=.', window.location.host.toString(), '; path=/;'].join('');
  document.cookie = cookie;
}
function read_cookie(name) {
 var result = document.cookie.match(new RegExp(name + '=([^;]+)'));
 result && (result = JSON.parse(result[1]));
 return result;
}
function delete_cookie(name) {
  document.cookie = [name, '=; expires=Thu, 01-Jan-1970 00:00:01 GMT; path=/; domain=.', window.location.host.toString()].join('');
}

//set cookie object
function setCookieObject(cname,cvalue,exdays) {
    var d = new Date();
    var cvalues = JSON.stringify(cvalue);
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalues + ";" + expires + ";path=/";
    //var cookie = [name, '=', JSON.stringify(value), '; domain=.', window.location.host.toString(), '; path=/;'].join('');
    //document.cookie = cookie;
}

/*function setCookieObject(cname,cvalue,exdays) {
    var d = new Date();
    var cvalues = JSON.stringify(cvalue);
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalues + ";" + expires + ";path=/";
}*/

 function deleteCookie(cookiename){
      var d = new Date();
      d.setDate(d.getDate() - 1);
      var expires = ";expires="+d;
      var name=cookiename;
      //alert(name);
      var value="";
      document.cookie = name + "=" + value + expires + "; path=/";                    
  }
function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function setCookieHours(cname,cvalue,hours) {
    var d = new Date();
    d.setTime(d.getTime() + (hours*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
(function( $ ) {
    "use strict";
})(jQuery);
var _name_provine='';
var _name_dictrict='';
var _cost_ship = '';
jQuery(document).ready(function($) {
  //load all provine
  var _e_form_order = $("#add-cart").find(".shopping-cart").find(".checkout").find(".form_order");
  var sel_provine = _e_form_order.find(".sel-option").find("select#provine");
  var sel_district = _e_form_order.find(".sel-option").find("select#district");
  //console.log(sel_provine);
  //var _e_order_cart = document.getElementById("add-cart").getElementsByClassName("shopping-cart")[0].getElementsByClassName("checkout")[0];
  //var element = _e_order_cart.getElementsByClassName("provine")[0];
    //select provine
    sel_provine.on('change', function() {
      var _idprovine = this.value;
      _name_provine =  $(this).find(':selected').text();    
      list_all_district(_idprovine);  
    })
    //select district
    sel_district.on('change', function() {
      _cost_ship = $(this).val();
      _name_dictrict =  $(this).find(':selected').text();
      var _e_order_header = document.getElementById("add-cart").getElementsByClassName("shopping-cart")[0].getElementsByClassName("shopping-cart-header")[0];
      var _e_t_ship = _e_order_header.getElementsByClassName("cost-ship")[0].getElementsByClassName("t-ship")[0];  
      //district_selected = element.options[element.selectedIndex].text;
     _cost_ship = parseFloat(_cost_ship).toFixed(3);
       _e_t_ship.innerHTML = _cost_ship;
      total_order();
    })
    //list provine
    function list_all_district(_idprovine){
      if(!isRealValue(_idprovine)){
        return false;
      }
      var _data = {
          action:'all_district',
          idprovine : _idprovine
        };
        $.ajax({ 
               type: "POST", 
               url: MyAjax.ajaxurl, 
               data: _data, 
               success: function(response) { 
                 var parsed_json = jQuery.parseJSON(response);
                 //console.log(parsed_json);
                 var _e_order_cart = document.getElementById("add-cart").getElementsByClassName("shopping-cart")[0].getElementsByClassName("checkout")[0];
                 var _e_district = _e_order_cart.getElementsByClassName("sel-option")[0].getElementsByClassName("district")[0];
                //console.log(_e_list);
                while (_e_district.hasChildNodes()) {   
                     _e_district.removeChild(_e_district.firstChild);
                }
                 var option = document.createElement("option");
                  option.setAttribute("value", "0");
                  option.innerHTML = "Quận/Huyện";
                  _e_district.appendChild(option);
                 var result = parsed_json['data'];
                  for (var i =0 ; i < result.length;i++) {
                    var iddistrict = result[i].iddistrict;
                    var name = result[i]._name;
                    var price =  result[i].price;
                    var option = document.createElement("option");
                    option.setAttribute("value", price);
                    option.innerHTML = name;               
                    _e_district.appendChild(option);
                  };
                  
                } 
        }); 
    }
    
});

//var btn_order = _e_shopping_cart.getElementsByClassName("order")[0];
// //console.log(btn_order);
//  btn_order.addEventListener('click', function(){
//            order_items(this,1);
//   });
function all_provine() {
    var _e_order_cart = document.getElementById("add-cart").getElementsByClassName("shopping-cart")[0].getElementsByClassName("checkout")[0];
    var _e_provine = _e_order_cart.getElementsByClassName("provine")[0];
    //console.log(_e_provine);
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
          var parsed_json = JSON.parse(this.responseText);
          for (var i =0 ; i < parsed_json.length;i++) {
            var idprovine = parsed_json[i].idprovine;
            var namepro =  parsed_json[i].namepro;
            var option = document.createElement("option");
            option.setAttribute("value", idprovine);
            option.innerHTML = namepro;               
            _e_provine.appendChild(option);
          }; 
      }
    };
    //var data={kvcArray : jsonString };
    //{data:"+JSON.stringify(items_cookie_new)+"}"
    xhttp.open("POST",MyAjax.ajaxurl+"?action=all_provine",true);
    xhttp.send();  
}
setTimeout(function(){ all_provine(); }, 1000);

var _total_items = 0;
var _total_ship = 0;
var _total_order = 0;
function total_order(){
    var _e_order_header = document.getElementById("add-cart").getElementsByClassName("shopping-cart")[0].getElementsByClassName("shopping-cart-header")[0];
    var _e_total = _e_order_header.getElementsByClassName("shopping-cart-total")[0].getElementsByClassName("total")[0];
    var _e_t_ship = _e_order_header.getElementsByClassName("cost-ship")[0].getElementsByClassName("t-ship")[0];
    //console.log(_e_total);
    //console.log(_e_t_ship);
    _total_items = parseFloat(_e_total.innerHTML);
    _total_ship = parseFloat(_e_t_ship.innerHTML);
    _total_order = parseFloat(_total_items + _total_ship).toFixed(3);
    //console.log("_total_order="+_total_order);
    var _e_t_order = _e_order_header.getElementsByClassName("order-total")[0].getElementsByClassName("t-order")[0];
     _e_t_order.innerHTML = _total_order; 
}

// $.ajax({ 
    //          type: "POST", 
    //          url: MyAjax.ajaxurl, 
    //          //data: { kvcArray : myJSONText },
    //          data: { action:'purchase',kvcArray : jsonString }, 
    //          success: function(response) { 
    //            var parsed_json = jQuery.parseJSON(response);
    //             console.log(parsed_json); 
    //           } 
    //   }); 
jQuery(document).ready(function($) {
  $(".footer").find("p.copyright").click(function(){
      var width_viewport = $( window ).width();
      var width_html_doc = $( document ).width();
      alert("width_viewport="+width_viewport+",  width_html_doc="+width_html_doc);
    });
});