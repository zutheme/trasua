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
   create_menu(categories);
   for (var i = 0;i <= _e_array_check.length - 1; i++) {
    if(_e_array_check[i].checked){
        _e_array_check[i].checked = false;
    }
  }

}

function create_menu(categories){
    var first = _e_menu.firstElementChild;
    var e_li;var _e_input;var _e_label;var _mydiv;
    while (first) { 
        first.remove(); 
        first = _e_menu.firstElementChild; 
    } 
  var e_ul = document.createElement("ul"); 
  for(var i = 0;i <= categories.length - 1; i++) {
     e_li = document.createElement("li");
     e_li.setAttribute("class","item");
     //e_li.setAttribute("ondrop","drop(event)");
     e_li.setAttribute("ondragover","allowDrop(event)");
     e_li.id = 'item-'+i; 
     //create div container
     _e_mydiv = document.createElement("div");
     _e_mydiv.setAttribute("class","mydiv");
     _e_mydiv.id = 'mydiv-'+i;
     //_e_mydiv.setAttribute("ondragstart","drag(event)");
     //_e_mydiv.setAttribute("draggable","true");
     _e_mydivheader = document.createElement("div");
     _e_mydivheader.setAttribute("class","mydivheader");
     _e_mydivheader.id = 'mydivheader-'+i;
     //input
     _e_input = document.createElement("input");
     _e_input.setAttribute("type","hidden");
     _e_input.setAttribute("value",categories[i].idcategory);
     _e_mydivheader.appendChild(_e_input);
     //label
     _e_label = document.createElement("label");
     _e_label.innerHTML = categories[i].namemenu;
     _e_mydivheader.appendChild(_e_label);
     _e_mydiv.appendChild(_e_mydivheader);
     e_li.appendChild(_e_mydiv);
     e_ul.appendChild(e_li);
  }
  _e_menu.appendChild(e_ul);
}
document.addEventListener("DOMContentLoaded", function(event) {
     var _store_items = localStorage.getItem('lmn_items');
     var categories = JSON.parse(_store_items);
     create_menu(categories);
});
function allowDrop(ev) {
  ev.preventDefault();
}
function drag(ev) {
  ev.dataTransfer.setData("text", ev.target.id);
}
function drop(ev) {
  ev.preventDefault();
  //var data = ev.dataTransfer.getData("text");
  // var id_element = element.getAttribute("id");
  // var _e_parent = element.parentElement;
  // var e_li = document.createElement("li");
  // e_li.setAttribute("class",id_element);
  // e_li.appendChild(document.getElementById(data));
  // console.log(data);
  // _e_parent.insertBefore(e_li, element);
  //_e_list_li.insertBefore(e_li,_e_list_li[i]);
  //e_li.appendChild(document.getElementById(data));
  //element.insertBefore(document.getElementById(data), element);
  //ev.target.appendChild(document.getElementById(data));
}

//Make the DIV element draggagle:
document.addEventListener("DOMContentLoaded", function(event) {
     var _store_items = localStorage.getItem('lmn_items');
    var _categories = JSON.parse(_store_items);
    var _element;
    // for(var i = 0;i <= _categories.length - 1; i++) {
    //       _element = document.getElementById("mydiv-"+i);
    //       dragElement(_element);
    //    }
    var e_li = _e_menu.getElementsByClassName("item");
    for (var i = e_li.length - 1; i >= 0; i--) {
          e_li[i].addEventListener("drop",function(ev){
          ev.preventDefault();
          var data = ev.dataTransfer.getData("text");
          var e_temp_child = document.getElementById(data);

          var e_tem_parent_child = e_temp_child.parentElement;
          console.log(e_temp_child);
          console.log(e_tem_parent_child);
          var id_element = this.getAttribute("id");
          var _e_parent = this.parentElement;
          
          var e_li = document.createElement("li");
          e_li.setAttribute("class","item");
          e_li.setAttribute("ondragover","allowDrop(event)");
          e_li.appendChild(document.getElementById(data));
          //_e_parent.insertBefore(e_li,this);
          //_e_parent.removeChild(e_parent_child);
          ev.target.appendChild(document.getElementById(data));
        });
        
      }

    var e_mydiv = _e_menu.getElementsByClassName("mydiv");
    for (var j = e_mydiv.length - 1; j >= 0; j--) {
      e_mydiv[j].addEventListener("dragstart",function(ev) {
        ev.dataTransfer.setData("text", ev.target.id);
        //console.log("start"+ev.target.id);
      });
      e_mydiv[j].setAttribute("draggable",true);
    }
});

function dragElement(elmnt) {
  var rect_top = _e_table_menu.offsetTop;
    var rect_left = _e_table_menu.offsetLeft;
    var rect = _e_table_menu.getBoundingClientRect();
    //console.log(rect.top, rect.right, rect.bottom, rect.left);
    //console.log(rect_top+","+rect_left);
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "-header")) {
    /* if present, the header is where you move the DIV from:*/
    document.getElementById(elmnt.id + "-header").onmousedown = dragMouseDown;
  } else {
    /* otherwise, move the DIV from anywhere inside the DIV:*/
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    var p2 = (elmnt.offsetTop - pos2);
    var p1 = (elmnt.offsetLeft - pos1);
    //console.log(p2,p1);
    //console.log(rect.top, rect.right, rect.bottom, rect.left);
    if(p2 > 0 && p1 > 0) {
      if(p2 < rect.bottom && p1 < rect.left){
        //console.log(p2,p1);
        elmnt.style.top = p2 + "px";
        elmnt.style.left = p1 + "px";
        elmnt.style.position = "absolute";
      }
    }
  }

  function closeDragElement() {
    /* stop moving when mouse button is released:*/
    document.onmouseup = null;
    document.onmousemove = null;
  }
}