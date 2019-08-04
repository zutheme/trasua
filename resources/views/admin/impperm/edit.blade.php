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
		<form method="post" action="{{action('Admin\ImpPermController@update',$id_impperm)}}">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idperm">Thêm quyền <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idperm">
                    	<option value="">Chọn quyền</option>
                    	@foreach($permissions as $row)
                    		 <option value="{{ $row['idperm'] }}">{{ $row['name'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idrole">Vào vai trò <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idrole">
                    	<option value="">chọn vai trò</option>
                    	@foreach($roles as $row)
                    		 <option value="{{ $row['idrole'] }}">{{ $row['name'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
			</div>
			@foreach($selected as $row)
			<script type="text/javascript">
				var selected_idperm = '{{$row['idperm']}}';
				var name_perm =  '{{ $row['nameperm'] }}';
				var selected_idrole =  '{{ $row['idrole'] }}';
				var name_role = '{{ $row['namerole'] }}';
			</script>
			@endforeach   
		</div>
</div>
@stop
@section('other_scripts')
{{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script>
	<script src="{{ asset('dashboard/production/js/impperm.js?v=1.0.1')}}"></script>
@stop