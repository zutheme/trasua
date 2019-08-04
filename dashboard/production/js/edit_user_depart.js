function getSelectedText(elementId) {

    var elt = document.getElementById(elementId);

    if (elt.selectedIndex == -1)

        return null;

    return elt.options[elt.selectedIndex].text;

}

var _e_sel_iddepart_main = document.getElementsByName("sel_iddepart_main")[0];

_e_sel_iddepart_main.addEventListener("change", function(){

    var select_iddepart = this.options[this.selectedIndex].value;

    if(select_iddepart > 0){

      select_department(select_iddepart);

    }

});

function comp_listcat(myarrs,idcmp){

    var iddepart;

    var idimppost = 0;

    for (let i = 0; i < myarrs.length; i++) {

      iddepart = myarrs[i].iddepart;

      if (iddepart == idcmp){

           idimppost = myarrs[i].idimppost;

           return idimppost;

          break;

      }      

    }

    return idimppost;

}

function select_department(select_iddepart){

  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");

  var http = new XMLHttpRequest();

  var host = window.location.hostname;

  var url = "/admin/department/listdepartmentbyid";

  var params = JSON.stringify({"sel_iddepart":select_iddepart});

  http.open("POST", url, true);

  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);

  http.setRequestHeader("Accept", "application/json");

  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

  //var load = _e_frm_reg.getElementsByClassName("loading")[0];

  //load.style.display = "block";

  http.onreadystatechange = function() {

      if(http.readyState == 4 && http.status == 200) {

           var myArr = JSON.parse(this.responseText);
           console.log(myArr);
           var e_ul =  document.getElementsByClassName("list-check")[0];

           var iddepart;

           var idimppost;

          while (e_ul.firstChild) {

              e_ul.removeChild(e_ul.firstChild);

          }

         

           Object.keys(myArr).forEach(function(key) {

            var e_li = document.createElement("li");

             var label = document.createElement("label");

             var e_input = document.createElement("input");

             

             iddepart = myArr[key].iddepart;

             e_input.type = "checkbox";

             e_input.value = iddepart;

             e_input.name = "list_check[]";

             e_input.setAttribute("class", "flat");

             idimppost = comp_listcat(list_sel_empdepart,iddepart);

             if(idimppost > 0 ){

                e_input.setAttribute("checked", "true");

                //e_input.setAttribute("onclick","getSelectedValue("+idimppost+","+iddepart+")");

                e_input.addEventListener("change",getSelectedValue);

             }         

             label.innerHTML = "&nbsp;"+myArr[key].namedepart;

             e_input.setAttribute("class", "flat");

             e_li.appendChild(e_input);

             e_li.appendChild(label); 

             e_ul.appendChild(e_li);

             if(idimppost > 0 ){

                var e_hidden_input = document.createElement("input");

                e_hidden_input.setAttribute("type", "hidden");             

                e_hidden_input.setAttribute("name","list_idimppost[]");

                e_hidden_input.setAttribute("value", idimppost+"," + iddepart);

                e_li.appendChild(e_hidden_input);

            }else{

                var e_hidden_input = document.createElement("input");

                e_hidden_input.setAttribute("type", "hidden");             

                e_hidden_input.setAttribute("name","list_idimppost[]");

                e_hidden_input.setAttribute("value", 0 + ","+0);

                e_input.addEventListener("change",getSelectedValue);

                e_li.appendChild(e_hidden_input);

            }  

            //console.log('iddepartegory='+myArr[key].iddepartegory+',name='+myArr[key].name)

          });

          //load.style.display = "none";      

      }

  }

  http.send(params);

}



function getSelectedValue() {

    var _check = this.checked;

    var iddepart = this.value;

    var e_imppost = this.parentElement.getElementsByTagName("input")[1];

    var idimppost = e_imppost.value;

    var rs;

    if(!_check){

        rs = idimppost.split(',');

        rs = rs[0]+","+0;

      e_imppost.setAttribute("value",rs);

    }else {

        rs = idimppost.split(',');

        rs = rs[0]+","+iddepart;

        e_imppost.setAttribute("value", rs);

    }

}





