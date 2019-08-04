@extends('admin.dashboard')

@section('other_styles')
      <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.2') }}" rel="stylesheet">
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
		<form class="frm_edit_menu" method="post" action="{{action('Admin\MenuController@update',$idmenu)}}">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			<div class="form-group">
				<input type="text" name="namemenu" class="form-control" value="{{$menus->namemenu}}">
			</div>
	
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Cập nhật" />
			</div>
		</form>
		<div class="select_dynamic">
        	@if(isset($str))
        		{!! $str !!}
        	@endif
    	</div>
		<form class="frm_create_menu_has" method="post" action="{{ url('admin/menu/hasidcate/'.$idmenu) }}">
			{{ csrf_field() }}
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idparent">Chuyên mục <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control catebyidcatetype" name="sel_idcategory">
                    	<option value="">Thuộc chuyên mục</option>
                    	@foreach($categories as $row)
                    		 <option value="{{ $row['idcategory'] }}">{{ $row['namecat'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idcattype">Kiểu chuyên mục <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control type-category" name="sel_idcattype">
                    	<option value="">Kiểu chuyên mục</option>
                    	@foreach($categorytypes as $row)
                    		<option value="{{ $row['idcattype'] }}">{{ $row['catnametype'] }}</option>
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
@section('other_scripts')
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    {{-- <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script> --}}
    <script src="{{ asset('dashboard/production/js/category.js?v=1.2.1')}}"></script>  
@stop
