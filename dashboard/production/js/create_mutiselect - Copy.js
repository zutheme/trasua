function getSelectedText(elementId) {

    var elt = document.getElementById(elementId);

    if (elt.selectedIndex == -1)

        return null;

    return elt.options[elt.selectedIndex].text;

}



var _e_sel_idcat_main = document.getElementsByName("sel_idcat_main")[0];

_e_sel_idcat_main.addEventListener("change", function(){

    var select_idcat = this.options[this.selectedIndex].value;
    //console.log(select_idcat);
    if(select_idcat > 0){

      select_category(select_idcat);
      
    }

});



function select_category(select_idcat){

  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");

  var http = new XMLHttpRequest();

  var host = window.location.hostname;

  var url = "/teamilk/admin/category/listcategorybyid";

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
           var e_sel_dynamic =  document.getElementsByClassName("select_dynamic")[0];
           //var e_ul =  document.getElementsByClassName("list-check")[0];

           var idcat;
           if(e_sel_dynamic){
              while (e_sel_dynamic.firstChild) {

                  e_sel_dynamic.removeChild(e_sel_dynamic.firstChild);

              }
            }
          console.log(myArr);
          var e_ul = document.createElement("ul");
          e_ul.setAttribute("class", "list-check");
           Object.keys(myArr).forEach(function(key) {

            var e_li = document.createElement("li");

            var e_input = document.createElement("input");

             var label = document.createElement("label");

             var e_input = document.createElement("input");

             idcat = myArr[key].idcategory;

             e_input.type = "checkbox";

             e_input.value = idcat;

             e_input.name = "list_check[]";

             e_input.setAttribute("class", "flat");       

             label.innerHTML = "&nbsp;"+myArr[key].namecat;

             e_input.setAttribute("class", "flat");

             e_li.appendChild(e_input);

             e_li.appendChild(label); 

             e_ul.appendChild(e_li);  
            //console.log('idcategory='+myArr[key].idcategory+',name='+myArr[key].name)
          });
           e_sel_dynamic.appendChild(e_ul);
          //load.style.display = "none";      

      }

  }

  http.send(params);

}





//document.getElementsByClassName("frm_create_post")[0].addEventListener("submit", getSelectedListcheck);

  

