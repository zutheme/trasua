	var original_filename;
	//var gbdataURL;
	function isUploadSupported() {
	    if (navigator.userAgent.match(/(Android (1.0|1.1|1.5|1.6|2.0|2.1))|(Windows Phone (OS 7|8.0))|(XBLWP)|(ZuneWP)|(w(eb)?OSBrowser)|(webOS)|(Kindle\/(1.0|2.0|2.5|3.0))/)) {
	        return false;
	    	}
	    	var elem = document.createElement('input');
		    elem.type = 'file';
		    return !elem.disabled;
		};

	if (window.File && window.FileReader && window.FormData) {
		var inputField = document.getElementsByClassName("file");
		for (var i = inputField.length - 1; i >= 0; i--) {
			inputField[i].addEventListener("change", function (e) {
				var file = e.target.files[0];
				//var files = event.target.files;
				//var fileName = files[0].name;
				original_filename = file.name;
				if (file) {				
					if (/^image\//i.test(file.type)) {
						var element = this.parentElement.parentElement;
						readFile(file,element);
					} else {
						alert('Not a valid image!');
					}
				}
			});
		}
	} else {
		alert("File upload is not supported!");
	}

	function readFile(file,element) {
		var reader = new FileReader();
		reader.onloadend = function () {
			processFile(reader.result, file.type,element);
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
	    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
	    var ab = new ArrayBuffer(byteString.length);
	    var ia = new Uint8Array(ab);
	    for (var i = 0; i < byteString.length; i++)
	    {
	        ia[i] = byteString.charCodeAt(i);
	    }
	    var bb = new Blob([ab], { "type": mimeString });
	    return bb;
	}
	function processFile(dataURL, fileType, element) {
		var maxWidth = 500;
		var maxHeight = 500;
		var image = new Image();
		image.src = dataURL;
		image.onload = function(){
			var width = image.width;
			var height = image.height;
			var EnableResize = (width < 1200) || (height < 1200);
			if(!EnableResize) {
				alert("Yêu cầu kích thước hình < 1200");
				return;
			}
			var shouldResize = (width > maxWidth) || (height > maxHeight);
			if (!shouldResize) {
				//sendFile(dataURL);
				alert("Kích thước hình tối thiểu"+" width="+width+", height="+height);
				return;
			}
			var newWidth = width;
			var newHeight =  height;
			var aspectRatio = ( width /  height );
			var newHeight = ( newWidth / aspectRatio );
			var newWidth = ( newHeight * aspectRatio );
			// if (width > height) {
			// 	newHeight = height * (maxWidth / width);
			// 	newWidth = maxWidth;
			// } else {
			// 	newWidth = width * (maxHeight / height);
			// 	newHeight = maxHeight;
			// }
			var canvas = document.createElement('canvas');
			canvas.width = newWidth;
			canvas.height = newHeight;
			var context = canvas.getContext('2d');
			context.drawImage(this, 0, 0, newWidth, newHeight);
			dataURL = canvas.toDataURL();
			//gbdataURL = dataURL;
			var e_frm_register = document.getElementsByClassName("frm-image")[0];
			var _width = e_frm_register.clientWidth;
			//var myCanvas = document.getElementById('my_canvas_id');
			var myCanvas = element.getElementsByTagName("canvas")[0];
				myCanvas.setAttribute("height", newHeight);
				myCanvas.setAttribute("width", newWidth);
				var ctx = myCanvas.getContext('2d');
					ctx.drawImage(this, 0, 0, newWidth, newHeight);
					//dataURL = myCanvas.toDataURL();
						
				//var img = new Image;
				//img.onload = function(){
				  //ctx.drawImage(img,0,0);
				//};
				//var _e_input_hidden = element.getElementsByClassName("data_url")[0];
				//_e_input_hidden.value=dataURL;
				//console.log(_e_input_hidden);		
				//img.src = dataURL;
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


 function getBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
  });
}