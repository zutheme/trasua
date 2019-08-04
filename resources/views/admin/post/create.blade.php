@extends('admin.dashboard')
@section('other_styles')
   {{-- <link rel="stylesheet" type="text/css" href="{{ asset('bower_components/bootstrap3-wysihtml5-bower/dist/bootstrap3-wysihtml5.min.css') }}"></link> --}}
   <link href="{{ asset('dashboard/production/editor/editor.css') }}" type="text/css" rel="stylesheet"/>
   <link href="{{ asset('dashboard/production/css/editor.css?v=0.0.7') }}" rel="stylesheet">
  
     <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.3') }}" rel="stylesheet">
@stop
@section('content')
<div class="row">
	<div class="col-md-12 col-xs-12">
		<h2>Thêm mới</h2>
		@if(count($errors) > 0)
		<div class="alert alert-danger">
			<ul>
				@foreach($errors->all() as $error)
					<li>{{ $error }}</li>
				@endforeach
			</ul>
		</div>
		@endif
		@if(\Session::has('success'))
			<div class="alert alert-success">
				<p>{{ \Session::get('success') }}</p>
			</div>
		@endif
	</div>
</div>
<script type="text/javascript">
	var test = '<a href="#">test</a>';
</script>
<div class="row">
		<form class="frm_create_post" method="post" action="{{url('admin/post')}}" onsubmit="return readytextarea()" enctype="multipart/form-data">
			{{ csrf_field() }}
			<div class="col-md-9 col-xs-12">
			<div class="form-group">
				<button type="button" onclick="pasteHtmlAtCaret(test)" value="addlink">insert link</button>
			</div>
			<div class="form-group">
				<input type="text" name="title" class="form-control" placeholder="Chủ đề" required />
			</div>
			{{-- <div class="form-group">
				<input type="text" name="slug" class="form-control" placeholder="Slug">
			</div> --}}
			<div class="form-group">
              <div class="x_panel">         
                <div class="x_content">
                  <div id="alerts"></div>         
                   <textarea id="txtEditor" name="body"></textarea>
                </div>
              </div>
			</div>
			<div class="form-group"> 
				<div class="col-lg-12">                
					<ul class="list-group multi-file">
						<li class="list-group-item item0">	
				     		<a href="#" onclick="performClickByClass(this);">Đính kèm&nbsp;&nbsp;<i class="fa fa-paperclip" aria-hidden="true"></i>&nbsp;&nbsp;</a>
							<input onchange="changefile(event,this);" type="file" style="display: none;" name="file_attach[]" class="file_attach" accept=".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf,.zip,.rar" />
							<label class="namefile"></label>
							<span class="btn bnt-default btn-trash" style="float: right; display: none;" onclick="trash(this);"><i class="fa fa-trash" aria-hidden="true"></i></span>
						</li>
					</ul>
					<input type="button" style="display: none" class="btn btn-default btn-more-file" name="btn-more-file" value="Thêm file" />
				</div>
			</div>
			<div class="form-group">
				<div class="col-lg-12">
					<input type="text" name="processing" class="form-control" placeholder="Tiến độ %" />
				</div>
			</div>	
			</div>
			<div class="col-md-3 col-xs-12">
				<div class="form-group row">
	                <label class="col-lg-4 col-form-label" for="sel_idposttype">Kiểu post <span class="text-danger">*</span></label>
	                <div class="col-lg-8">
	                    <select class="form-control cus-drop" name="sel_idposttype" required >
	                    	<option value="">Chọn kiểu post</option>
	                    	@foreach($posttypes as $row)
	                    		 <option value="{{ $row['idposttype'] }}">{{ $row['nametype'] }}</option>
							@endforeach        
	                    </select>
	                </div>
	            </div>
	            <div class="form-group row">
	                <label class="col-lg-4 col-form-label" for="sel_idstatustype">Trạng thái <span class="text-danger">*</span></label>
	                <div class="col-lg-8">
	                    <select class="form-control cus-drop" name="sel_idstatustype" required >
	                    	<option value="">Chọn trạng thái</option>
	                    	@foreach($statustypes as $row)
	                    		 <option value="{{ $row['id_status_type'] }}">{{ $row['name_status_type'] }}</option>
							@endforeach        
	                    </select>
	                </div>
	            </div>
				<div class="form-group row">
	                <label class="col-lg-12 col-form-label" for="sel_idcategory">Chuyên mục chính<span class="text-danger">*</span></label>
	                <div class="col-lg-12">
	                    <select class="form-control cus-drop" name="sel_idcat_main" required>
	                    	<option value="">Thuộc chuyên mục</option>
	                    	@foreach($categories as $row)
	                    		 <option value="{{ $row['idcategory'] }}">{{ $row['namecat'] }}</option>
							@endforeach        
	                    </select>
	                </div>
	            </div>
	            <div class="form-group row">
	                <label class="col-lg-12 col-form-label" for="sel_idcategory">Chuyên mục <span class="text-danger required_sub_cat">*</span></label>
	                <div class="col-lg-12">
	                    	<ul class="list-check">
	                     	</ul>
	                </div>
	            </div>
	            <div class="form-group">            				
					<a href="#" onclick="performClick('file');">Hình đại diện&nbsp;&nbsp;<i class="fa fa-camera-retro" aria-hidden="true"></i></a>
					<input style="display:none" type="file" name="file_name" id="file" accept="image/*" multiple/>
					<img class="loading" src="{{ asset('dashboard/production/images/loader.gif') }}" style="display:none">  
					 <img id="canvasImg" style="width: auto;height: auto" alt="">
				</div>	
	            <div class="form-group text-right">
					<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
				</div>
			 </div>
			 
		</form>
		
</div>

@stop
@section('other_scripts')

  	<script src="{{ asset('dashboard/production/editor/editor.js?v=0.0.1') }}"></script>
  	<script src="{{ asset('dashboard/production/js/edit_post.js?v=0.0.9') }}"></script>
  	<script src="{{ asset('dashboard/production/js/create_mutiselect.js?v=0.5.1') }}"></script>
  	{{-- <script src="{{ asset('dashboard/production/js/create_uploadfile.js?v=0.8.7') }}"></script> --}}
  	<script src="{{ asset('dashboard/production/js/uploadmultifile.js?v=0.2.8') }}"></script>
      <!-- Custom Theme Scripts -->
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script>
@stop