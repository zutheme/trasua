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







function select_department(select_iddepart){



  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");



  var http = new XMLHttpRequest();



  var host = window.location.hostname;



  //var url = "http://thammyvienthienkhue.com.vn/admin/department/listdepartmentbyid";

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



           var e_ul =  document.getElementsByClassName("list-check")[0];



           var iddepart;



          while (e_ul.firstChild) {



              e_ul.removeChild(e_ul.firstChild);



          }



         



           Object.keys(myArr).forEach(function(key) {



            var e_li = document.createElement("li");



            var e_input = document.createElement("input");



             var label = document.createElement("label");



             var e_input = document.createElement("input");



             iddepart = myArr[key].iddepart;



             e_input.type = "checkbox";



             e_input.value = iddepart;



             e_input.name = "list_check[]";



             e_input.setAttribute("class", "flat");       



             label.innerHTML = "&nbsp;"+myArr[key].namedepart;



             e_input.setAttribute("class", "flat");



             e_li.appendChild(e_input);



             e_li.appendChild(label); 



             e_ul.appendChild(e_li);  



            //console.log('iddepart='+myArr[key].iddepart+',name='+myArr[key].name)



          });



          //load.style.display = "none";      



      }



  }



  http.send(params);



}











//document.getElementsByClassName("frm_create_post")[0].addEventListener("submit", getSelectedListcheck);



  



