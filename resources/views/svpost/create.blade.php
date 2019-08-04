@extends('master')
@section('content')
<div class="row">
	<div class="col-sm-6">
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
		<form class="frm_create_post" method="post" action="{{url('svpost')}}">
			{{ csrf_field() }}
			
			<div class="form-group">
				<input type="text" name="title" class="form-control" placeholder="Chủ đề">
			</div>
			<div class="form-group">
				<textarea name="body" rows="4" cols="50" placeholder="Mô tả"></textarea>
			</div>
			<div class="form-group">
				<input type="text" name="url" class="form-control" placeholder="Đường dẫn">
			</div>
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idposttype">Kiểu post <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idposttype">
                    	<option value="">Chọn kiểu post</option>
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
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
			</div>
		</form>
	</div>
</div>

@stop