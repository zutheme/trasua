
  function getSelectedText(elementId) {

    var elt = document.getElementById(elementId);

    if (elt.selectedIndex == -1)

        return null;

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
  var url = url_home+"/admin/category/catebyidcatetype/"+select_idcattype;
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
           console.log(myArr);
           if(_e_catebyidcatetype){
              while (_e_catebyidcatetype.firstChild) {
                  _e_catebyidcatetype.removeChild(_e_catebyidcatetype.firstChild);
              }
            }
          var e_option = document.createElement("option");
          e_option.setAttribute("value", "0");
          e_option.innerHTML = "Thuộc chuyên mục";
          _e_catebyidcatetype.appendChild(e_option);
          for (var key in myArr) {
          console.log(myArr[key].namecat);
          e_option = document.createElement("option");
          e_option.setAttribute("value", myArr[key].idcategory);
          e_option.innerHTML = myArr[key].namecat;
          _e_catebyidcatetype.appendChild(e_option);
      }    
      }
  }
  http.send();
  //http.send(params);
}
  