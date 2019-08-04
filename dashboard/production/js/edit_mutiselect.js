function getSelectedText(elementId) {
    var elt = document.getElementById(elementId);
    if (elt.selectedIndex == -1)
        return null;
    return elt.options[elt.selectedIndex].text;
}
var _e_sel_idcat_main = document.getElementsByName("sel_idcat_main")[0];
_e_sel_idcat_main.addEventListener("change", function(){
    var select_idcat = this.options[this.selectedIndex].value;
    if(select_idcat > 0){
      select_category(select_idcat);
    }
});
function comp_listcat(myarrs,idcmp){
    var idcat;
    var idimppost = 0;
    for (let i = 0; i < myarrs.length; i++) {
      idcat = myarrs[i].idcategory;
      if (idcat == idcmp){
           idimppost = myarrs[i].idimppost;
           return idimppost;
          break;
      }      
    }
    return idimppost;
}
function select_category(select_idcat){
  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
  var http = new XMLHttpRequest();
  var host = window.location.hostname;
  var url = "/automark/admin/post/listcatbyidcat";
  var params = JSON.stringify({"sel_idcategory":select_idcat});
  http.open("POST", url, true);
  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
  http.setRequestHeader("Accept", "application/json");
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  //var load = _e_frm_reg.getElementsByClassName("loading")[0];
  //load.style.display = "block";
  http.onreadystatechange = function() {
      if(http.readyState == 4 && http.status == 200) {
           var myArr = JSON.parse(this.responseText);
           var e_ul =  document.getElementsByClassName("list-check")[0];
           var idcat;
           var idimppost;
          while (e_ul.firstChild) {
              e_ul.removeChild(e_ul.firstChild);
          }
         
           Object.keys(myArr).forEach(function(key) {
            var e_li = document.createElement("li");
             var label = document.createElement("label");
             var e_input = document.createElement("input");
             
             idcat = myArr[key].idcategory;
             e_input.type = "checkbox";
             e_input.value = idcat;
             e_input.name = "list_check[]";
             e_input.setAttribute("class", "flat");
             idimppost = comp_listcat(list_select,idcat);
             if(idimppost > 0 ){
                e_input.setAttribute("checked", "true");
                //e_input.setAttribute("onclick","getSelectedValue("+idimppost+","+idcat+")");
                e_input.addEventListener("change",getSelectedValue);
             }         
             label.innerHTML = "&nbsp;"+myArr[key].namecat;
             e_input.setAttribute("class", "flat");
             e_li.appendChild(e_input);
             e_li.appendChild(label); 
             e_ul.appendChild(e_li);
             if(idimppost > 0 ){
                var e_hidden_input = document.createElement("input");
                e_hidden_input.setAttribute("type", "hidden");             
                e_hidden_input.setAttribute("name","list_idimppost[]");
                e_hidden_input.setAttribute("value", idimppost+"," + idcat);
                e_li.appendChild(e_hidden_input);
            }else{
                var e_hidden_input = document.createElement("input");
                e_hidden_input.setAttribute("type", "hidden");             
                e_hidden_input.setAttribute("name","list_idimppost[]");
                e_hidden_input.setAttribute("value", 0 + ","+0);
                e_input.addEventListener("change",getSelectedValue);
                e_li.appendChild(e_hidden_input);
            }  
            //console.log('idcategory='+myArr[key].idcategory+',name='+myArr[key].name)
          });
          //load.style.display = "none";      
      }
  }
  http.send(params);
}

function getSelectedValue() {
    var _check = this.checked;
    var idcat = this.value;
    var e_imppost = this.parentElement.getElementsByTagName("input")[1];
    var idimppost = e_imppost.value;
    var rs;
    if(!_check){
        rs = idimppost.split(',');
        rs = rs[0]+","+0;
      e_imppost.setAttribute("value",rs);
    }else {
        rs = idimppost.split(',');
        rs = rs[0]+","+idcat;
        e_imppost.setAttribute("value", rs);
    }
}
function comp_listpostype(myarrs,idcmp){
    var idpostype;
    var rs = false;
    //console.log(myarrs);
    for (let i = 0; i < myarrs.length; i++) {
      idpostype = myarrs[i].idposttype;
      console.log(idpostype);
      if (idpostype == idcmp){
          rs = true;
          break;
      }      
    }
    return rs;
}
  var _e_sel_idposttype = document.getElementsByName("sel_idposttype")[0];
  var _e_option_idposttype = _e_sel_idposttype.getElementsByTagName("option");
  var idpostype;
  for (var i =  _e_option_idposttype.length - 1; i >= 0; i--) {
    idpostype = _e_option_idposttype[i].value;
    if(idpostype > 0) {
      if(comp_listpostype(list_select,idpostype)){
        _e_option_idposttype[i].setAttribute("selected", true);
      }
    }
  }
  function comp_idcatparent(myarrs,idcmp){
    var idcatparent;
    var rs = false;
    for (let i = 0; i < myarrs.length; i++) {
      idcatparent = myarrs[i].idcatparent;
      //console.log(idpostype);
      if (idcatparent == idcmp){
          rs = true;
          break;
      }      
    }
    return rs;
}
  var _e_sel_idcat_main = document.getElementsByName("sel_idcat_main")[0];
  var _e_option_idcat_main = _e_sel_idcat_main.getElementsByTagName("option");
  var idcat_main;

  for (var i =  _e_option_idcat_main.length - 1; i >= 0; i--) {
    idcat_main = _e_option_idcat_main[i].value;
    if(idcat_main > 0) {
      if(comp_idcatparent(list_select,idcat_main)){
        _e_option_idcat_main[i].setAttribute("selected", true);
        select_category(idcat_main);
      }
    }
  }
function comp_idstatustype(myarrs,idcmp){
    var id_status_type;
    var rs = false;
    //console.log(myarrs);
    for (let i = 0; i < myarrs.length; i++) {
      id_status_type = myarrs[i].id_status_type;
      //console.log(idpostype);
      if (id_status_type == idcmp){
          rs = true;
          break;
      }      
    }
    return rs;
}
  var _e_sel_idstatustype = document.getElementsByName("sel_idstatustype")[0];
  var _e_option_idstatustype = _e_sel_idstatustype.getElementsByTagName("option");
  var id_status_type;

  for (var i =  _e_option_idstatustype.length - 1; i >= 0; i--) {
    id_status_type = _e_option_idstatustype[i].value;
    if(id_status_type > 0) {
      if(comp_idstatustype(list_select,id_status_type)){
        _e_option_idstatustype[i].setAttribute("selected", true);
      }
    }
  }
