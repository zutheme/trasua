@extends('master')

@section('other_styles')
    
@stop
@section('content')
<div class="row">
	<div class="col-sm-6">
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
				<p>{{ \Session::get('success') }}</p>
			</div>
		@endif
		<form class="frm_create_post" method="post" action="{{action('SvPostController@update',$id_svpost)}}">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			
			<div class="form-group">
				<input type="text" name="title" class="form-control" value="{{$svposts->title}}">
			</div>
			<div class="form-group">
				<textarea name="body" rows="4" cols="50" placeholder="Mô tả">{{$svposts->body}}</textarea>
			</div>
			<div class="form-group">
				<input type="text" name="url" class="form-control" value="{{$svposts->url}}">
			</div>
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idposttype">Kiểu post <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idposttype">
                    	<option value="">chọn kiểu post</option>
                    	@foreach($svposttypes as $row)
                    		 <option value="{{ $row['id_post_type'] }}">{{ $row['name'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idcategory">Chuyên mục <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idcategory">
                    	<option value="">Thuộc chuyên mục</option>
                    	@foreach($categories as $row)
                    		 <option value="{{ $row['idcategory'] }}">{{ $row['name'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Cập nhật" />
			</div>
		</form>
		
		@foreach($selected as $row)
		<script type="text/javascript">
			var selected_type = '{{$row['id_post_type']}}';
			var name_type =  '{{ $row['type'] }}';
			var selected_idcat =  '{{ $row['idcategory'] }}';
			var category = '{{ $row['category'] }}';
		</script>
		@endforeach   
	</div>
</div>
@stop

@section('other_scripts')
    <script type="text/javascript">
	var _e_sel_posttype = document.getElementsByName("sel_idposttype")[0];
	var _e_option_type = _e_sel_posttype.getElementsByTagName("option");
	for (var i = _e_option_type.length - 1; i >= 0; i--) {
		if(_e_option_type[i].value==selected_type){
			_e_option_type[i].setAttribute("selected", true);
		}
	}
	var _e_sel_category = document.getElementsByName("sel_idcategory")[0];
	var _e_option_cat = _e_sel_category.getElementsByTagName("option");
	for (var i =  _e_option_cat.length - 1; i >= 0; i--) {
		if( _e_option_cat[i].value==selected_idcat){
			 _e_option_cat[i].setAttribute("selected", true);
		}
	}
</script>
@stop