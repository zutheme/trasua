@extends('admin.dashboard')
@section('other_styles')
     <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.2') }}" rel="stylesheet">
@stop

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
		<div class="col-sm-8">
			<form class="frm_create_menu" method="post" action="{{ action('Admin\MenuController@store') }}">
				{{ csrf_field() }}
				<div class="form-group row">
	             <label class="col-lg-4 col-form-label">Chọn memnu <span class="text-danger">*</span></label>
	                <div class="col-lg-8">
	                    <select class="form-control cus-drop" name="sel_idparent">
	                    	<option value="">Chọn ...</option>
	                    	@foreach($rs_menu as $row)
	                    		 <option value="{{ $row['idmenu'] }}">{{ $row['namemenu'] }}</option>
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
</div>
@stop
@section('other_scripts')
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    {{-- <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script> --}}
@stop