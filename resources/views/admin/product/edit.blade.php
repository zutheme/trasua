@extends('admin.dashboard')
@section('other_styles')
   {{-- <link rel="stylesheet" type="text/css" href="{{ asset('bower_components/bootstrap3-wysihtml5-bower/dist/bootstrap3-wysihtml5.min.css') }}"></link> --}}
   <link href="{{ asset('dashboard/production/editor/editor.css') }}" type="text/css" rel="stylesheet"/>
   <link href="{{ asset('dashboard/production/css/editor.css?v=0.0.7') }}" rel="stylesheet">
  
     <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.4.0') }}" rel="stylesheet">
@stop
@section('content')
<div class="row">
	<div class="col-md-12 col-xs-12">
		<h2>Chỉnh sửa</h2>
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
				<p>{!! \Session::get('success') !!}</p>
			</div>
		@endif
	</div>
</div>

<div class="row">
		<form class="frm_create_post" method="post" action="{{ action('Admin\ProductsController@update',$idproduct) }}" onsubmit="return readytextarea()" enctype="multipart/form-data">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			<input type="hidden" name="idimp" value="{{ $product[0]['idimp'] }}">
			<div class="col-md-9 col-xs-12">
			<div class="form-group">
				{{-- <button type="button" onclick="pasteHtmlAtCaret(test)" value="addlink">insert link</button> --}}
				<a class="btn btn-default btn-gallery" href="javascript:void(0)"><i class="fa fa-photo"></i> Media</a>
			</div>
			<div class="form-group">
				<input type="text" name="title" class="form-control" placeholder="Chủ đề" required value="{{ $product[0]['namepro'] }}" />
			</div>
			<div class="form-group">
				<input type="text" name="slug" class="form-control" placeholder="Slug" value="{{ $product[0]['slug'] }}">
			</div>
			<div class="form-group">
              <div class="x_panel">         
                <div class="x_content">
                  <div id="alerts"></div>
                   <input type="hidden" name="render" value="{{ $product[0]['description'] }}" />         
                   <input id="txtEditor" name="body" value="{{ $product[0]['description'] }}" />         
                   {{-- <textarea id="txtEditor" name="body"></textarea> --}}
                </div>
              </div>
			</div>
			 
	          <div class="form-group short_desc">
	            <label class="control-label col-md-3 col-sm-3 col-xs-12">Mô tả vắn tắt</label>
	            <div class="col-md-12">
	              <textarea name="short_desc" class="form-control" rows="3" cols="50" placeholder="Mô tả vắn tắt">{{ $product[0]['short_desc'] }}</textarea>
	            </div>
	          </div>
	           <div class="ln_solid"></div>
			<div class="form-group"> 
				<div class="col-lg-12">
					<script>
				    var list_gallery = [];
				    var item ='';
					</script>             
					<ul class="multi-file">
						@foreach($gallery as $row)
						<li class="item{{ $row['idfile'] }}">
							<input class="producthasfile" type="hidden" name="edit-gallery[]" value="0">	
				     		<a href="javascript:void(0);" onclick="performClickByClass(this);">Chỉnh sửa&nbsp;&nbsp;<i class="fa fa-paperclip" aria-hidden="true"></i>&nbsp;&nbsp;</a>
							<input onchange="editfile(event,this,'{{ $row['idproducthasfile'] }}');" type="file" style="display: none;" name="file_attach[]" class="file file_attach" accept=".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf,.zip,.rar" />
							<label class="namefile"></label>
		                    <p><canvas class="my_canvas gallery" width="0px" height="0px"></canvas></p>
		                    <script> 
		                    	var item = '{{ asset($row['urlfile']) }}';
		                    	if(item) {
		                    		list_gallery.push(item); 
		                    	}
		                    	</script>
		                    <p><a href="javascript:void(0);" class="btn bnt-default btn-trash" style="display: block;" onclick="trash_item('item{{ $row['idfile'] }}','{{ $row['idproducthasfile'] }}');"><i class="fa fa-trash" aria-hidden="true"></i></a></p>
		                    <p><img class="loading-trash" style="display:none;width:30px;" src="{{ asset('dashboard/production/images/loader.gif') }}"></p>
						</li>
						 @endforeach
					</ul>
					<p><input type="button" style="display: block" class="btn btn-default btn-more-file" name="btn-more-file" value="Thêm file" /></p>
					 <div class="ln_solid"></div>
				</div>
			</div>
			<div class="row">
				 <div class="col-sm-12 col-xs-12">	
			       <div class="form-group">
		            <label class="control-label col-md-3 col-sm-3 col-xs-12">Giá nhập hàng:</label>
		            <div class="col-md-9 col-sm-9 col-xs-12">
		              <input type="text" name="price_import" class="form-controls" value="{{ $product[0]['price_import'] }}" />
		            </div>
		          </div> 
		          <div class="form-group">
		            <label class="control-label col-md-3 col-sm-3 col-xs-12">Giá bán gốc:</label>
		            <div class="col-md-9 col-sm-9 col-xs-12">
		              <input type="text" name="price_sale_origin" class="form-controls" value="{{ $product[0]['price_sale_origin'] }}" />
		            </div>
		          </div>
		          <div class="form-group">
		            <label class="control-label col-md-3 col-sm-3 col-xs-12">Giá bán:</label>
		            <div class="col-md-9 col-sm-9 col-xs-12">
		              <input type="text" name="price" class="form-controls" value="{{ $product[0]['price'] }}" />
		            </div>
		          </div>
		          <div class="form-group">
		            <label class="control-label col-md-3 col-sm-3 col-xs-12">Số lượng:</label>
		            <div class="col-md-9 col-sm-9 col-xs-12">
		              <input type="text" name="amount" class="form-controls" value="{{ $product[0]['amount'] }}"/>
		            </div>
		          </div>
		          <div class="form-group">
	                <label class="control-label col-md-3 col-sm-3 col-xs-12">Kích thước</label>
	                <div class="col-md-9 col-sm-9 col-xs-12">
	                  <select class="form-controls" name="idsize">
	                  	<option value="0">Chọn kích thước</option>
	                  	@if(isset($size))
		                  	@foreach($size as $row)
		                		<option value="{{ $row['idsize'] }}" {{ $row['idsize'] == $product[0]['idsize'] ? 'selected="selected"' : '' }}>{{ $row['value'] }}</option>
							@endforeach
						@endif 
	                  </select>
	                 </div>
	              </div>
	              <div class="form-group">
	                <label class="control-label col-md-3 col-sm-3 col-xs-12">Màu sắc</label>
	                <div class="col-md-9 col-sm-9 col-xs-12">
	                  <select class="form-controls" name="idcolor">
	                  	<option value="0">Chọn màu</option>
	                  	@if(isset($color))
		                  	@foreach($color as $row)
		                		<option value="{{ $row['idcolor'] }}" {{ $row['idcolor'] == $product[0]['idcolor'] ? 'selected="selected"' : '' }}>{{ $row['value'] }}</option>
							@endforeach
						@endif 
	                  </select>
	                 </div>
	              	</div>
	              </div>
	              <div class="col-sm-12 col-xs-12"></div>
              </div>
              	<!--extend atribute-->
              <div class="ln_solid"></div>
	          	<div class="cross-product">
		          @foreach($sel_cross_by_idproduct as $row)
			          <div class="row">
			          			<div class="col-sm-6"> 
					                 <div class="form-group">
							            <label class="control-label col-md-3 col-sm-3 col-xs-12">Giá:</label>
							            <div class="col-md-9 col-sm-9 col-xs-12">
							              <input type="text" name="cross_price" class="form-controls" value="{{ $row['price'] }}" />
							            </div>
							          </div>
							          <div class="form-group">
							            <label class="control-label col-md-3 col-sm-3 col-xs-12">Số lượng:</label>
							            <div class="col-md-9 col-sm-9 col-xs-12">
							              <input type="text" name="cross_amount" class="form-controls" value="{{ $row['amount'] }}" />
							            </div>
							          </div>
							          <div class="form-group">
							            <label class="control-label col-md-3 col-sm-3 col-xs-12">size:</label>
							            <div class="col-md-9 col-sm-9 col-xs-12">
							              <input type="text" name="cross_size" class="form-controls" value="{{ $row['size'] }}" />
							            </div>
							          </div>
							          <div class="form-group">
							            <label class="control-label col-md-3 col-sm-3 col-xs-12">Màu sắc:</label>
							            <div class="col-md-9 col-sm-9 col-xs-12">
							              <input type="text" name="cross_color" class="form-controls" value="{{ $row['color'] }}" />
							            </div>
							          </div>
							          <div class="form-group">
							          	<a href="{{ action('Admin\ProductsController@edit',$row['idproduct']) }}" class="info-number">Chỉnh sửa <i class="fa fa-pencil-square"></i></a>
							      	  </div>
							    </div>
							    <div class="col-sm-6 text-left">
							    	<a href="{{ action('Admin\ProductsController@edit',$row['idproduct']) }}"><img class="thumb-cross" src="{{ asset( $row['urlfile']) }}" /></a>
							    </div>
						</div>
				  @endforeach
				</div>
				 <div class="ln_solid"></div>
				<a href="javascript:void(0);" onclick="cross_product();" class="btn btn-primary btn-cross-product">Cross product</a>
				@foreach($sel_parent_cross_product as $item)
					@if(isset($item) && $item['idproduct'])
						<a href="{{ action('Admin\ProductsController@edit',$item['idproduct']) }}">&nbsp;<i class="fa fa-angle-double-left"></i>&nbsp;Về sản phẩm chính</a>
					@endif
				@endforeach
			</div>
			<div class="col-md-3 col-xs-12">
				<div class="form-group row">
	                <label class="col-lg-4 col-form-label" for="sel_idposttype">Kiểu post <span class="text-danger">*</span></label>
	                <div class="col-lg-8">
	                    <select class="form-control cus-drop" name="sel_idposttype" required >
	                    	<option value="">Chọn kiểu post</option>
	                    	@foreach($posttypes as $row)
	                    		<option value="{{ $row['idposttype'] }}" {{ $row['nametype'] == 'product' ? 'selected="selected"' : '' }}>{{ $row['nametype'] }}</option>
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
	                    		 <option value="{{ $row['id_status_type'] }}" {{ $row['id_status_type'] == $product[0]['id_status_type'] ? 'selected="selected"' : '' }}>{{ $row['name_status_type'] }}</option>
							@endforeach        
	                    </select>
	                </div>
	            </div>
				<div class="form-group row">
	                <label class="col-lg-12 col-form-label" for="sel_idcategory">Chuyên mục chính<span class="text-danger">*</span></label>
	                <div class="col-lg-12">
	                    <select class="form-control cus-drop" name="sel_idcat_main" required>
	                    	<option value="0">--Tất cả--</option>
	                    	@foreach($categories as $row)
	                    		 <option value="{{ $row['idcategory'] }}">{{ $row['namecat'] }}</option>
							@endforeach        
	                    </select>
	                </div>
	            </div>
	            <div class="form-group row">
	            	<div class="col-lg-12">
	            		<div class="select_dynamic">
			            	@if(isset($str))
			            		{!! $str !!}
			            	@endif
		            	</div>
		            </div>
	            </div>
	            <script>var _url_thumbnail = '{{ asset($product[0]['url_thumbnail']) }}';</script>
	            <div class="form-group frm-image thumbnails">
                    <p><a href="javascript:void(0)" onclick="performClick('file1');"><i class="fa fa-camera-retro" aria-hidden="true"></i>&nbsp;&nbsp;&nbsp;Ảnh đại diện</a>
                    <input style="display:none" type="file" name="thumbnail" class="file" id="file1" accept="image/*"/></p>
                    <p><canvas id="canvas_thumbnail" width="0px" height="0px"></canvas></p>
				</div>	
	            <div class="form-group text-right">
					<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
				</div>
			 </div> 
		</form>
		
</div>
<div class="modal-media-form">
  <div class="modal-media">
    <!-- Modal content -->
    <div class="modal-content-media">
      <span class="close">&times;</span>
      	<form class="frm-media">
		  <div class="input-group-media">
			<a href="javascript:void(0);" onclick="performClickByClass(this);"><i class="fa fa-photo"></i>&nbsp;&nbsp;Chọn tập tin&nbsp;&nbsp;</a>
			<input onchange="changefile(event,this);" type="file" style="display: none;" name="file_attach[]" class="file file_attach" accept=".xlsx,.xls,image/*,.doc, .docx,.ppt, .pptx,.txt,.pdf,.zip,.rar" />
			<label class="namefile"></label>
            <p><canvas id="my_canvas_media" class="my_canvas" width="500px" height="500px"></canvas></p>
		  </div>
		  <div class="input-group-media area-btn"><a class="btn btn-default btn-insert-picture">Chèn vào bài viết</a></div>
		  <div class="input-group-media">
		  	<p><img class="loading" style="display:none;width:30px;" src="{{ asset('dashboard/production/images/loader.gif') }}"></p>
		  	<span class="result"></span>  	
		  </div>	 
		</form>	  	
    </div>
  </div>
</div>
<div class="modal-cross-form">
  <div class="modal-cross">
    <!-- Modal content -->
    <div class="modal-content-cross">
      <span class="close">&times;</span>
      	<form class="frm-cross form-horizontal form-label-left" method="post" action="{{ action('Admin\ProductsController@crossproduct',$idproduct) }}">
      	  {{ csrf_field() }}
      	  <input type="hidden" name="cross_description" value="{{ $product[0]['description'] }}">
      	  <input type="hidden" name="cross_short_desc" value="{{ $product[0]['short_desc'] }}">
      	  <input type="hidden" name="cross_slug" value="{{ $product[0]['slug'] }}">
      	  <input type="hidden" name="cross_namepro" value="{{ $product[0]['namepro'] }}">
      	  <input type="hidden" name="cross_id_thumbnail" value="{{ $product[0]['id_thumbnail'] }}">
		  <div class="cross-product">
		  	  <div class="form-group">
		  	  	<div class="col-sm-12">
			  	  	<select class="form-control cus-drop" name="cross_sel_idposttype" required >
		                    	<option value="">Chọn kiểu post</option>
		                    	@foreach($posttypes as $row)
		                    		<option value="{{ $row['idposttype'] }}" {{ $row['nametype'] == 'product' ? 'selected="selected"' : '' }}>{{ $row['nametype'] }}</option>
								@endforeach        
		             </select>
		        </div>
		  	  </div>
		  	  <div class="form-group">
		  	  	<div class="col-sm-12">
		  	  		<input type="text" class="form-control" name="cross_price" placeholder="Giá">
		  	  	</div>
		  	  </div>
	          <div class="form-group">
                <div class="col-sm-12">
                  <select class="form-control" name="cross_idsize">
                  	<option value="0">Chọn kích thước</option>
                  	@if(isset($size))
	                  	@foreach($size as $row)
	                		<option value="{{ $row['idsize'] }}">{{ $row['value'] }}</option>
						@endforeach
					@endif 
                  </select>
                 </div>
              </div>
              <div class="form-group">
                <div class="col-sm-12">
                  <select class="form-control" name="cross_idcolor">
                  	<option value="0">Chọn màu</option>
                  	@if(isset($color))
	                  	@foreach($color as $row)
	                		<option value="{{ $row['idcolor'] }}">{{ $row['value'] }}</option>
						@endforeach
					@endif 
                  </select>
                 </div>
              	</div>
	          </div>
	          <div class="form-group">
	          	<button type="submit" class="btn btn-primary btn-submit-cross">Xác nhận</button>
	          </div> 
		</form>	  	
    </div>
  </div>
</div>
<script>var _idproduct = '{{ $idproduct }}';</script>
@stop
@section('other_scripts')
	<script src="{{ asset('dashboard/production/js/process_images/capture_image.js?v=0.3.1') }}"></script>
  	<script src="{{ asset('dashboard/production/editor/editor.js?v=0.0.1') }}"></script>
  	<script src="{{ asset('dashboard/production/js/edit_post.js?v=0.1.0') }}"></script>
  	<script src="{{ asset('dashboard/production/js/create_mutiselect.js?v=0.6.8') }}"></script>	
  	{{-- <script src="{{ asset('dashboard/production/js/process_images/image_product.js.js?v=0.0.2') }}"></script> --}}
  	<script src="{{ asset('dashboard/production/js/uploadmultifile.js?v=0.8.7') }}"></script>
    <script src="{{ asset('dashboard/production/js/media-galerry.js?v=0.5.8') }}"></script>
     <!-- Custom Theme Scripts -->
     <script src="{{ asset('dashboard/production/js/cross_product.js?v=0.0.3') }}"></script>
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.4') }}"></script>
@stop