	function isUploadSupported() {
	    if (navigator.userAgent.match(/(Android (1.0|1.1|1.5|1.6|2.0|2.1))|(Windows Phone (OS 7|8.0))|(XBLWP)|(ZuneWP)|(w(eb)?OSBrowser)|(webOS)|(Kindle\/(1.0|2.0|2.5|3.0))/)) {
	        return false;
	    	}
	    	var elem = document.createElement('input');
		    elem.type = 'file';
		    return !elem.disabled;
		};
		if (window.File && window.FileReader && window.FormData) {
			var inputField = document.getElementById("file");
			inputField.addEventListener("change", function (e) {
				var file = e.target.files[0];
				if (file) {				
					if (/^image\//i.test(file.type)) {
						readFile(file);
					} else {
						alert('Not a valid image!');
					}
				}
			});
		} else {
			alert("File upload is not supported!");
		}
	function readFile(file) {
		var reader = new FileReader();
		reader.onloadend = function () {
			processFile(reader.result, file.type);
		}
		reader.onerror = function () {
			alert('There was an error reading the file!');
		}
		reader.readAsDataURL(file);
	}
	function dataURItoBlob(dataURI) {
	    // convert base64/URLEncoded data component to raw binary data held in a string
	    var byteString;
	    if (dataURI.split(',')[0].indexOf('base64') >= 0)
	        byteString = atob(dataURI.split(',')[1]);
	    else
	        byteString = unescape(dataURI.split(',')[1]);
	    // separate out the mime component
	    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
	    // write the bytes of the string to a typed array
	    var ia = new Uint8Array(byteString.length);
	    for (var i = 0; i < byteString.length; i++) {
	        ia[i] = byteString.charCodeAt(i);
	    }
	    return new Blob([ia], {type:mimeString});
	}
	function _dataURItoBlob(dataURI) {
      if(!dataURI) return null;
      else var mime = dataURI.match(/^data\:(.+?)\;/);
      var byteString = atob(dataURI.split(',')[1]);
      var ab = new ArrayBuffer(byteString.length);
      var ia = new Uint8Array(ab);
      for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
      }
      return new Blob([ab], {type: mime[1]});
    }
    function b64toBlob(b64Data, contentType, sliceSize) {
	        contentType = contentType || '';
	        sliceSize = sliceSize || 512;

	        var byteCharacters = atob(b64Data);
	        var byteArrays = [];

	        for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
	            var slice = byteCharacters.slice(offset, offset + sliceSize);

	            var byteNumbers = new Array(slice.length);
	            for (var i = 0; i < slice.length; i++) {
	                byteNumbers[i] = slice.charCodeAt(i);
	            }

	            var byteArray = new Uint8Array(byteNumbers);

	            byteArrays.push(byteArray);
	        }

	      var blob = new Blob(byteArrays, {type: contentType});
	      return blob;
	}
	function data_URI_to_Blob(dataURI)
	{
	    var byteString = atob(dataURI.split(',')[1]);

	    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

	    var ab = new ArrayBuffer(byteString.length);
	    var ia = new Uint8Array(ab);
	    for (var i = 0; i < byteString.length; i++)
	    {
	        ia[i] = byteString.charCodeAt(i);
	    }

	    var bb = new Blob([ab], { "type": mimeString });
	    return bb;
	}
	function processFile(dataURL, fileType) {
		var maxWidth = 600;
		var maxHeight = 600;
		var image = new Image();
		image.src = dataURL;
		image.onload = function () {
			var width = image.width;
			var height = image.height;
			
			var shouldResize = (width > maxWidth) || (height > maxHeight);
			if (!shouldResize) {
				//sendFile();
				return;
			}
			var newWidth;
			var newHeight;
			if (width > height) {
				newHeight = height * (maxWidth / width);
				newWidth = maxWidth;
			} else {
				newWidth = width * (maxHeight / height);
				newHeight = maxHeight;
			}
			var canvas = document.createElement('canvas');
			canvas.width = newWidth;
			canvas.height = newHeight;
			var context = canvas.getContext('2d');
			context.drawImage(this, 0, 0, newWidth, newHeight);
			dataURL = canvas.toDataURL();
			//dataURL = canvas.toDataURL('image/jpeg', 0.5);
			 document.getElementById('canvasImg').src = dataURL;
			//var blob = dataURItoBlob(dataURL);
			//var blob = _dataURItoBlob(dataURL);
			//sendFile();
		};
		image.onerror = function () {
			alert('There was an error processing your file!');
		};
	}
	
function performClick(elemId) {
   var elem = document.getElementById(elemId);
   if(elem && document.createEvent) {
      var evt = document.createEvent("MouseEvents");
      evt.initEvent("click", true, false);
      elem.dispatchEvent(evt);
   }
}
function sendFile() {	
		//var blob;
		var ImageURL = document.getElementById('canvasImg').getAttribute("src");
		// if(dataURL){
		// 	blob = dataURItoBlob(dataURL);
		// }
		// var block = ImageURL.split(";");
		// var contentType = block[0].split(":")[1];// In this case "image/gif"
		// // get the real base64 content of the file
		// var realData = block[1].split(",")[1];// In this case "R0lGODlhPQBEAPeoAJosM...."

		// // Convert it to a blob to upload
		// var blob = b64toBlob(realData, contentType);
		var blob = data_URI_to_Blob(ImageURL);
		//console.log(blob);
		var frm = document.getElementById("formID");	
		var fd = new FormData();
		fd.append('file', blob,'test.png');
		//fd.append('userpic', myFileInput.files[0], 'chris.jpg'); 
		//Display the key/value pairs
		for (var pair of fd.entries()) {
		    console.log(pair[0]+ ', ' + pair[1]); 
		}
	  var _csrf_token = document.getElementsByName("csrf-token")[0].getAttribute("content");
	  var http = new XMLHttpRequest();
	  var host = window.location.hostname;
	  var url = "/automark/admin/upload";
	  //var params = "file="+blob;
	  //var params = JSON.stringify({"file":ImageURL});
	  http.open("POST", url, true);
	  http.setRequestHeader("X-CSRF-TOKEN", _csrf_token);
	  http.setRequestHeader("Accept", "application/json");
	  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	  var load = document.getElementsByClassName("loading")[0];
	  load.style.display = "block";
	  http.onreadystatechange = function() {
	      if(http.readyState == 4 && http.status == 200) {
	          //alert(http.responseText);
	          var myArr = JSON.parse(this.responseText);
	          console.log(myArr);
	          load.style.display = "none";
	      }
	  }
	  http.send(fd);
}
function performClick(elemId) {
   var elem = document.getElementById(elemId);
   if(elem && document.createEvent) {
      var evt = document.createEvent("MouseEvents");
      evt.initEvent("click", true, false);
      elem.dispatchEvent(evt);
   }
}
 $(document).ready(function(){
		$("#uploaddiamond").on("submit", function(e) {
		    e.preventDefault();		   
		    var extension = $('#result_file').val().split('.').pop().toLowerCase();
		    if ($.inArray(extension, ['csv', 'xls', 'xlsx']) == -1) {
		        $('#errormessage').html('Please Select Valid File... ');
		    } else {
		    	var file_data = $('#result_file').prop('files')[0];
		        //var supplier_name = $('#supplier_name').val();
		        var form_data = new FormData();
		        form_data.append('file', file_data);
		        //form_data.append('supplier_name', supplier_name);
		        for (var pair of form_data.entries()) {
				    console.log(pair[0]+ ', ' + pair[1]); 
				}
		        $.ajaxSetup({
		            headers: {
		                'X-CSRF-Token': $('meta[name=_token]').attr('content')
		            }
		        });

		        $.ajax({
		            url: "/automark/admin/postDiamond", // point to server-side PHP script
		            data: form_data,
		            type: 'POST',
		            contentType: false, // The content type used when sending data to the server.
		            cache: false, // To unable request pages to be cached
		            processData: false,
		            success: function(data) {
		            	console.log(data);
		            }
		        });
		    }
		});

 });