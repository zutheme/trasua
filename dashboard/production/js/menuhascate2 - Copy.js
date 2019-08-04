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
//add category to menu
//make call ajax
function makeAjaxCall(idmenu, obj, callback){
   var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
   var xhr = new XMLHttpRequest();
   var url = url_home + "/admin/menu/additem/"+idmenu;
   xhr.open("POST", url, true);
   xhr.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
   xhr.setRequestHeader("Accept", "application/json");
   xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   var params = JSON.stringify(obj);
   xhr.send(params);
   xhr.onreadystatechange = function(){
     if (xhr.readyState === 4){
        if (xhr.status === 200){
           console.log("xhr done successfully");
           var resp = xhr.responseText;
           var respJson = JSON.parse(resp);
           callback(respJson);
        } else {
           console.log("xhr failed");
        }
     } else {
        console.log("xhr processing going on");
     }
   }
   console.log("request sent succesfully");
}

function processUserDetailsResponse(userData){
  _data = userData.idmenuhascate;
  console.log(_data);
  return _data;
} 
//end make call
function errorHandler(statusCode){
 console.log("failed with status", status);
}
//end promise
function AddMenuItem(idmenu,obj){
    var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
    var http = new XMLHttpRequest();
    var url = url_home + "/admin/menu/additem/"+idmenu;
    var params = JSON.stringify(obj);
    var _idmenuhascate = 0;
    http.open("POST", url, true);
    http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
    http.setRequestHeader("Accept", "application/json");
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //var load = e_element.getElementsByClassName("loading-trash")[0];
    //load.style.display = "block";
    http.onreadystatechange = function() {
        if(http.readyState == 4 && http.status == 200) {
            var myArr = JSON.parse(this.responseText);
            //console.log(myArr);
            if(myArr.success){
              //load.style.display = "none";        
              _idmenuhascate = myArr.idmenuhascate;
            }
        }
    }
    http.send(params);
}
//end add category

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
  var _idparent = 0; var _idcategory = 0; var _namemenu = "";var _idmenuhascate = 0; var _reorder = 0;
  for (var i = 0;i <= _e_array_check.length - 1; i++) {
    if(_e_array_check[i].checked){
        _idcategory = _e_array_check[i].value;
        _idparent = _e_array_parent[i].value;
        _namemenu = _e_array_check[i].parentElement.getElementsByTagName("label")[0].innerHTML;
        var _e_menu = document.getElementsByName("sel_idmenu")[0];
        var _idmenu = _e_menu.options[_e_menu.selectedIndex].value;
        if(!_idmenu){
          alert("Bạn chưa chọn menu");
          return false;
        }
        var obj = { idcategory:_idcategory, namemenu:_namemenu ,idparent:_idparent, depth:0, trash:0 };
        //makeAjaxCall(_idmenu, obj, processUserDetailsResponse);
        //console.log("ajax call");
        mnitem = { idmenuhascate: _idmenuhascate, idmenu:_idmenu, idcategory:_idcategory, namemenu:_namemenu ,idparent:_idparent, reorder:0, depth:0, trash:0 }; 
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
     if(categories){
        create_menu(categories);
     }
   for (var i = 0;i <= _e_array_check.length - 1; i++) {
    if(_e_array_check[i].checked){
        _e_array_check[i].checked = false;
    }
  }
  var _store_items = localStorage.getItem('lmn_items');
  var categories = JSON.parse(_store_items);
  var _e_frm_menuhascate = document.getElementsByClassName("frm-create-category")[0]; 
  _e_frm_menuhascate.getElementsByClassName("idmenu")[0].value = _idmenu;
  var obvalue = _e_frm_menuhascate.getElementsByClassName("obj-add-cate")[0];
  obvalue.value = _store_items;
  localStorage.removeItem("lmn_items");
  //return true;
  //document.getElementsByClassName("frm-create-category")[0].submit();
  //location.reload();
}

function create_menu(categories){
  //console.log(categories);
    var first = _e_menu.firstElementChild;
    var e_li;var _e_input;var _e_label;var _mydiv;
    while (first) { 
        first.remove(); 
        first = _e_menu.firstElementChild; 
    } 
  var e_ul = document.createElement("ul");
  e_ul.setAttribute("class","menu-item root");
  
  for(var i = 0;i <= categories.length - 1; i++) {
     e_li = document.createElement("li");
     e_li.setAttribute("class","item menu-"+categories[i].idcategory+" depth-"+categories[i].depth);
     //e_li.setAttribute("ondrop","drop(event)");
     e_li.setAttribute("ondragover","allowDrop(event)");
     e_li.id = 'item-'+i; 
     //create div container
     _e_mydiv = document.createElement("div");
     _e_mydiv.setAttribute("class","mydiv");
     _e_mydiv.id = 'mydiv-'+i;
     
     //input
     _e_input = document.createElement("input");
     _e_input.setAttribute("class","idmenuhascate");
     _e_input.setAttribute("name","idmenuhascate");
     _e_input.setAttribute("type","hidden");
     _e_input.setAttribute("value",categories[i].idmenuhascate);
     _e_mydiv.appendChild(_e_input);
     //input
     _e_input = document.createElement("input");
     _e_input.setAttribute("class","idcategory");
     _e_input.setAttribute("name","idcategory");
     _e_input.setAttribute("type","hidden");
     _e_input.setAttribute("value",categories[i].idcategory);
     _e_mydiv.appendChild(_e_input);
     //idparent
     _e_input_parent = document.createElement("input");
     _e_input_parent.setAttribute("class","idparent");
     _e_input_parent.setAttribute("name","idparent");
     _e_input_parent.setAttribute("type","hidden");
     _e_input_parent.setAttribute("value",categories[i].idparent);
     _e_mydiv.appendChild(_e_input_parent);
     //depth
     _e_input_depth = document.createElement("input");
     _e_input_depth.setAttribute("class","depth");
     _e_input_depth.setAttribute("name","depth");
     _e_input_depth.setAttribute("type","hidden");
     _e_input_depth.setAttribute("value",categories[i].depth);
     _e_mydiv.appendChild(_e_input_depth);
     //trash
     _e_input_depth = document.createElement("input");
     _e_input_depth.setAttribute("class","trash");
     _e_input_depth.setAttribute("name","trash");
     _e_input_depth.setAttribute("type","hidden");
     _e_input_depth.setAttribute("value",categories[i].trash);
     _e_mydiv.appendChild(_e_input_depth);
     //label
     _e_label = document.createElement("label");
     _e_label.innerHTML = categories[i].namemenu;
     _e_mydiv.appendChild(_e_label);
     //_e_mydiv.appendChild(_e_mydivheader);
     e_li.appendChild(_e_mydiv);
     e_ul.appendChild(e_li);
  }
  _e_menu.appendChild(e_ul);
}
document.addEventListener("DOMContentLoaded", function(event) {
     var _store_items = localStorage.getItem('lmn_items');
     var categories = JSON.parse(_store_items);
     if(categories){
        create_menu(categories);
     }
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
              var e_from_data = document.getElementById(data);
              var e_from_parent_data = e_from_data.parentElement;
              var id_from_data = e_from_parent_data.getAttribute("id");
              var class_from_data = e_from_parent_data.getAttribute("class");
              var e_li = document.createElement("li");
              e_li.setAttribute("class",class_from_data);
              e_li.setAttribute("ondragover","allowDrop(event)");
              var _e_parent = this.parentElement;
              var _e_prev = this.previousSibling;
              //var _e_next = this.nextSibling;
                if(_e_prev){
                    if(_e_prev.innerHTML==e_from_parent_data.innerHTML){
                    _e_parent.insertBefore(this, _e_prev);
                  }else{
                    _e_parent.insertBefore(e_from_parent_data, this);
                  }
                }else {
                   _e_parent.insertBefore(e_from_parent_data, this);
                }        
              //e_from_data.style.opacity = "1.0";
              //setTimeout(function(){ _e_parent.marginBottom = "0px"; _e_next.marginBottom = "0px";}, 500);
              document.getElementById("dragend").innerHTML = "drop="+data; 
            });
            e_li[i].addEventListener("dragleave", function(e) {       
                 if ( e.target.className == "item" ) {
                    e.target.style.border = "";
                    var id_target = e.target.id;
                    document.getElementById("dragleave").innerHTML = "dragleave="+id_target; 
                    e.target.style.backgroundColor = "white";
                    var ex = document.getElementById(id_target);
                    //setInterval(function(){ ex.style.marginTop = "0px"; }, 2000);
                    //setTimeout(function(){ ex.style.marginBottom = "0px"; }, 500);
                  }
            });
            //for (var k = e_li.length - 1; k >= 0; k--) {
            e_li[i].addEventListener("dragenter", function(e) {
              var id_target = e.target.id;
              var this_id = this.getAttribute("id");
              //e.target.className
              if ( id_target == this_id ) {
                  document.getElementById("enter").innerHTML = "enter="+id_target; 
                  //e.target.style.backgroundColor = "lightblue";        
                  //e_li.appendChild(e_from_data);
                  //this.style.marginBottom = "0px";
                }        
            });      
      }
      
    //var e_li = _e_menu.getElementsByClassName("item");
    var e_mydiv = _e_menu.getElementsByClassName("mydiv");
    for (var j = e_mydiv.length - 1; j >= 0; j--) {
      e_mydiv[j].addEventListener("dragstart",function(e) {
        var id_target = e.target.id;
        var this_id = this.getAttribute("id");
        //if ( id_target == this_id ) {
           document.getElementById("dragstart").innerHTML = "dragstart="+id_target;
            e.dataTransfer.setData("text", id_target);
            //e.target.style.opacity = "0.4";
            //this.parentElement.style.display="none";
          //}    
      });
      e_mydiv[j].addEventListener("drag", function(e) {
            var id_target = e.target.id; 
      });
       e_mydiv[j].addEventListener("dragend", function(e) {
                var id_target = e.target.id;
                var _e_target = document.getElementById(id_target);
                var _e_parent = this.parentElement;
                var _e_next = _e_parent.nextSibling;
                var _e_prev = _e_parent.previousSibling;
               //_e_next.style.marginBottom = "0px";
               //_e_parent.style.marginBottom = "0px";
                var _store_items = localStorage.getItem('lmn_items');
                var categories = JSON.parse(_store_items);
                e = e || window.event;
                e.preventDefault();
                var rect = this.getBoundingClientRect();
                pos_x = e.clientX;
                pos_y = e.clientY;
                var _left = rect.left + (this.clientWidth/4);
                var _class_prev;
                var _depth = 0; var pos = 0;var list_class;var last_class;var list_class;       
                if(pos_x > _left){
                    if(_e_prev){
                        //console.log("move right");
                        var _idmenuhascate_curent = parseInt(_e_parent.getElementsByClassName("idmenuhascate")[0].value);
                        var _idcate_curent = parseInt(_e_parent.getElementsByClassName("idcategory")[0].value);
                        var _prev_idparent = parseInt(_e_prev.getElementsByClassName("idparent")[0].value);
                        var _prev_idcategory = parseInt(_e_prev.getElementsByClassName("idcategory")[0].value);
                        var _prev_depth = parseInt(_e_prev.getElementsByClassName("depth")[0].value);
                        if(_prev_idparent == 0){
                            _prev_idparent = _prev_idcategory;
                        }
                        for (var k = categories.length - 1; k >= 0; k--) {
                            var _id_menuhascate = categories[k].idmenuhascate;
                            if(_id_menuhascate ==_idmenuhascate_curent){  
                                categories[k].depth = parseInt(categories[k].depth) + 1;
                                var cmp = parseInt(categories[k].depth) - _prev_depth;
                                //console.log(categories[k].depth,_prev_depth);
                                if(cmp == 0){
                                    this.getElementsByClassName("idparent")[0].value = _prev_idparent;
                                    this.getElementsByClassName("depth")[0].value = _prev_depth;
                                    categories[k].depth = _prev_depth;
                                    categories[k].idparent = _prev_idparent;
                                    _e_parent.classList.add("depth-"+_prev_depth);
                                }else if(cmp == 1){
                                    this.getElementsByClassName("idparent")[0].value = _prev_idcategory;
                                    this.getElementsByClassName("depth")[0].value = _prev_depth+1;
                                    categories[k].idparent = _prev_idcategory;
                                    categories[k].depth = _prev_depth + 1;
                                    _e_parent.classList.add("depth-"+(_prev_depth + 1));
                                }else if(cmp > 1){
                                    categories[k].depth = _prev_depth + 1;
                                }else if(cmp < 0){
                                    var abs_cmp = Math.abs(cmp);
                                    for (var t = k - 1; t >= 0; t--) {
                                        if(categories[t].depth==abs_cmp){
                                          var _idparent = parseInt(categories[t].idparent);
                                          var _depth = parseInt(categories[t].depth);
                                          this.getElementsByClassName("idparent")[0].value = _idparent;
                                          this.getElementsByClassName("depth")[0].value = _depth;
                                          categories[k].depth = _depth;
                                          categories[k].idparent = _idparent;
                                           _e_parent.classList.add("depth-"+ _depth);
                                          break;
                                        }
                                    }
                                }
                                var _listclass = _e_parent.getAttribute("class");
                                var _arr_lclass = _listclass.split(" ");
                                var l = _arr_lclass.length;
                                if(l > 3){
                                  var _rm = _arr_lclass[l-2];
                                  _e_parent.classList.remove(_rm);
                                } 
                          }
                        }
                        localStorage.removeItem("lmn_items");
                        localStorage.setItem('lmn_items', JSON.stringify(categories));
                    }                 
                }else{              
                    if(_e_prev){
                        //console.log("move left");
                        var _e_parent_this = this.parentElement;
                        var _class_curent = _e_parent_this.getAttribute("class");
                        var list_class = _class_curent.split(" ");
                        var n = list_class.length;
                        var _prev_this_depth = 0;
                        var _sub_depth = 0;
                        var _idmenuhascate_curent = parseInt(_e_parent.getElementsByClassName("idmenuhascate")[0].value);    
                        var _this_idcategory = this.getElementsByClassName("idcategory")[0].value;
                        for (var m = categories.length - 1; m >= 0; m--) {
                          var _id_menuhascate = parseInt(categories[m].idmenuhascate);
                          if( _id_menuhascate == _idmenuhascate_curent){
                              _sub_depth = parseInt(categories[m].depth) - 1;
                              //console.log(_sub_depth);
                              if(_sub_depth > -1 ){
                                  for (var x = m - 1; x >= 0; x--) {
                                    var _depth = parseInt(categories[x].depth);
                                    //console.log(_sub_depth,_depth);               
                                      if(_depth ==_sub_depth){
                                        var _idparent = parseInt(categories[x].idparent);
                                        var _depth = parseInt(categories[x].depth);
                                        //console.log(_sub_depth,_idparent,_depth);
                                        this.getElementsByClassName("idparent")[0].value = _idparent;
                                        this.getElementsByClassName("depth")[0].value = _depth;
                                        categories[m].depth = _depth;
                                        categories[m].idparent = _idparent;
                                        if(n > 2){
                                               var last_class = list_class[n-1];
                                              _e_parent_this.classList.remove(last_class);
                                              _e_parent.classList.add("depth-"+ _depth);
                                        }
                                        localStorage.removeItem("lmn_items");
                                        localStorage.setItem('lmn_items', JSON.stringify(categories));
                                        break;
                                      }
                                  }
                              }
                          }
                        }
                     } 
                }
          });
          e_mydiv[j].setAttribute("draggable",true);
    }
});
function re_order_block(){
    var arr_categories = [];
    var _e_list_item = document.getElementsByClassName("frm_menuhascate")[0].getElementsByClassName("item");
    var _e_menu = document.getElementsByName("sel_idmenu")[0];
    var _idmenu = _e_menu.options[_e_menu.selectedIndex].value;

    if(!_idmenu){
      alert("Bạn chưa chọn menu");
      return false;
    }
    for (var i = _e_list_item.length - 1; i >= 0; i--) {
      var _idmenuhascate = _e_list_item[i].getElementsByClassName("idmenuhascate")[0].value;
      var _idcategory = _e_list_item[i].getElementsByClassName("idcategory")[0].value;
      var _namemenu = _e_list_item[i].getElementsByTagName("label")[0].innerHTML;
      var _idparent = _e_list_item[i].getElementsByClassName("idparent")[0].value; 
      var _depth = _e_list_item[i].getElementsByClassName("depth")[0].value;
      var _trash = _e_list_item[i].getElementsByClassName("trash")[0].value;
      arr_categories[i] = { idmenuhascate: _idmenuhascate, idmenu:_idmenu, idcategory:_idcategory, namemenu:_namemenu ,idparent:_idparent, reorder:i, depth:_depth, trash:_trash };
      //categories[i] = { idcategory:_idcategory, namemenu:_namemenu ,idparent:_idparent, depth:_depth, trash:_trash };
    }
    localStorage.removeItem("lmn_items");
    localStorage.setItem('lmn_items', JSON.stringify(arr_categories));
    var _store_items = localStorage.getItem('lmn_items');
    var categories = JSON.parse(_store_items);
    var _e_frm_menuhascate = document.getElementsByClassName("frm_menuhascate")[0]; 
    var obvalue = _e_frm_menuhascate.getElementsByClassName("obj-menu")[0];
    obvalue.value = _store_items;
    document.getElementsByClassName("frm_menuhascate")[0].submit();
}
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
