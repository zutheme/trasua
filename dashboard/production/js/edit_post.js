jQuery(document).ready(function($) {	
	$("#txtEditor").Editor(); 
});

window.addEventListener('DOMContentLoaded', function(){
      //document.getElementsByClassName("frm_create_post")[0].addEventListener("submit",readytextarea(event));
      var e_editor = document.getElementsByClassName("Editor-editor")[0];
      var _e_body = document.getElementsByName("render")[0];
      if(_e_body){
        var _body = document.getElementsByName("render")[0].value;
        if(_body){
            e_editor.innerHTML = _body;
        }
      }
});

function readytextarea(){
    //event.preventDefault()
    var e_editor = document.getElementsByClassName("Editor-editor")[0];
	var text = e_editor.innerHTML;
	document.getElementsByName("body")[0].value = text;
	if(text.length == 0) {
        alert("Bạn chưa nhập nội dung");
        //console.log("Bạn chưa nhập nội dung");
        return false;
    }   
    var elt = document.getElementsByName("list_check[]");
      var checked = false;
        for (let i = 0; i < elt.length; i++) {
          checked = elt[i].checked;
          
          if (checked){
              checked = true; 
              break;
          }
        }
        console.log(checked);
        if(!checked){
            document.getElementsByClassName("required_sub_cat")[0].innerHTML="Bạn chưa chọn chuyên mục";
            return false;
        }
        console.log(checked);
        return true;
}

function pasteHtmlAtCaret(html) {
    var sel, range;
    if (window.getSelection) {
        // IE9 and non-IE
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();

            // Range.createContextualFragment() would be useful here but is
            // only relatively recently standardized and is not supported in
            // some browsers (IE9, for one)
            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            range.insertNode(frag);

            // Preserve the selection
            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                range.collapse(true);
                sel.removeAllRanges();
                sel.addRange(range);
            }
        }
    } else if (document.selection && document.selection.type != "Control") {
        // IE < 9
        document.selection.createRange().pasteHTML(html);
    }
}	

function pasteHtmlAtCaret(html, selectPastedContent) {
    var sel, range;
    if (window.getSelection) {
        // IE9 and non-IE
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();

            // Range.createContextualFragment() would be useful here but is
            // only relatively recently standardized and is not supported in
            // some browsers (IE9, for one)
            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            var firstNode = frag.firstChild;
            range.insertNode(frag);

            // Preserve the selection
            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                if (selectPastedContent) {
                    range.setStartBefore(firstNode);
                } else {
                    range.collapse(true);
                }
                sel.removeAllRanges();
                sel.addRange(range);
            }
        }
    } else if ( (sel = document.selection) && sel.type != "Control") {
        // IE < 9
        var originalRange = sel.createRange();
        originalRange.collapse(true);
        sel.createRange().pasteHTML(html);
        if (selectPastedContent) {
            range = sel.createRange();
            range.setEndPoint("StartToStart", originalRange);
            range.select();
        }
    }
}

