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
		@if(\Session::has('success'))
			<div class="alert alert-success">
				<p>{{ \Session::get('success') }}</p>
			</div>
		@endif
		<form class="frm_create_permission" method="post" action="{{url('admin/permission')}}">
			{{ csrf_field() }}
			<div class="form-group">
				<input type="text" name="name" class="form-control" placeholder="Tên quyền">
			</div>
			<div class="form-group">
				<textarea name="description" rows="4" cols="100" class="form-control" placeholder="Mô tả..."></textarea>
			</div>
			<div class="form-group">
                        <label class="col-md-3 col-sm-3 col-xs-12 control-label">Vai trò
                          <br>
                          <small class="text-navy">Cấp quyền vai trò</small>
                        </label>

                        <div class="col-md-9 col-sm-9 col-xs-12">
                        	@foreach($roles as $row)
							<div class="checkbox">
		                            <label>
		                              <input name="role_list[]" value="{{ $row['idrole'] }}" type="checkbox" class="flat"> {{ $row['name'] }}
		                            </label>
		                     </div>
							@endforeach
                                               
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
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script>
@stop