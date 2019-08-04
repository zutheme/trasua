// var e_ul =  document.getElementsByClassName("list-check")[0];
//      var idcat;
//     while (e_ul.firstChild) {
//         e_ul.removeChild(e_ul.firstChild);
//     }

function performClickthumbnail(classname) {
  var elem = classname.parentElement.getElementsByClassName("file")[0];
   if(elem && document.createEvent) {
      var evt = document.createEvent("MouseEvents");
      evt.initEvent("click", true, false);
      elem.dispatchEvent(evt);
   }
}

function performClickByClass(classname) {
  var elem = classname.parentElement.getElementsByClassName("file_attach")[0];
   if(elem && document.createEvent) {
      var evt = document.createEvent("MouseEvents");
      evt.initEvent("click", true, false);
      elem.dispatchEvent(evt);
   }
}

var e_muti_files =  document.getElementsByClassName("multi-file")[0];
var bntmore = document.getElementsByName("btn-more-file")[0];
var e_btn_trash = document.getElementsByClassName("btn-trash")[0];
function changefile(e,element){
  var file = e.target.files[0];
  if(!jscheckfile(file)){
    return false;
  }
  var element = element.parentElement;
   var e_btn_trash = element.getElementsByClassName("btn-trash")[0];
   var name = file.name;
   if (file) {        
          if (/^image\//i.test(file.type)) {        
            readFile(file,element);
             e_btn_trash.style.display = "block";
          } else {
            alert('Not a valid image!');
          }
        }
   bntmore.style.display = "block";
}
function editfile(e,element,_idproducthasfile){
  var file = e.target.files[0];
  if(!jscheckfile(file)){
    return false;
  }
  var element = element.parentElement;
   var e_btn_trash = element.getElementsByClassName("btn-trash")[0];
   var name = file.name;
   if (file) {        
          if (/^image\//i.test(file.type)) {        
            readFile(file,element);
             e_btn_trash.style.display = "block";
          } else {
            alert('Not a valid image!');
          }
        }
   var _e_edit_gallery = element.getElementsByClassName("producthasfile")[0];
   _e_edit_gallery.value = _idproducthasfile;
   bntmore.style.display = "block";
}
var item = 0;
bntmore.addEventListener("click", function(){
     item = item + 1;
     var class_item = "item"+item;
     var e_li = document.createElement("li");
     e_li.setAttribute("class",class_item);
     var e_ahref = document.createElement("a");
     e_ahref.setAttribute("href", "javascript:void(0);");
     e_ahref.setAttribute("onclick", "performClickByClass(this);");
     e_ahref.innerHTML = 'Đính kèm&nbsp;&nbsp;<i class="fa fa-paperclip" aria-hidden="true"></i>&nbsp;&nbsp;';
     var e_input_file = document.createElement("input");
     e_input_file.type = "file";
     e_input_file.name = "file_attach[]";
     e_input_file.setAttribute("onchange", "changefile(event,this);");
     e_input_file.setAttribute("style", "display: none;");
     e_input_file.setAttribute("class", "file file_attach "+class_item);
     e_input_file.setAttribute("accept", ".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf,.zip,.rar");
     var _e_p1 = document.createElement("p");
     var _e_canvas = document.createElement("canvas");
     _e_canvas.setAttribute("class", "mycanvas");
     _e_canvas.setAttribute("width", "0px");
     _e_canvas.setAttribute("height", "0px");
    var _e_p2 = document.createElement("p");
     var e_span = document.createElement("span");
     e_span.setAttribute("class", "btn bnt-default btn-trash");
     e_span.setAttribute("style", "display: none;");
     e_span.setAttribute("onclick", "trash('"+class_item+"');");
     //e_span.setAttribute("onclick", "trash(this);");
     e_span.innerHTML = '<i class="fa fa-trash" aria-hidden="true"></i>';
     e_li.appendChild(e_ahref);
     e_li.appendChild(e_input_file);
     e_li.appendChild(_e_p1);
     e_li.appendChild(_e_canvas);
     e_li.appendChild(_e_p2);
     e_li.appendChild(e_span);
     e_muti_files.appendChild(e_li);  
});

function trash(element){
  var e_element = document.getElementsByClassName(element)[0];
  e_element.parentNode.removeChild(e_element);
} 
function trash_item(element,_idproducthasfile){
  var e_element = document.getElementsByClassName(element)[0];
  e_element.parentNode.removeChild(e_element);
  DeleteItem(e_element,_idproducthasfile);
}
function DeleteItem(e_element,_idproducthasfile){
    var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
    var http = new XMLHttpRequest();
    var url = "/teamilk/admin/producthasfile/delete";
    var params = JSON.stringify({"idproducthasfile":_idproducthasfile});
    http.open("POST", url, true);
    http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
    http.setRequestHeader("Accept", "application/json");
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var load = e_element.getElementsByClassName("loading-trash")[0];
    load.style.display = "block";
    http.onreadystatechange = function() {
        if(http.readyState == 4 && http.status == 200) {
            var myArr = JSON.parse(this.responseText);
            if(myArr[0]=='success'){
              load.style.display = "none";
            }
        }
    }
    http.send(params);
}
// function trash(elem){
//   console.log(elem.parentElement.parentElement);
//   var colClass = elem.parentElement.className;
//   var string = colClass.split(" ");
//   var i = string.length -1;
//   var element = document.getElementsByClassName(string[i])[0];
//   element.parentNode.removeChild(element);
// } 
function jscheckfile(_file) {
    var validExts = new Array(".xlsx", ".xls", ".csv", ".doc", ".docx", ".pdf",".zip",".rar", ".gz", ".jpg", ".png");
    var fileExt = _file.name;
    fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
    if (validExts.indexOf(fileExt) < 0) {
      alert("File không hợp lệ, chỉ chấp nhận loại file " +
               validExts.toString() + " types.");
      return false;
    } else {
      var fs = _file.size;
      if(fs > 1000000){
        alert("dung lượng file không quá 1MB");
        return false;
      }
      return true;
    }
}
// var _e_cross_product = document.getElementsByClassName("cross-product")[0];
// function cross_product(element){ 
//   var e_ln_solid = document.createElement("div");
//   e_ln_solid.setAttribute("class","ln_solid");
//   var e_div = document.createElement("div");
//   e_div.setAttribute("class","form-group");
//   var e_label = document.createElement("label");
//   e_label.setAttribute("class", "control-label col-md-3 col-sm-3 col-xs-12");
//   e_label.innerHTML = "Kích thước";
//   var e_div1 = document.createElement("div");
//   e_div1.setAttribute("class","col-md-9 col-sm-9 col-xs-12");
//   var e_select = document.createElement("select");
//   e_select.setAttribute("class","form-controls");
//   e_select.name = "listsize[]";
//   var e_option = document.createElement("option");
//   e_option.setAttribute("class","form-controls");
//   e_option.value = "0";
//   e_option.innerHTML = "Chọn kích thước";
//   e_div.appendChild(e_label);
//   e_select.appendChild(e_option);
//   e_div1.appendChild(e_select);
//   _e_cross_product.appendChild(e_ln_solid);
//   e_div.appendChild(e_div1);
//   _e_cross_product.appendChild(e_div);
//   return false;
// }