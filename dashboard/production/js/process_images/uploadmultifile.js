// var e_ul =  document.getElementsByClassName("list-check")[0];
//      var idcat;
//     while (e_ul.firstChild) {
//         e_ul.removeChild(e_ul.firstChild);
//     }

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
  var filename = e.target.files[0];
  if(!jscheckfile(filename)){
    return false;
  }
  var e_btn_trash = element.parentElement.getElementsByClassName("btn-trash")[0];
   var name = filename.name;
   var e_lb = element.parentElement.getElementsByTagName("label")[0];
   e_lb.innerHTML = name;
   bntmore.style.display = "block";
   e_btn_trash.style.display = "block";
}
var item = 0;
bntmore.addEventListener("click", function(){
     item = item + 1;
     var class_item = "list-group-item item"+item;
     var e_li = document.createElement("li");
     e_li.setAttribute("class",class_item);
     var e_ahref = document.createElement("a");
     e_ahref.setAttribute("href", "#");
     e_ahref.setAttribute("onclick", "performClickByClass(this);");
     e_ahref.innerHTML = 'Đính kèm&nbsp;&nbsp;<i class="fa fa-paperclip" aria-hidden="true"></i>&nbsp;&nbsp;';
     var e_input_file = document.createElement("input");
     e_input_file.type = "file";
     e_input_file.name = "file_attach[]";
     e_input_file.setAttribute("onchange", "changefile(event,this);");
     e_input_file.setAttribute("style", "display: none;");
     e_input_file.setAttribute("class", "file_attach");
     e_input_file.setAttribute("accept", ".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf,.zip,.rar");
     var label = document.createElement("label");
     label.innerHTML = "";
     var e_span = document.createElement("span");
     e_span.setAttribute("class", "btn bnt-default btn-trash");
     e_span.setAttribute("style", "float: right; display: none;");
     e_span.setAttribute("onclick", "trash(this);");
     e_span.setAttribute("onclick", "trash(this);");
     e_span.innerHTML = '<i class="fa fa-trash" aria-hidden="true"></i>';
     e_li.appendChild(e_ahref);
     e_li.appendChild(e_input_file);
     e_li.appendChild(label);
     e_li.appendChild(e_span);
     e_muti_files.appendChild(e_li);  
});

function trash(elem){
  var colClass = elem.parentElement.className;
  var string = colClass.split(" ");
  var i = string.length -1;
  var element = document.getElementsByClassName(string[i])[0];
  element.parentNode.removeChild(element);
} 
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
      if(fs > 5000000){
        alert("dung lượng file không quá 5MB");
        return false;
      }
      return true;
    }
}