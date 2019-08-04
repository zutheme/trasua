function extractHostname(url) {

    var hostname;

    //find & remove protocol (http, ftp, etc.) and get hostname

    if (url.indexOf("//") > -1) {

        hostname = url.split('/')[2];

    }

    else {

        hostname = url.split('/')[0];

    }

    //find & remove port number

    hostname = hostname.split(':')[0];

    //find & remove "?"

    hostname = hostname.split('?')[0];

    return hostname;

}
//mediation
var _modal_media_form = document.getElementsByClassName('modal-media-form')[0];
var _e_modal_media = _modal_media_form.getElementsByClassName('modal-media')[0];
var _e_media_form = _modal_media_form.getElementsByClassName('frm-media')[0];
var _e_bnt_insert_media = _e_media_form.getElementsByClassName('btn-insert-picture')[0];
//assign button register media
var _e_btn_gallery = document.getElementsByClassName('btn-gallery');
for (var i = _e_btn_gallery.length - 1; i >= 0; i--) {
    _e_btn_gallery[i].addEventListener("click", show_media_popup);
}
function show_media_popup(){
  _e_modal_media.style.display = "block";
}
var _e_close = _e_modal_media.getElementsByClassName('close')[0];
_e_close.addEventListener("click", close_media_popup);
function close_media_popup(){
   _e_modal_media.style.display = "none";
}
_e_bnt_insert_media.addEventListener("click", upload_images);
function upload_images(){
	  var _img = "";
	  var _url_host = document.URL;
	  _url_host = "http://"+extractHostname(_url_host)+"/teamilk/";
	  var canvas = document.getElementById('my_canvas_media');
	  var width = canvas.width;
	  var height = canvas.height;
	  var ImageURL = canvas.toDataURL('image/jpg', 1.0);
	  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
	  var http = new XMLHttpRequest();
	  var url = "/teamilk/admin/files/uploaddataurl";
	  //var params = "file="+ImageURL;
	  var params = JSON.stringify({"file":ImageURL});
	  http.open("POST", url, true);
	  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
	  http.setRequestHeader("Accept", "application/json");
	  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	  var load = document.getElementsByClassName("loading")[0];
	  load.style.display = "block";
	  http.onreadystatechange = function() {
	      if(http.readyState == 4 && http.status == 200) {
	          var myArr = JSON.parse(this.responseText);
	          _url = myArr.pathfile;
	          _img = "<img width='"+width+"' height='"+height+"' src='"+ _url_host + _url+ "' />";
	          pasteHtmlAtCaret(_img);
	          load.style.display = "none";
	          _e_modal_media.style.display = "none";
	          _img = "";
	          const context = canvas.getContext('2d');
			  context.clearRect(0, 0, canvas.width, canvas.height);
	      }
	  }
	  http.send(params);
	//pasteHtmlAtCaret(test);
}
function upload_files(){
	  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
	  var http = new XMLHttpRequest();
	  var url = "/teamilk/admin/files/uploadfile";
	  var params = JSON.stringify({"file":ImageURL});
	  http.open("POST", url, true);
	  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
	  http.setRequestHeader("Accept", "application/json");
	  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	  var load = document.getElementsByClassName("loading")[0];
	  load.style.display = "block";
	  http.onreadystatechange = function() {
	      if(http.readyState == 4 && http.status == 200) {
	          var myArr = JSON.parse(this.responseText);
	          console.log(myArr.pathfile);
	          load.style.display = "none";
	      }
	  }
	  http.send(params);
}

// var canvas_thumbnail = document.getElementById("my_canvas_id1");
// if(canvas_thumbnail && _url_thumbnail){
// 	var context = canvas_thumbnail.getContext("2d");
// 	var myImg = new Image();
// 	myImg.onload = function() {
// 	   context.drawImage(myImg, 0, 0);
// 	};
// 	myImg.src = _url_thumbnail;
// }

function draw_thumbail(_url_thumbnail) {
if(_url_thumbnail){
	  var c = document.getElementById("canvas_thumbnail");
	  var ctx = c.getContext("2d");
	  var img = new Image();
	  img.onload = function() {
	  	c.setAttribute("height", this.height);
	    c.setAttribute("width", this.width);
	    ctx.drawImage(img, 0, 0);
	  };
	  img.src = _url_thumbnail;
	}
}
window.onload = function() {
	draw_thumbail(_url_thumbnail);
	if(list_gallery){
		list_gallery.forEach(myFunction);
	}
}

function myFunction(value, index, array) {
  	var c = document.getElementsByClassName("gallery")[index];
	var ctx = c.getContext("2d");
	var img = new Image();
		img.onload = function() {
			c.setAttribute("height", this.height);
			c.setAttribute("width", this.width);
			ctx.drawImage(img, 0, 0);
		};
	img.src = value;
}