function getSelectedText(elementId) {
    var elt = document.getElementById(elementId);
    if (elt.selectedIndex == -1) return null;
    return elt.options[elt.selectedIndex].text;
}
var _e_type_category = document.getElementsByClassName("type-category")[0];
_e_type_category.addEventListener("change", function(){
    var select_idcat = this.options[this.selectedIndex].value;
    if(select_idcat > -1){
      select_category_by_idcatetype(select_idcat);
    }
});

function select_category_by_idcatetype(select_idcattype){
  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
  var http = new XMLHttpRequest();
  var host = window.location.hostname;
  var url = url_home+"/admin/menuhascate/bytype/"+select_idcattype;
  //console.log(url);
  //var params = JSON.stringify({"sel_idcategory":select_idcat});
  http.open("POST", url, true);

  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);

  http.setRequestHeader("Accept", "application/json");

  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  //var load = _e_frm_reg.getElementsByClassName("loading")[0];
  //load.style.display = "block";
  var _e_catebyidcatetype = document.getElementsByClassName("catebyidcatetype")[0];
  http.onreadystatechange = function() {
      if(http.readyState == 4 && http.status == 200) {
           var myArr = JSON.parse(this.responseText);
           _e_catebyidcatetype.innerHTML =  myArr['result'];      
			     }    
  }
  http.send();
  //http.send(params);
}
function isRealValue(obj){
  return obj && obj !== 'null' && obj !== 'undefined';
}
var mn_items = [];
var mnitem = {}; var l_mnitems;
var _mnindex_int = 0;
var _mnparent_id = 0;
var _store_items;
var _e_table_menu = document.getElementsByClassName("table-menu")[0];
var _e_menu = _e_table_menu.getElementsByClassName("menu")[0];
var main_menu = "";
function AddCateToMenu(){
  var _e_array_parent = document.getElementsByClassName("array-parent");
  var _e_array_check = document.getElementsByClassName("array-check");
  var _parent = 0; var _idcategory = 0; var _namemenu = "";
  for (var i = 0;i <= _e_array_check.length - 1; i++) {
    if(_e_array_check[i].checked){
        _idcategory = _e_array_check[i].value;
        _parent = _e_array_parent[i].value;
        _namemenu = _e_array_check[i].parentElement.getElementsByTagName("label")[0].innerHTML;
        mnitem = { idcategory:_idcategory, namemenu:_namemenu ,parent_idhascate:_parent, trash:0 };
        _store_items = localStorage.getItem('lmn_items');
        if(!isRealValue(_store_items)){
          mn_items[0] = mnitem;       
          localStorage.setItem('lmn_items', JSON.stringify(mn_items));
        }else{  
          l_mnitems = JSON.parse(_store_items);
          _mnindex_int = l_mnitems.length;
          l_mnitems[_mnindex_int] = mnitem;
          localStorage.setItem('lmn_items', JSON.stringify(l_mnitems));
        }      
    }
  }

  var _store_items = localStorage.getItem('lmn_items');
  var categories = JSON.parse(_store_items);
   main_menu = "";
   create_menu(categories,0);
}

function create_menu(categories, idparent){
  //var _store_items = localStorage.getItem('lmn_items');
  //var _lstitemstore = JSON.parse(_store_items);
  var array_child = [];
  var item = {};
  for(var i = 0;i <= categories.length - 1; i++) {
      if(categories[i].parent_idhascate == idparent){
          array_child.push(categories[i]);    
          categories.splice(i, 1);
      }    
  }
  if(isRealValue(array_child)){
       main_menu = main_menu + "<ul>";
       var e_li = document.createElement("li");
       for(var j = 0;j <= array_child.length - 1; j++) {
            main_menu = main_menu + "<li>";
            main_menu = main_menu + array_child[j].namemenu;
            create_menu(categories, array_child[j].idcategory);
            main_menu = main_menu + "</li>";
       }
       main_menu = main_menu + "</ul>";
  }
  _e_menu.innerHTML = main_menu;
}
